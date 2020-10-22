FROM alpine:latest
LABEL author="Greg Agacinski <greg@nobl9.com>"

LABEL "com.github.actions.name"="Download GitHub Release Asset"
LABEL "com.github.actions.description"="Downloads an release asset from private repository"
LABEL "com.github.actions.icon"="download"
LABEL "com.github.actions.color"="blue"

RUN	apk add --no-cache \
  bash \
  ca-certificates \
  curl \
  wget \
  jq

COPY download-asset.sh /usr/bin/download-asset.sh
RUN chmod +x /usr/bin/download-asset.sh

ENTRYPOINT ["/usr/bin/download-asset.sh"]
