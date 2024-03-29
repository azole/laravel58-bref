# Bref Laravel Workshop

https://bref.sh/

> Bref provides the tools and documentation to easily deploy and run serverless PHP applications.

Bref relies on serverless and requires PHP 7.2+. If you don't have the environment, you can try docker image.


- https://medium.com/@azole/deploy-serverless-laravel-by-bref-6f28b1e0d53a


## Build Environment Manually

If you don't have PHP 7.2+, you can use docker image:


```bash
docker pull php:7.2-cli

docker run -it php:7.2-cli /bin/bash
```

### Install composer

```bash
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php composer-setup.php
php -r "unlink('composer-setup.php');"
mv composer.phar /usr/local/bin/composer
```

### Prepare tools

Install tools what you need:


```bash
apt-get update
apt-get upgrade -y
apt-get install -y unzip git

# if you need...
apt-get install -y nano

```

### Install npm

```bash
apt-get install -y nodejs npm
```

### Install serverless

```bash
npm install -g serverless

serverless config credentials --provider aws --key <key> --secret <secret>
```

## Build Environment By Dockerfile

```bash
docker build . -t laravel-bref-builder

docker run -it -e AWS_KEY=<key> -e AWS_SECRET=<secret> laravel-bref-builder /bin/bash

# or mount host folder to container

docker run -it -e AWS_KEY=<key> -e AWS_SECRET=<secret> -v <host-folder>:<container-folder> laravel-bref-builder /bin/bash
```

## Create Laravel Project

```bash
composer create-project laravel/laravel laravel58-bref --prefer-dist
composer require bref/bref
```

or clone this repo:

```bash
git clone https://github.com/azole/laravel58-bref.git
cd laravel58-bref
composer install
cp .env.example .env
php artisan k:g
```

### Laravel-Bref

https://bref.sh/docs/frameworks/laravel.html

- prepare serverless.yml
  - service name
  - region
- edit `bootstrap/app.php`
- edit `.env`
- edit `app/Providers/AppServiceProvider.php`


### Deployment

https://bref.sh/docs/deploy.html

```bash
composer install --optimize-autoloader --no-dev
serverless deploy
```

#### deletion

```bash
serverless remove
```

## Observe What Happen in AWS

### CloudFormation

Go to AWS CloudFormation, you will find a new stacks



