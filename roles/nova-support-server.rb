name "nova-support-server"

#
# Not currently used, but maybe one day.
#
#    "role[nova-openldap-server]",
#
run_list(
    "role[nova-mysql-server]",
    "role[nova-rabbitmq-server]"
)
