param name string
param location string = resourceGroup().location
param endpointConfig object

resource cdnProfile 'Microsoft.Cdn/profiles@2020-09-01' = {
  name: name
  location: location
  tags: {
    displayName: name
  }
  sku: {
    name: 'Standard_Microsoft'    
  }
}

resource endpoint 'Microsoft.Cdn/profiles/endpoints@2020-09-01' = {
  parent: cdnProfile
  name: endpointConfig.name
  location: location
  tags: {
    displayName: endpointConfig.name
  }
  properties: {
    originHostHeader: endpointConfig.originHostHeader
    isHttpAllowed: true
    isHttpsAllowed: true
    queryStringCachingBehavior: 'IgnoreQueryString'
    contentTypesToCompress: [
      'text/plain'
      'text/html'
      'text/css'
      'application/x-javascript'
      'text/javascript'
    ]
    isCompressionEnabled: true
    origins: [
      {
        name: 'origin1'
        properties: {
          hostName: endpointConfig.originHostHeader
        }
      }
    ]
  }
}

output hostName string = endpoint.properties.hostName
output originHostHeader string = endpoint.properties.originHostHeader
