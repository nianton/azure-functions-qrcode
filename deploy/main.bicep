param naming object
param location string = resourceGroup().location
@allowed([
  'Y1'
  'EP1'
  'EP2'
  'EP3'
])
param functionAppServicePlanSku string
param functionAppRepoUrl string
param tags object

var resourceNames = {
  functionApp: naming.functionApp.name
  dataStorage: naming.storageAccount.nameUnique
  cdnProfile: naming.cdnProfile.name
  cdnEndpoint: naming.cdnEndpoint.name
}

// Deploying a module, passing in the necessary naming parameters (storage account name should be globally unique, we prefer the 'nameUnique' value)
module dataStorage 'modules/storage.module.bicep' = {
  name: 'dataStorage-Deployment'
  params: {
    location: location
    kind: 'StorageV2'
    skuName: 'Standard_LRS'
    name: resourceNames.dataStorage
    tags: tags
  }
}

module functionApp 'modules/functionApp.module.bicep' = {
  name: 'functionApp-Deployment'
  params: {
    name: resourceNames.functionApp
    location: location
    skuName: functionAppServicePlanSku
    funcDeployRepoUrl: functionAppRepoUrl
    tags: tags
  }
}

module cdnProfile 'modules/cdnProfile.module.bicep' = {
  name: 'cdnProfile-Deployment'
  params: {
    name: resourceNames.cdnProfile
    endpointConfig: {
      name: resourceNames.cdnEndpoint
      originHostHeader: functionApp.outputs.defaultHostName      
    }
    location: location
  }
}

output dataStorageAccountName string = dataStorage.outputs.name
output functionAppUrl string = functionApp.outputs.name
