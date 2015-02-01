# vi: set ft=ruby :

TSURU_MAIN = "192.168.50.4"

Vagrant.configure("2") do |config|

  config.vm.provider :virtualbox do |vbox, override|
    override.vm.box = "ubuntu14.04"
    override.vm.box_url = "https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box"
  end

  config.vm.define :main, primary: true do |vbox|
    vbox.vm.network "private_network", ip: TSURU_MAIN

    config.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "1024"]
      vb.customize ["modifyvm", :id, "--cpus", "2"]
    end

    vbox.vm.provision :shell do |shell|
      shell.path = "install_main.sh"
      shell.args = [
        ENV["TSURU_BOOTSTRAP"]      || "stable",
        ENV["TSURU_NOW_SCRIPT_URL"] || "https://raw.githubusercontent.com/tsuru/now/master/run.bash",
        ENV["TSURU_NOW_HOOK_URL"]   || "https://raw.githubusercontent.com/tsuru/tsuru/master/misc/git-hooks/pre-receive.archive-server",
        ENV["TSURU_NOW_OPTIONS"]    || ""
      ]
    end
  end

  config.vm.define :node1 do |vbox|
    vbox.vm.network "private_network", ip: "192.168.50.10"

    config.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "512"]
      vb.customize ["modifyvm", :id, "--cpus", "1"]
    end

    vbox.vm.provision :shell do |shell|
      shell.path = "install_node.sh"
      shell.args = %W{ node1 TSURU_MAIN }
    end
  end

  config.vm.define :node2 do |vbox|
    vbox.vm.network "private_network", ip: "192.168.50.11"

    config.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "512"]
      vb.customize ["modifyvm", :id, "--cpus", "1"]
    end

    vbox.vm.provision :shell do |shell|
      shell.path = "install_node.sh"
      shell.args = %W{ node2 TSURU_MAIN }
    end
  end

end
