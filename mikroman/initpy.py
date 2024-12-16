import json
import psycopg2

# Step 1: Read connection details from server.json
with open('/conf/server-conf.json') as f:
    config = json.load(f)

# Step 2: Connect to the PostgreSQL database
try:
    conn = psycopg2.connect(
        dbname=config['PYSRV_DATABASE_NAME'],
        user=config['PYSRV_DATABASE_USER'],
        password=config['PYSRV_DATABASE_PASSWORD'],
        host=config['PYSRV_DATABASE_HOST_POSTGRESQL'],
        port=config['PYSRV_DATABASE_PORT']
    )
    cursor = conn.cursor()
    print("Connected to the database successfully.")

    # Step 3: Read the SQL commands from the SQL file
    with open('init.sql', 'r') as sql_file:
        sql_commands = sql_file.read()

    # Step 4: Execute the SQL commands
    cursor.execute(sql_commands)
    if cursor.description:  # Check if there are results
        # Fetch all results
        results = cursor.fetchall()
        # Print each row of results
        for row in results:
            print(row)
    conn.commit()  # Commit the changes if it's not a SELECT query
    print("Executed SQL commands successfully.")

except Exception as e:
    print(f"An error occurred: {e}")
    exit(1)
finally:
    # Close the database connection
    if cursor:
        cursor.close()
    if conn:
        conn.close()
    print("Database connection closed.")
