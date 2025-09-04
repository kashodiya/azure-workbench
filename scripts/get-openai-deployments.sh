#!/bin/bash

RESOURCE=$(az cognitiveservices account list --query "[?kind=='OpenAI'].{name:name, resourceGroup:resourceGroup}" --output tsv)
RESOURCE_NAME=$(echo "$RESOURCE" | cut -f1)
RESOURCE_GROUP=$(echo "$RESOURCE" | cut -f2)

# Get endpoint URL
ENDPOINT=$(az cognitiveservices account show --name "$RESOURCE_NAME" --resource-group "$RESOURCE_GROUP" --query "properties.endpoint" --output tsv)

# Get API key
API_KEY=$(az cognitiveservices account keys list --name "$RESOURCE_NAME" --resource-group "$RESOURCE_GROUP" --query "key1" --output tsv)

echo "Resource: $RESOURCE_NAME"
echo "Endpoint: $ENDPOINT"
echo "API Key: $API_KEY"
echo ""

# List deployments with details
az cognitiveservices account deployment list \
  --name "$RESOURCE_NAME" \
  --resource-group "$RESOURCE_GROUP" \
  --query "[].{Name:name, Model:properties.model.name, Endpoint:'$ENDPOINT', ApiKey:'$API_KEY'}" \
  --output table