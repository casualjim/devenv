set -x -o pipefail

PASSWORD=$(/usr/bin/openssl passwd -crypt 'vagrant')

pacman -S --noconfirm git vim
cp -a /tmp/common/* /

echo "===> creating vagrant user"
useradd -m -U -s /bin/zsh -c 'Vagrant User' -G wheel -p ${PASSWORD} vagrant
echo 'vagrant ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/10_vagrant
chmod 0440 /etc/sudoers.d/10_vagrant
install --directory --owner=vagrant --group=vagrant --mode=0700 /home/vagrant/.ssh
curl -sL'#' --output /home/vagrant/.ssh/authorized_keys --location https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub
chown vagrant:vagrant /home/vagrant/.ssh/authorized_keys
chmod 0600 /home/vagrant/.ssh/authorized_keys
