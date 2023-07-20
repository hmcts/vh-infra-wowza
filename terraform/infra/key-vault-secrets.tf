locals {
  secret_prefix = "wowzaconfiguration"
  secrets = {
    "azure-storage-directory"   = "/wowzadata/azurecopy",
    "endpoint-rtmps"            = "rtmps://${local.wowza_domain}:443/",
    "endpoint-https"            = "https://${local.wowza_domain}:443/",
    "restendpoint--0"           = "https://${local.wowza_domain}:8090/",
    "restendpoint--1"           = "https://${local.wowza_domain}:8091/",
    "hostname"                  = "_defaultVHost_"
    "managedidentityclientid"   = data.azurerm_user_assigned_identity.vh_mi.client_id,
    "restPassword"              = random_password.restPassword.result,
    "ServerName"                = "_defaultServer_"
    "ssh-private"               = tls_private_key.vm.private_key_openssh
    "ssh-public"                = tls_private_key.vm.public_key_openssh
    "storage-account-container" = local.recordings_container_name,
    "storage-account-endpoint"  = module.wowza_recordings.storageaccount_primary_blob_endpoint,
    "storage-account"           = module.wowza_recordings.storageaccount_name,
    "storageaccountkey"         = module.wowza_recordings.storageaccount_primary_access_key,
    "storage-connection-string" = module.wowza_recordings.storageaccount_primary_connection_string,
    "streamPassword"            = random_password.streamPassword.result,
    "username"                  = var.admin_user
    "wowza-storage-directory"   = "usr/local/WowzaStreamingEngine/content/"
    "Splunk-admin"              = local.splunk_admin_username
    "Splunk-password"           = ""
  }
}

resource "azurerm_key_vault_secret" "secret" {
  for_each        = local.secrets
  key_vault_id    = data.azurerm_key_vault.vh-infra-core.id
  name            = "${local.secret_prefix}--${each.key}"
  value           = each.value
  tags            = local.common_tags
  content_type    = ""
  expiration_date = "2032-12-31T00:00:00Z"
}