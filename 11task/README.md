# Task 11 - Vault and secrets

Understand run_all.sh skeleton and scripts.

Develop and deploy a simple helm chart (i.e. deployment with an echo).

Integrate with run_all.sh to deploy it when calling run_all.sh.

Add a custom secret in Vault.

Access from mypod to Vault to get the secret.

## Create binary, docker file, image and helm package

1. Create code and compile. 
2. Build docker image.
3. Create kind cluster. Load docker image.
4. Create and check that it works installing the helm chart.

```bash
helm install -f task11-helm/values.yaml task11-test ./task11-helm/
NAME: task11-test
LAST DEPLOYED: Wed Mar 24 12:33:09 2021
NAMESPACE: default
STATUS: deployed
REVISION: 1
TEST SUITE: None
```

## Add your deployment in run_all script adding a vault secret

1. Create martest dir in pkihub and add files.
2. Build image - Add the following code in line 133 in `builder/products/pkihub/build-images.sh`:
```
docker build -t green:latest -f $PKIHUB_HOME/martest/green/Dockerfile .
```
3. Kind load images - Add the following code in line 28 in `service/kubernetes/kind/load-kind-images.sh`:
```
printf "\033[0;32mLoading Image pkihub: Mar Test into the cluster...\033[0m\n"
    kind load docker-image green:latest \
    --nodes kind-worker,kind-worker2
```
4. Helm install - Add the following code in `builder/utils/pkihub/deploy_pkihub.sh`:

Line 92 - File defined in step 11.
```
# Put PKIHub secrets inside Vault
secrets-management/setup_pkihub_martest_vault_secrets.sh
```
Line 110
```
#Deploy Mar Test
export HELM_RELEASE_NAME_MAR_TEST=pkihub-martest-$CLUSTER_NAME
export HELM_VALUES_FILE_PATH_MAR_TEST=$PKIHUB_HOME/martest/helm/values.yaml
./kubernetes/deploy-martest.sh
```
5. Deploy script - Write deploy-martest.sh in `service/kubernetes/deploy-martest.sh`. See in extra_files folder.
6. Create SA martest  -  Add the following code in `service/vault/config/pkihub/pkihub-sa.yaml`:
Line 93:
```
apiVersion: v1
kind: ServiceAccount
metadata:
  name: martest
  namespace: pkihub
  labels:
    rds-access: "true"
---
```

Line 153:
```
  - kind: ServiceAccount
    name: martest
    namespace: pkihub
``` 
7. KV policy - Add martest-kv-policy.hcl (See in extra_files) in `service/vault/config/pkihub/martest-kv-policy.hcl`.
8. Deployment and SA - Define SA in deployment and update values.yaml.
9. Deployment and Vault secret - Add vault annotations in deployment.
10. Isitio vault policy - Add martest SA in istio policies to allow comunication with vault. Add the following code in line 36 in `service/istio/policies/vault/vault-policy.yaml`:
```
"cluster.local/ns/pkihub/sa/martest"
```
11. Vault secret - Create and write file setup_pkihub_martest_vault_secrets.sh (See in extra_files) in `service/secrets-management/setup_pkihub_martest_vault_secrets.sh`.
12. Run all:
```bash
DISABLE_MSSQL=1 CAGW=1 CLONE_BRANCH=develop PKIHUB_HOME=$PWD/.. CLEANUP=off HMAC=1 utils/pkihub/run_all.sh
```
13. Check all pods working and check that the secret is in martest pod:
```
kubectl exec -it martest-deployment-77b95f6f79-fd49n -n pkihub -c martest -- sh 
/ # cd home/pkihub/secrets/
/home/pkihub/secrets # ls
pkihub
/home/pkihub/secrets # cat pkihub

somepassword=mypassword
```
