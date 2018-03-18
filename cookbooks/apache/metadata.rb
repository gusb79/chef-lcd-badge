name 'apache'
maintainer 'Gustavo'
maintainer_email 'gusb79@gmail.com'
license 'Apache-2.0'
description 'Installs/Configures apache'
long_description 'Installs/Configures apache'
version '0.2.0'
chef_version '>= 12.1' if respond_to?(:chef_version)
supports 'centos', '>= 7.0'

depends 'java', '= 1.39.0'

# The `issues_url` points to the location where issues for this cookbook are
# tracked.  A `View Issues` link will be displayed on this cookbook's page when
# uploaded to a Supermarket.
#
issues_url 'https://github.com/gusb79/chef-lcd-badge/apache/issues'

# The `source_url` points to the development repository for this cookbook.  A
# `View Source` link will be displayed on this cookbook's page when uploaded to
# a Supermarket.
#
source_url 'https://github.com/gusb79/chef-lcd-badge/apache'
