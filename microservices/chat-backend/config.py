import os

# Trace config
service_name = os.environ.get('OTEL_SERVICE_NAME', 'chat-backend')
otlp_endpoint = os.environ.get('OTEL_ENDPOINT', 'localhost:4317')

# AI config
apikey = os.environ.get('OPENAI_API_KEY', '')
ai_model = os.environ.get('OPENAI_MODEL', 'gpt-3.5-turbo')

# Kafka broker and topic configurations
kafka_bootstrap_servers = os.environ.get('KAFKA_BOOTSTRAP_SERVERS', 'localhost:33333')
chat_request_topic = os.environ.get('CHAT_REQUEST_TOPIC', 'non-prod-chat-request')
chat_response_topic = os.environ.get('CHAT_RESPONSE_TOPIC', 'non-prod-chat-response')
kafka_security_protocol = os.environ.get('KAFKA_SECURITY_PROTOCOL','SASL_PLAINTEXT')
kafka_sasl_mechanism = os.environ.get('KAFKA_SASL_MECHANISM','SCRAM-SHA-512')
kafka_username = os.environ.get('KAFKA_USER',"")
kafka_password = os.environ.get('KAFKA_PASSWORD',"")
kafka_chat_request_group_id = os.environ.get('KAFKA_CHAT_REQUEST_GROUP_ID',"non-prod-chat-request-group")

# PostgreSQL database configuration
pg_host = os.environ.get('PG_HOST', 'localhost')
pg_user = os.environ.get('PG_USER', 'user1')
pg_password = os.environ.get('PG_PASSWORD', 'password1')
pg_database = os.environ.get('PG_DB', 'postgres')
