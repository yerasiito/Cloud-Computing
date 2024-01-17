#!/bin/bash

grafana_host="http://localhost:3000"
grafana_cred="admin:admin"
grafana_datasource="InfluxDB"

ds=(3387 20268)

for d in "${ds[@]}"; do
  echo -n "Processing $d: "
  j=$(curl -s -u "$grafana_cred" $grafana_host/api/gnet/dashboards/$d | jq .json)

  # Save JSON payload to a temporary file
  temp_file=$(mktemp)
  echo "{\"dashboard\":$j,\"overwrite\":true, \
        \"inputs\":[{\"name\":\"DS_INFLUXDB\",\"type\":\"datasource\", \
        \"pluginId\":\"influxdb\",\"value\":\"$grafana_datasource\"}]}" > "$temp_file"

  # Use the file in the curl command
  curl -s -u "$grafana_cred" -XPOST -H "Accept: application/json" \
    -H "Content-Type: application/json" \
    --data @"$temp_file" \
    $grafana_host/api/dashboards/import; echo ""

  # Remove the temporary file
  rm "$temp_file"
done
