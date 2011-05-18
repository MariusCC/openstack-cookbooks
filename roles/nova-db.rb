name "nova-db"
description "Role for defining which database is used by Nova. Currently only MySQL, other databases to be added (PostgreSQL, Drizzle, etc.)"

run_list(
         "recipe[nova::mysql]"
         )

override_attributes(
                    "nova" => {
                      "mysql" => "true"
                    }
                    )
