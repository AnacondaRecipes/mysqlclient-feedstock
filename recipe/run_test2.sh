#!/bin/bash -ex

# Function to cleanup MySQL server
cleanup() {
    echo "Shutting down MySQL server..."
    mysql.server stop
    # Or: mysqladmin shutdown
    # Or: brew services stop mysql
}

# Set trap to call cleanup function on script exit
trap cleanup EXIT


echo "MySQL setup..."
mkdir data
export TESTDB=${PREFIX}/mysql_test_db.cnf
#mysqld --defaults-file=tests/actions.cnf --datadir=$CONDA_PREFIX/data/
#mysqld --initialize-insecure --defaults-file=mysql_test_db.cnf
mysqld --initialize --datadir=./data
#mysqld --initialize-insecure --datadir=$PREFIX/data/

#mysqld --datadir=./data \
#  --socket=./data/mysql.sock \
#  --pid-file=./data/mysql.pid \
#  --port=3306 \
#  --log-error=./data/error.log

echo "Running MySQL server..."
# Start MySQL server
mysql.server start

# Check if server started successfully
if ! pgrep mysqld > /dev/null; then
    echo "Failed to start MySQL server"
    exit 1
fi

# Your application code here
echo "MySQL server is running..."
# ... rest of your script

#pytest -vv tests

#cleanup() {
#    echo "Cleaning up..."
#    if pgrep mysqld > /dev/null; then
#        echo "Stopping MySQL server..."
#        mysql.server stop
#    fi
#}
#
## Trap various exit conditions
#trap cleanup EXIT INT TERM
#
## Start server
#mysql.server start
#
## Check if server started successfully
#if ! pgrep mysqld > /dev/null; then
#    echo "Failed to start MySQL server"
#    exit 1
#fi
#
#echo "Server running. Press Ctrl+C to stop."
## Keep script running
#while true; do
#    sleep 1
#done