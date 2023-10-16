FROM node:18-alpine3.17

WORKDIR /frontend

COPY package.json package-lock.json ./

RUN npm install --non-interactive --frozen-lockfile.

CMD ["npm", "run", "dev"]