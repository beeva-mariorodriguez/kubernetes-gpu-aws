# PoC Kubernetes cluster with GPU support

experiment: build a kubernetes cluster in AWS with nvidia GPU support

## notes
* this is an experiment/proof of concept, do NOT use blindly in production
* currently GPU support in kubernetes is a moving target, it's expected to change
* good luck!

## requirements
* [packer](https://www.packer.io/) 1.1.2
* [terraform](https://www.terraform.io/) 0.11.1
* [kubectl](https://github.com/kubernetes/kubectl) 1.7.3
* [Kubernetes Operations (kops)](https://github.com/kubernetes/kops) 1.8.x
* [AWS CLI](https://aws.amazon.com/cli/) 1.11.x
* GNU make, jq, bash


## instructions

0. authenticate with aws and export the three variables:

1. build the AMI: https://github.com/beeva-mariorodriguez/beevalabs-docker-nvidia-ami
    ```bash
    packer build beevalabs-docker-nvidia.json
    ```

2. create S3 bucket to store kops state (in us-east-1)
    ```bash
    aws s3api create-bucket --bucket s3://my-kops-state-store --region us-east-1
    ```

3. export terraform environment variables
    ```bash
    export TF_VAR_kops_state_store="s3://your-kops-state-store"
    export KOPS_STATE_STORE="s3://my-kops-state-store"
    export TF_VAR_cluster_name="mycluster.example.com"
    export TF_VAR_domain_name="example.com"
    ```

4. create the VPC and the (private) dns zone
    ```bash
    terraform plan
    terraform apply
    ```

5. use kops to create the cluster (just state and terraform configuration)
    ```bash
    ./createcluster.sh
    ```

6. [optional] edit the nodes instancegroup to use an image with nvidia drivers (``602636675831/beevalabs-docker-nvidia-jessie-0.6``)
    ```bash
    kops edit ig nodes --name cluster.k8s.beevalabs
    ```
    ```yaml
    spec:
      image: 602636675831/beevalabs-docker-nvidia-jessie-0.6
    ```

7. [optional] edit the cluster to enable the accelerators featuregate
    ```bash
    kops edit cluster --name cluster.k8s.beevalabs
    ```
    ```yaml
    spec:
      kubelet:
        featureGates:
          Accelerators: "true"
    ```

8. finish the k8s deploy
    ```bash
    kops update cluster  $(terraform output cluster_name) --state $(terraform output kops_state_store)  --yes
    ```

9. now you need to add the public api load balancer's IP to your /etc/hosts (remember, the dns zone is private)
    1. get the LB's public dns name
        ```bash
        aws route53 list-resource-record-sets \
            --hosted-zone-id $(terraform output aws_dns_zone_id) | \
            jq --arg resource api.$(terraform output cluster_name). \
            '.ResourceRecordSets[]|select(.Name==$resource).AliasTarget.DNSName'
        ```
    2. use nslookup to get the IP
    3. add the public IP to your /etc/hosts as cluster_name
        ```
        echo "1.2.3.4 api.$TF_VAR_cluster_name" >> /etc/hosts
        ```
    there _must_ be a better way ...

## references
* https://kubernetes.io/docs/tasks/manage-gpus/scheduling-gpus/
* https://www.nivenly.com/kops-1-5-1/
* https://github.com/ryane/kubernetes-aws-vpc-kops-terraform/
* https://github.com/kubernetes/kops/blob/db7c973112a1a3561ea1c18be85c5b5abed23b9e/docs/gpu.md
* https://github.com/ryane/kubernetes-aws-vpc-kops-terraform/

