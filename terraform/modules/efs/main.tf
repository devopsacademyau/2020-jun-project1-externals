resource "aws_efs_file_system" "efs" {
   creation_token = "wordpress"
   performance_mode = "generalPurpose"
   throughput_mode = "bursting"
 tags = {
     Name = "wordpress"
   }
 }

resource "aws_efs_mount_target" "efs-mnt1" {
   file_system_id  = aws_efs_file_system.efs.id
   subnet_id = var.subnet_id1
 }

resource "aws_efs_mount_target" "efs-mnt2" {
   file_system_id  = aws_efs_file_system.efs.id
   subnet_id = var.subnet_id2
 }

resource "aws_efs_access_point" "ap" {
  file_system_id = aws_efs_file_system.efs.id
  root_directory {
    path = "/wordpress"
  }
  tags = {
    Name = "wordpress"
  }

}

