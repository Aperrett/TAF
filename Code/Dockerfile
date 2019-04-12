FROM ruby:2.6.2-alpine3.9

LABEL author="Andy Perrett"

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
    && echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories \
    && echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories

RUN apk --update add --no-cache \
    build-base \
    curl \
    firefox \
    font-misc-misc \
    #chromium \
    #chromium-chromedriver \
    # VNC for debugging.
    dbus\
    dumb-init \
    fluxbox \
    gnutls \
    libxshmfence-dev \
    x11vnc \
    xdpyinfo \
    xvfb \
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