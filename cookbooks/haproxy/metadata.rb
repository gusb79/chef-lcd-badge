name 'haproxy'
maintainer 'Gus'
maintainer_email 'gusb79@gmail.com'
license 'Apache-2.0'
description 'Installs/Configures haproxy'
long_description 'Installs/Configures haproxy'
version '0.1.0'
chef_version '>= 12.1' if respond_to?(:chef_version)

depends 'apache', '>= 0.2.0'
supports 'centos', '>= 7.0'

# The `issues_url` points to the location where issues for this cookbook are
# tracked.  A `View Issues` link will be displayed on this cookbook's page when
# uploaded to a Supermarket.
#
issues_url 'https://github.com/gusb79/chef-lcd-badge/haproxy/issues'

# The `source_url` points to the development repository for this cookbook.  A
# `View Source` link will be displayed on this cookbook's page when uploaded to
# a Supermarket.
#
source_url 'https://github.com/gusb79/chef-lcd-badge/haproxy'
