resource "aws_elastic_beanstalk_application" "privesc-elasticbeanstalk-app" {
  name        = "privesc-elasticbeanstalk-app"
  description = "privesc-elasticbeanstalk-app"
  tags = {
    yor_trace = "f821dbd4-e3f3-4638-a6a5-56b389be9bdf"
  }
}

resource "aws_elastic_beanstalk_environment" "privesc-elasticbeanstalk-env" {
  name                = "privesc-elasticbeanstalk-env"
  application         = aws_elastic_beanstalk_application.privesc-elasticbeanstalk-app.name
  solution_stack_name = "64bit Amazon Linux 2 v3.4.4 running Docker"
  instance_type       = "t2.micro"

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = var.shared_high_priv_servicerole
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "ServiceRole"
    value     = var.shared_high_priv_servicerole
  }

  tags = {
    yor_trace = "2921f179-648e-49fe-8ba8-81082d662c28"
  }
}

resource "aws_elastic_beanstalk_application_version" "privesc-elasticbeanstalk-app-version" {
  name        = "privesc-elasticbeanstalk-app-version"
  application = aws_elastic_beanstalk_application.privesc-elasticbeanstalk-app.name
  bucket      = "my-test-bucket-for-ebs"
  key         = "latest.zip"
  tags = {
    yor_trace = "8af70418-829f-47e2-b46f-a79b8e179079"
  }
}