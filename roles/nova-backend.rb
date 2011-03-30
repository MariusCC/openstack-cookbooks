name "nova-backend"

run_list(
#    "recipe[nova::volume]",
    "recipe[nova::compute]"
)
