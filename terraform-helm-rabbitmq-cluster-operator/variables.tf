variable "rabbitmq_cluster_operator_values" {
  type    = list(string)
  default = []
}

variable "rabbitmq_cluster_users" {
  type = list(object({
    username = string
    password = string
  }))
  default = [
    {
      username = "circleblue"
      password = "mypassword"
    },
    {
      username = "bayudwiyansatria"
      password = "bayudwiyansatria"
    }
  ]
}