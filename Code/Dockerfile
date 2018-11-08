FROM ruby:2.5.1-alpine3.7

LABEL author="Andy Perrett"

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
    && echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories \
    && echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories

RUN apk --update add --no-cache \
    build-base \
    curl \
    unzip \
    ca-certificates \
    expat=2.2.5-r0 \
    #ssl_client=1.27.2-r11 \
    git \
    libexif \
    libffi-dev \
    firefox \
    font-misc-misc \
    #chromium \
    #chromium-chromedriver \
    && rm -rf /var/cache/apk/*

RUN apk upgrade

#============
# GeckoDriver
#============
ARG GECKODRIVER_VERSION=0.23.0
RUN wget --no-verbose --no-check-certificate -O geckodriver.tar.gz https://github.com/mozilla/geckodriver/releases/download/v$GECKODRIVER_VERSION/geckodriver-v$GECKODRIVER_VERSION-linux64.tar.gz \
  && tar -zxf geckodriver.tar.gz \
  && rm geckodriver.tar.gz \
  && mv geckodriver /usr/bin/geckodriver \
  && chmod 755 /usr/bin/geckodriver  

ENV PORTAL_URL=blank \
    ADMINL_URL=blank \
    PORTAL_USER_EMAIL=blank \
    PORTAL_USER_PASS=blank \ 
    ADMIN_USER=blank \
    ADMIN_USER_PASS=blank \
    PORTAL_USER_CHANGE_PASS=blank
    
WORKDIR /app
COPY Gemfile Gemfile.lock /app/
RUN bundle install
COPY . /app/

CMD bundle exec ruby main.rb [Test Suite name]
