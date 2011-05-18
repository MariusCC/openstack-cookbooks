name "nova-multi-controller"

description "Installs requirements to run the Controller node in a Nova cluster"
run_list(
         "role[nova-db]",
         "role[nova-rabbitmq-server]",
         "recipe[nova::user]",
         "recipe[nova::project]",
         "recipe[nova::finalize]"
         "recipe[nova::api]",
         "recipe[nova::objectstore]",
         "role[nova-cloud-controller]",
         )
