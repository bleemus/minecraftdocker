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

ARG USER_ID=1000
ARG GROUP_ID=1000

# Create group and user, handling cases where GID/UID already exist
RUN set -eux; \
  # Create group if GID doesn't exist, otherwise use existing group
  if ! getent group ${GROUP_ID} > /dev/null 2>&1; then \
    groupadd -g ${GROUP_ID} minecraft; \
  fi; \
  # Get the group name for this GID
  GROUP_NAME=$(getent group ${GROUP_ID} | cut -d: -f1); \
  # Create user if UID doesn't exist
  if ! getent passwd ${USER_ID} > /dev/null 2>&1; then \
    useradd -m -u ${USER_ID} -g ${GROUP_NAME} minecraft; \
  fi; \
  # Ensure ownership using numeric IDs (works regardless of username/groupname)
  chown -R ${USER_ID}:${GROUP_ID} /bedrock-server

EXPOSE 19132/udp

WORKDIR /bedrock-server
ENV LD_LIBRARY_PATH=.
RUN chmod +x ./bedrock_server

# Switch to user by numeric ID (works even if we reused existing user)
USER ${USER_ID}
CMD ["./bedrock_server"]

