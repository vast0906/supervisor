[unix_http_server]
file=/home/admin/tengine/run/supervisor_tengine.sock

[supervisord]
directory=/home/admin/tengine
logfile=/home/admin/tengine/logs/tengine_supervisor.log
logfile_maxbytes=50MB
logfile_backups=10
loglevel=warn
pidfile=/home/admin/tengine/run/supervisor_tengine.pid
nodaemon=false
minfds=1024
minprocs=200

[rpcinterface:supervisor]
supervisor.rpcinterface_factory = supervisor.rpcinterface:make_main_rpcinterface

[supervisorctl]
serverurl=unix:////home/admin/tengine/run/supervisor_tengine.sock

[program:tengine]
stopsignal=INT
directory=/home/admin/tengine
command=/home/admin/tengine/sbin/nginx
user=admin
autostart=true
autorestart=true
stdout_logfile=/home/admin/tengine/logs/tengine.log
stderr_logfile=/home/admin/tengine/logs/tengine.log

