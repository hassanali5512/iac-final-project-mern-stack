FROM ubuntu

RUN apt update -y && \
    apt install -y nginx git curl gnupg

WORKDIR /opt/app/

RUN git clone https://github.com/hassanali5512/iac-final-project-mern-stack.git .

RUN curl -fsSL https://deb.nodesource.com/setup_current.x | bash - && \
    apt-get install -y nodejs

RUN echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-8.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/8.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-8.0.list && \
    curl -fsSL https://www.mongodb.org/static/pgp/server-8.0.asc | gpg --dearmor -o /usr/share/keyrings/mongodb-server-8.0.gpg && \
    apt-get update && \
    apt-get install -y mongodb-org

RUN mkdir -p /data/db && \
    chown -R mongodb:mongodb /data/db

WORKDIR /opt/app
RUN npm install

WORKDIR /opt/app/frontend
RUN npm install

RUN npm run build

WORKDIR /opt/app

CMD ["sh", "-c", "mongod --bind_ip_all & npm run server"]
