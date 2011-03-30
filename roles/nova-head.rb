name "nova-head"

run_list(
    "recipe[nova::api]",
    "recipe[nova::objectstore]"
)
