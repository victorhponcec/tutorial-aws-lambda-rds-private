#IAM Role/Trust Policy for Lambda
resource "aws_iam_role" "lambda" {
  name               = "hello_lambda_function"
  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "lambda.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}

#IAM Policy For Lambda
resource "aws_iam_policy" "lambda" {
  name        = "policy_for_lambda"
  path        = "/"
  description = "IAM Policy for the Lamnda Role"
  policy      = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": [
       "logs:CreateLogGroup",
       "logs:CreateLogStream",
       "logs:PutLogEvents"
     ],
     "Resource": "arn:aws:logs:*:*:*",
     "Effect": "Allow"
   }
 ]
}
EOF
}

#Policy Attachment 
resource "aws_iam_role_policy_attachment" "attach_role_policy_lambda" {
  role       = aws_iam_role.lambda.name
  policy_arn = aws_iam_policy.lambda.arn
}
#Policy to allow lambda to create interfaces in VPC 
resource "aws_iam_role_policy_attachment" "attach_role_policy_lambda_vpc" {
  role       = aws_iam_role.lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole" #https://docs.aws.amazon.com/aws-managed-policy/latest/reference/AWSLambdaVPCAccessExecutionRole.html
}

#ZIP code for Lambda
data "archive_file" "zip_py" {
  type        = "zip"
  source_dir  = "${path.module}/lambda_code/"
  output_path = "${path.module}/lambda_code/lambda.zip"
}

#Lambda Function
resource "aws_lambda_function" "lambda_vpc" {
  filename      = "${path.module}/lambda_code/lambda.zip"
  function_name = "lambda_vpc_py"
  role          = aws_iam_role.lambda.arn
  handler       = "lambda.lambda_handler" #lambda=name of the file | lambda_handler=function to invoke the python code
  runtime       = "python3.8"
  depends_on    = [aws_iam_role_policy_attachment.attach_role_policy_lambda, aws_iam_role_policy_attachment.attach_role_policy_lambda_vpc]
  vpc_config {
    subnet_ids         = [aws_subnet.private_subnet.id, aws_subnet.private_subnet_b.id]
    security_group_ids = [aws_security_group.lambda.id]
  }
  environment {
    variables = {
      DB_HOST = aws_db_instance.rds.address #env variable: passes the RDS endpoint to lambda.py
    }
  }
}