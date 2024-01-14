#!/bin/bash

# Parameters for new datasource InfluxDB
GRAFANA_URL="http://localhost:3000"
INFLUXDB_URL="http://localhost:8086"
INFLUXDB_DATABASE="telegraf"
INFLUXDB_USER="telegraf"
INFLUXDB_PASSWORD="telegraf"

# Auth information
GRAFANA_USER="admin"
GRAFANA_PASSWORD="admin"

# Create datasource in Grafana using curl
curl -X POST \
  -H "Content-Type: application/json" \
  -d '{
    "name":"InfluxDB",
    "type":"influxdb",
    "url":"'${INFLUXDB_URL}'",
    "access":"proxy",
    "isDefault":true,
    "database":"'${INFLUXDB_DATABASE}'",
    "user":"'${INFLUXDB_USER}'",
    "password":"'${INFLUXDB_PASSWORD}'",
    "basicAuth":true,
    "basicAuthUser":"'${INFLUXDB_USER}'",
    "basicAuthPassword":"'${INFLUXDB_PASSWORD}'",
    "jsonData":{},
    "secureJsonFields":{},
    "version":1,
    "readOnly":false
  }' \
  -u "${GRAFANA_USER}:${GRAFANA_PASSWORD}" \
  "${GRAFANA_URL}/api/datasources"

# Check the HTTP response code
if [ "$(echo "$response" | tail -n1)" == "200" ]; then
  echo "Datasource added successfully."
else
  echo "Error adding datasource. HTTP response code: $(echo "$response" | tail -n1)"
fi
