resource "aws_kms_key" "this" {
  enable_key_rotation = true
  is_enabled = true
  policy = var.policy
  tags = {
    Name = var.key_name
  }
}

resource "aws_kms_alias" "this" {
  name          = var.key_alias_name
  target_key_id = aws_kms_key.this.key_id
}
