from confluent_kafka import Consumer, KafkaError
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
    'bootstrap.servers': kafka_bootstrap_servers,
    'security.protocol': kafka_security_protocol,
    'sasl.mechanism': kafka_sasl_mechanism,
    'sasl.username': kafka_username,
    'sasl.password': kafka_password
}

class KafkaConsumer:
    def __init__(self, group_id, offset_reset):
        conf['group.id'] = group_id
        conf['auto.offset.reset'] = offset_reset
        self.consumer = Consumer(conf)
        otlp_logger.info('Kafka consumer initiated.')
        
    def subscribe(self, topics):
        self.consumer.subscribe(topics)
        otlp_logger.info('Kafka consumer subscribed to: %s', topics)
        
    def poll(self, timeout):
        return self.consumer.poll(timeout=timeout)
        
    def close(self):
        self.consumer.close()
        
    def handle_message(self, msg):
        if msg.error():
            if msg.error().code() == KafkaError._PARTITION_EOF:
                otlp_logger.error('%% %s [%d] reached end at offset %d\n' %
                                  (msg.topic(), msg.partition(), msg.offset()))
            else:
                otlp_logger.error('Error while consuming message: %s', msg.error())
            return None

        otlp_logger.info('Received message from Kafka: %s', msg.value())
        return safe_json_decode(msg.value())
