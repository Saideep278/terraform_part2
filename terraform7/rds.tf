resource "random_id" "id" {
  byte_length = 8
}

resource "random_password" "db_master_pwd" {
  length = 40
  special = true
  min_special = 5
  override_special = "!@#$%^&*()"
}


# secret manager comparable to key-value pairs, secret_key(aws_secretsmanager_secret)-secret_value(aws_secretsmanager_secret_version)
# this resource is goint to create only secret manager enable [KEY] 
resource "aws_secretsmanager_secret" "db_secret_pwd_key" {
  name = "db-pass-${random_id.id.hex}"
}
#inside secret manager we are going to add the secret [VALUE] it can also has key_value_pair
resource "aws_secretsmanager_secret_version" "db_secret_pwd_value" {
  secret_id = aws_secretsmanager_secret.db_secret_pwd_key.id
  secret_string = jsonencode({
    username = aws_rds_cluster.cluster.master_username,
    password = aws_rds_cluster.cluster.master_password,
    engine = "mysql",
    host = aws_rds_cluster.cluster.endpoint
  })
}

#we will create the subnet group
resource "aws_db_subnet_group" "db_subnet_group" {
  subnet_ids = aws_subnet.db_subnet[*].id
}

resource "aws_rds_cluster" "cluster" {
  engine = "aurora-mysql"
  engine_version = "5.7.mysql_aurora.2.07.1"
  engine_mode = "serverless"
  database_name = "saideepdb"
  master_username = "admin"
  master_password = random_password.db_master_pwd.result
  enable_http_endpoint = true
  skip_final_snapshot = true
  vpc_security_group_ids = [aws_security_group.db_sg.name]

}