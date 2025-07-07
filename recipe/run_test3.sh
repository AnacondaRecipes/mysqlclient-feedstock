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

# Clean setup
rm -rf ./data
mkdir ./data

# Initialize
mkdir data
mysqld --initialize-insecure --datadir=./data

# Create error log
touch ./data/error.log

# Start server
mysqld --datadir=./data \
  --socket=./data/mysql.sock \
  --pid-file=./data/mysql.pid \
  --port=3306 \
  --log-error=./data/error.log &

# Wait and test
sleep 3
#mysql -u root --socket=./data/mysql.sock -e "SELECT 1;"