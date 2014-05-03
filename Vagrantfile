# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure('2') do |config|
  config.vm.box = 'precise64'
  config.vm.box_url = 'http://cloud-images.ubuntu.com/precise/current/precise-server-cloudimg-vagrant-amd64-disk1.box'
  config.vm.provider :virtualbox do |v|
    v.gui = true
    v.customize [ 'modifyvm', :id, '--memory', '2048' ]
  end
  config.vm.provision :shell, :path => 'provision.sh'
  config.vm.provision :puppet do |puppet|
    puppet.module_path = 'modules'
    puppet.facter = {
      # tor20.anonymizer.ccc.de
      'tor_bridge_ip'          => '31.172.30.3',
      'tor_bridge_orport'      => '443',
      'tor_bridge_fingerprint' => '766CC246C1C68DF009A7BF03332285240DC3F2B4',
    }
  end
end
