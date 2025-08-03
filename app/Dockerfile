FROM golang:1.25-rc-alpine AS builder

WORKDIR /app

COPY app/go.mod app/go.sum ./
RUN go mod download

COPY app/main.go .

RUN go build -o app .

FROM debian:bullseye-slim

WORKDIR /app

COPY --from=builder /app/app .

EXPOSE 9090

CMD ["./app"]