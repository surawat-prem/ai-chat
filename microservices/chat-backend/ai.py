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
        response = _ai_client.chat.completions.create(
            model=ai_model,
            messages=[
                {"role": "system", "content": "You are a helpful assistant that provides information and answers questions."},
                {"role": "user", "content": chat_message }
            ],
            n=1,
            max_tokens=50
        )
        span.set_status(Status(StatusCode.OK))
        return response.choices[0].message.content
    
    except Exception as e:
        otlp_logger.error("Error getting AI response: %s", e)
        span.set_status(Status(StatusCode.ERROR, str(e)))
        raise
