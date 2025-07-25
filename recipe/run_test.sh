#!/bin/bash -ex

pip check
python -c "from importlib.metadata import version; assert(version('${PKG_NAME}')=='${PKG_VERSION}')"

# Parts of the test code are based on output generated by AI

# Function to cleanup MySQL server
cleanup() {
    echo "Shutting down MySQL server..."
    mysqladmin -u root shutdown
    rm -rf /tmp/mysqlclienttest
}

# Set trap to call cleanup function on script exit
trap 'mysqladmin -u root shutdown || true; rm -rf /tmp/mysqlclienttest' EXIT

# Initialize
mkdir -p /tmp/mysqlclienttest/data
mysqld --initialize-insecure --datadir=/tmp/mysqlclienttest/data

# Create error log
touch /tmp/mysqlclienttest/data/error.log

# Start server
mysqld --user=root --datadir=/tmp/mysqlclienttest/data --pid-file=/tmp/mysqlclienttest/mysql.pid --port=33071 &

#mysqladmin ping
sleep 3 # Required on linux CI

# Create database for testing
mysql -u root -e "CREATE DATABASE test;"

# Run client tests:
#   Create client configuration
mv mysql_test_db.cnf tests/mysql_test_db.cnf
#   Point the tests to the configuration file and run the tests
TESTDB=mysql_test_db.cnf pytest -vv tests