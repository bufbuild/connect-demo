# syntax=docker/dockerfile:1
FROM golang:1.18-alpine AS builder
RUN apk add --update --no-cache git && rm -rf /var/cache/apk/*
WORKDIR /workspace
COPY go.mod go.sum /workspace/
RUN go mod download
COPY main.go /workspace/
COPY internal /workspace/internal
RUN go build -o connect-demo .

FROM alpine
RUN apk add --update --no-cache ca-certificates tzdata && rm -rf /var/cache/apk/*
COPY --from=builder /workspace/connect-demo /usr/local/bin/connect-demo
CMD [ "/usr/local/bin/connect-demo" ]