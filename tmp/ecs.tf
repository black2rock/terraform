resource "aws_ecs_cluster" "ecs_cluster" {
    name = "ecs-test-cluster"
}
 
#resource "aws_ecs_service" "ecs_replica_service" {
#    name = "ecs-replica-service"
#    cluster = ${aws_ecs_cluster.ecs_cluster.id}
#    task_definition = ${aws_ecs_task_definition.xxx.arn}
#    desired_count = 2
#    lifecycle {
#       ignore_changes = ["desired_count"]
#    }
#    iam_role = ${aws_iam_role.xxx.arn}
#    depends_on = ["aws_iam_role_policy.xxx"]
#}

resource "aws_ecs_service" "ecs_daemon_service" {
    name = "ecs-daemon-service"
    cluster = aws_ecs_cluster.ecs_cluster.id
    task_definition = aws_ecs_task_definition.ecs_daemon_task.arn

    scheduling_strategy = "DAEMON"
    #iam_role = ${aws_iam_role.xxx.arn}
    #depends_on = ["aws_iam_role_policy.xxx"]
}

resource "aws_ecs_task_definition" "ecs_daemon_task" {
    family = "ecs_daemon_task"
    container_definitions = file("/Users/ryota/terraform/task-definitions/task-definition.json")
    task_role_arn = aws_iam_role.ecs_task_role.arn
}

resource "aws_iam_role_policy" "ecs_task_policy" {
  name = "ecs_task_policy"
  role = aws_iam_role.ecs_task_role.id

  policy = file("/Users/ryota/terraform/iam_policy/ecs_task_policy.json")
}

resource "aws_iam_role" "ecs_task_role" {
  name = "ecs_task_role"

  assume_role_policy = file("/Users/ryota/terraform/iam_policy/ecs_task_assume_policy.json")
  //assume_role_policy = <<-EOF
  //{
  //  "Version": "2012-10-17",
  //  "Statement": [
  //    {
  //      "Action": "sts:AssumeRole",
  //      "Principal": {
  //        "Service": "ec2.amazonaws.com"
  //      },
  //      "Effect": "Allow",
  //      "Sid": ""
  //    }
  //  ]
  //}
  //EOF
}