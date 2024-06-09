FROM node:21-alpine

RUN apk add --no-cache \
    tzdata \
    curl \
    bash

WORKDIR /app

# Configure non-root user.
ARG HOST_USER_ID=1000
ARG HOST_GROUP_ID=1000
RUN deluser --remove-home node \
  && addgroup -S node -g ${HOST_GROUP_ID} \
  && adduser -S -G node -u ${HOST_USER_ID} node

USER node
