targetScope = 'resourceGroup'

param location string = resourceGroup().location
param clusterName string

module network './network.bicep' = {
  name: 'network'
  params: {
    location: location
  }
}

module loganalytics './loganalytics.bicep' = {
  name: 'loganalytics'
  params: {
    location: location
  }
}

module acr './acr.bicep' = {
  name: 'acr'
  params: {
    location: location
  }
}

module aks './aks.bicep' = {
  name: 'aks'
  params: {
    location: location
    clusterName: clusterName
    subnetId: network.outputs.subnetId
    workspaceId: loganalytics.outputs.workspaceId
    acrId: acr.outputs.acrId
  }
}
