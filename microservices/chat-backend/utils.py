import json
from otel import otlp_logger

def format_chat_message(user_id, chat):
    return {
        'user_id': user_id,
        'chat': chat
    }
    
def safe_json_encode(data):
    try:
        return json.dumps(data).encode('utf-8')
    except (TypeError, ValueError) as e:
        otlp_logger.error("JSON encode failed: %s", e )
        return None
    
def safe_json_decode(msg_value):
    try:
        return json.loads(msg_value.decode('utf-8'))
    except (json.JSONDecodeError, KeyError) as e:
        otlp_logger.error("JSON decode failed: %s", e )
        return None