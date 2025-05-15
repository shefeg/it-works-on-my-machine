FROM golang:1.21.3

WORKDIR /app

COPY go.mod go.sum ./
COPY *.go ./

RUN GOOS=linux GOARCH=amd64 go build -o golang-demo
RUN chmod +x golang-demo

EXPOSE 8080

CMD ["./golang-demo"]
