#!/usr/bin/env bash

# deploy a StorageClass, PersistentVolumeClaim, and a Pod to use the new FSx for Lustre file system.

# Configure Storage Class
## Before you deploy the FSx StorageClass, you need to collect and set up a few components:

## Find a Subnet ID for the FSx for Lustre filesystem to be provisioned into.
## Create a security group which will allow the cluster to access the FSx file system.
## Get the VPC ID for your cluster:

# there is a typo in the original doc, missing "-cluster" after "driver"
VPC_ID=$(aws ec2 describe-vpcs --output text --region $AWS_REGION --filters "Name=tag:Name,Values=eksctl-fsx-csi-driver-cluster/VPC" --query "Vpcs[0].VpcId")

# get one of your Amazon EKS cluster subnet IDs; your Lustre file system will be provisioned within this subnet:
# TODO here region Subnet is hard coded to "SubnetPrivateUSEAST2A" and will only work with USEAST2A
SUBNET_ID=$(aws ec2 describe-subnets --filters "[{\"Name\": \"vpc-id\",\"Values\": [\"$VPC_ID\"]},{\"Name\": \"tag:aws:cloudformation:logical-id\",\"Values\": [\"SubnetPrivateUSEAST2A\"]}]" --region $AWS_REGION --query "Subnets[0].SubnetId" --output text)

# With the subnet ID, create your security group for the FSx file system and
# add an ingress rule that opens up port 988 from the 192.168.0.0/16 CIDR range:
SECURITY_GROUP_ID=$(aws ec2 create-security-group --group-name eks-fsx-security-group --vpc-id ${VPC_ID} --description "FSx for Lustre Security Group" --query "GroupId" --output text --region $AWS_REGION)
aws ec2 authorize-security-group-ingress --group-id ${SECURITY_GROUP_ID} --protocol tcp --port 988 --cidr 192.168.0.0/16 --region $AWS_REGION

# Once you have both the subnet ID and the security group ID set up, you can then create your StorageClass:
storage_class=$DEPLOYMENT_FOLDER/storage-class.yaml
cat >$storage_class <<EOF
kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
  name: fsx-sc
provisioner: fsx.csi.aws.com
parameters:
  subnetId: ${SUBNET_ID}
  securityGroupIds: ${SECURITY_GROUP_ID}
EOF

kubectl apply -f $storage_class
