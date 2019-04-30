# Deploy Galaxy on AWS with EKS and FSx

Amazon Web Services (AWS) provides a turn-key Kubernetes setup, Elastic
Kubernetes Service (EKS). Currently Galaxy requires a shared file system to run,
for which we can use Amazon Lustre setup (FSx). Once the EKS cluster and
FSx shared file-system are set, deploying Galaxy through the Helm chart is not very
different to the other Kubernetes setup.

For the deployment of EKS and FSx we have condensed [this guide from AWS](https://aws.amazon.com/blogs/opensource/using-fsx-lustre-csi-driver-amazon-eks/) into a single script, available on this
directory. Before running it, you need to make sure that your environment has all
the dependencies:

- kubectl
- [eksctl](https://eksctl.io/)
- [aws cli]

Also make sure that the user configured with aws cli has the `poweruser-iam` policy, which will
include all the permissions required for running.

Once those are setup, run:

```
export AWS_REGION=us-west-2
./deploy_eks_cluster.sh
./deploy_fsx.sh
```
