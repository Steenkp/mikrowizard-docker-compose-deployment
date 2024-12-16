import psycopg2
import time
import os
import json

# Step 1: Read connection details from server.json

def wait_for_postgres():
    try:
        with open('/conf/server-conf.json') as f:
            config = json.load(f)
            db_name = config['PYSRV_DATABASE_NAME']
            db_user = config['PYSRV_DATABASE_USER']
            db_password = config['PYSRV_DATABASE_PASSWORD']
            db_host = config['PYSRV_DATABASE_HOST_POSTGRESQL']
            db_port = config['PYSRV_DATABASE_PORT']

    except Exception as e:
        print(f"An error occurred: {e}")
        exit(1)
    print(f"Waiting for PostgreSQL database {db_name} to become available...")
    while True:
        try:
            conn = psycopg2.connect(
                dbname=db_name,
                user=db_user,
                password=db_password,
                host=db_host,
                port=db_port
            )
            conn.close()
            print("PostgreSQL is ready!")
            break
        except psycopg2.OperationalError as e:
            print(f"Database not ready yet. Retrying in 5 seconds...\nError: {e}")
            time.sleep(5)

wait_for_postgres()
