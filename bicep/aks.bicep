param location string
param clusterName string
param subnetId string
param workspaceId string
param acrId string

resource aks 'Microsoft.ContainerService/managedClusters@2024-05-01' = {
  name: clusterName
  location: location

  identity: {
    type: 'SystemAssigned'
  }

  sku: {
    name: 'Basic'
    tier: 'Free'
  }

  properties: {
    dnsPrefix: 'akslab'

    enableRBAC: true

    apiServerAccessProfile: {
      enablePrivateCluster: true
    }

    networkProfile: {
      networkPlugin: 'azure'
      networkPluginMode: 'overlay'
    }

    addonProfiles: {
      omsagent: {
        enabled: true
        config: {
          logAnalyticsWorkspaceResourceID: workspaceId
        }
      }
    }

    agentPoolProfiles: [
      {
        name: 'nodepool1'
        count: 1
        vmSize: 'Standard_B2s'
        osType: 'Linux'
        mode: 'System'
        vnetSubnetID: subnetId
      }
    ]
  }
}
