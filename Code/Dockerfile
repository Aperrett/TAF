FROM ruby:2.4.2-alpine 

WORKDIR /opt/taf/

COPY Gemfile Gemfile.lock ./

RUN bundle install

COPY taf.zip ./

CMD ["bundle", "exec", "-C", "main.rb"]