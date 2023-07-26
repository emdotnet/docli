FROM python:3.10-buster

# Set environment variables
RUN export LANG=C.UTF-8
RUN export LC_ALL=C.UTF-8
RUN export LANGUAGE=en_US.UTF-8

# Install dependencies
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-suggests --no-install-recommends mariadb-client xfonts-75dpi xfonts-base
RUN wget -q https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6-1/wkhtmltox_0.12.6-1.buster_amd64.deb
RUN dpkg -i wkhtmltox_0.12.6-1.buster_amd64.deb && rm wkhtmltox_0.12.6-1.buster_amd64.deb
RUN rm -rf /var/lib/apt/lists/*
RUN rm -rf /etc/apt/sources.list.d/*
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash
RUN apt-get install -y nodejs
RUN npm install --global yarn

# Create user
RUN adduser --disabled-password --gecos "" dokotest
RUN usermod -aG sudo dokotest
RUN echo 'dokotest ALL=(ALL)  NOPASSWD:ALL' >> /etc/sudoers

# Install bench
USER dokotest
RUN export PATH=$PATH:/home/dokotest/.local/bin
RUN pip install dokos-cli

RUN mkdir -p /home/dokotest/dokos-bench
WORKDIR /home/dokotest/dokos-bench
