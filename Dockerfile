# -------------------------------------------------------------------
#                               BASE NODE
# -------------------------------------------------------------------
# We need full node as we need git to download from some GitHub repos.
# -------------------------------------------------------------------
FROM node:8.16.2@sha256:723750b1acf5c7e752e4270e3cc5a5e54c845ba769b62a104e60f722b5bfad42 as BASE
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
FROM node:8.16.2-alpine@sha256:e820bbb6174b672a8eaf3c08aea105f0e436e4f85f46d973271b0cf73084deb5 as RELEASE

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
