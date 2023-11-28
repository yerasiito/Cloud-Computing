import yaml
import os

def get_ip_addresses(file_path):
    with open(file_path, 'r') as file:
        data = yaml.safe_load(file)
        ip_addresses = [value for key, value in data.items() if key.startswith('tf_floating_ip')]
        return ip_addresses

def write_to_inventory(ip_addresses, inventory_path):
    with open(inventory_path, 'w') as inventory_file:
        inventory_file.write("all:\n")
        inventory_file.write("  hosts:\n")
        inventory_file.write("    my_hosts:\n")
        for idx, ip in enumerate(ip_addresses, start=1):
            inventory_file.write(f"      ansible_host: {ip}\n")


file_path = '../terraform/tf_ansible_vars_file.yml'
inventory_path = 'inventory.yml'

ip_addresses = get_ip_addresses(file_path)
write_to_inventory(ip_addresses, inventory_path)
print(f"Inventory file '{inventory_path}' has been created with extracted IP addresses.")
