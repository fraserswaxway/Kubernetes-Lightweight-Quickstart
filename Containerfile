FROM golang:latest
COPY ./hello.go hello.go
RUN go build -o /bin/hello hello.go
CMD ["hello"]
