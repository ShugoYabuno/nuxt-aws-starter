FROM node:16.15.1-alpine

ENV LANG C.UTF-8
ENV TZ Asia/Tokyo
ENV ROOT_PATH /app

RUN mkdir $ROOT_PATH
COPY . $ROOT_PATH
WORKDIR $ROOT_PATH

RUN apk update && apk upgrade\
  && yarn install && yarn run build

EXPOSE 3000

CMD ["yarn", "run", "start"]
