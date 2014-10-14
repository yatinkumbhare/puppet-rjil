require 'puppet/provider/blocker'

Puppet::Type.type(:dns_blocker).provide(
  :default,
  :parent => Puppet::Provider::Blocker
) do

  def ready
    result = block_until_ready do
      debug("Trying to resolve: #{resource[:name]}")
      result = []
      Resolv::DNS.open do |dns|
        result = dns.getresources(resource[:name],
                                  Resolv::DNS::Resource::IN::A)
      end
      if result.class == Array and result.size > 0
        debug("Found A record(s): #{result.inspect}")
        return true
      end
    end
    fail("Could not find a registered address")
  end

  def ready=(val)
    # do nothing
  end

end
