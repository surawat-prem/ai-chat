import json
import uuid
import os
import asyncio
import websockets
from kafka import KafkaProducer, KafkaConsumer
import asyncpg
import logging

# Set up logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

# Kafka broker and topic configurations
kafka_bootstrap_servers = os.environ.get('KAFKA_BOOTSTRAP_SERVERS','localhost:33333')
chat_request_topic = os.environ.get('CHAT_REQUEST_TOPIC','test-topic-chat-request')
chat_response_topic = os.environ.get('CHAT_RESPONSE_TOPIC','test-topic-chat-response')

# PostgreSQL database configuration
pg_host = os.environ.get('PG_HOST','localhost')
pg_user = os.environ.get('PG_USER','postgres')
pg_password = os.environ.get('PG_PASSWORD','OvtbB7Yrv3wYU53gvqTeD0tle7Mm8e3sg1BBBNKvyvSSPlkBTCqwcwd3lxIaXklU')
pg_database = os.environ.get('PG_DB','postgres')

ws_host = os.environ.get('HOST', 'localhost')
ws_port = os.environ.get('PORT', 8765)

# Initialize Kafka producer and consumer
producer = KafkaProducer(
    bootstrap_servers=[kafka_bootstrap_servers],
    value_serializer=lambda v: json.dumps(v).encode('utf-8')
)

consumer = KafkaConsumer(
    chat_response_topic,
    'temp-group',
    bootstrap_servers=[kafka_bootstrap_servers],
    value_deserializer=lambda x: json.loads(x.decode('utf-8')),
    auto_offset_reset='latest',
    enable_auto_commit=True
)

# Create a PostgreSQL connection pool
async def create_pg_pool():
    return await asyncpg.create_pool(
        user=pg_user,
        password=pg_password,
        host=pg_host,
        database=pg_database
    )

user_connections = {}

async def handle_connection(websocket, pg_pool):
    user_id = str(uuid.uuid4())
    user_connections[user_id] = websocket
    print(f"Connected user with ID: {user_id}")

    try:
        while True:
            data = await websocket.recv()
            message = json.loads(data)
            chat_text = message['chat']
            
            await store_chat_message(pg_pool, user_id, chat_text, 'client')

            await send_chat_request_to_kafka(user_id, chat_text)

            response = await receive_chat_response_from_kafka(user_id)
            await websocket.send(json.dumps(response))
    except (websockets.exceptions.ConnectionClosed, json.JSONDecodeError) as e:
        print(f"Connection closed or invalid JSON: {e}")
    finally:
        del user_connections[user_id]
        print(f"Disconnected user with ID: {user_id}")

async def store_chat_message(pg_pool, user_id, chat_text, type):
    async with pg_pool.acquire() as connection:
        await connection.execute('''
                                 INSERT INTO messages (type, user_id, message, timestamp)
                                 VALUES ($1, $2, $3, CURRENT_TIMESTAMP);
                                 ''', type, user_id, chat_text)

async def send_chat_request_to_kafka(user_id, chat_text):
    producer.send(chat_request_topic, {'user_id': user_id, 'chat': chat_text})

async def receive_chat_response_from_kafka(user_id):
    for message in consumer:
        response = message.value
        if response['user_id'] == user_id:
            return response

async def main():
    pg_pool = await create_pg_pool()
    async with websockets.serve(lambda ws, _: handle_connection(ws, pg_pool), ws_host, ws_port):
        await asyncio.Future()  # Run forever

if __name__ == '__main__':
    asyncio.run(main())
