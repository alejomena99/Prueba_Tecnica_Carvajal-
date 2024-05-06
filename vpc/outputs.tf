output "az" {
  value = data.aws_availability_zones.available.names
}

output "numero_az" {
  value = length(data.aws_availability_zones.available.names)
}