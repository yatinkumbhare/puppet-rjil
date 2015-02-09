Facter.add(:ipaddress_vhost0_or_eth0) do
  setcode do
    Facter.value(:ipaddress_vhost0) || Facter.value(:ipaddress_eth0)
  end
end
