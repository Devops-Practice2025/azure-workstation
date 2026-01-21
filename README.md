# azure-workstation
workstation
````
az vm create \
    --resource-group $RESOURCEGROUP \
    --name myVM \
    --image "/CommunityGalleries/LDOTrail-a8215d2e-c9a8-43ef-904d-c8b1ffb29cf7/Images/rhel9-devops-practice/Versions/latest" \
    --admin-username azureuser \
    --admin-password $password \
    --location eastus \
    --authentication-type password \
    --public-ip-sku Standard \
    --accept-term

````
