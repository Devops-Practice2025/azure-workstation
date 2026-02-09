#terraform
sudo dnf update -y
sudo dnf install -y dnf-plugins-core
sudo dnf config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
sudo dnf -y install terraform

#ansible
sudo dnf config-manager --enable codeready-builder-for-rhel-9-x86_64-rhui-rpms
sudo dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm
sudo dnf makecache
sudo dnf install -y ansible

#az- cli
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo dnf install -y azure-cli

#lv
sudo lvextend -L +5G /dev/mapper/rootvg-homelv
sudo xfs_growfs /home