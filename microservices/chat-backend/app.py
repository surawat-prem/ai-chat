import asyncio
import json
import os
import logging
from concurrent.futures import ThreadPoolExecutor
from kafka import KafkaProducer, KafkaConsumer
from openai import OpenAI
import asyncpg

# Set up logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

apikey = os.environ.get('OPENAI_API_KEY', 'xxx')
ai_model = os.environ.get('OPENAI_MODEL', 'davinci-002')
ai_client = OpenAI(api_key=apikey)

# Kafka broker and topic configurations
kafka_bootstrap_servers = os.environ.get('KAFKA_BOOTSTRAP_SERVERS', 'localhost:33333')
chat_request_topic = os.environ.get('CHAT_REQUEST_TOPIC', 'test-topic-chat-request')
chat_response_topic = os.environ.get('CHAT_RESPONSE_TOPIC', 'test-topic-chat-response')

# PostgreSQL database configuration
pg_host = os.environ.get('PG_HOST', 'localhost')
pg_user = os.environ.get('PG_USER', 'postgres')
pg_password = os.environ.get('PG_PASSWORD', 'OvtbB7Yrv3wYU53gvqTeD0tle7Mm8e3sg1BBBNKvyvSSPlkBTCqwcwd3lxIaXklU')
pg_database = os.environ.get('PG_DB', 'postgres')

# Initialize Kafka producer
producer = KafkaProducer(
    bootstrap_servers=[kafka_bootstrap_servers],
    value_serializer=lambda v: json.dumps(v).encode('utf-8')
)

# Create PostgreSQL connection pool
async def create_pg_pool():
    logger.info("Creating PostgreSQL connection pool.")
    return await asyncpg.create_pool(
        user=pg_user,
        password=pg_password,
        host=pg_host,
        database=pg_database
    )

# Executor for running synchronous OpenAI calls
executor = ThreadPoolExecutor(max_workers=1)

def get_ai_response(chat_message):
    logger.info("Getting AI response for message: %s", chat_message)
    response = ai_client.completions.create(
        model=ai_model,
        prompt=chat_message,
        n=1,
        max_tokens=30
    )
    return response.choices[0].text

async def consume_messages(pg_pool):
    logger.info("Starting Kafka consumer.")
    consumer = KafkaConsumer(
        chat_request_topic,
        bootstrap_servers=[kafka_bootstrap_servers],
        value_deserializer=lambda x: json.loads(x.decode('utf-8')),
        group_id='chat-request',
        enable_auto_commit=True
    )
    
    for message in consumer:
        logger.info("Received message from Kafka: %s", message.value)
        values = message.value
        user_id = values['user_id']
        chat_message = values['chat']
        
        # Get OpenAI response
        ai_response = await asyncio.get_event_loop().run_in_executor(
            executor, get_ai_response, chat_message
        )
        
        # Store response data
        await store_chat_message(pg_pool, user_id, ai_response, 'response')
        
        # Send OpenAI response
        producer.send(
            chat_response_topic,
            {
                'user_id': user_id,
                'chat': ai_response
            }
        )
        logger.info("Sent AI response to Kafka for user_id: %s", user_id)

async def store_chat_message(pg_pool, user_id, ai_response, msg_type):
    async with pg_pool.acquire() as connection:
        logger.info("Storing chat message in database for user_id: %s", user_id)
        await connection.execute('''
                                 INSERT INTO messages (type, user_id, message, timestamp)
                                 VALUES ($1, $2, $3, CURRENT_TIMESTAMP);
                                 ''', msg_type, user_id, ai_response)

async def main():
    pg_pool = await create_pg_pool()
    await consume_messages(pg_pool)

if __name__ == '__main__':
    logger.info("Starting application.")
    asyncio.run(main())

# trigger workflow ss