# Build the manager binary
FROM golang:1.23.4-alpine3.21 AS builder
ARG GOPROXY=""
ENV GOSUMDB=off \
    GO111MODULE=on

WORKDIR /workspace

COPY go.mod go.mod
COPY go.sum go.sum

# cache deps before building and copying source so that we don't need to re-download as much
# and so that source changes don't invalidate our downloaded layer
RUN go mod download -x

# Copy the go source
COPY main.go main.go

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -o probe .

# Main container
FROM alpine:3.21.0

ENV USER_UID=2001 \
    USER_NAME=probe \
    GROUP_NAME=probe

WORKDIR /app/

COPY --from=builder --chown=${USER_UID} /workspace/probe /app/

RUN addgroup ${GROUP_NAME} \
    && adduser -D -G ${GROUP_NAME} -u ${USER_UID} ${USER_NAME}

USER ${USER_UID}

CMD ["/app/probe"]
