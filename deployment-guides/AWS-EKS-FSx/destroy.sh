# Bring down helm deployments?

# Bring down PV and PVC?

# Bring down file system if the PVC and PV have been deleted
# Deleting the PVC takes an awful load of time.

aws fsx delete-file-system --file-system-id fs-07d3020633da11fab --region $AWS_REGION
# this deletes cleanly, but takes a while

aws iam detach-role-policy --policy-arn ${POLICY_ARN} --role-name ${INSTANCE_ROLE_NAME}
aws iam delete-policy --policy-arn=$POLICY_ARN


eksctl delete cluster -f $eks_config
# so far I haven't seen a clean deletion
# security groups don't get deleted either
