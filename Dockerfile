# -------------------------------------------------------------------
#                               BASE NODE
# -------------------------------------------------------------------
# We need full node as we need git to download from some GitHub repos.
# -------------------------------------------------------------------
FROM node:8.11.3@sha256:625d0b446f63b2d051c7b2a468f6cee63536dec716f09afcf9ae1c575d9b953a as BASE
MAINTAINER Stefan Walther <swr-nixda@gmail.com>

ARG SENSE_GO_VERSION="0.14.6"

WORKDIR /opt/sense-go

RUN npm install sense-go@$SENSE_GO_VERSION -g

## -------------------------------------------------------------------
##                                RELEASE
## -------------------------------------------------------------------
FROM node:8.11.3-alpine@sha256:c9f2470464363addb0be6a61678f44854e73eee974bbc792a71d4d2b7ffd5edd as RELEASE

RUN apk update
RUN apk add bash

WORKDIR /opt/sense-go

# Enables colored output
ENV FORCE_COLOR=true

# OK, here we have to copy the symbolic link
# use npm config get prefix to get the node.js prefix https://stackoverflow.com/questions/18383476/how-to-get-the-npm-global-path-prefix

# Create the symbolic link
RUN ln -s /usr/local/lib/node_modules/sense-go/bin/cli.js /usr/local/bin/sense-go

# Copy the global packages previously being installed
COPY --from=BASE /usr/local/lib/node_modules /usr/local/lib/node_modules

COPY ./docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
