Vagrant.configure("2") do |config|
  config.vm.define "dapps" do |dapps|
    dapps.vm.box = "ubuntu/trusty64"
    
    dapps.vm.provider "virtualbox" do |v|
      v.memory = 2048
      v.cpus = 2
    end

    dapps.vm.provision "ansible" do |ansible|
      ansible.playbook = "setup.yml"
      ansible.verbose = "v"
      ansible.groups = {
        "pyeth" => ["dapps"]
      }
    end
  end
end
