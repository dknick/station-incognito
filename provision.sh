#!/bin/bash

# Set up apt sources
echo "# puppetlabs" | tee /etc/apt/sources.list.d/puppetlabs.list
echo "deb http://apt.puppetlabs.com $(lsb_release -sc) main dependencies" | tee -a /etc/apt/sources.list.d/puppetlabs.list
apt-key adv --keyserver keyserver.ubuntu.com --recv 4BD6EC30

# Update the system
apt-get update
DEBIAN_FRONTEND=noninteractive apt-get -q -y upgrade

# Install a modern ruby
DEBIAN_FRONTEND=noninteractive apt-get -q -y install ruby1.9.1 ruby1.9.1-dev rubygems1.9.1 irb1.9.1 ri1.9.1 rdoc1.9.1 build-essential libopenssl-ruby1.9.1 libssl-dev zlib1g-dev
update-alternatives --install /usr/bin/ruby ruby /usr/bin/ruby1.9.1 400 --slave /usr/share/man/man1/ruby.1.gz ruby.1.gz /usr/share/man/man1/ruby1.9.1.1.gz --slave /usr/bin/ri ri /usr/bin/ri1.9.1 --slave /usr/bin/irb irb /usr/bin/irb1.9.1 --slave /usr/bin/rdoc rdoc /usr/bin/rdoc1.9.1
update-alternatives --install /usr/bin/gem gem /usr/bin/gem1.9.1 400

# Get the puppet we want
DEBIAN_FRONTEND=noninteractive apt-get -q -y purge puppet puppet-common
DEBIAN_FRONTEND=noninteractive apt-get -q -y --force-yes install puppet=3.3.1-1puppetlabs1 puppet-common=3.3.1-1puppetlabs1
