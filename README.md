
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
### VM
````
az account --set subscription C_029
az vm create \
  --resource-group $rg \
  --name workstation \
  --image RedHat:RHEL:9-lvm-gen2:latest \
  --admin-username azureuser \
  --admin-password $ps \
  --location eastus \
  --assign-identity \
  --authentication-type password \
  --public-ip-sku Standard

### role

spid=$(az vm identity assign   --resource-group $rg   --name test --query systemAssignedIdentity -o tsv)

àz role assignment create \
  --assignee $spid \
  --role Contributor \
  --scope /subscriptions/$sub/resourceGroups/$rg
````

## get kube ctl

````
az aks get-credentials   --resource-group nebula-sandbox-karthikeyangopal-629394fa   --name test-aks`
````

✅ Install kubectl on Red Hat (RHEL 8 / RHEL 9)
1️⃣ Add the official Kubernetes repo
````

cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.30/rpm/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.30/rpm/repodata/repomd.xml.key
EOF
````
```
sudo dnf install -y kubectl
kubectl version --client
```

