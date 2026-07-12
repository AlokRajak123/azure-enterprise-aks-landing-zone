@description('Azure Region')
param location string

@description('Jump Box VM Name')
param vmName string = 'jumpbox'

@description('Administrator Username')
param adminUsername string = 'azureuser'

@secure()
@description('Administrator Password')
param adminPassword string

@description('Existing VNet Name')
param vnetName string = 'vnet-aks'

@description('Management Subnet Name')
param subnetName string = 'management-subnet'

@description('VM Size')
param vmSize string = 'Standard_B2s'

@description('Allowed public IP for SSH (CIDR)')
param allowedSshIp string

// Existing VNet
resource vnet 'Microsoft.Network/virtualNetworks@2024-01-01' existing = {
  name: vnetName
}

// Existing Subnet
resource subnet 'Microsoft.Network/virtualNetworks/subnets@2024-01-01' existing = {
  parent: vnet
  name: subnetName
}

// Public IP
resource publicIP 'Microsoft.Network/publicIPAddresses@2024-01-01' = {
  name: '${vmName}-pip'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

// Network Security Group
resource nsg 'Microsoft.Network/networkSecurityGroups@2024-01-01' = {
  name: '${vmName}-nsg'
  location: location

  properties: {
    securityRules: [
      {
        name: 'Allow-SSH'
        properties: {
          priority: 100
          protocol: 'Tcp'
          access: 'Allow'
          direction: 'Inbound'
          sourceAddressPrefix: allowedSshIp
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '22'
        }
      }
    ]
  }
}

// Network Interface
resource nic 'Microsoft.Network/networkInterfaces@2024-01-01' = {
  name: '${vmName}-nic'
  location: location

  properties: {
    networkSecurityGroup: {
      id: nsg.id
    }

    ipConfigurations: [
      {
        name: 'ipconfig1'

        properties: {
          subnet: {
            id: subnet.id
          }

          privateIPAllocationMethod: 'Dynamic'

          publicIPAddress: {
            id: publicIP.id
          }
        }
      }
    ]
  }
}

// Ubuntu VM
resource vm 'Microsoft.Compute/virtualMachines@2024-03-01' = {
  name: vmName
  location: location

  properties: {

    hardwareProfile: {
      vmSize: vmSize
    }

    osProfile: {
      computerName: vmName
      adminUsername: adminUsername
      adminPassword: adminPassword
      linuxConfiguration: {
        disablePasswordAuthentication: false
      }
    }

    storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer: 'ubuntu-24_04-lts'
        sku: 'server'
        version: 'latest'
      }

      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'StandardSSD_LRS'
        }
      }
    }

    networkProfile: {
      networkInterfaces: [
        {
          id: nic.id
        }
      ]
    }
  }
}

output jumpboxPublicIP string = publicIP.properties.ipAddress
