
# azure-workstation
# 1. workstation creation
````
export RESOURCEGROUP = 
export password = 
az vm create \
    --resource-group $RESOURCEGROUP \
    --name workstation \
    --image "/CommunityGalleries/LDOTrail-a8215d2e-c9a8-43ef-904d-c8b1ffb29cf7/Images/rhel9-devops-practice/latest-x64 Gen2" \
    --admin-username azureuser \
    --admin-password $password \
    --location eastus \
    --authentication-type password \
    --public-ip-sku Standard \
    --accept-term

````
### check vm status
````
 az vm show -g $RESOURCEGROUP -n workstation -d --query "{name:name,public_Ip:publicIps,state:powerState,private_Ip:privateIps,size:vmSize}" -o table 
 ````
### Vm
````
az account --set subscription C_029
az vm create \
  --resource-group $rg \
  --name workstation \
  --image RedHat:RHEL:9-lvm-gen2:latest \
  --admin-username azureuser \
  --admin-password $ps \
  --location eastus \
  --authentication-type password \
  --public-ip-sku Standard
``


