FROM ubuntu:noble

RUN set -eux; \
  apt-get update; \
  apt-get install -y --no-install-recommends \
    ca-certificates curl jq unzip; \
  rm -rf /var/lib/apt/lists/*

# Scrape the official download-links API for the latest Bedrock Linux server ZIP.
# Fallback: attempt HTML pattern scrape (less reliable if the page is fully client-rendered).
RUN set -eux; \
  url="$(curl -fsSL --http1.1 \
      'https://net-secondary.web.minecraft-services.net/api/v1.0/download/links' \
    | jq -r '.result.links[] | select(.downloadType=="serverBedrockLinux") | .downloadUrl' \
    | head -n1)"; \
  echo "Downloading: $url"; \
  curl -fL --progress-bar -A 'Mozilla/5.0' -o /tmp/bedrock-server.zip "$url"; \
  mkdir -p /bedrock-server; \
  unzip -q /tmp/bedrock-server.zip -d /bedrock-server; \
  rm /tmp/bedrock-server.zip

EXPOSE 19132/udp

WORKDIR /bedrock-server
ENV LD_LIBRARY_PATH=.
RUN chmod +x ./bedrock_server

CMD ["./bedrock_server"]

