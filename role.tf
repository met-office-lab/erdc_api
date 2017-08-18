
variable "awsProfile" {
    type = "string"
    default = "default"
}

variable "publicKey" {
  type = "string"
}

variable "bucketName" {
  type = "string"
}

provider aws {
    region = "eu-west-1"
    profile = "${var.awsProfile}"
}

resource "aws_iam_access_key" "regrid" {
  user    = "${aws_iam_user.regrid.name}"
  pgp_key = "${var.publicKey}"
}

resource "aws_iam_user" "regrid" {
  name = "regrid_api"
}

resource "aws_iam_user_policy" "regrid" {
  name = "test"
  user = "${aws_iam_user.regrid.name}"

  policy = <<EOF
{
  "Id": "RegridAccessBucketPolicy",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1503050425436",
      "Action": [
        "s3:GetObject",
        "s3:ListBucket",
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::${var.bucketName}/*"
    }
  ]
}
EOF
}

output "secret" {
  value = "${aws_iam_access_key.regrid.encrypted_secret}"
}

output "id" {
  value = "${aws_iam_access_key.regrid.id}"
}