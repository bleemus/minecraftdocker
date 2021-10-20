FROM ubuntu:latest

RUN apt-get update
RUN apt-get install -y unzip curl wget

#RUN wget -O bedrock-server.zip `curl -v --silent  https://www.minecraft.net/en-us/download/server/bedrock 2>&1 | grep -o 'https://minecraft.azureedge.net/bin-linux/[^\"]*'`

RUN wget -O bedrock-server.zip `wget --no-verbose -U "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1)" -qO- https://minecraft.net/en-us/download/server/bedrock/ | grep -o 'https://minecraft.azureedge.net/bin-linux/[^\"]*'`

EXPOSE 19132/udp

RUN unzip bedrock-server.zip -d bedrock-server
RUN rm bedrock-server.zip

WORKDIR /bedrock-server
ENV LD_LIBRARY_PATH=.
RUN chmod +x ./bedrock_server
CMD ./bedrock_server
