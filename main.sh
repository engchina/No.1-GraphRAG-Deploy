#!/bin/bash
upload_dir="/u01/aipoc/No.1-GraphRAG/data/upload"
output_dir="/u01/aipoc/No.1-GraphRAG/data/output"

if [ ! -d "$upload_dir" ]; then
    mkdir -p "$upload_dir"
    echo "Created directory: $upload_dir"
else
    echo "Directory already exists: $upload_dir"
fi

if [ ! -d "$output_dir" ]; then
    mkdir -p "$output_dir"
    echo "Created directory: $output_dir"
else
    echo "Directory already exists: $output_dir"
fi

nohup /usr/bin/docker compose -f /u01/aipoc/No.1-GraphRAG/docker-compose.yml up -d &
exit 0

# nohup /u01/aipoc/miniconda/envs/no.1-graphrag/bin/python /u01/aipoc/No.1-GraphRAG/main.py --host 0.0.0.0 > /u01/aipoc/No.1-GraphRAG/main.log 2>&1 &
