#!/bin/bash

for ip in `cat /home/$USER/ips.txt`
do
        master_ip=$ip
        break
done

replace_data() {
  local variable_name="$1"
  local new_data="$2"
  local file_name="$3"

  sudo sed -i "s/$variable_name: .*/$variable_name: $new_data/" "$file_name"
}

file_name="/etc/cassandra/cassandra.yaml"

this_node_address=`hostname -I | cut -d' ' -f2`

# Replace data for seeds, may have may seeds, then have to change the command
replace_data "seeds" "\"$master_ip\"" "$file_name"

# Replace data for listen_address
replace_data "listen_address" "$this_node_address" "$file_name"

# Replace data for rpc_address
replace_data "rpc_address" "$this_node_address" "$file_name"

# Replce the bloody snitch
replace_data "endpoint_snitch" "GossipingPropertyFileSnitch" "$file_name"

echo "auto_bootstrap: false" | sudo tee -a $file_name
