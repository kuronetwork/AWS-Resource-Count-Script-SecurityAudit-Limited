# Initialize variables
TOTAL_EC2_COUNT=0
TOTAL_EKS_CLUSTER_COUNT=0
TOTAL_EKS_NODE_COUNT=0
TOTAL_ECS_CLUSTER_COUNT=0
TOTAL_ECS_INSTANCE_COUNT=0
TOTAL_RDS_COUNT=0

# Manually list all common AWS regions, SecurityAudit policy does not have list regions permissions
#sample 
regions="ap-south-1 eu-north-1"

# Function to retrieve and count EC2 instances
count_ec2_instances() {
    local region=$1
    local ec2_count
    ec2_count=$(aws ec2 describe-instances --region "$region" --query "Reservations[*].Instances[*]" --output json | jq 'flatten | length')
    echo "  EC2 count: $ec2_count"
    TOTAL_EC2_COUNT=$((TOTAL_EC2_COUNT + ec2_count))
}

# Function to retrieve and count EKS clusters and nodes
count_eks_clusters_and_nodes() {
    local region=$1
    local eks_cluster_count
    eks_cluster_count=$(aws eks list-clusters --region "$region" --query "clusters" --output json | jq 'length')
    echo "  EKS Cluster count: $eks_cluster_count"
    TOTAL_EKS_CLUSTER_COUNT=$((TOTAL_EKS_CLUSTER_COUNT + eks_cluster_count))

    for cluster in $(aws eks list-clusters --region "$region" --query "clusters" --output text); do
        local node_count
        node_count=$(aws eks list-nodegroups --region "$region" --cluster-name "$cluster" --query "nodegroups" --output json | jq 'length')
        echo "    EKS Cluster $cluster Node count: $node_count"
        TOTAL_EKS_NODE_COUNT=$((TOTAL_EKS_NODE_COUNT + node_count))
    done
}

# Function to retrieve and count ECS clusters and container instances
count_ecs_clusters_and_instances() {
    local region=$1
    local ecs_cluster_count
    ecs_cluster_count=$(aws ecs list-clusters --region "$region" --query "clusterArns" --output json | jq 'length')
    echo "  ECS Cluster count: $ecs_cluster_count"
    TOTAL_ECS_CLUSTER_COUNT=$((TOTAL_ECS_CLUSTER_COUNT + ecs_cluster_count))

    for cluster_arn in $(aws ecs list-clusters --region "$region" --query "clusterArns" --output text); do
        local instance_count
        instance_count=$(aws ecs list-container-instances --region "$region" --cluster "$cluster_arn" --query "containerInstanceArns" --output json | jq 'length')
        echo "    ECS Cluster $cluster_arn Container count: $instance_count"
        TOTAL_ECS_INSTANCE_COUNT=$((TOTAL_ECS_INSTANCE_COUNT + instance_count))
    done
}

# Function to retrieve and count RDS instances
count_rds_instances() {
    local region=$1
    local rds_count
    rds_count=$(aws rds describe-db-instances --region "$region" --query "DBInstances" --output json | jq 'length')
    echo "  RDS count: $rds_count"
    TOTAL_RDS_COUNT=$((TOTAL_RDS_COUNT + rds_count))
}

# Check each region
for region in $regions; do
    echo "Currently checking region: $region"
    
    count_ec2_instances "$region"
    count_eks_clusters_and_nodes "$region"
    count_ecs_clusters_and_instances "$region"
    count_rds_instances "$region"
    
    echo
done

# Display totals for all regions
echo "Total EC2 count for all regions: $TOTAL_EC2_COUNT"
echo "Total EKS Cluster count for all regions: $TOTAL_EKS_CLUSTER_COUNT"
echo "Total EKS Node count for all regions: $TOTAL_EKS_NODE_COUNT"
echo "Total ECS Cluster count for all regions: $TOTAL_ECS_CLUSTER_COUNT"
echo "Total ECS Container count for all regions: $TOTAL_ECS_INSTANCE_COUNT"
echo "Total RDS count for all regions: $TOTAL_RDS_COUNT"

# Calculate the grand total
TOTAL=$((TOTAL_EC2_COUNT + TOTAL_EKS_CLUSTER_COUNT + TOTAL_EKS_NODE_COUNT + TOTAL_ECS_CLUSTER_COUNT + TOTAL_ECS_INSTANCE_COUNT + TOTAL_RDS_COUNT))
echo "Grand total count: $TOTAL"

