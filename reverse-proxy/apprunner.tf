resource "aws_apprunner_service" "reverse_proxy" {
  service_name = "${local.appname}-reverse-proxy"

  source_configuration {
    authentication_configuration {
      access_role_arn = time_sleep.wait_10_seconds.triggers["access_role_arn"]
    }

    image_repository {
      image_identifier      = "${data.aws_caller_identity.current.account_id}.dkr.ecr.ap-northeast-1.amazonaws.com/immich-reverse-proxy:latest"
      image_repository_type = "ECR"

      image_configuration {
        port = "80"

        runtime_environment_variables = {
          MY_GLOBAL_IP = var.my_global_ip
        }
      }
    }

    auto_deployments_enabled = true
  }

  health_check_configuration {
    healthy_threshold = 1
    interval = 5
    path = "/"
    protocol = "HTTP"
    timeout = 5
    unhealthy_threshold = 3
  }
}

output "domain" {
  value = aws_apprunner_service.reverse_proxy.service_url
}
