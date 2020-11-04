# WDCTF-Caddy-PHP-MariaDB
**单纯的Caddy服务,使用的是官方的Caddy镜像: `caddy:latest`**<br>
**PHP版本是php7-fpm**<br>
**PHP插件是php7-mysqli**<br>
**MariaDB版本是10.4.15-MariaDB**<br>
网站目录在`/srv`<br>
端口是`80`

# 作为父镜像时的注意事项
如果要执行什么脚本可以放在`/n2r.sh`<br>
如果是耗时项目将会阻塞<br>
如果要一直执行请加`&`

# 直接使用镜像
```bash
/ > docker pull registry.cn-shanghai.aliyuncs.com/wd_ctf_2020/wdctf_caddy_php
/ > docker run -p80:80 -v /html:/srv registry.cn-shanghai.aliyuncs.com/wd_ctf_2020/wdctf_caddy_php
```
