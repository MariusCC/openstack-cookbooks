name "nova-base"

description "Base role for all OpenStack servers"

run_list(
         "recipe[apt]"
         )

