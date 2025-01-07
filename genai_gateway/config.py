PORT = 8088
RELOAD = True
DEBUG = False
DEFAULT_API_KEYS = "sk-0123456789aAbBcCdDeEfFgGhHiIjJkKlLmMnNoOpPqQrRsStTuUvVwWxXyYzZ"
API_ROUTE_PREFIX = "/v1"

# AUTH_TYPE can be "API_KEY" or "INSTANCE_PRINCIPAL"
AUTH_TYPE = "API_KEY"
OCI_CONFIG_FILE = "/root/.oci/config"
OCI_CONFIG_FILE_KEY = "DEFAULT"
INFERENCE_ENDPOINT_TEMPLATE = "https://inference.generativeai.ap-osaka-1.oci.oraclecloud.com/20231130"

TITLE = "OCI Generative AI Proxy APIs"
SUMMARY = "OpenAI-Compatible RESTful APIs for OCI Generative AI Service"
VERSION = "0.1.0"
DESCRIPTION = """
Use OpenAI-Compatible RESTful APIs for OCI Generative AI Service models and OCI Data Science AI quick actions models.

Please edit "models.yaml" to specify your models and their call endpoints.
"""
