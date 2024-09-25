# vagrant-dev-vm

This vagrant build creates a local Dev VM with a GUI

## Creating the VM

You will need to run the `bootstrap_desktop` first, which ends with a forced reboot. 
Then you can up the VM again or run with the `install_dev_tools.sh`

Un-comment `# config.vm.provision "shell", path: "scripts/bootstrap_desktop.sh", privileged: false` in `Vagrantfile`
Then
```
vagrant up
```

Once this has finished and rebooted, you can halt the VM. 
```
vagrant halt
```

Re-comment `# config.vm.provision "shell", path: "scripts/bootstrap_desktop.sh", privileged: false` in `Vagrantfile`
Un-comment `# config.vm.provision "shell", path: "scripts/install_dev_tools.sh", privileged: false`
Then
```
vagrant up
```

### Run provisioning scripts

```
Vagrant.configure("2") do |config|
    config.vm.box = "ubuntu/focal64"
    config.vm.provider "virtualbox" do |vb|
        <omitted>
    end
    config.vm.provision "shell", path: "path/to/script.sh", privileged: false
    config.vm.provision "shell", path: "path/to/another/script", privileged: false
  end 
```

### Forward ports from the host to the vagrant gues

Forward ports 80 and 443
```
Vagrant.configure("2") do |config|
    config.vm.box = "ubuntu/focal64"
    config.vm.provider "virtualbox" do |vb|
        <omitted>
    end
    config.vm.network :forwarded_port, guest: 443, host: 443
    config.vm.network :forwarded_port, guest: 80, host: 80
  end
```