FROM ruby:2.6.1-alpine3.8

LABEL author="Andy Perrett"

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
    && echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories \
    && echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories

RUN apk --update add --no-cache \
    build-base \
    curl \
    unzip \
    libuuid=2.32-r0 \
    libmount=2.32-r0 \
    libblkid=2.32-r0 \
    expat=2.2.5-r0 \
    git \
    libexif \
    libffi-dev \
    firefox \
    font-misc-misc \
    #chromium \
    #chromium-chromedriver \
    # VNC for debugging.
    dbus=1.10.24-r1 \
    dumb-init=1.2.2-r1 \
    fluxbox=1.3.7-r2 \
    gnutls=3.6.2-r0 \
    libxshmfence-dev=1.2-r2 \
    x11vnc=0.9.14-r4 \
    xdpyinfo=1.3.2-r0 \
    xvfb=1.19.6-r3 \
    && rm -rf /var/cache/apk/*

#RUN apk upgrade

#============
# GeckoDriver
#============
ARG GECKODRIVER_VERSION=0.23.0
RUN wget --no-verbose --no-check-certificate -O geckodriver.tar.gz https://github.com/mozilla/geckodriver/releases/download/v$GECKODRIVER_VERSION/geckodriver-v$GECKODRIVER_VERSION-linux64.tar.gz \
  && tar -zxf geckodriver.tar.gz \
  && rm geckodriver.tar.gz \
  && mv geckodriver /usr/bin/geckodriver \
  && chmod 755 /usr/bin/geckodriver  
    
WORKDIR /app
COPY Gemfile Gemfile.lock /app/
RUN bundle install
COPY . /app/

ENTRYPOINT ["/usr/bin/dumb-init", "/app/docker-entrypoint.sh"]