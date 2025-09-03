# Create Azure OpenAI service
resource "azurerm_cognitive_account" "openai" {
  name                = "${var.project_name}-openai-v2"
  location            = "East US 2"
  resource_group_name = data.azurerm_resource_group.main.name
  kind                = "OpenAI"
  sku_name            = "S0"

  tags = var.tags
}

# Deploy GPT-4o model
resource "azurerm_cognitive_deployment" "gpt4o" {
  name                 = "gpt-4o-deployment"
  cognitive_account_id = azurerm_cognitive_account.openai.id

  model {
    format  = "OpenAI"
    name    = "gpt-4o"
    version = "2024-05-13"
  }

  scale {
    type     = "Standard"
    capacity = 236
  }
}



