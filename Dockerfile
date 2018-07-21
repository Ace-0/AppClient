FROM hub.c.163.com/public/nodejs:8.1.2 AS static-pages
COPY ./ /repo/
WORKDIR /repo/
RUN npm install
RUN npm run build

FROM hub.c.163.com/library/nginx:1.12.0
COPY --from=static-pages /repo/dist /static/