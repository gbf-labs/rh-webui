FROM debian:stretch 

RUN apt-get update -y && \
    apt-get install -y openssh-server && \
    apt-get install -y vim &&  \
    apt-get install -y apt-utils && \
    apt-get install -y imagemagick && \
    apt-get install -y curl && \
    apt-get install -y sudo && \
    curl -sL https://deb.nodesource.com/setup_10.x | sudo bash - && \
    apt-get install -y nodejs && \
    apt-get install -y nginx && \
    apt-get install -y gnupg && \
    apt-get install -y net-tools && \
    apt-get install -y supervisor && \
    apt-get install -y htop

WORKDIR /app-dev

COPY . .

RUN npm install
RUN npm install -g env-cmd
RUN npm run build:clean-dev


WORKDIR /app

COPY . .

RUN npm install
RUN npm install -g env-cmd
RUN npm run build:clean-prod

COPY ./default /etc/nginx/sites-available/default

ADD ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 22 443
CMD ["/usr/bin/supervisord"]
