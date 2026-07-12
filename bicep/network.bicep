param location string
param vnetName string
param aksSubnetName string

resource vnet 'Microsoft.Network/virtualNetworks@2023-05-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.10.0.0/16'
      ]
    }

    subnets: [
      {
        name: aksSubnetName
        properties: {
          addressPrefix: '10.10.1.0/24'
        }
      }
    ]
  }
}

output subnetId string = vnet.properties.subnets[0].id
