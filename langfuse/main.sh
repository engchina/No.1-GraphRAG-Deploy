#!/bin/bash
nohup /usr/bin/docker compose -f /u01/aipoc/No.1-GraphRAG/langfuse/docker-compose.yml up -d &
exit 0