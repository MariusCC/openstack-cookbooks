name "nova-multi-compute"

description "Installs requirements to run a Compute node in a Nova cluster"
run_list(
         "recipe[apt]",
         "recipe[nova::network]",
         "recipe[nova::compute]",
         )
