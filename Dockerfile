FROM node:16.17.1-alpine

RUN apk add g++ make python

ENV PROJECT_ROOTDIR /app/

WORKDIR $PROJECT_ROOTDIR

COPY package.json yarn.lock $PROJECT_ROOTDIR

RUN yarn install

COPY . $PROJECT_ROOTDIR

EXPOSE 3000
ENV HOST 0.0.0.0

CMD ["yarn", "dev"]
