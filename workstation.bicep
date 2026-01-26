param virtualMachines_test_name string = 'test'
param disks_test_OsDisk_1_69816b1b7c6448cc94df42f34c894ee1_externalid string = '/subscriptions/5556f231-83ae-4b43-852a-5bacdb7558b6/resourceGroups/nebula-sandbox-karthikeyangopal-629394fa/providers/Microsoft.Compute/disks/test_OsDisk_1_69816b1b7c6448cc94df42f34c894ee1'
param networkInterfaces_testVMNic_externalid string = '/subscriptions/5556f231-83ae-4b43-852a-5bacdb7558b6/resourceGroups/nebula-sandbox-karthikeyangopal-629394fa/providers/Microsoft.Network/networkInterfaces/testVMNic'

resource virtualMachines_test_name_resource 'Microsoft.Compute/virtualMachines@2024-11-01' = {
  name: virtualMachines_test_name
  location: 'eastus'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_DS2_v5'
    }
    storageProfile: {
      imageReference: {
        publisher: 'RedHat'
        offer: 'RHEL'
        sku: '9-lvm-gen2'
        version: 'la${virtualMachines_test_name}'
      }
      osDisk: {
        osType: 'Linux'
        name: '${virtualMachines_test_name}_OsDisk_1_69816b1b7c6448cc94df42f34c894ee1'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          id: disks_test_OsDisk_1_69816b1b7c6448cc94df42f34c894ee1_externalid
        }
        deleteOption: 'Detach'
      }
      dataDisks: []
      diskControllerType: 'SCSI'
    }
    osProfile: {
      computerName: virtualMachines_test_name
      adminUsername: 'azureuser'
      linuxConfiguration: {
        disablePasswordAuthentication: false
        provisionVMAgent: true
        patchSettings: {
          patchMode: 'ImageDefault'
          assessmentMode: 'ImageDefault'
        }
      }
      secrets: []
      allowExtensionOperations: true
      requireGuestProvisionSignal: true
    }
    securityProfile: {
      uefiSettings: {
        secureBootEnabled: true
        vTpmEnabled: true
      }
      securityType: 'TrustedLaunch'
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterfaces_testVMNic_externalid
        }
      ]
    }
  }
}
