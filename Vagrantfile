Vagrant.configure("2") do |config|
    config.vm.box = "ubuntu/focal64"
    config.vm.provider "virtualbox" do |vb|
        # Display the VirtualBox GUI when booting the machine
        vb.gui = true
        vb.memory = "8192"
        vb.customize ["modifyvm", :id, "--vram", "56"]
        # Known workaround for ubuntu slow boot bug
        vb.customize ["modifyvm", :id, "--uart1", "0x3F8", "4"]
        vb.customize ["modifyvm", :id, "--uartmode1", "file", File::NULL]
        vb.customize ["modifyvm", :id, "--nestedpaging", "off"]
        vb.customize ["modifyvm", :id, "--cpus", 4]
        vb.customize ["modifyvm", :id, "--paravirtprovider", "hyperv"]
    end
    # config.vm.provision "shell", path: "scripts/bootstrap_desktop.sh", privileged: false
    # config.vm.provision "shell", path: "scripts/install_dev_tools.sh", privileged: false
    config.vm.boot_timeout = 300
    config.vm.box_check_update = false
  end