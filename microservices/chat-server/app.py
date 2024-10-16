import json, uuid, asyncio, websockets
from concurrent.futures import ( ThreadPoolExecutor )
from opentelemetry import trace
from config import ( ws_host, ws_port, chat_request_topic, chat_response_topic, kafka_chat_response_group_id )
from db import ( create_pg_pool, store_chat_request_message )
from kafka_consumer import ( KafkaConsumer )
from kafka_producer import ( KafkaProducer )
from otel import ( tracer, otlp_logger )
from utils import ( safe_json_decode )
user_connections = {}
running = True

async def handle_connection(websocket, pg_pool):
    producer = KafkaProducer()
    user_id = str(uuid.uuid4())
    user_connections[user_id] = websocket
    otlp_logger.info('Connected user with ID: %s', user_id)
    try:
        
        try:
            while running:                
                data = await websocket.recv()
                message = json.loads(data)
                chat_text = message['chat']
                
                await store_chat_request_message(pg_pool, user_id, chat_text, 'client')
                producer.send_message(chat_request_topic, user_id, chat_text)
                
        except websockets.exceptions.ConnectionClosed:
            otlp_logger.error('WebSocket connection closed unexpectedly')
        except json.JSONDecodeError:
            otlp_logger.error('Received invalid JSON: %s', data)
        except Exception as e:
            otlp_logger.error('Error processing message: %s', e)
            
    except (websockets.exceptions.ConnectionClosed) as e:
        otlp_logger.error('Connection error: %s', e)
    finally:
        del user_connections[user_id]
        otlp_logger.info('Disconnected user with ID: %s', user_id)
        
async def listen_to_kafka(consumer):
    await consumer.start()
    try:
        async for msg in consumer:
            if msg is None:
                continue
            values = safe_json_decode(msg.value)
            user_id = values.get('user_id')
            if user_id in user_connections:
                target_websocket = user_connections[user_id]
                chat_message = values.get('chat')
                
                if chat_message:
                    await target_websocket.send(json.dumps({'chat': chat_message}))
    except Exception as e:
        otlp_logger.error('Error listening to kafka: %s', e)

async def main():
    pg_pool = await create_pg_pool()
    consumer = KafkaConsumer(kafka_chat_response_group_id, 'earliest', chat_response_topic)
    asyncio.create_task(listen_to_kafka(consumer))
    async with websockets.serve(lambda ws, _: handle_connection(ws, pg_pool), ws_host, ws_port):
        await asyncio.Future()

if __name__ == '__main__':
    try:
        otlp_logger.info("Starting chat-server application")
        asyncio.run(main())
    except KeyboardInterrupt:
        otlp_logger.warning("Application stopped by KeyboardInterrupt")
        running = False
