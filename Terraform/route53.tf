data "aws_route53_zone" "zone" {
  name         = join("", [var.domain, "."])
  private_zone = false
}

resource "aws_route53_record" "stockBot-JumpBox-A_Record" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = "aws.${data.aws_route53_zone.zone.name}"
  type    = "A"
  ttl     = 300
  records = [aws_instance.stockBot-JumpBox.public_ip]

  depends_on = [aws_instance.stockBot-JumpBox]
}