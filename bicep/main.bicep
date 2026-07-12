targetScope = 'resourceGroup'

@description('Azure Region')
param location string = resourceGroup().location

// Infrastructure Modules

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

// AKS and JumpBox will be added in Part-2
