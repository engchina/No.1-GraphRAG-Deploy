#!/bin/bash
echo "Initializing application setup..."

# Oracle Instant Client setup
cd /u01/aipoc

# Git clone source code
cd /u01/aipoc/No.1-GraphRAG
dos2unix main.cron
crontab main.cron

# Docker setup
chmod +x ./langfuse/install_docker.sh
./langfuse/install_docker.sh
systemctl start docker

docker network create aipoc-network

# Update environment variables
DB_CONNECTION_STRING=$(cat /u01/aipoc/props/db.env)
COMPARTMENT_ID=$(cat /u01/aipoc/props/compartment_id.txt)
cp .env.example .env
sed -i "s|ORACLE_23AI_CONNECTION_STRING=TODO|ORACLE_23AI_CONNECTION_STRING=$DB_CONNECTION_STRING|g" .env
cp data/.env.example data/.env
sed -i "s|ORACLE_23AI_CONNECTION_STRING=TODO|ORACLE_23AI_CONNECTION_STRING=$DB_CONNECTION_STRING|g" data/.env
sed -i "s|OCI_COMPARTMENT_ID=TODO|OCI_COMPARTMENT_ID=$COMPARTMENT_ID|g" data/.env
sed -i "s|OCI_COMPARTMENT_ID|$COMPARTMENT_ID|g" genai_gateway/models.yaml

# Application setup
EXTERNAL_IP=$(curl -s -m 10 http://whatismyip.akamai.com/)
sed -i "s|localhost:3000|$EXTERNAL_IP:3000|g" ./langfuse/docker-compose.yml
chmod +x ./langfuse/main.sh
nohup ./langfuse/main.sh &

mkdir /root/.oci
cp .oci/config /root/.oci/config && chmod 600 /root/.oci/config
cp .oci/oci_api_key.pem /root/.oci/oci_api_key.pem && chmod 600 /root/.oci/oci_api_key.pem

chmod +x main.sh
./main.sh &

chmod +x ./genai_gateway/main.sh
# Must run in the after setting
# nohup ./genai_gateway/main.sh &
echo "Initialization complete."
