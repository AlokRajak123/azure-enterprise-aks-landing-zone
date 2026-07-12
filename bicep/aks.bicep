param location string
param aksName string
param subnetId string
param workspaceId string

resource aks 'Microsoft.ContainerService/managedClusters@2024-02-01' = {
  name: aksName
  location: location

  identity: {
    type: 'SystemAssigned'
  }

  properties: {

    dnsPrefix: 'akslab'

    enableRBAC: true

    networkProfile: {
      networkPlugin: 'azure'
    }

    agentPoolProfiles: [
      {
        name: 'system'

        count: 1

        vmSize: 'Standard_B2s'

        mode: 'System'

        osType: 'Linux'

        vnetSubnetID: subnetId
      }
    ]

    addonProfiles: {
      omsagent: {
        enabled: true
        config: {
          logAnalyticsWorkspaceResourceID: workspaceId
        }
      }
    }

    apiServerAccessProfile: {
      enablePrivateCluster: true
    }
  }
}
