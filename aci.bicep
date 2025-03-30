param location string = 'westeurope'
param containerName string = 'exampleflaskcrud'
param acrName string = 'r0990219acram'
param workspaceId string
param workspaceKey string
@secure()
param acrPassword string

resource aci 'Microsoft.ContainerInstance/containerGroups@2021-09-01' = {
  name: containerName
  location: location
  properties: {
    containers: [
      {
        name: containerName
        properties: {
          image: '${acrName}.azurecr.io/example-flask-crud:v1'
          ports: [
            {
              protocol: 'TCP'
              port: 80
            }
          ]
          resources: {
            requests: {
              cpu: 1
              memoryInGB: 2
            }
          }
        }
      }
    ]
    osType: 'Linux'
    imageRegistryCredentials: [
      {
        server: '${acrName}.azurecr.io'
        username: acrName
        password: acrPassword
      }
    ]
    ipAddress: {
      type: 'Public'
      ports: [
        {
          protocol: 'TCP'
          port: 80
        }
      ]
    }
    diagnostics: {
      logAnalytics: {
        workspaceId: workspaceId
        workspaceKey: workspaceKey
      }
    }
  }
}
