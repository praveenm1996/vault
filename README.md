# vault Setup Using Vault helm and operator chart 
# vault-env Injection enabled 
# Vault in development mode.

1. Vaultsetup.sh
line 2-6: Installing the Vault CLI to confige the vault after the helm chart installation task unsealing,enableing k8s auth , adding policy etc

Line 10-13: Adding the helm repo and installing the vault helm chart with UI enabled,Loadbalancer service type, injector is false because going to us banzaicloud injector

Line 15-20: Creating all the needed k8s object to authenticate with vault after the deployment.

Line 21: Creating busybox to read the Serviceaccount mapped Token and ca.crt to map it to vault configuration.
Line 25: Reading the Token saving it in the token.txt
Line 29: reading the ca.crt of the service account using the busybox
Line 30: installing the vault webhook with vaule role env value which is nothing but Role which is going to create in the vault after installion 

NOTE.txt
Line 3-6: initalize the vault and unseal it. While doing this u will get token and inital token.
Line 10-12: Login to vault to config auth method and role and policy.
Line 14: enable the kubernetes
Line 16-19: auth config
Line 21: Policy creation from the file ./full-access-policy
Line 23-27: Assign role to auth

Buildagent.yaml
Diffenent from other deployment
annotations: need to download bin
serviceaccountname: connect
automountServiceAccountToken : auth