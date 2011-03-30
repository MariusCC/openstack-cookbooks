name "nova-cloud-controller"
description "Cloud controller that runs the nova- services"
run_list(
         "recipe[nova::scheduler]",
         "recipe[nova::network]"
         )
