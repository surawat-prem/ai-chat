import asyncpg
from config import ( pg_host, pg_database, pg_user, pg_password )
from otel import ( otlp_logger, tracer )
from opentelemetry import ( trace )
from opentelemetry.instrumentation.asyncpg import ( AsyncPGInstrumentor )
from opentelemetry.sdk.trace import ( Status, StatusCode )

async def create_pg_pool():
    otlp_logger.info("Creating PostgreSQL connection pool.")
    return await asyncpg.create_pool(
        user=pg_user,
        password=pg_password,
        host=pg_host,
        database=pg_database
    )

@tracer.start_as_current_span('store-chat-response-data')
async def store_chat_response_message(pg_pool, user_id, ai_response, msg_type):
    span = trace.get_current_span()
    AsyncPGInstrumentor().instrument()
    try:
        async with pg_pool.acquire() as connection:
            otlp_logger.info("Storing chat response message in database for user_id: %s", user_id)
            await connection.execute('''
                                    INSERT INTO messages (type, user_id, message, timestamp)
                                    VALUES ($1, $2, $3, CURRENT_TIMESTAMP);
                                    ''', msg_type, user_id, ai_response)
            span.set_status(Status(StatusCode.OK))
    
    except Exception as e:
        otlp_logger.error("Error storing chat response message: %s", e)
        span.set_status(Status(StatusCode.ERROR, str(e)))
        raise
