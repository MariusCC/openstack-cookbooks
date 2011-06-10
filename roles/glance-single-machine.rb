name "glance-single-machine"
description "Installs everything required to run Glance on a single machine"
run_list(
  "recipe[glance::api]",
  "recipe[glance::registry]"
  )
