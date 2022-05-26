FROM node:14-slim

# Based on puppeteer Dockerfile example: https://github.com/puppeteer/puppeteer/blob/main/docs/troubleshooting.md#running-puppeteer-in-docker

RUN apt-get update \
    && apt-get install -y wget gnupg \
    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
    && apt-get update \
    && apt-get install -y fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst fonts-freefont-ttf libxss1 $( \
        apt-cache depends google-chrome-stable | \
            grep -E '^\s+|?Depends' | \
            grep -vE '[<>]'| \
            cut -d: -f2) \
        --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*


COPY entrypoint.sh /entrypoint.sh
RUN chmod a+rx /entrypoint.sh

RUN wget https://github.com/Yelp/dumb-init/releases/download/v1.2.5/dumb-init_1.2.5_amd64.deb
RUN dpkg -i dumb-init_*.deb

# Run everything after as non-privileged user and install npm packages localy
USER node
WORKDIR /home/node

RUN npm init -y &&  \
    npm i resume-cli \
    && mkdir -p /home/node/Downloads

USER node
ENTRYPOINT [ "dumb-init", "--", "/entrypoint.sh" ]
