FROM ruby:2.4.2-alpine3.6 

LABEL author="Andy Perrett"

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
    && echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories \
    && echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories

RUN apk --update --upgrade add --no-cache \
    build-base \ 
    curl \
    unzip \
    ca-certificates \
    libexif \
    libffi-dev \
    firefox \
    chromium \
    chromium-chromedriver \
    && rm -rf /var/cache/apk/*

#============
# GeckoDriver
#============
ARG GECKODRIVER_VERSION=0.19.1
RUN wget --no-verbose -O geckodriver.tar.gz https://github.com/mozilla/geckodriver/releases/download/v$GECKODRIVER_VERSION/geckodriver-v$GECKODRIVER_VERSION-linux64.tar.gz \
  && tar -zxf geckodriver.tar.gz \
  && rm geckodriver.tar.gz \
  && mv geckodriver /usr/bin/geckodriver \
  && chmod 755 /usr/bin/geckodriver   
    
WORKDIR /app
COPY Gemfile Gemfile.lock /app/
RUN bundle install
COPY . /app/

CMD bundle exec ruby main.rb [Test Suite name]
