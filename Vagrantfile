# -*- mode: ruby -*-
# vi: set ft=ruby :

module OS
  def OS.windows?
    (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
  end

  def OS.mac?
   (/darwin/ =~ RUBY_PLATFORM) != nil
  end

  def OS.unix?
    !OS.windows?
  end

  def OS.linux?
    OS.unix? and not OS.mac?
  end
end

ENV['VAGRANT_DEFAULT_PROVIDER'] ||= OS.mac? ? 'vmware_appcatalyst' : "vmware_workstation"

fusion_path="/Applications/VMware Fusion.app/Contents/Library"
if File.directory?(fusion_path)
  ENV['PATH'] = "#{fusion_path}:#{ENV['PATH']}"
end

appcatalyst_path="/opt/vmware/appcatalyst/libexec"
if File.directory?(appcatalyst_path)
  ENV['PATH'] = "#{appcatalyst_path}:#{ENV['PATH']}"
end

# Hey Now! thanks StackOverflow: http://stackoverflow.com/a/28801317/1233435
req_plugins = %w(vagrant-triggers
                 vagrant-guests-photon)

if OS.mac?
  req_plugins << "vagrant-vmware-fusion" if File.directory?(fusion_path)
  req_plugins << "vagrant-vmware-appcatalyst" if File.directory?(appcatalyst_path)
else
  req_plugins << "vagrant-vmware-workstation"
end

# Cycle through the required plugins and install what's missing.
plugins_install = req_plugins.select { |plugin| !Vagrant.has_plugin? plugin }
licensed_plugins = plugins_install.select { |plugin| plugin =~ /vagrant-vmware-(?:fusion|workstation)$/ }
licensed_plugins.each do |plugin|
  unless File.exist? "#{ENV["VAGRANT_VMWARE_LICENSE_FILE"]||"./#{plugin}.lic"}"
    abort "Failed to configure license, you can configure the path with VAGRANT_VMWARE_LICENSE_FILE"
  end
end

unless plugins_install.empty?
  puts "Installing plugins: #{plugins_install.join(' ')}"
  if system "vagrant plugin install #{plugins_install.join(' ')}"
    exec "vagrant #{ARGV.join(' ')}"
  else
    abort 'Installation of one or more plugins has failed. Aborting.'
  end
end

licensed_plugins.each do |plugin|
  unless system "vagrant plugin license #{plugin} #{ENV["VAGRANT_VMWARE_LICENSE_FILE"]||"./#{plugin}.lic"}"
    abort "Failed to configure license, you can configure the path with VAGRANT_VMWARE_LICENSE_FILE"
  end
end

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "casualjim/archie-base"
  # config.vm.synced_folder ".", "/vagrant", disabled: true

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  config.vm.provider "virtualbox" do |vb|
    # Customize the amount of memory on the VM:
    vb.memory = "2048"
    vb.cpus = 2
  end


  %w(vmware_workstation vmware_fusion vmware_appcatalyst).each do |vmw_p|
    config.vm.provider vmw_p do |vmw|
      vmw.vmx["memsize"] = "2048"
      vmw.vmx["numvcpus"] = "2"
    end
  end

  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define "atlas" do |push|
  #   push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
  # end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   sudo apt-get update
  #   sudo apt-get install -y apache2
  # SHELL
end
