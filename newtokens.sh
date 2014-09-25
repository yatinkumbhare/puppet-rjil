echo Fetching new tokens
export consul_discovery_token=$(curl -s http://consuldiscovery.linux2go.dk/new)
echo export consul_discovery_token=${consul_discovery_token}
export etcd_discovery_token=$(curl -s https://discovery.etcd.io/new | awk -F/ '{ print $NF }')
echo export etcd_discovery_token=${etcd_discovery_token}
echo "(If you ran newtokens.sh with '. newtokens.sh' or 'source newtokens.sh', these have already been exported)"
