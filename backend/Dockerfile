FROM golang:1.21.3-alpine3.18

ARG GO111MODULE=on

RUN apk update && apk add git
RUN mkdir /backend
# ワーキングディレクトリの設定
WORKDIR /backend

COPY . /backend

RUN go mod tidy && \
    go install github.com/cosmtrek/air@v1.46.0 && \
    go install -tags 'postgres' github.com/golang-migrate/migrate/v4/cmd/migrate@latest &&  \
    go install github.com/volatiletech/sqlboiler/v4@v4.15.0 && \
    go install github.com/volatiletech/sqlboiler/v4/drivers/sqlboiler-psql@v4.15.0