resource "aws_iam_role" "role" {
  name        = "${local.name}-svr-role"
  description = "Grants an EC2 instance permissions to AWS resources for our build server."
  assume_role_policy = jsonencode({
    Version = "2008-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

locals {
  
  managed_policies = {
    update_lambda = {
      description = "IAM Policy for updating Lambda code and aliases"
      policy = {
        "Version" : "2012-10-17",
        "Statement" : [
          {
            "Sid" : "VisualEditor0",
            "Effect" : "Allow",
            "Action" : [
              "lambda:CreateFunction",
              "lambda:TagResource",
              "lambda:UpdateEventSourceMapping",
              "lambda:ListVersionsByFunction",
              "lambda:GetLayerVersion",
              "lambda:GetEventSourceMapping",
              "lambda:GetFunction",
              "lambda:ListAliases",
              "lambda:UpdateFunctionConfiguration",
              "lambda:GetFunctionConfiguration",
              "lambda:GetLayerVersionPolicy",
              "lambda:PutFunctionConcurrency",
              "lambda:UpdateAlias",
              "lambda:UpdateFunctionCode",
              "lambda:ListTags",
              "lambda:PublishVersion",
              "lambda:GetAlias",
              "lambda:GetPolicy",
              "lambda:CreateAlias"
            ],
            "Resource" : [
              "arn:aws:lambda:*:*:event-source-mapping:*",
              "arn:aws:lambda:*:*:function:*",
              "arn:aws:lambda:*:*:layer:*:*"
            ]
          },
          {
            "Sid" : "VisualEditor1",
            "Effect" : "Allow",
            "Action" : "lambda:PublishLayerVersion",
            "Resource" : "arn:aws:lambda:*:*:layer:*"
          },
          {
            "Sid" : "VisualEditor2",
            "Effect" : "Allow",
            "Action" : [
              "lambda:ListFunctions",
              "lambda:ListEventSourceMappings",
              "lambda:GetAccountSettings",
              "lambda:ListLayers",
              "lambda:ListLayerVersions",
              "lambda:CreateEventSourceMapping"
            ],
            "Resource" : "*"
          }
        ]
      }
    },
    DocNetwork_ChefServer_BootstrapInstances = {
      description = "Policy for bootsrapping new AWS Instances for our Chef Server"
      policy = {
        "Version" : "2012-10-17",
        "Statement" : [
          {
            "Action" : [
              "opsworks-cm:AssociateNode",
              "opsworks-cm:DescribeNodeAssociationStatus"
            ],
            "Effect" : "Allow",
            "Resource" : [
              "*"
            ]
          }
        ]
      }
    }
  }

}

### Terraform managed policies
resource "aws_iam_policy" "managed_policies" {
  for_each    = local.managed_policies
  name        = each.key
  description = each.value.description
  policy      = jsonencode(each.value.policy)
}

locals {
  tmp      = [for p in aws_iam_policy.managed_policies : p.name]

  aws_managed_policies = ["AmazonEC2FullAccess", "AmazonS3FullAccess", "AmazonECS_FullAccess", "AmazonEC2ContainerRegistryPowerUser"]
  policies = { for e in concat(setproduct(local.aws_managed_policies, ["aws"]), setproduct(local.tmp, ["878788551012"])) : e[0] => e[1] }
  # This sets up all the possible cominations of the elements and creates a map of them so that we can iterate over them with for_each
}

### AWS Managed Policies
resource "aws_iam_role_policy_attachment" "attach" {
  for_each   = local.policies
  role       = aws_iam_role.role.name
  policy_arn = "arn:aws:iam::${each.value}:policy/${each.key}"
}
resource "aws_iam_role_policy_attachment" "service-attach" {
  role       = aws_iam_role.role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "iprf" {
  name = "${local.name}-svr-iprf"
  role = aws_iam_role.role.name
}
