# -------------------------------------------------------------------
#                               BASE NODE
# -------------------------------------------------------------------
# We need full node as we need git to download from some GitHub repos.
# -------------------------------------------------------------------
FROM node:8.16.1@sha256:c1c738e90e6c1f1f44043be5d0e77f1f16253b50ec4d98ab0f887fca72820a95 as BASE
MAINTAINER Stefan Walther <swr-nixda@gmail.com>

COPY package.json .
RUN node -p -e "require('./package.json').devDependencies['sense-go']" > /root/sense-go-version
RUN SENSE_GO_VERSION=$(cat /root/sense-go-version)

RUN echo "Installing sense-go version $SENSE_GO_VERSION"

WORKDIR /opt/sense-go

RUN npm install sense-go@$SENSE_GO_VERSION -g

# -------------------------------------------------------------------
#                                RELEASE
# -------------------------------------------------------------------
FROM node:8.16.1-alpine@sha256:4201be67ca08fbd095790ea514766ec96ef1debd73b9858922d47862ccd242e2 as RELEASE

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
