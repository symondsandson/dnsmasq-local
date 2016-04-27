# Encoding: UTF-8
#

name 'dnsmasq-local'
maintainer 'Jonathan Hartman'
maintainer_email 'jonathan.hartman@socrata.com'
license 'apache2'
description 'Configures a local-only dnsmasq'
long_description 'Configures a local-only dnsmasq'
version '0.0.1'

if respond_to?(:source_url)
  source_url 'https://github.com/socrata-cookbooks/dnsmasq-local'
end
if respond_to?(:issues_url)
  issues_url 'https://github.com/socrata-cookbooks/dnsmasq-local/issues'
end

conflicts 'dnsmasq'

supports 'ubuntu'