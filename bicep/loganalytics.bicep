param location string

param workspaceName string = 'law-${uniqueString(resourceGroup().id)}'

resource workspace 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {

  name: workspaceName

  location: location

  sku: {
    name: 'PerGB2018'
  }

  properties: {}

}

output workspaceId string = workspace.id

output workspaceName string = workspace.name
