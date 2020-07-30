resource "aws_efs_file_system" "efs" {
   creation_token = "wordpress"
   performance_mode = "generalPurpose"
   encrypted = "true"
 tags = {
     Name = "wordpress"
   }
 }

resource "aws_efs_mount_target" "efs-mnt" {
   file_system_id  = aws_efs_file_system.efs.id
   subnet_id = var.subnet_id
 }
