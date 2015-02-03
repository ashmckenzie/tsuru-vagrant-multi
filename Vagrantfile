TSURU_MAIN  = '192.168.50.4'
TSURU_MYSQL = '192.168.50.5'
TSURU_NODES = [
  { name: 'node1', ip: '192.168.50.10' },
  { name: 'node2', ip: '192.168.50.11' }
]

Vagrant.configure('2') do |config|

  config.vm.provider :virtualbox do |vbox, override|
    override.vm.box = 'ubuntu14.04'
    override.vm.box_url = 'https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box'
  end

  # Main
  #
  config.vm.define :main, primary: true do |vbox|
    vbox.vm.network 'private_network', ip: TSURU_MAIN

    config.vm.provider :virtualbox do |vb|
      vb.customize [ 'modifyvm', :id, '--memory', '1024']
      vb.customize [ 'modifyvm', :id, '--cpus', '2' ]
    end

    vbox.vm.provision :shell do |shell|
      shell.path = 'install_main.sh'
      shell.args = [ 'stable', 'server' ]
    end
  end

  # MySQL
  #
  config.vm.define :mysql do |vbox|
    vbox.vm.network 'private_network', ip: TSURU_MYSQL

    config.vm.provider :virtualbox do |vb|
      vb.customize [ 'modifyvm', :id, '--memory', '512']
      vb.customize [ 'modifyvm', :id, '--cpus', '1']
    end
  end

  # Nodes
  #
  TSURU_NODES.each do |node|
    config.vm.define node[:name].to_sym do |vbox|
      vbox.vm.network 'private_network', ip: node[:ip]

      vb.customize [ 'modifyvm', :id, '--memory', '1024']
      vb.customize [ 'modifyvm', :id, '--cpus', '1' ]

      vbox.vm.provision :shell do |shell|
        shell.path = 'install_node.sh'
        shell.args = [ node[:name], TSURU_MAIN ]
      end
    end
  end

end
