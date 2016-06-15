Vagrant.configure("2") do |config|
  config.vm.define "ethereum" do |ethereum|
    ethereum.vm.box = "ubuntu/trusty64"
    ethereum.vm.network "private_network", type: "dhcp"
    ethereum.vm.network :forwarded_port, guest: 8545, host: 8545
    ethereum.vm.network :forwarded_port, guest: 30303, host: 30303, protocol: "udp"
    
    ethereum.vm.provider "virtualbox" do |v|
      host = RbConfig::CONFIG['host_os']

      # Give VM 1/4 system memory & access to all cpu cores on the host
      if host =~ /darwin/
        cpus = `sysctl -n hw.ncpu`.to_i
        # sysctl returns Bytes and we need to convert to MB
        mem = `sysctl -n hw.memsize`.to_i / 1024 / 1024 / 4
      elsif host =~ /linux/
        cpus = `nproc`.to_i
        # meminfo shows KB and we need to convert to MB
        mem = `grep 'MemTotal' /proc/meminfo | sed -e 's/MemTotal://' -e 's/ kB//'`.to_i / 1024 / 4
      else # sorry Windows folks, I can't help you
        cpus = 2
        mem = 1024
      end

      v.customize ["modifyvm", :id, "--memory", mem]
      v.customize ["modifyvm", :id, "--cpus", cpus]
    end

    ethereum.vm.provision "shell", path: "configure-parity.sh"
  end
end


