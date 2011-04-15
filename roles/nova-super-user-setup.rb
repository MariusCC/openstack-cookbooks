name "nova-super-user-setup"

run_list(
    "recipe[nova::setup]",
    "recipe[nova::creds]",
    "recipe[nova::finalize]"
)
