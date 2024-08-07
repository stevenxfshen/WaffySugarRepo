sudo apt install software-properties-common
sudo apt update
sudo apt install golang-go -y
sudo apt install make
git clone https://github.com/prometheus/node_exporter.git
cd node_exporter
make build
cp node_exporter /usr/bin



sudo groupadd -f node_exporter
sudo useradd -g node_exporter --no-create-home --shell /bin/false node_exporter
sudo mkdir /etc/node_exporter
sudo chown node_exporter:node_exporter /etc/node_exporter
sudo chown node_exporter:node_exporter /usr/bin/node_exporter


