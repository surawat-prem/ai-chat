import asyncio
from concurrent.futures import ( ThreadPoolExecutor )
from config import ( chat_request_topic, chat_response_topic, kafka_chat_request_group_id )
from ai import ( get_ai_response, init_ai_client )
from db import ( create_pg_pool, store_chat_response_message )
from kafka_producer import ( KafkaProducer )
from kafka_consumer import ( KafkaConsumer )
from otel import ( otlp_logger )

# Init kafka producer and consumer
running = True

# Executor for running synchronous OpenAI calls
executor = ThreadPoolExecutor(max_workers=1)

async def consume_chat_messages(pg_pool):
    consumer = KafkaConsumer(kafka_chat_request_group_id, 'earliest')
    consumer.subscribe([chat_request_topic])
    producer = KafkaProducer()
    try:
        while running:
            msg = consumer.poll(1.0)
            if msg is None:
                continue
            
            values = consumer.handle_message(msg)
            if values is None:
                continue
        
            user_id = values['user_id']
            chat_message = values['chat']
            
            # Get OpenAI response
            ai_response = await asyncio.get_event_loop().run_in_executor(
                executor, get_ai_response, chat_message
            )
            
            # Store response data
            await store_chat_response_message(pg_pool, user_id, ai_response, 'response')
            
            # Send OpenAI response
            producer.send_message(chat_response_topic, user_id, ai_response)
    finally:
        consumer.close()

async def main():
    await init_ai_client()
    pg_pool = await create_pg_pool()
    await consume_chat_messages(pg_pool)

if __name__ == '__main__':
    try:
        otlp_logger.info("Starting chat-backend application")
        asyncio.run(main())
    except KeyboardInterrupt:
        otlp_logger.warning("Application stopped by KeyboardInterrupt")
