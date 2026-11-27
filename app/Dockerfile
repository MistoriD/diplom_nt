FROM nginx:1.25-alpine

ARG VERSION=1.0.0
ENV APP_VERSION=${VERSION}

# Копируем конфигурацию Nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Копируем статику
COPY index.html /usr/share/nginx/html/index.html

# Подставляем версию в HTML
RUN sed -i "s/APP_VERSION_PLACEHOLDER/${APP_VERSION}/g" /usr/share/nginx/html/index.html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
