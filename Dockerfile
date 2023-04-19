FROM alpine:3.17.3

ENV BASE_URL="https://get.helm.sh"

ENV HELM_2_FILE="helm-v2.17.0-linux-amd64.tar.gz"
ENV HELM_3_FILE="helm-v3.4.2-linux-amd64.tar.gz"

# 2023-04-19: patch "ERROR: unable to select packages: python3-3.10.11-r0: breaks: py3-colorama-0.4.6-r3[python3~3.11]"
# based on https://github.com/zidsa/helm/commit/96f96a3ee9a71a6fd941a015c1c0919714f0f245
RUN apk add --no-cache ca-certificates jq curl bash
RUN apk add --no-cache nodejs
RUN apk add --no-cache python3 py3-pip
RUN pip3 install --upgrade pip awscli
# Install helm version 2:
RUN curl -L ${BASE_URL}/${HELM_2_FILE} |tar xvz && \
    mv linux-amd64/helm /usr/bin/helm && \
    chmod +x /usr/bin/helm && \
    rm -rf linux-amd64
# Install helm version 3:
RUN curl -L ${BASE_URL}/${HELM_3_FILE} |tar xvz && \
    mv linux-amd64/helm /usr/bin/helm3 && \
    chmod +x /usr/bin/helm3 && \
    rm -rf linux-amd64
# Init version 2 helm:
RUN helm init --client-only

ENV PYTHONPATH "/usr/lib/python3.8/site-packages/"

COPY . /usr/src/
ENTRYPOINT ["node", "/usr/src/index.js"]
