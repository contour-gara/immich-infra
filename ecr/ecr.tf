resource "aws_ecr_repository" "reverse_proxy" {
  name                 = "${local.appname}-reverse-proxy"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

data "template_file" "lifecycle-policy" {
  template = file("./policies/lifecycle_policy.json")
}

resource "aws_ecr_lifecycle_policy" "lifecycle" {
  repository = aws_ecr_repository.reverse_proxy.name
  policy     = data.template_file.lifecycle-policy.rendered
}
