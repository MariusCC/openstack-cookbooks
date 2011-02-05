name "nova-cloud-controller"
description "Cloud controller that runs the nova- services"
run_list(
         "recipe[apt]",
         "recipe[nova::mysql]",
         "recipe[nova::openldap]",
         "recipe[nova::rabbit]",
         "recipe[nova::common]",
         "recipe[nova::api]"
         # include_recipe "nova::scheduler"
         # include_recipe "nova::network"
         # include_recipe "nova::objectstore"

         )
