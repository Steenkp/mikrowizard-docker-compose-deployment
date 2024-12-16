#!/bin/bash

# test if it is in build mode!
if [[ -z "${AM_I_IN_A_DOCKER_CONTAINER}" ]]; then
   echo "Starting Mikroman ..."
else
   exit 0
fi


# First Check if db is ready and accepting connections

python3 /app/testdb.py

# Check if the Python script ran successfully
if [ $? -ne 0 ]; then
    echo "An error occurred while executing the SQL commands."
    exit 1
else
    echo "Good News! Database is Running. :)"
fi

CONTAINER_ALREADY_STARTED="CONTAINER_ALREADY_STARTED_PLACEHOLDER"
if [ ! -e $CONTAINER_ALREADY_STARTED ]; then
    echo "-- Initializing the mikroman for first run  --"

    # YOUR_JUST_ONCE_LOGIC_HERE
    cd /app && export PYTHONPATH=/app/py && export PYSRV_CONFIG_PATH=/conf/server-conf.json && python3 scripts/dbmigrate.py

cat << EOF1 | tee init.sql >/dev/null
    INSERT INTO public.tasks( signal, name, status) VALUES ( 100, 'check-update',  false);
    INSERT INTO public.tasks( signal, name, status) VALUES ( 110, 'upgrade-firmware',  false);
    INSERT INTO public.tasks( signal, name, status) VALUES ( 120, 'backup', false);
    INSERT INTO public.tasks( signal, name, status) VALUES ( 130, 'scanner',  false);
    INSERT INTO public.tasks( signal, name, status) VALUES ( 140, 'downloader',  false);
    INSERT INTO public.tasks( signal, name, status) VALUES ( 150, 'firmware-service',  false);
    INSERT INTO public.tasks( signal, name, status) VALUES ( 160, 'snipet-exec',  false);
    INSERT INTO public.sysconfig( key,  value) VALUES ( 'scan_mode', 'mac');
    INSERT INTO public.sysconfig( key,  value) VALUES ( 'mac_scan_interval', '5');
    INSERT INTO public.sysconfig( key,  value) VALUES ( 'ip_scan_interval', '4');
    INSERT INTO public.sysconfig( key,  value) VALUES ( 'old_firmware_action', 'keep');
    INSERT INTO public.sysconfig( key,  value) VALUES ( 'default_user', '');
    INSERT INTO public.sysconfig( key,  value) VALUES ( 'default_password', '');
    INSERT INTO public.sysconfig( key,  value) VALUES ( 'old_version', '');
    INSERT INTO public.sysconfig( key,  value) VALUES ( 'latest_version', '');
    INSERT INTO public.sysconfig( key,  value) VALUES ( 'default_ip', '${MW_SERVER_IP}');
    INSERT INTO public.sysconfig( key,  value) VALUES ( 'rad_secret', '${MW_RAD_SECRET}');
    INSERT INTO public.sysconfig( key,  value) VALUES ( 'system_url', 'http://${MW_SERVER_IP}');
    INSERT INTO public.sysconfig( key,  value) VALUES ( 'force_perms', 'True');
    INSERT INTO public.sysconfig( key,  value) VALUES ( 'force_radius', 'True');
    INSERT INTO public.sysconfig( key,  value) VALUES ( 'force_syslog', 'True');
    INSERT INTO public.sysconfig( key,  value) VALUES ( 'safe_install', 'True');
    INSERT INTO public.sysconfig( key,  value) VALUES ( 'timezone', 'UTC');
    INSERT INTO public.sysconfig( key,  value) VALUES ( 'username', '');
    INSERT INTO public.sysconfig( key,  value) VALUES ( 'install_date', '');
    INSERT INTO public.sysconfig( key,  value) VALUES ( 'all_ip', '');
    INSERT INTO public.device_groups( id, name ) VALUES (1, 'Default');
    INSERT INTO public.users(username, first_name, last_name,email, role) VALUES ('system', 'system', '','system@localhost', 'disabled');
    INSERT INTO public.users(id,username, password, first_name, last_name, email, role,adminperms) VALUES ('37cc36e0-afec-4545-9219-94655805868b','mikrowizard', '$pbkdf2-sha256$29000$yVnr/d9b6917j7G2tlYqRQ$.8fbnLorUGGt6z8SZK9t7Q5WHrRnmKIYL.RW5IkyZLo', 'admin','admin','admin@localhost', 'admin','{"device": "full", "device_group": "full", "task": "full", "backup": "full", "snippet": "full", "accounting": "full", "authentication": "full", "users": "full", "permissions": "full", "settings": "full", "system_backup": "full"}');
    INSERT INTO public.permissions(id, name, perms) VALUES (1, 'full', '{"api": true, "ftp": true, "password": true, "read": true, "romon": true, "sniff": true, "telnet": true, "tikapp": true, "winbox": true, "dude": true, "local": true, "policy": true, "reboot": true, "rest-api": true, "sensitive": true, "ssh": true, "test": true, "web": true, "write": true}');
    INSERT INTO public.permissions(id, name, perms) VALUES (2, 'read', '{"api": true, "ftp": false, "password": true, "read": true, "romon": true, "sniff": true, "telnet": true, "tikapp": true, "winbox": true, "dude": false, "local": true, "policy": false, "reboot": true, "rest-api": true, "sensitive": true, "ssh": true, "test": true, "web": true, "write": false}');
    INSERT INTO public.permissions(id, name, perms) VALUES (3, 'write', '{"api": true, "dude": false, "ftp": false, "local": true, "password": true, "policy": false, "read": true, "reboot": true, "rest-api": true, "romon": true, "sensitive": true, "sniff": true, "ssh": true, "telnet": true, "test": true, "tikapp": true, "web": true, "winbox": true, "write": true}');
    INSERT INTO public.user_group_perm_rel(group_id, user_id, perm_id) VALUES ( 1, '37cc36e0-afec-4545-9219-94655805868b', 1);
EOF1
    # Run the Python script
    python3 /app/initpy.py

    # Check if the Python script ran successfully
    if [ $? -ne 0 ]; then
        echo "An error occurred while executing the SQL commands."
    else
        touch $CONTAINER_ALREADY_STARTED
        echo "SQL commands executed successfully."
    fi
        cron
        uwsgi --ini /app/conf/uwsgi.ini:uwsgi-production --touch-reload=/app/reload
else
    cron
    uwsgi --ini /app/conf/uwsgi.ini:uwsgi-production --touch-reload=/app/reload
fi
