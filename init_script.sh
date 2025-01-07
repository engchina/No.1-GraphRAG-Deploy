#!/bin/bash
echo "Initializing application setup..."

# Oracle Instant Client setup
cd /u01/aipoc
wget https://download.oracle.com/otn_software/linux/instantclient/2360000/instantclient-basic-linux.x64-23.6.0.24.10.zip -O instantclient.zip
unzip instantclient.zip -d ./
wget http://ftp.de.debian.org/debian/pool/main/liba/libaio/libaio1_0.3.113-4_amd64.deb
dpkg -i libaio1_0.3.113-4_amd64.deb
echo "/u01/aipoc/instantclient_23_6" > /etc/ld.so.conf.d/oracle-instantclient.conf
ldconfig
echo 'export LD_LIBRARY_PATH=/u01/aipoc/instantclient_23_6:$LD_LIBRARY_PATH' >> /etc/profile
source /etc/profile
unzip wallet.zip -d ./wallet
cp ./wallet/* ./instantclient_23_6/network/admin/

# Miniconda setup
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh
bash miniconda.sh -b -p /u01/aipoc/miniconda
eval "$(/u01/aipoc/miniconda/bin/conda shell.bash hook)"
/u01/aipoc/miniconda/bin/conda init bash

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
# nohup ./genai_gateway/main.sh &
echo "Initialization complete."
