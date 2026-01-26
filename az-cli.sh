set -x

sub_id=$(az account list -o table | grep C_029773-training-subscription | awk '{print $3}')
rg=$(az group list -o table | grep nebula | awk '{print $1}')
read -p "Enter your pass for VM workstation: " ps

az account set --subscription $sub_id
az vm create \
  --resource-group $rg \
  --name workstation \
  --image RedHat:RHEL:9-lvm-gen2:latest \
  --admin-username azureuser \
  --admin-password $ps \
  --location eastus \
  --size Standard_D2s_v5\
  --assign-identity \
  --authentication-type password \
  --public-ip-sku Standard

set +x