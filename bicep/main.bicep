targetScope='resourceGroup'

module network './network.bicep' = {
  name: 'network'
}

module aks './aks.bicep' = {
  name: 'aks'
  params:{
      subnetId: network.outputs.subnetId
  }
}
