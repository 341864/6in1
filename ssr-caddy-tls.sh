#!/bin/bash
sudo curl https://getcaddy.com | bash -s personal hook.service
sudo mkdir /etc/caddy
sudo mkdir /etc/ssl/caddy
sudo mkdir /var/www               
echo "请输入您的域名，例如：example.com："
read domainname
sudo mkdir /var/www/$domainname   
echo "请输入您的邮箱："
read emailname
echo "您输入的邮箱正确吗?(y/n)"
read ans
if [ans == "n"]
then
echo "请重新输入您的邮箱:"
read emailname
fi
echo "请输入端口号1-65535，但不能是443："
read port
echo "$domainname {  
        gzip  
		tls $emailname
        root /var/www/$domainname 
        
}" > /etc/caddy/Caddyfile

sudo caddy -service install -agree -email $emailname -conf /etc/caddy/Caddyfile 
sudo caddy -service start

echo "开始安装ssr吗？（y/n）"
read ans
if [ans == "n"]
then
exit
fi

wget --no-check-certificate -O shadowsocks-all.sh https://raw.githubusercontent.com/teddysun/shadowsocks_install/master/shadowsocks-all.sh
chmod +x shadowsocks-all.sh
./shadowsocks-all.sh 2>&1 | tee shadowsocks-all.log

sed '4c "server_port":$port,' /etc/shadowsocks-r/config.json
sudo /etc/init.d/shadowsocks-r restart

echo "******************************
caddy 安装和配置成功
卸载：caddy -service uninstall
启动：caddy -service start  
停止：caddy -service stop     
重启：caddy -service restart  
查看状态：caddy -service status  
安装目录为：/usr/local/bin/caddy 
配置文件位置：/etc/caddy/Caddyfile
*****************************************
ssr安装和配置成功
启动：/etc/init.d/shadowsocks-r start    
停止：/etc/init.d/shadowsocks-r stop     
重启：/etc/init.d/shadowsocks-r restart  
查看状态：/etc/init.d/shadowsocks-rstatus  
配置文件位置：/etc/shadowsocks-r/config.json
"
sudo exit 0
