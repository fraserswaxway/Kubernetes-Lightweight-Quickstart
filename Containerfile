FROM registry-1.docker.io/library/golang:latest
COPY ./hello.go hello.go
RUN go build -o /bin/hello hello.go
CMD ["hello"]