= Expensable
## Environment

### Facebook authentication

#### Configure your localhost https support

To not get the facebook errors you should serve the application via https.

Make sure you have nginx installed, it will be used to serve localhost via https.

```
mkdir certs_localhost
# generate self signed certificate, the identifier for it should be localhost
cd certs_localhost
openssl req -x509 -newkey rsa:2048 -keyout expensable-development.key -out expensable-development.crt -days 5000 -nodes

# assumming path to nginx is /usr/local/etc/nginx/

# copy certificates and configuration
cd <project>
cp -r certs_localhost /usr/local/etc/nginx/
mv /usr/local/etc/nginx/certs_localhost/rails_https /usr/local/etc/nginx/sites-enabled/rails_https

# ensure that your /usr/local/etx/nginx/nginx.conf has the following line in http section
include /usr/local/etc/nginx/sites-enabled/*;

# test nginx configuration
nginx -t

# restart nginx
service nginx restart
```

Launch rails application and visit https://localhost

