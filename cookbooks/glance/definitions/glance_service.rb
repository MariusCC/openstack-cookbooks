define :glance_service do

  service_name="glance-#{params[:name]}"
  pidfile="#{node[:glance][:pid_directory]}/#{service_name}.pid"

  service service_name do
    start_command "su -c '#{service_name} --flagfile=/etc/glance/glance.conf --pidfile=#{pidfile} --daemonize' glance"
    stop_command "[ -f #{pidfile} ] && kill -s TERM $(cat #{pidfile})"
    status_command "pgrep #{service_name}"
    supports :status => true, :restart => false
    action :start
    subscribes :restart, resources(:template => "/etc/glance/glance.conf")
  end

end
