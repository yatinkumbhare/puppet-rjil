Facter.add(:ipaddress_vhost0_or_eth1) do
  setcode do
    Facter.value(:ipaddress_vhost0) || Facter.value(:ipaddress_eth1)
  end
end
