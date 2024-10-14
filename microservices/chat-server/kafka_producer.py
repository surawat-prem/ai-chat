from confluent_kafka import Producer
from config import (
    kafka_bootstrap_servers,
    kafka_security_protocol,
    kafka_sasl_mechanism,
    kafka_username,
    kafka_password,
)
from otel import ( otlp_logger )
from utils import ( format_chat_message, safe_json_encode )

# Init Kafka Config
conf = {
    'bootstrap.servers': kafka_bootstrap_servers,
    'security.protocol': kafka_security_protocol,
    'sasl.mechanism': kafka_sasl_mechanism,
    'sasl.username': kafka_username,
    'sasl.password': kafka_password,
}

class KafkaProducer:
    def __init__(self):
        self.producer = Producer(conf)
        otlp_logger.info('Kafka producer initiated.')
        
    def send_message(self, topic, user_id, chat):
        message = format_chat_message(user_id, chat)
        encoded_message = safe_json_encode(message)
        
        if encoded_message is not None:
            try:
                self.producer.produce(topic, encoded_message)
                self.producer.flush(timeout=1.0)
                otlp_logger.info("Sent chat request to Kafka for user_id: %s", user_id)
            except Exception as e:
                otlp_logger.error("Failed to send chat request to Kafka for user_id: %s, error: %s", user_id, e)