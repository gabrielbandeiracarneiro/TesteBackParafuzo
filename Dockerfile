FROM ruby:3.0.2-alpine

MAINTAINER Gabriel Bandeira <gabrielbandeiracarneiro@gmail.com>

ARG SOURCE_COMMIT
ENV SOURCE_COMMIT $SOURCE_COMMIT

ENV PORT 8000
ENV SSL_PORT 8443
ENV RAILS_ENV production
ENV SECRET_KEY_BASE changeme
ENV RAILS_SERVE_STATIC_FILES true
ENV RAILS_LOG_TO_STDOUT true

EXPOSE $PORT
EXPOSE $SSL_PORT

WORKDIR /app

ADD . .

RUN apk update 
RUN apk add sqlite-dev build-base zlib-dev tzdata nodejs yarn openssl-dev shared-mime-info   
RUN rm -rf /var/cache/apk/* 
RUN gem install bundler -v $(tail -n1 Gemfile.lock | xargs) 
RUN bundle config set build.sassc '--disable-march-tune-native' 
RUN bundle config set without 'development test' 
RUN bundle install 
RUN addgroup -S app && adduser -S app -G app -h /app 
RUN chown -R app.app /app 
RUN chown -R app.app /usr/local/bundle 
RUN apk del build-base yarn
RUN rails db:create
RUN rails g model Parking plate:string:index reservation:string time:string paid:boolean left:boolean entryDate:datetime paidDate:datetime exitDate:datetime
RUN rails db:migrate
USER app

CMD puma -C config/puma.rb