#!/bin/bash

set -e

echo "INSTALLATION-K8S"

#sudo dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm

#wget http://mirror.centos.org/centos/7/os/x86_64/Packages/squashfs-tools-4.3-0.21.gitaae0aff4.el7.x86_64.rpm

#sudo yum install squashfs-tools-4.3-0.21.gitaae0aff4.el7.x86_64.rpm -y

sudo yum -y install snapd

sudo systemctl start snapd

sudo ln -s /var/lib/snapd/snap /snap

sudo snap install microk8s --classic --channel=1.28/stable

sleep 5

sudo usermod -aG microk8s $USER

sudo chown -f -R $USER ~/.kube

snap list

echo "FIREWALL-RULES"

sudo firewall-cmd  --permanent --add-port={10255,12379,25000,16443,10250,10257,10259,32000}/tcp

sudo firewall-cmd --add-masquerade --permanent

sudo firewall-cmd --reload

echo ""

#echo -e "export LC_ALL=C.UTF-8\n export LANG=C.UTF-8" >> ~/.bashrc

#echo "alias kubectl='microk8s kubectl'" > ~/.bash_aliases

#echo -e "\nif [ -f ~/.bash_aliases ]; then\n        . ~/.bash_aliases\nfi"  >> ~/.bashrc

#source ~/.bashrc

#echo "DELETE-DOWNLOADS"

#sudo rm squashfs-tools-4.3-0.21.gitaae0aff4.el7.x86_64.rpm

echo "ENABLED-FEATURES"

microk8s enable dns ingress

microk8s stop

microk8s start

echo "K8s-installation successfully"