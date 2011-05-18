name "nova-multi-controller"

description "Installs requirements to run the Controller node in a Nova cluster"
run_list(
         "role[nova-mysql-server]",
         "role[nova-rabbitmq-server]",
         "role[nova-head]",
         "role[nova-cloud-controller]",
         "role[nova-super-user-setup]"
         )
