# -------------------------------------------------------------------
#                               BASE NODE
# -------------------------------------------------------------------
# We need full node as we need git to download from some GitHub repos.
# -------------------------------------------------------------------
FROM node:8.15.0@sha256:a8a9d8eaab36bbd188612375a54fb7f57418458812dabd50769ddd3598bc24fc as BASE
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
FROM node:8.15.0-alpine@sha256:812e5a88e7dc8e8d9011f18a864d2fd7da4d85b6d77c545b71a73b13c1f4993e as RELEASE

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
