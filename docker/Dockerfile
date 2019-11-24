FROM anthonykgross/docker-fullstack-web:ubuntu-php7.2

MAINTAINER Anthony K GROSS

WORKDIR /var/www/html

ARG APPLICATION_ENV='dev'
ARG DB_USER='DB_USER'
ARG DB_PASSWORD='DB_PASSWORD'
ARG DB_HOST='DB_HOST'
ARG DB_NAME='DB_NAME'
ARG MAILER_USER='MAILER_USER'
ARG MAILER_PASSWORD='DB_NAME'
ENV APPLICATION_ENV $APPLICATION_ENV

RUN apt-get update -y && \
	apt-get upgrade -y && \
	apt-get install -y supervisor nginx && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get autoremove -y --purge && \
    rm -Rf /etc/nginx/sites-enabled/default && \
    mkdir -p /var/www/logs

ADD docker/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

COPY ./src /var/www/html
COPY ./docker/supervisor.conf /etc/supervisor/conf.d/supervisor.conf
COPY ./docker/nginx.conf /etc/nginx/sites-enabled/nginx.conf

RUN if [ "$APPLICATION_ENV" = "prod" ]; then \
        cp -f .env.prod .env && \
        sed -i -e "s,\${{DB_USER}},$DB_USER,g" .env && \
        sed -i -e "s,\${{DB_PASSWORD}},$DB_PASSWORD,g" .env && \
        sed -i -e "s,\${{DB_HOST}},$DB_HOST,g" .env && \
        sed -i -e "s,\${{DB_NAME}},$DB_NAME,g" .env && \
        sed -i -e "s,\${{MAILER_USER}},$MAILER_USER,g" .env && \
        sed -i -e "s,\${{MAILER_PASSWORD}},$MAILER_PASSWORD,g" .env && \
        echo "Settings done !" \
    ; fi

RUN chmod +x /entrypoint.sh && \
    bash --rcfile "/root/.bash_profile" -ic "/entrypoint.sh permission" && \
    bash --rcfile "/root/.bash_profile" -ic "/entrypoint.sh install"

EXPOSE 80
EXPOSE 443

ENTRYPOINT ["/entrypoint.sh"]
CMD ["run"]

