class rjil::jiocloud::sources($snapshot_version = false) {
  include apt

  $ubuntu_url = $snapshot_version ? {
    false   => "http://archive.ubuntu.com/ubuntu",
    default => "http://archive.internal/${snapshot_version}/archive.ubuntu.com/ubuntu"
  }

  $rustedhalo_url = $snapshot_version ? {
    false   => "http://jiocloud.rustedhalo.com/ubuntu",
    default => "http://archive.internal/${snapshot_version}/jiocloud.rustedhalo.com/ubuntu"
  }

  apt::source { 'ubuntu':
    location    => $ubuntu_url,
    release     => $codename,
    repos       => 'main universe restricted',
    key         => '437D05B5',
  }

  apt::source { 'rustedhalo':
    location    => $rustedhalo_url,
    release     => $codename,
    repos       => 'main universe restricted',
    key         => '85596F7A',
    key_server  => 'keyserver.ubuntu.com',
    key_content => '-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: GnuPG v1

mQENBFM0FdsBCADbcuhgf4ny6HQXSCrskXK3hp8HUA4UbW9xIO/fqUzKTvxRuwUR
yRZHXVdCCaLOD8En+h4fnAs2PY3ueVfcIDt9DsJcmqWE+cbFG191Yw8hQV/MtxXU
YNAS6oKOwMheC3BtxdbplJ4hbg065m38wPmcgt/rJiAQZBxrKggCHTvIQunvJnmG
/7OMuwhkzewEAaG5E1mmdVq+IMJAg0ltMiRANASo07wrB0At4q62ozBomua6Hk3s
69ie5ZGiQtyIOgB1mO4RwxS0MoMd+ffq6Kyc8GPoM9EFj4zYGIyOZBa4YqI9cs9A
88E5910lHNx8p2wZCsN+Z00IDN3c6nGmHrzNABEBAAG0Kkppb0Nsb3VkIFJlcG9z
aXRvcnkgPHN1cHBvcnRAamlvY2xvdWQuY29tPokBOAQTAQIAIgUCUzQV2wIbAwYL
CQgHAwIGFQgCCQoLBBYCAwECHgECF4AACgkQhgQCvoVZb3oKVwf+Pr3hBs1h5oOk
VFHwQ/whCcnLjdY1so9wVeZ0TsZVRTrepyKB4Bi+yy4xtYZ572JLbORqRIfdOTgE
06cagaoi2Mc1e5sW/l0ifOvfjlrxIECMX4ftL2igZ7Cu4GB8+WmuDdHpsTdi1Fvx
9cn2eHAylHS3oblwoKpdfiHLPkP0Dt5aJFKOyBQfDPhjX4LF0S0aC0Zg43jNIZdf
nnC71P2+i5WwvljJV2+DTtp3/ImBMKVKgAISxOtBsA5PC+yP6X4lsUUwEP4amti8
jnq2HAjKkpM3UTAWLbHN3x6O2Mg+OIvjYUhrbYeHqQEQurUoPUx2FjZhrXDM/Cxg
tnaES5wRqLkBDQRTNBXbAQgAs4OQ1KlirGpiZC4hEvfmrkBKiJUk1sxsRzqqatkv
Ul5ay3DWoknYO+C7RIzYTwMQ9lv/QwJA2T+FpYykiu6gg872W5aje9xqg98z9DTM
C2lZ79yUMNiMNdKr6Zd05Q6zz0EQVaTMwrYEb+DOW0H8ka7HJA2MJc/ot0Bf2G2A
uavopMiikaVX67901qvHKqQMFgFzbe0C16poK057W3iFEnYAYTzJ6sLhCukfMkwk
6cIApeCEDz9d1tq5aiYcgXhnhnLnXBR9nUlI5qdfU/6+Nmcgh+izjtQp+U5cKHhl
YaiPfbVLQVUg/jbhem0XZuXJ9LdaNoeDdG+7KP7s+N+fIwARAQABiQEfBBgBAgAJ
BQJTNBXbAhsMAAoJEIYEAr6FWW96QewH/20zMCYcDgt8AoRJsyhLPLw8Xa8N57YD
EJfNUKA/74UrUSiLNktXzOVRLa1vAp5kdd9x6HNg5C0bt8kjvYzTvVChRBGt7NRg
SViL4sowyCFpT23JhHRajMmiJPigG+c4gjIJF4DbnpSG8WPC3jDPV891EZCodmaz
klc+BnhnZrb4FcB04RdQ/WXgVshDCzVQhmdIEILGKYHMTjlK/HkV6YqH7l7+jRvJ
phmH35+GJQumLfXWlvDchtBjUTo5ZDCa7TWhwhXZoFg5nxadQDX4TwHhZBQH1TX5
Chk4NnD90SYZt36sTLITe5O/BgYlRMqVo+bVj0tmjMJP/B4PZjABX7A=
=iZW7
-----END PGP PUBLIC KEY BLOCK-----',
  }


  # XXX: This needs to be snapshotted as well.
  apt::key { '3695394E':
    key_content => '-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: GnuPG v1

mI0EUiawUAEEAM9/ECoc/GkWl5lxFybOMxAEuWyXcTlqQeOJZFwB/FYd1b8MS12Y
81a6HVLU9SAjZS531LwsyZc8CmZYbCT4NWbTxDJGeZQX0UkdZ1K4aGcjyLCkSi21
pJ4izrWu1qJfmYfJbiWItRbZ7sBPUbtx45y98plBn3XmHWNEczaoTS9BABEBAAG0
IkxhdW5jaHBhZCBQUEEgZm9yIEJlbmphbWluIFN0YWZmaW6IuAQTAQIAIgUCUiaw
UAIbAwYLCQgHAwIGFQgCCQoLBBYCAwECHgECF4AACgkQUdPWHjaVOU4oNwP/QjJ/
8HHH1wRow3UYZO2XTSqzuT7wMPtWxeF48CL2wLFJ4oKaF6EcL80emcGq9G5UGZqt
ov/HLX6kmL+s9NKFPrlgF1vPEzoj6As05DQmtiMCZZUMubdXeWcwqf2H/yzwW11s
ZJLc7lQ0gUibky1GWuXx66wCyc68ucnJLfI3jqE=
=kTTQ
-----END PGP PUBLIC KEY BLOCK-----',
  } ->
  apt::ppa { 'ppa:benley/etcd': }

}
