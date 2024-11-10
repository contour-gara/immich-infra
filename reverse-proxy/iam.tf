data "template_file" "access_trust_policy" {
  template = file("./policies/apprunner-access-trust-policy.json")
}

resource "aws_iam_role" "access_role" {
  name               = "${local.appname}-apprunner-access"
  assume_role_policy = data.template_file.access_trust_policy.rendered
}

resource "aws_iam_role_policy_attachment" "ecr_access_policy" {
  role       = aws_iam_role.access_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSAppRunnerServicePolicyForECRAccess"
}

# Apprunner 作成時に InvalidRequestException: Error in assuming access role が発生しないように10秒待つ
resource "time_sleep" "wait_10_seconds" {
  create_duration = "10s"

  triggers = {
    access_role_arn = aws_iam_role.access_role.arn
  }
}
