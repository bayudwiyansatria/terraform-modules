output "id" {
  value = google_sql_database_instance.instance.id
}

output "self_link" {
  value = google_sql_database_instance.instance.self_link
}

output "ipv4" {
  value = {
    private_ip_address = google_sql_database_instance.instance.private_ip_address
  }
}

output "cert" {
  value = google_sql_database_instance.instance.server_ca_cert
}