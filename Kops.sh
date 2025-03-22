#vim .bashrc
#export PATH=$PATH:/usr/local/bin/
#source .bashrc


#! /bin/bash
#aws configure  If we have given Role to ec2 istance then we don't need this line 
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
wget https://github.com/kubernetes/kops/releases/download/v1.25.0/kops-linux-amd64
chmod +x kops-linux-amd64 kubectl
mv kubectl /usr/local/bin/kubectl
mv kops-linux-amd64 /usr/local/bin/kops

# Create an S3 bucket & enable Versioning
aws s3api create-bucket --bucket yashkops123.k8s.local --region ap-south-1 --create-bucket-configuration LocationConstraint=ap-south-1
aws s3api put-bucket-versioning --bucket yashkops123.k8s.local --region ap-south-1 --versioning-configuration Status=Enabled

# Set the KOPS_STATE_STORE environment variable to the S3 bucket where Kops will store the cluster state and configuration
export KOPS_STATE_STORE=s3://yashkops123.k8s.local

# Will create a cluster having 1 master node and 2 worker/slave nodes of t2.micro size
kops create cluster --name yashkops123.k8s.local --zones ap-south-1a --master-count=1 --master-size t2.micro --node-count=2 --node-size t2.micro
kops update cluster --name yashkops123.k8s.local --yes --admin
