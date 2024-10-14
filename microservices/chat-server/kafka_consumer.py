from aiokafka import AIOKafkaConsumer
from config import (
    kafka_bootstrap_servers,
    kafka_security_protocol,
    kafka_sasl_mechanism,
    kafka_username,
    kafka_password,
)
from otel import ( otlp_logger )
from utils import ( safe_json_decode )

# Init Kafka Config
conf = {
    'bootstrap_servers': kafka_bootstrap_servers,
    'security_protocol': kafka_security_protocol,
    'sasl_mechanism': kafka_sasl_mechanism,
    'sasl_plain_username': kafka_username,
    'sasl_plain_password': kafka_password
}

class KafkaConsumer:
    def __init__(self, group_id, offset_reset, topics):
        conf['group_id'] = group_id
        conf['auto_offset_reset'] = offset_reset
        self.consumer = AIOKafkaConsumer(topics, **conf)
        otlp_logger.info('Kafka consumer initiated.')
        otlp_logger.info('Kafka consumer subscribed to: %s', topics)
        
    async def stop(self):
        await self.consumer.stop()
        
    async def start(self):
        await self.consumer.start()

    def __aiter__(self):
        """Allows for async iteration over the consumer."""
        return self

    async def __anext__(self):
        """Fetch the next message from the consumer."""
        msg = await self.consumer.getone()
        return msg