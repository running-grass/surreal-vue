FROM node AS build
WORKDIR /app
RUN npm config set registry https://repo.nju.edu.cn/repository/npm/
RUN npm i -g pnpm

COPY ./package.json .
COPY ./pnpm-lock.yaml .
RUN pnpm i

COPY . .
RUN npm run build

FROM nginx AS prod
WORKDIR /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf
COPY entrypoint.sh /scripts/
COPY init.sql /scripts/
COPY --from=build /app/dist .
ENTRYPOINT /scripts/entrypoint.sh