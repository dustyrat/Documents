## Requirements:
- kubectl: https://kubernetes.io/docs/tasks/tools/
- yq: https://github.com/mikefarah/yq

## Common Commands:
- Version
  - `kubectl version`
- Config
  - Current Context:
    - `kubectl config current-context`
  - Get Contexts:
    - `kubectl config get-contexts`
- Deployments:
  - List Deployments:
    -  `kubectl get deployments --context [CONTEXT]`
      <br>ex: `kubectl get deployments --context dev`
  - List Deployments extended:
    -  `kubectl get deployments -o wide --context [CONTEXT]`
      <br>ex: `kubectl get deployments -o wide --context dev`
  - Get Deployment:
    -  `kubectl get deployment [DEPLOYMENT_NAME] --context [CONTEXT]`
      <br>ex: `kubectl get deployment example --context dev`
  - Get Deployment extended:
    -  `kubectl get deployment [DEPLOYMENT_NAME] -o wide --context [CONTEXT]`
      <br>ex: `kubectl get deployment example -o wide --context dev`
  - Get Deployment Details:
    -  `kubectl describe deployment [DEPLOYMENT_NAME] --context [CONTEXT]`
      <br>ex: `kubectl describe deployment example --context dev`
 - Logs
    - Tail Pods's Logs:
      -  `kubectl logs [POD_NAME] --all-containers --ignore-errors -f --context [CONTEXT]`
      <br>ex: `kubectl logs example-000000000-00000 --all-containers --ignore-errors -f --context dev`
    - Tail All Container's Logs:
      -  `kubectl logs --all-containers --ignore-errors --max-log-requests 50 -l [SELECTOR_KEY]=[SELECTOR_VALUE] -f --context [CONTEXT]`
      <br>ex: `kubectl logs --all-containers --ignore-errors --max-log-requests 50 -l app=example -f --context dev`
- Scaling:
  - Scale Deployment:
    -  `kubectl scale deployment [DEPLOYMENT_NAME] --replicas [REPLICAS] --context [CONTEXT]`
      <br>ex: `kubectl scale deployment example --replicas 0 --context dev`
      <br>ex: `kubectl scale deployment example --replicas 1 --context dev`
  - Restart Application:
    -  `kubectl rollout restart deployment [DEPLOYMENT_NAME] --context [CONTEXT]`
      <br>ex: `kubectl rollout restart deployment example --context dev`
-  Secrets:
   - Create Secret (to STDOUT):
     -  `kubectl create secret generic [SECRET_NAME] --from-file=[FILE_NAME | DIRECTORY] --dry-run -o yaml --context [CONTEXT]`
      <br>ex: `kubectl create secret generic example --from-file=example.json --dry-run -o yaml`
      <br>ex: `kubectl create secret generic example --from-file=./example/directory --dry-run -o yaml`
   - Create Secret and Upload:
     -  `kubectl create secret generic [SECRET_NAME] --from-file=[FILE_NAME | DIRECTORY] --dry-run -o yaml --context [CONTEXT] | kubectl apply -f - --context [CONTEXT]`
      <br>ex: `kubectl create secret generic example --from-file=example.json --dry-run -o yaml | kubectl apply -f - --context dev`
      <br>ex: `kubectl create secret generic example --from-file=./example/directory --dry-run -o yaml | kubectl apply -f - --context dev`
   - Get JSON Secret File (to STDOUT):
     -  `kubectl get secret [SECRET_NAME] -o yaml --context [CONTEXT] | yq e -M ".data" - | awk -F ': ' '{print $2}' | base64 -D`
      <br>ex: `kubectl get secret example -o yaml --context dev | yq e -M ".data" - | awk -F ": " '{print $2}' | base64 -D`
      