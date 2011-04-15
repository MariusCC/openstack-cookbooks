name "nova-rabbitmq-server"

run_list(
    "recipe[apt]",
    "recipe[rabbitmq]",
    "recipe[nova::rabbit]"
)
