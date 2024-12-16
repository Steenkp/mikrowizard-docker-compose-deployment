#!/bin/bash

# Load environment variables
set -a
source .env
set +a
export MW_encryptKey=$(python3 -c 'import os; import base64; print(base64.urlsafe_b64encode(os.urandom(32)).decode("utf-8"))')
# Create directories dynamically based on the environment variables
sudo mkdir -p "${CONF_PATH}"
sudo mkdir -p "${FIRMWARE_PATH}"
sudo mkdir -p "${BACKUPS_PATH}"
sed -i "s/.*MW_encryptKey.*/MW_encryptKey=${MW_encryptKey}/" .env

echo "Required directories created:"
echo "Conf: ${CONF_PATH}"
echo "Firmware: ${FIRMWARE_PATH}"
echo "Backups: ${BACKUPS_PATH}"

echo "Your configuration:"


cat << EOF1 | sudo tee ${CONF_PATH}/server-conf.json >/dev/null
{
    "name": "python server config template - rename me",
    "PYSRV_IS_PRODUCTION": "1",
    "PYSRV_DATABASE_HOST": "127.0.0.1",
    "PYSRV_DATABASE_HOST_POSTGRESQL": "127.0.0.1",
    "PYSRV_DATABASE_PORT": "5432",
    "PYSRV_DATABASE_NAME": "${MW_DB_NAME}",
    "PYSRV_DATABASE_USER": "${MW_DB_USER}",
    "PYSRV_DATABASE_PASSWORD": "${MW_DB_PASSWORD}",
    "PYSRV_CRYPT_KEY": "${MW_encryptKey}",
    "PYSRV_BACKUP_FOLDER":"/backups/",
    "PYSRV_FIRM_FOLDER":"/firms/",
    "PYSRV_COOKIE_HTTPS_ONLY": false,
    "PYSRV_REDIS_HOST": "127.0.0.1:6379",
    "PYSRV_DOMAIN_NAME": "",
    "PYSRV_CORS_ALLOW_ORIGIN": "*"
}
EOF1

cat << EOF2 | sudo tee ./mikroman/server-conf.json >/dev/null
{
    "name": "python server config template - rename me",
    "PYSRV_IS_PRODUCTION": "1",
    "PYSRV_DATABASE_HOST": "127.0.0.1",
    "PYSRV_DATABASE_HOST_POSTGRESQL": "127.0.0.1",
    "PYSRV_DATABASE_PORT": "5432",
    "PYSRV_DATABASE_NAME": "${MW_DB_NAME}",
    "PYSRV_DATABASE_USER": "${MW_DB_USER}",
    "PYSRV_DATABASE_PASSWORD": "${MW_DB_PASSWORD}",
    "PYSRV_CRYPT_KEY": "${MW_encryptKey}",
    "PYSRV_BACKUP_FOLDER":"/backups/",
    "PYSRV_FIRM_FOLDER":"/firms/",
    "PYSRV_COOKIE_HTTPS_ONLY": false,
    "PYSRV_REDIS_HOST": "127.0.0.1:6379",
    "PYSRV_DOMAIN_NAME": "",
    "PYSRV_CORS_ALLOW_ORIGIN": "*"
}
EOF2

echo "Stored in : ${CONF_PATH}/server-conf.json"
