# EC2 Service Commands

## List all available security-group ids
aws ec2 describe-security-groups

## create new security group
aws ec2 describe-vpcs
aws ec2 create-security-group --group-name my-sg --description "My security group" --vpc-id vpc-1a2b3c4d

## this will give output of created my-sg with its id, so we can do:
aws ec2 describe-security-groups --group-ids sg-903004f8

## add firewall rule to the group for port 22
aws ec2 authorize-security-group-ingress --group-id sg-903004f8 --protocol tcp --port 22 --cidr 203.0.113.0/24
aws ec2 describe-security-groups --group-ids sg-903004f8

# Use an existing key-value pair or if you want, create and use a new key-pair. 'KeyMaterial' gives us an unencrypted PEM encoded RSA private key.
aws ec2 create-key-pair --key-name MyKeyPair --query 'KeyMaterial' --output text > MyKeyPair.pem

# launch ec2 instance in the specified subnet of a VPC
aws ec2 describe-subnets
aws ec2 describe-instances # will give us ami-imageid, we will use the same one
aws ec2 run-instances --image-id ami-xxxxxxxx --count 1 --instance-type t2.micro --key-name MyKeyPair --security-group-ids sg-903004f8 --subnet-id subnet-6e7f829e

# ssh into the ec2 instance with the new key pem after creating it - public IP will be returned as json, so query it
asw ec2 describe-instances --instance-ids {instance-id}
chmod 400 MyKeyPair.pem
ssh -i MyKeyPair.pem ec2-user@public-ip

# check UI for all the components that got created

# describe-instances - with filter and query
--filter # is for picking some instances.
--query # is for picking certain info about those instances

# IAM Service Commands
aws iam create-group --group-name MyIamGroup
aws iam create-user --user-name MyUser
aws iam add-user-to-group --user-name MyUser --group-name MyIamGroup

# verify that my-group contains the my-user
aws iam get-group --group-name MyIamGroup

# attach policy to group
## this is the command so we need the policy-ARN - how can we get that?
aws iam attach-user-policy --user-name MyUser --policy-arn {policy-arn} # attach to user directly
aws iam attach-group-policy --group-name MyGroup --policy-arn {policy-arn} # attach policy to group

## can check in the UI for AmazonEC2FullAccess policy ARN

## OR if you know the name of the policy 'AmazonEC2FullAccess', list them
aws iam list-policies --query 'Policies[?PolicyName==`AmazonEC2FullAccess`].{ARN:Arn}' --output text
aws iam attach-group-policy --group-name MyGroup --policy-arn {policy-arn}

# validate policy attached to group or user
aws iam list-attached-group-policies --group-name MyGroup - [aws iam list-attached-user-policies --user-name MyUser]

# Now that user needs acces to the command line and UI, but we didn't give it any credentials. Can achieve that with this:
## UI access
aws iam create-login-profile --user-name MyUser --password My!User1Login*P@ssword --password-reset-required
## user will have to update password on UI or programmatically with a command: 
aws iam update-login-profile --user-name MyUser --password My!User1ADifferentP@ssword

# Create test policy
aws iam create-policy --policy-name bla --policy-document file://bla.json

## cli access
aws iam create-access-key --user-name MyUser # you will see the access keys

# ssh into the EC2 instance with this user
# 'aws configure' with new user creds
aws configure set aws_access_key_id default_access_key
aws configure set aws_secret_access_key default_secret_key

export AWS_ACCESS_KEY_ID = someACCESSkeyEXAMPLEid
export AWS_SECRET_ACCESS_KEY = someSECRETaccessKEYexample
export AWS_DEFAULT_REGION = us-west-2