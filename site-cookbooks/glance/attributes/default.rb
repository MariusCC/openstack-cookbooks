default[:glance][:logdir]="/var/log/glance"
default[:glance][:working_directory]="/var/lib/glance"
default[:glance][:config_file]="/etc/glance/glance.conf"
default[:glance][:pid_directory]="/var/run/glance/"

default[:glance][:verbose] = "false"
default[:glance][:api_host] = "0.0.0.0"
default[:glance][:api_port] = "9292"

#default_store choices are: file, http, https, swift, s3
default[:glance][:default_store] = "file"
default[:glance][:filesystem_store_datadir] = "/var/lib/glance/images"
