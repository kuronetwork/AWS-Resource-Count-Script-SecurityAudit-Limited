# List and format regions
regions=$(aws ec2 describe-regions --query "Regions[].RegionName" --output text)

# Output the regions
echo "regions=\"$regions\""
