# AWS-Resource-Count-Script-SecurityAudit-Limited


This repository contains a custom script for performing an asset inventory of specific AWS resources across multiple regions. Designed to operate under the AWS SecurityAudit policy, the script efficiently gathers counts of EC2 instances, ECS clusters and instances, EKS clusters and nodes, and RDS instances without requiring full administrative permissions.

## Table of Contents
- [Overview](#overview)
- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
- [Security Considerations](#security-considerations)
- [References](#references)

---

## Overview
The **AWS-Resource-Count-Script-SecurityAudit-Limited** provides a secure and limited-access method to inventory AWS resources using a user account with the SecurityAudit Managed Policy. It’s designed for scenarios where administrators need to audit specific AWS resources but only have limited permissions.

**Features:**
- Counts EC2 instances, ECS clusters and container instances, EKS clusters and nodes, and RDS instances across multiple regions.
- Operates within the constraints of SecurityAudit policy, ensuring minimal permissions required.
- Outputs aggregated totals for each resource type.

## Requirements
- **AWS CLI**: Installed and configured with access to AWS resources.
- **jq**: A lightweight command-line JSON processor.
- **Operating System**: Tested on Ubuntu via Windows Subsystem for Linux (WSL) but can be adapted for other Linux environments.
- **IAM Permissions**: The AWS SecurityAudit Managed Policy attached to the user account.

## Installation

1. **Install WSL (for Windows users)**:
    ```bash
    wsl --install
    ```
    Restart your machine after installation.

2. **Install jq**:
    ```bash
    sudo apt install jq
    ```

3. **Install AWS CLI**:
    ```bash
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    sudo apt install unzip 
    unzip awscliv2.zip
    sudo ./aws/install
    ```

4. **Clone this repository and set script permissions**:
    ```bash
    git clone https://github.com/yourusername/AWS-Resource-Count-Script-SecurityAudit-Limited.git
    cd AWS-Resource-Count-Script-SecurityAudit-Limited
    chmod +x AWSInventoryScript.sh
    ```

## Usage

1. **Set up AWS environment variables** (or configure using `aws configure`). For demonstration purposes, here’s an example with environment variables:
    ```bash
    export AWS_ACCESS_KEY_ID=your-access-key
    export AWS_SECRET_ACCESS_KEY=your-secret-key
    export AWS_DEFAULT_REGION=us-west-2
    ```
    The above credentials are official sample data

2. **Run the script**:
    ```bash
    ./AWSInventoryScript.sh
    ```
    The script will output the count of each resource type for all specified regions and provide a total summary at the end.

## Security Considerations

⚠️ **Important**: Storing Access Keys locally in plain text is a security risk. For production use, consider using AWS IAM roles and temporary credentials via AWS SSO or IAM roles for EC2 if running within an EC2 instance. Avoid hard-coding sensitive information.

The script was scanned using Amazon CodeGuru for any security vulnerabilities and was found to have no critical issues.

## References
- [Setting up WSL Development Environment](https://learn.microsoft.com/en-us/windows/wsl/)
- [AWS CLI Installation Guide](https://aws.amazon.com/cli/)
- [jq - Command-line JSON Processor](https://stedolan.github.io/jq/)
- [Amazon CodeGuru Security Scans](https://aws.amazon.com/codeguru/)



