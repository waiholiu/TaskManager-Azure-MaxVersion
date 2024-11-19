# Upgrade the Azure CLI
az upgrade

# Install/upgrade the Azure Container Apps & Application Insights extensions
az extension add --upgrade --name containerapp
az extension add --upgrade --name application-insights

# Log in to Azure
az login

# Retrieve the currently active Azure subscription ID
$AZURE_SUBSCRIPTION_ID = az account show --query id --output tsv

# Set a specific Azure Subscription ID (if you have multiple subscriptions)
# $AZURE_SUBSCRIPTION_ID = "<Your Azure Subscription ID>" # Your Azure Subscription id which you can find on the Azure portal
# az account set --subscription $AZURE_SUBSCRIPTION_ID

echo $AZURE_SUBSCRIPTION_ID

# Create a random, 6-digit, Azure safe string
$RANDOM_STRING=-join ((97..122) + (48..57) | Get-Random -Count 6 | ForEach-Object { [char]$_})
$RESOURCE_GROUP="rg-tasks-tracker-$RANDOM_STRING"
$LOCATION="eastus"
$ENVIRONMENT="cae-tasks-tracker"
$WORKSPACE_NAME="log-tasks-tracker-$RANDOM_STRING"
$APPINSIGHTS_NAME="appi-tasks-tracker-$RANDOM_STRING"
$BACKEND_API_NAME="tasksmanager-backend-api"
$AZURE_CONTAINER_REGISTRY_NAME="crtaskstracker$RANDOM_STRING"
$VNET_NAME="vnet-tasks-tracker"
$TARGET_PORT=8080


# Create the Log Analytics workspace
az monitor log-analytics workspace create `
--resource-group $RESOURCE_GROUP `
--workspace-name $WORKSPACE_NAME

# Retrieve the Log Analytics workspace ID
$WORKSPACE_ID=az monitor log-analytics workspace show `
--resource-group $RESOURCE_GROUP `
--workspace-name $WORKSPACE_NAME `
--query customerId `
--output tsv

# Retrieve the Log Analytics workspace secret
$WORKSPACE_SECRET=az monitor log-analytics workspace get-shared-keys `
--resource-group $RESOURCE_GROUP `
--workspace-name $WORKSPACE_NAME `
--query primarySharedKey `
--output tsv