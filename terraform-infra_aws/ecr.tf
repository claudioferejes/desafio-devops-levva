resource "aws_ecr_repository" "levva_ecr" {
  name                 = "levva_ecr"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}