locals {
  name = "${var.name_prefix}-srv"

  tags = {
    Environment = "m3-demo"
    ManagedBy   = "terraform"
  }

  server-tags = merge(
    {
      Name = local.name
    },
    local.tags
  )
}

resource "aws_launch_template" "srv" {
  name          = "${local.name}-lt"
  image_id      = var.ami_id == "" ? data.aws_ami.ami[0].id : var.ami_id
  instance_type = var.server_instance_type

  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      encrypted   = true
      volume_type = "gp2"
      volume_size = var.ebs_vol_size
    }
  }

  ### Network interface to demo subnets and changing launch template
  # }
  # network_interfaces {
  #   delete_on_termination = true
  #   security_groups       = [aws_security_group.sg.id]
  #   subnet_id             = element(tolist(data.aws_subnet_ids.subnets.ids), 0) #tolist is needed because aws_subnet_ids returns an unordered set and element needs a list.
  # }

}

resource "aws_instance" "srv" {
  launch_template {
    id      = aws_launch_template.srv.id
    version = "$Latest"
  }

  tags = local.server-tags

  lifecycle {
    ignore_changes = [
      launch_template[0].version
    ]
  }

  ### A second device mapping.  Since this is part of the instance block, it will force a the instance to be rebuilt.
  # ebs_block_device {
  #   device_name = "/dev/sdh"
  #   encrypted   = false
  #   volume_type = "gp2"
  #   volume_size = 10
  # }
  
  #### Instance profile to add in IAM and demo that.
  #  iam_instance_profile = aws_iam_instance_profile.iprf.id

}

# ### EBS Volume with attachment.  This doesn't force a rebuild
# resource "aws_ebs_volume" "datadrive" {
#   availability_zone = aws_instance.srv.availability_zone
#   size              = 10

#   tags = merge(
#     {
#       Name = "${local.name}-datavol"
#     },
#     local.tags
#   )
# }

# resource "aws_volume_attachment" "ebs_att" {
#   device_name = "/dev/sdh"
#   volume_id   = aws_ebs_volume.datadrive.id
#   instance_id = aws_instance.srv.id
# }

