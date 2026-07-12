az bicep build --file bicep/main.bicep

az deployment group validate `
    --resource-group rg-aks-lab `
    --template-file bicep/main.bicep `
    --parameters parameters/dev.parameters.json