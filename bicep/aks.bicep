param location string

param clusterName string

param subnetId string

param workspaceId string

param acrId string

param nodeCount int = 1

param vmSize string = 'Standard_B2s'

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

    dnsPrefix: clusterName

    enableRBAC: true

    apiServerAccessProfile: {
      enablePrivateCluster: true
    }

    networkProfile: {
      networkPlugin: 'azure'
      networkPluginMode: 'overlay'
      loadBalancerSku: 'standard'
      outboundType: 'loadBalancer'
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
        name: 'system'

        mode: 'System'

        count: nodeCount

        vmSize: vmSize

        osType: 'Linux'

        osDiskSizeGB: 30

        type: 'VirtualMachineScaleSets'

        vnetSubnetID: subnetId
      }
    ]
  }
}
