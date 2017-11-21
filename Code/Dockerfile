FROM ruby:2.4.2-alpine 

RUN apk add --no-cache \
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