FROM ruby:2.7.0-slim-buster

LABEL author="Andy Perrett"

RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		build-essential \
    	apt-utils \
		software-properties-common \
		# chromium \
		# chromedriver \
		git-core \
		curl \
    	wget \
	&& rm -rf /var/lib/apt/lists/*

RUN add-apt-repository "deb http://deb.debian.org/debian/ unstable main contrib non-free"

RUN echo 'Package: *\n\
Pin: release a=stable\n\
Pin-Priority: 900\n\
\n\
Package: *\n\
Pin release a=unstable\n\
Pin-Priority: 10%\n'\
> /etc/apt/preferences.d/99pin-unstable

RUN apt-get update \
	&& apt-get install -y --no-install-recommends -t unstable firefox \
	&& rm -rf /var/lib/apt/lists/*

#============
# GeckoDriver
#============
ARG GECKODRIVER_VERSION=0.26.0
RUN wget --no-verbose --no-check-certificate -O geckodriver.tar.gz https://github.com/mozilla/geckodriver/releases/download/v$GECKODRIVER_VERSION/geckodriver-v$GECKODRIVER_VERSION-linux64.tar.gz \
  && tar -zxf geckodriver.tar.gz \
  && rm geckodriver.tar.gz \
  && mv geckodriver /usr/bin/geckodriver \
  && chmod 755 /usr/bin/geckodriver

WORKDIR /app
COPY Gemfile Gemfile.lock /app/
RUN gem install bundler
RUN bundle install
COPY . /app/

ENTRYPOINT ["/app/docker-entrypoint.sh"]