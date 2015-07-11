FROM ruby:2.2

RUN mkdir /app
ADD . /app
WORKDIR /app
RUN bundle install

CMD bundle exec bin/pinboard-fixup-github-titles
