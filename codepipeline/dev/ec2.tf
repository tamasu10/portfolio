######################################################################################
# EC2   
# EC2 name rule : ec2-[system]-[account]-[env]-[component][no2]
# key pair name rule : key-[system]-[account]-[env]-[component][no2]
# Please make key pairs before create instances
######################################################################################

module "ec2-instance-test01" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "3.3.0"

  name                        = format("ec2-%s-%s-%s-test01", var.system, var.account, var.env)
  associate_public_ip_address = false
  ami                         = "ami-0218d08a1f9dac831"
  instance_type               = "t3.micro"
  iam_instance_profile        = module.iam_assumable_role_ssm.iam_instance_profile_name
  vpc_security_group_ids      = [module.sg_ec2_test.security_group_id]
  subnet_id                   = module.vpc.subnets["private-subnet02-a"].id
  root_block_device = [
    {
      volume_size = "20"
      volume_type = "gp3"
      encrypted   = "true"
    }
  ]
  key_name = "key-aap-template-account-dev-test01"

  monitoring                           = true
  instance_initiated_shutdown_behavior = "stop"
  ebs_optimized                        = true


  tags = {
    Terraform   = "true"
    Environment = "dev"
  }

}