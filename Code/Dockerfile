FROM ruby:2.6.3-slim-stretch

LABEL author="Andy Perrett"

RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		build-essential \
    apt-utils \
    firefox-esr \
		git-core \
		curl \
    wget \
	&& rm -rf /var/lib/apt/lists/*

#============
# GeckoDriver
#============
ARG GECKODRIVER_VERSION=0.24.0
RUN wget --no-verbose --no-check-certificate -O geckodriver.tar.gz https://github.com/mozilla/geckodriver/releases/download/v$GECKODRIVER_VERSION/geckodriver-v$GECKODRIVER_VERSION-linux64.tar.gz \
  && tar -zxf geckodriver.tar.gz \
  && rm geckodriver.tar.gz \
  && mv geckodriver /usr/bin/geckodriver \
  && chmod 755 /usr/bin/geckodriver  
    
WORKDIR /app
COPY Gemfile Gemfile.lock /app/
RUN bundle install
COPY . /app/

# ENTRYPOINT ["/usr/bin/dumb-init", "/app/docker-entrypoint.sh"]
ENTRYPOINT ["/app/docker-entrypoint.sh"]