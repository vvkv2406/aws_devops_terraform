resource "aws_iam_user" "code-user" {
  name = var.user-name
  path = "/users/"
}