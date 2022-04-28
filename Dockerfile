## Use this dockerfile if docker image scan is not enabled
# 1. For build React app
FROM node:lts AS development

# Set working directory
WORKDIR /app

# 
COPY package.json /app/package.json
COPY package-lock.json /app/package-lock.json

# Same as npm install
RUN npm ci

COPY . /app

ENV CI=true
ENV PORT=3000

CMD [ "npm", "start" ]

FROM development AS build

RUN npm run build

# 2. For Nginx setup
FROM nginx:alpine



WORKDIR /usr/share/nginx/html

# Remove default nginx static assets
RUN rm -rf ./* 

# Copy static assets from builder stage
COPY --from=build /app/build .
USER nginx
# Containers run nginx with global directives and daemon off
ENTRYPOINT ["nginx", "-g", "daemon off;"]


################## Use this dockerfile if docker image scan is enabled
###For low vulnerabilities
# FROM alpine:3.15.4


# RUN apk add --update --no-cache nodejs npm && \
# 	rm -rf /var/cache/apk/* && \
# 	mkdir /home/app-user && adduser -h /home/app-user -s /bin/sh -D app-user && \
# 	chown -R app-user:app-user /home/app-user

# WORKDIR /home/app-user


# COPY . .


# RUN npm install
# RUN chown -R app-user:app-user /home/app-user/*
# USER	app-user
# CMD [ "npm", "start" ]