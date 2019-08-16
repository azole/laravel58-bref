# Custom Runtime - PHP

This is not working...


https://aws.amazon.com/tw/blogs/apn/aws-lambda-custom-runtime-for-php-a-practical-example/

From docker amazonlinux

```bash

# install dependencies
yum update -y
yum groupinstall -y "Development tools"
yum install libcurl-devel libxml2-devel openssl openssl-devel readline-devel libmcrypt gzip tar nano python2-pip -y


# install php 7.3
# https://github.com/gitKearney/php7-from-scratch

mkdir ~/php-7-bin
curl -sL https://github.com/php/php-src/archive/php-7.3.0.tar.gz | tar -xz
cd php-src-php-7.3.0
./buildconf --force
./configure --prefix=/root/php-7-bin/  \
    --enable-mysqlnd \
    --with-pdo-mysql \
    --with-pdo-mysql=mysqlnd \
    --enable-bcmath \
    --enable-fpm \
    --with-fpm-user=www-data \
    --with-fpm-group=www-data \
    --disable-cgi \
    --enable-mbstring \
    --enable-shmop \
    --enable-sockets \
    --enable-sysvmsg \
    --enable-sysvsem \
    --enable-sysvshm \
    --with-zlib \
    --with-curl \
    --without-pear \
    --with-openssl \
    --enable-pcntl \
    --with-readline

make install

# test version
/root/php-7-bin/bin/php -v

# install composer
cd ~
curl -sS https://getcomposer.org/installer | ./php-7-bin/bin/php


```


準備好檔案夾結構：

```bash
mkdir -p ~/php-example/{bin,src,lib}/
cd ~/php-example
touch ./src/{hello,goodbye}.php
touch ./bootstrap && chmod +x ./bootstrap
cp ~/php-7-bin/bin/php ./bin

./bin/php  ~/composer.phar require guzzlehttp/guzzle

nano ./lib/php.ini
#extension_dir=/opt/lib/php/
#display_errors=On
#extension=opcache.so

mkdir lib/php
cp ~/php-7-bin/lib/php/extensions/no-debug-non-zts-20180731/* lib/php/
cp /usr/lib64/libedit.so.0.0.42 lib/
cp /usr/lib64/libncurses.so.6 lib/
cp /usr/lib64/libpcre.so.1.2.0 lib/
cp /usr/lib64/libtinfo.so.6 lib/

nano bootstrap
#!/opt/bin/php -c/opt/lib/php.ini
nano src/hello.php
nano src/goodbye.php




zip -r runtime.zip bin lib bootstrap
zip -r vendor.zip vendor/
zip hello.zip src/hello.php
zip goodbye.zip src/goodbye.php

```




```bash
pip install --upgrade awscli

aws configure
```


prepare policy:

edit trust-policy.json

```json
{
  "Version": "2012-10-17",
  "Statement": [
   {
    "Effect": "Allow",
    "Principal": {
      "Service": "lambda.amazonaws.com"
   },
   "Action": "sts:AssumeRole"
  }
 ]
}
```

```bash
aws iam create-role \
    --role-name LambdaPhpExample \
    --path "/service-role/" \
    --assume-role-policy-document file:///root/php-example/trust-policy.json
```

deploy lambda layer

```
aws lambda publish-layer-version \
    --layer-name php-example-runtime \
    --zip-file fileb://runtime.zip \
    --region us-west-2

aws lambda publish-layer-version \
    --layer-name php-example-vendor \
    --zip-file fileb://vendor.zip \
    --region us-west-2
```


deploy lambda function


```
aws lambda create-function \
    --function-name php-example-hello \
    --handler hello \
    --zip-file fileb://./hello.zip \
    --runtime provided \
    --role "arn:aws:iam::286414557562:role/service-role/LambdaPhpExample" \
    --region us-west-2 \
    --layers "arn:aws:lambda:us-west-2:286414557562:layer:php-example-runtime:4" \
          "arn:aws:lambda:us-west-2:286414557562:layer:php-example-vendor:2"
```


