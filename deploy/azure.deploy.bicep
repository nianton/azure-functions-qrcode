targetScope = 'subscription'

param location string
param applicationName string
param environment string

@allowed([
  'Y1'
  'EP1'
  'EP2'
  'EP3'
])
param functionAppServicePlanSku string
param functionAppRepoUrl string
param tags object = {}

var defaultTags = union({
  applicationName: applicationName
  environment: environment
}, tags)

// Resource group which is the scope for the main deployment below
resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'rg-${applicationName}-${environment}'
  location: location
  tags: defaultTags
}

// Naming module to configure the naming conventions for Azure
module naming 'modules/naming.module.bicep' = {
  scope: resourceGroup(rg.name)
  name: 'NamingDeployment'  
  params: {
    suffix: [
      applicationName
      environment
    ]
    uniqueLength: 6
    uniqueSeed: rg.id
  }
}

// Main deployment has all the resources to be deployed for 
// a workload in the scope of the specific resource group
module main 'main.bicep' = {
  scope: resourceGroup(rg.name)
  name: 'MainDeployment'
  params: {
    location: location
    naming: naming.outputs.names
    functionAppServicePlanSku: functionAppServicePlanSku
    functionAppRepoUrl: functionAppRepoUrl    
    tags: defaultTags
  }
}

// Customize outputs as required from the main deployment module
output resourceGroupId string = rg.id
output resourceGroupName string = rg.name
output dataStorageAccountName string = main.outputs.dataStorageAccountName
output functionAppUrl string = main.outputs.functionAppUrl
