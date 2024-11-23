resource "aws_ecr_repository" "buckee_control_plane" {
  name         = "buckee-control-plane"
  force_delete = true
}
