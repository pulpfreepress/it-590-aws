# Elastic File System (EFS) Web shares
---
Creates an EFS with a mount target in each public subnet of non-default VPC for use by public-facing web servers deployed in the <a href="../ec2-web-efs">ec2-web-efs</a> example repo.

# Depends On: Non-Default VPC

   <a href="../vpc">vpc</a>

# DEPLOYMENT
1. Deploy non-default <a href="../vpc">vpc</a>
2. Run efs/build.sh: `build.sh dev oh efs`
3. Run `aws cloudformation list-exports` to get EFS ID
4. Use the EFS ID to configure EFS mounts in EC2 instances
5. See <a href="../ec2-web-efs">ec2-web-efs</a>
