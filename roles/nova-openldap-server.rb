name "nova-openldap-server"

run_list(
    "recipe[apt]",
    "recipe[openldap::server]",
    "recipe[nova::openldap]"
)
