param location string

resource law 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {

  name: 'law-akslab'

  location: location

  properties: {}

  sku: {
    name: 'PerGB2018'
  }

}

output workspaceId string = law.id
