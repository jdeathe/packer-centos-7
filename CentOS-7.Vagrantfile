# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

  # Set the user for SSH access
  config.ssh.username = "{{user `ssh_user`}}"

  config.vm.network "forwarded_port", 
    guest: 22, 
    host: 2222, 
    id: "ssh", 
    auto_correct: true

  # Disable the default Vagrant directory sync
  config.vm.synced_folder ".", 
    "/vagrant", 
    disabled: true

  # VirtualBox Guest customisations
  config.vm.provider "virtualbox" do |vb|

    # Prevent checking VirtualBox GuestAdditions
    vb.check_guest_additions = false

    # Prevent checking VirtualBox Shared Folders
    vb.functional_vboxsf = false
  end
end

