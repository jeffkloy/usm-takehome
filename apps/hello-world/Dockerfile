FROM golang:1.23-alpine AS builder

WORKDIR /app
COPY ./src/main.go .

RUN go build -o main main.go

FROM alpine:latest

RUN apk --no-cache add ca-certificates
WORKDIR /root/

COPY --from=builder /app/main .

EXPOSE 8080
CMD ["./main"]
