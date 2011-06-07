name "nova-rabbitmq-server"

run_list(
  "recipe[nova::rabbit]"
  )
