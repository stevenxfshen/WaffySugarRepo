#!/bin/bash

# Update and upgrade the system
sudo apt update
sudo apt upgrade -y

# Install gnupg and curl
sudo apt install gnupg -y
sudo apt install curl -y

# Install MongoDB
curl -fsSL https://www.mongodb.org/static/pgp/server-6.0.asc | sudo gpg -o /usr/share/keyrings/mongodb-server-6.0.gpg --dearmor
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-6.0.gpg] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/6.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list
sudo apt update
sudo apt install -y mongodb-org
sudo systemctl start mongod
sudo systemctl enable mongod

# Install Open5GS
sudo add-apt-repository ppa:open5gs/latest -y
sudo apt update
sudo apt install open5gs -y

# Install Node.js
sudo apt update
sudo apt install ca-certificates curl gnupg -y 
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
NODE_MAJOR=20
echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list
sudo apt update
sudo apt install nodejs -y

# Install Open5GS WebUI
curl -fsSL https://open5gs.org/open5gs/assets/webui/install | sudo -E bash -



sudo sed -i '/ngap:/,/address:/s/address: 127.0.0.5/address: 192.168.33.64/' /etc/open5gs/amf.yaml
sudo sed -i '/plmn_id:/,/mcc:/s/mcc: 999/mcc: 315/' /etc/open5gs/amf.yaml
sudo sed -i '/plmn_id:/,/mnc:/s/mnc: 70/mnc: 010/' /etc/open5gs/amf.yaml
sudo sed -i '/gtpu:/,/address:/s/address: 127.0.0.7/address: 10.38.0.64/' /etc/open5gs/upf.yaml
sudo sed -i '/session:/,/subnet:/s/subnet: 10.45.0.0/subnet: 172.28.0.0/' /etc/open5gs/upf.yaml
sudo sed -i '/session:/,/gateway:/s/gateway: 10.45.0.1/gateway: 172.28.0.1/' /etc/open5gs/upf.yaml
