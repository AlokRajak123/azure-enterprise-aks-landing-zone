param location string

resource acr 'Microsoft.ContainerRegistry/registries@2023-07-01' = {

  name: 'akslabacr12345'

  location: location

  sku: {

    name: 'Basic'

  }

}

output acrId string = acr.id
