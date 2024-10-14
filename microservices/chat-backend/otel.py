import logging

from opentelemetry._logs import set_logger_provider
from opentelemetry.sdk._logs import LoggerProvider, LoggingHandler
from opentelemetry.exporter.otlp.proto.grpc._log_exporter import OTLPLogExporter
from opentelemetry.sdk._logs.export import BatchLogRecordProcessor

from opentelemetry import trace
from opentelemetry.exporter.otlp.proto.grpc.trace_exporter import OTLPSpanExporter
from opentelemetry.sdk.resources import Resource
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import BatchSpanProcessor
# from opentelemetry.instrumentation.kafka import KafkaInstrumentor

from config import (
    service_name,
    otlp_endpoint
)

# Setup trace
resource = Resource.create({
    "service.name": service_name
})
trace.set_tracer_provider(TracerProvider(resource=resource))
otlp_trace_exporter = OTLPSpanExporter(endpoint=otlp_endpoint, insecure=True)
trace.get_tracer_provider().add_span_processor(BatchSpanProcessor(otlp_trace_exporter))
tracer = trace.get_tracer(__name__)

# Set up logging
logger_provider = LoggerProvider(resource=resource)
set_logger_provider(logger_provider)
otlp_log_exporter = OTLPLogExporter(endpoint=otlp_endpoint, insecure=True)
logger_provider.add_log_record_processor(BatchLogRecordProcessor(otlp_log_exporter))
handler = LoggingHandler(level=logging.INFO, logger_provider=logger_provider)
logger = logging.getLogger().addHandler(handler)

otlp_logger = logging.getLogger(service_name)
otlp_logger.setLevel(logging.DEBUG)

# init console handler
console_handler = logging.StreamHandler()
console_handler.setLevel(logging.DEBUG)
otlp_logger.addHandler(console_handler)

# Instrument kafka
# KafkaInstrumentor().instrument()