FROM node:14 as BUILD

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY package.json /usr/src/app
RUN npm install && npm cache clean --force

COPY . /usr/src/app
WORKDIR /usr/src/app

RUN node_modules/.bin/ng build


FROM nginx
RUN apt-get update && apt-get install -y jq && rm -rf /var/lib/apt/lists/*
COPY --from=BUILD /usr/src/app/dist/ /usr/share/nginx/html/
COPY ./nginx-start /usr/local/bin
COPY ./nginx-conf /etc/nginx/conf.d/default.conf
ENV PORT=3003

CMD nginx-start
