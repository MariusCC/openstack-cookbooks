name "nova-single-machine"
description "Installs everything required to run Nova on a single machine"
run_list(
  "role[nova-db]",
  "role[nova-rabbitmq-server]",
  "role[glance-single-machine]",
  "recipe[nova::api]",
  "recipe[nova::network]",
  "recipe[nova::objectstore]",
  "recipe[nova::scheduler]",
  "recipe[nova::project]"
  "role[nova-multi-compute]"
  )
