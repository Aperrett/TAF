FROM ruby:2.4.2-alpine3.6 

LABEL author="Andy Perrett"

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
    && echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories

RUN apk --update --upgrade add --no-cache \
    build-base \ 
    curl \
    unzip \
    libexif \
    libffi-dev \
    chromium \
    chromium-chromedriver

WORKDIR /app
COPY Gemfile Gemfile.lock /app/
RUN bundle install
COPY . /app/


CMD bundle exec ruby main.rb [Test File]
