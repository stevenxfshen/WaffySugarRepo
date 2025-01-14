#!/bin/bash

# Update and upgrade the system
sudo apt update
sudo apt upgrade -y

# Install gnupg and curl and meson git
sudo apt install gnupg -y
sudo apt install curl -y
sudo apt install meson  -y
sudo apt install git -y

# Install MongoDB
curl -fsSL https://pgp.mongodb.com/server-6.0.asc | sudo gpg -o /usr/share/keyrings/mongodb-server-6.0.gpg --dearmor
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-6.0.gpg] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/6.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list
sudo apt update
sudo apt install -y mongodb-org
sudo systemctl start mongod
sudo systemctl enable mongod

# Install Open5GS
sudo apt install python3-pip python3-setuptools python3-wheel ninja-build build-essential flex bison git cmake libsctp-dev libgnutls28-dev libgcrypt-dev libssl-dev libidn11-dev libmongoc-dev libbson-dev libyaml-dev libnghttp2-dev libmicrohttpd-dev libcurl4-gnutls-dev libnghttp2-dev libtins-dev libtalloc-dev meson -y
git clone https://github.com/open5gs/open5gs
cd open5gs
meson build --prefix=`pwd`/install
ninja -C build
./build/tests/registration/registration
#cd build
#meson test -v

cd build
ninja install
cd ../

# Install Node.js
sudo apt update
sudo apt install ca-certificates curl gnupg -y 
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
NODE_MAJOR=20
echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list
sudo apt update
sudo apt install nodejs -y

cd webui
npm ci
npm run dev

# Install Open5GS WebUI
curl -fsSL https://open5gs.org/open5gs/assets/webui/install | sudo -E bash -
sudo sed -i '/Environment=NODE_ENV=production/a Environment=HOSTNAME=0.0.0.0\nEnvironment=PORT=9999' /lib/systemd/system/open5gs-webui.service

# Add the ogtun interface/ip
sudo ip tuntap add name ogstun mode tun
sudo ip addr add 10.45.0.1/16 dev ogstun
sudo ip link set ogstun up

sudo sysctl -w net.ipv4.ip_forward=1
#sudo nano /etc/sysctl.conf
#net.ipv4.ip_forward = 1
sudo iptables -t nat -A POSTROUTING -s 10.45.0.0/16 ! -o ogstun -j MASQUERADE
sudo iptables -I INPUT -i ogstun -j ACCEPT
sudo iptables -I INPUT -s 10.45.0.0/16 -j DROP




#sudo sed -i '/ngap:/,/address:/s/address: 127.0.0.5/address: 192.168.33.20/' /etc/open5gs/amf.yaml
#sudo sed -i '/plmn_id:/,/mcc:/s/mcc: 999/mcc: 315/' /etc/open5gs/amf.yaml
#sudo sed -i '/plmn_id:/,/mnc:/s/mnc: 70/mnc: 010/' /etc/open5gs/amf.yaml
#sudo sed -i '/gtpu:/,/address:/s/address: 127.0.0.7/address: 10.38.0.64/' /etc/open5gs/upf.yaml
#sudo sed -i '/session:/,/subnet:/s/subnet: 10.45.0.0/subnet: 172.28.0.0/' /etc/open5gs/upf.yaml
#sudo sed -i '/session:/,/gateway:/s/gateway: 10.45.0.1/gateway: 172.28.0.1/' /etc/open5gs/upf.yaml

