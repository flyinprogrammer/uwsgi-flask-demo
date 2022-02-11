#!/bin/sh

echo "========== START UWSGI CONFIG =========="
cat uwsgi.ini
echo "========== END UWSGI CONFIG =========="
exec uwsgi --ini ./uwsgi.ini
