FROM ruby:2.5.1-alpine3.7

RUN apk add --no-cache alpine-sdk sqlite sqlite-dev

RUN gem install mailcatcher -v 0.6.5 --no-ri --no-rdoc

EXPOSE 1025 8080

CMD ["mailcatcher", "-f", "--ip=0.0.0.0", "--http-port=8080"]
