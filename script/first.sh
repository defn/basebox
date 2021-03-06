#!/usr/bin/env bash

if [[ ! $PACKER_BUILDER_TYPE =~ amazon ]]; then
  if [[ -n "${http_proxy:-}" ]]; then
    echo "Acquire::http::Proxy \"$http_proxy\";" | tee /etc/apt/apt.conf.d/99boxcache
  fi
fi

dpkg --remove-architecture i386
apt-get update >/dev/null
apt-get install -y aptitude

aptitude update >/dev/null
aptitude install -y ntp curl unzip git perl ruby language-pack-en nfs-common build-essential dkms lvm2 xfsprogs xfsdump bridge-utils linux-headers-$(uname -r) software-properties-common

update-locale LANG=en_US.UTF-8

export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
locale-gen en_US.UTF-8
dpkg-reconfigure locales

useradd -s /bin/bash -m ubuntu || true
chsh -s /bin/bash ubuntu
gpasswd -a ubuntu sudo

cat > /etc/sudoers.d/90-cloud-init-users <<EOF
# User rules for ubuntu
ubuntu ALL=(ALL) NOPASSWD:ALL
EOF
chmod 440 /etc/sudoers.d/90-cloud-init-users
touch ~root/.cloud-init.hostname

install -d -o ubuntu -g ubuntu /opt/pkgsrc /vagrant


