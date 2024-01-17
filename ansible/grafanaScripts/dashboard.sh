#!/bin/bash

# Parameters for Grafana and InfluxDB
GRAFANA_URL="http://localhost:3000"
GRAFANA_USER="admin"
GRAFANA_PASSWORD="admin"
DASHBOARD_ID="1138"
DATASOURCE_NAME="InfluxDB"

# Import the dashboard using curl
curl -X POST \
  -H "Content-Type: application/json" \
  --data-binary @dashboard.json \
  -u "${GRAFANA_USER}:${GRAFANA_PASSWORD}" \
  "${GRAFANA_URL}/api/dashboards/import"

# Remove the temporary dashboard configuration file
# rm dashboard.json

