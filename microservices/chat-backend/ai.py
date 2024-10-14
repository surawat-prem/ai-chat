from openai import OpenAI
from config import ( apikey, ai_model )
from otel import ( otlp_logger, tracer )
from opentelemetry import ( trace )
from opentelemetry.sdk.trace import ( Status, StatusCode )

async def init_ai_client():
    global _ai_client
    try:
        _ai_client = OpenAI(api_key=apikey)
        otlp_logger.info("Ai CLient initiated successfully")
    except Exception as e:
        otlp_logger.error("Error initiating Ai client %s", e)

@tracer.start_as_current_span('request-openai-response')
def get_ai_response(chat_message):
    
    span = trace.get_current_span()
    span.set_attribute("chat_message", chat_message)
    
    try:
        otlp_logger.info("Getting AI response for message: %s", chat_message)
        response = _ai_client.completions.create(
            model=ai_model,
            prompt=chat_message,
            n=1,
            max_tokens=30
        )
        span.set_status(Status(StatusCode.OK))
        return response.choices[0].text
    
    except Exception as e:
        otlp_logger.error("Error getting AI response: %s", e)
        span.set_status(Status(StatusCode.ERROR, str(e)))
        raise
