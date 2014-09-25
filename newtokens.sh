echo Fetching new token
export etcd_discovery_token=$(curl -s https://discovery.etcd.io/new | awk -F/ '{ print $NF }')
echo export etcd_discovery_token=${etcd_discovery_token}
echo "(If you ran newtokens.sh with '. newtokens.sh' or 'source newtokens.sh', it has already been exported)"
