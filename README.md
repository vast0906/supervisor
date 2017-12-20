# supervisor
记录日常supervisor中ini的定义
```
#pip install supervisor

#echo_supervisord_conf > /etc/supervisor/supervisord.conf

#cat >> /etc/supervisor/supervisord.conf << "END" 
[inet_http_server]    
port=*:9001        
username=user              
password=123  
 
[include]
files = /etc/supervisor/conf.d/*.ini
END
```

```
启动单个service
supervisorctl -c conf/$service.ini
```


* 如果程序默认是以守护进程运行的，希望使用supervisor来控制的话，需要将他们调整为非守护进程的方式来运行，否则的话会看到相应的进程不断的重启
## redis
需修改redis.conf
```
sed -i 's/^daemonize\(.*\)/daemonize no/g' /home/admin/redis/conf/redis.conf
daemonize no
```

## tengine
需修改nginx.conf
```
sed -i 's/^daemon\(.*\)/daemon on\;/g' /home/admin/tengine/conf/nginx.conf
daemon on;
```
参考链接：

http://c.isme.pub/2017/04/20/supervisor/

[Wangxj's Blog](http://wangxj.org/2017/03/14/%E4%BD%BF%E7%94%A8supervisord%E5%AE%88%E6%8A%A4%E8%BF%9B%E7%A8%8B%E6%8E%A7%E5%88%B6%E5%A4%9A%E7%A8%8B%E5%BA%8F%E8%BF%90%E8%A1%8C/)
