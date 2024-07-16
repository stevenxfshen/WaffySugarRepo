service upf stop

export ROOT_DPRC=dprc.1
export PARENT_DPRC=dprc.3
export DPCON_COUNT=3
export DPBP_COUNT=4
export DPMCP_COUNT=1
export DPSECI_COUNT=8
export DPIO_COUNT=17
export DPCI_COUNT=2
export DPDMAI_COUNT=2

/usr/local/dpdk/dpaa2/dynamic_dpl.sh dpmac.6
ims-stop
systemctl restart amf smf pcf ausf udm upf
ims-start
