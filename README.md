# Azure Container Instance Deployment with Public IP

This project demonstrates how to deploy a containerized Flask application to Azure using Azure Container Instances (ACI), with a public IP for external access. It also includes logging to Azure Monitor.

## Prerequisites

Before you begin, ensure that you have the following:

- **Azure CLI** installed and configured with your Azure account.
- **Docker** installed for building and pushing container images.
- **Bicep** installed (for deploying resources via Infrastructure-as-Code).
- **Git** installed for version control and pushing to GitHub.
- A **container image** stored in Azure Container Registry (ACR).
- An **Azure Monitor Log Analytics workspace** to store container logs.

## Azure Resources

This solution requires the following resources:

- **Azure Container Instance (ACI)**: To host the container.
- **Azure Container Registry (ACR)**: To store the Docker image.
- **Public IP**: To make the Flask app accessible from the internet.
- **Log Analytics workspace**: To send container logs to Azure Monitor.

## Steps to Deploy

### 1. Log in to Azure

First, log in to your Azure account:

az login

2. Create the Resource Group
Create a resource group in your desired location (replace westeurope with your preferred location):

az group create --name myResourceGroup --location westeurope

3. Create the Azure Container Registry (ACR)
Create an Azure Container Registry (ACR) to store the Docker image:

az acr create --resource-group myResourceGroup --name r0990219acram --sku Basic

4. Create a Log Analytics Workspace
Create a Log Analytics workspace to collect logs:

az monitor log-analytics workspace create --resource-group myResourceGroup --workspace-name myWorkspace

5. Get Workspace ID and Key
Retrieve the Workspace ID and Key for Azure Monitor integration:

workspaceId=$(az monitor log-analytics workspace show --resource-group myResourceGroup --workspace-name myWorkspace --query id --output tsv)
workspaceKey=$(az monitor log-analytics workspace get-shared-keys --resource-group myResourceGroup --workspace-name myWorkspace --query primarySharedKey --output tsv)

6. Build and Push Docker Image to ACR
If you haven't already built your container image, you need to do so:

# Login to Azure Container Registry
az acr login --name r0990219acram

# Build the Docker image
docker build -t r0990219acram.azurecr.io/example-flask-crud:v1 .

# Push the image to Azure Container Registry
docker push r0990219acram.azurecr.io/example-flask-crud:v1

8. Deploy ACI Using Bicep Template
Deploy the container using the Bicep template you created:

az deployment group create --resource-group myResourceGroup --template-file aci.bicep  --parameters containerName=exampleflaskcrud  acrPassword="***enter acr password***"

9. Verify Deployment
Once the deployment is complete, check the status and public IP address of your container:

az container show --resource-group myResourceGroup --name exampleflaskcrud --query "{Status:instanceView.state,FQDN:ipAddress.fqdn}" --output table
