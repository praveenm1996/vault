#vault cli install
sudo apt update && sudo apt install gpg wget
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install vault


#Helm Chart
helm  repo add hashicorp https://helm.releases.hashicorp.com 
helm repo add banzaicloud https://kubernetes-charts.banzaicloud.com
helm repo update
helm upgrade --install vault hashicorp/vault  --set='ui.enabled=true' --set='ui.serviceType=LoadBalancer' --set='injector.enabled=false'
sleep 30
kubectl create serviceaccount vault-auth
kubectl apply -f ./serviceaccount.yaml
kubectl apply -f ./role.yaml
kubectl apply -f ./rolebinding.yaml
kubectl apply -f ./clusterrole.yaml
kubectl apply -f ./clusterrolebinding.yaml
kubectl apply -f ./busybox.yaml
sleep 30
#kubectl get secret mysecretname -o jsonpath="{.data['ca\.crt']}" | base64 --decode > ca1.crt
# Not Worked kubectl get secret mysecretname -o jsonpath="{.data['ca\.crt']}"  > ca.crt
kubectl get secret mysecretname -o jsonpath="{.data['token']}" | base64 --decode > token.txt
##
TOKEN=$(cat token.txt)

# Extract the header (first part)
HEADER=$(echo "$TOKEN" | cut -d '.' -f 1)

# Extract the payload (second part)
PAYLOAD=$(echo "$TOKEN" | cut -d '.' -f 2)

# Extract the signature (third part)
SIGNATURE=$(echo "$TOKEN" | cut -d '.' -f 3)

echo "$PAYLOAD" | base64 --decode > tokensplit.txt
##

#kubectl exec -it vault-auth-pod -- cat /var/run/secrets/kubernetes.io/serviceaccount/token > tokenin.txt
#changed name
kubectl exec -it vault-auth-pod -- cat /var/run/secrets/kubernetes.io/serviceaccount/ca.crt > ca.crt
helm upgrade --install mphook banzaicloud/vault-secrets-webhook --set='env.VAULT_ROLE=full-access-role'