FROM ruby:3.1

WORKDIR /app
COPY Gemfile /app/
RUN bundle install
COPY . /app/
EXPOSE 4567

CMD ["ruby", "server.rb", "-o", "0.0.0.0"]