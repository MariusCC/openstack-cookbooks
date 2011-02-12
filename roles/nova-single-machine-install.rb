name "nova-single-machine-install"
description "Installs everything required to run Nova on a single machine"
run_list(
         "recipe[apt]",
         "recipe[nova::mysql]",
         "recipe[nova::openldap]",
         "recipe[nova::rabbit]",
         "recipe[nova::common]",
         "recipe[nova::api]",
         "recipe[nova::scheduler]",
         "recipe[nova::network]",
         "recipe[nova::objectstore]",
         "recipe[nova::compute]",
         "recipe[nova::setup]",
         "recipe[nova::creds]",
         "recipe[nova::finalize]"
         )
