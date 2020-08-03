resource "aws_efs_file_system" "this" {
  creation_token   = "wordpress"
  performance_mode = "generalPurpose"
  throughput_mode  = "bursting"
  tags = {
    Name = "wordpress"
  }
}

resource "aws_efs_mount_target" "mnt1" {
  file_system_id  = aws_efs_file_system.this.id
  subnet_id       = var.subnet_id1
  security_groups = [aws_security_group.efs_sg.id]
}

resource "aws_efs_mount_target" "mnt2" {
  file_system_id  = aws_efs_file_system.this.id
  subnet_id       = var.subnet_id2
  security_groups = [aws_security_group.efs_sg.id]
}

resource "aws_efs_access_point" "ap" {
  file_system_id = aws_efs_file_system.this.id
  root_directory {
    path = "/wordpress"
  }
  tags = {
    Name = "wordpress"
  }

}

