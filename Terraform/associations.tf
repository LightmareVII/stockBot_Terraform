resource "aws_route_table_association" "stockBot-RT_Assoc_Public" {
  subnet_id      = aws_subnet.stockBot-Subnet-Public.id
  route_table_id = aws_route_table.stockBot-RT-Public.id

  depends_on = [aws_route_table.stockBot-RT-Public]
}

resource "aws_route_table_association" "stockBot-RT_Assoc_Private" {
  subnet_id      = aws_subnet.stockBot-Subnet-Private.id
  route_table_id = aws_route_table.stockBot-RT-Private.id

  depends_on = [aws_route_table.stockBot-RT-Private]
}