FROM ubuntu:18.04

WORKDIR /app
COPY . .

# setup nginx + passenger + node lts + npm
RUN apt-get update \
  && apt-get install -y nginx nodejs npm curl \
  && npm install -g n && n lts \
  && apt-get install -y dirmngr gnupg \
  && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7 \
  && apt-get install -y apt-transport-https ca-certificates \
  && sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger bionic main > /etc/apt/sources.list.d/passenger.list' \
  && apt-get update \
  && apt-get install -y libnginx-mod-http-passenger

# setup nginx conf
RUN cat /app/default.conf > /etc/nginx/sites-available/default

# setup app
RUN npm install
RUN ./node_modules/.bin/next build

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

EXPOSE 80
STOPSIGNAL SIGTERM
CMD ["nginx", "-g", "daemon off;"]