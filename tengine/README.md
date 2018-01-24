非root启动nginx80端口
```
chown root sbin/nginx

chmod +s sbin/nginx
```
非守护运行
在ngxinx.conf中添加
```
daemon off;
```
