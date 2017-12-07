# riseml installation instructions

0. setup the k8s cluster
1. setup helm
    ```bash
    helm init --tiller-namespace kube-system
    helm repo add riseml-charts https://cdn.riseml.com/helm-charts
    ```
2. install RiseML!
    * with GPU
    ```bash
    kubectl create namespace riseml
    helm install riseml-charts/riseml --name riseml --namespace riseml -f riseml/riseml-config.yml
    watch -n 1 kubectl get pods -n riseml
    ```
    * no GPU
    ```bash
    kubectl create namespace riseml
    helm install riseml-charts/riseml --name riseml --namespace riseml -f riseml/riseml-config-no-GPU.yml
    watch -n 1 kubectl get pods -n riseml
    ```

3. once all riseml pods are running, get the endpoints:
    ```bash
    riseml/riseml-endpoints.sh
    ```
4. login to riseml, manually copypaste the endpoints obtained in step 3
    ```
    riseml user login
    ```
5. check installation
    ```
    riseml system info
    riseml system test
    ```

