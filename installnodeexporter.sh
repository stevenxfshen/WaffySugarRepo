sudo apt update
sudo apt install golang-go
git clone https://github.com/prometheus/node_exporter.git
cd node_exporter
make build
./node_exporter <flags>
