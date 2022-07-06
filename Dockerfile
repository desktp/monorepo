FROM node:16.13.1-alpine
RUN apt-get -y update
RUN apt-get -y install git wrangler