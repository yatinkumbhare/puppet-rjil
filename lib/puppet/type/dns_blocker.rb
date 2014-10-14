Puppet::Type.newtype(:dns_blocker) do

  desc <<-'EOD'
  Blocks until an address has registered A records.
  EOD

  newparam(:name, :namevar => true) do
    desc 'DNS name to resolve'
  end

  newparam(:try_sleep) do
    desc 'The amount of time to sleep between retries'
    defaultto 1
    munge do |v|
      Integer(v)
    end
  end

  newproperty(:ready) do
    defaultto true
  end

  newparam(:tries) do
    desc 'The amount of times to retry before failing'
    defaultto 1
    munge do |v|
      Integer(v)
    end
  end

  validate do
    raise(Puppet::Error, 'Ready should not be set') unless self[:ready] == true
  end

end
