#!/bin/bash

set -euxo pipefail

# Can't use local path:
# [ERROR] [MY-010267] [Server] The socket file path is too long (> 103): /private/var/folders/k1/30mswbxs7r1g6zwn8y4fyt500000gp/T/abs_ectvkej3sa/croot/mysql-suite_1750671432327/test_tmp/mysql.sock
mkdir -p /tmp/mysql93build

trap 'mysqladmin --socket=/tmp/mysql93build/mysql.sock -u root shutdown || true; rm -rf /tmp/mysql93build' EXIT

echo "===DATABASE TEST START==="
echo "---INITIALIZING DATABASE---"
mysqld --initialize-insecure --datadir=/tmp/mysql93build/data --socket=/tmp/mysql93build/mysql.sock
echo "---STARTING SERVER---"
mysqld --user=root --datadir=/tmp/mysql93build/data --socket=/tmp/mysql93build/mysql.sock --pid-file=/tmp/mysql93build/mysql.pid --port=33071 &
echo "---WAITING FOR SERVER---"
for i in {1..10}; do
    if mysqladmin --socket=/tmp/mysql93build/mysql.sock -u root ping &> /dev/null; then
        break
    fi
    sleep 1
done
echo "---TRYING MYSQL-CONNECTOR-PYTHON---"
$PYTHON database_test.py /tmp/mysql93build/mysql.sock
echo "===DATABASE TEST END==="