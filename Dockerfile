FROM amazonlinux

# Utils for Installing Components
RUN yum install -y wget && \
    yum install -y tar && \
    yum install -y unzip

# TWS Dependencies
RUN yum install -y socat && \
    yum install -y xorg-x11-server-Xvfb && \
    yum install -y libXtst && \
    yum install -y libXrender && \
    yum install -y libXi && \
    yum install -y which && \
    yum install -y telnet && \
    yum install -y xterm && \
    yum install -y dos2unix && \
    yum install -y xauth

# Get the ibgateway stable version
RUN wget -q https://download2.interactivebrokers.com/installers/ibgateway/stable-standalone/ibgateway-stable-standalone-linux-x64.sh && \
    chmod a+x ibgateway-stable-standalone-linux-x64.sh && \
    ./ibgateway-stable-standalone-linux-x64.sh -q && \
    rm ibgateway-stable-standalone-linux-x64.sh

# Install IBC into a new directory
WORKDIR /opt/ibc

RUN wget -q https://github.com/IbcAlpha/IBC/releases/download/3.8.4-beta.2/IBCLinux-3.8.4-beta.2.zip && \
    unzip ./IBCLinux-3.8.4-beta.2.zip && \
    chmod -R u+x *.sh && \
    chmod -R u+x scripts/*.sh && \
    rm IBCLinux-3.8.4-beta.2.zip

WORKDIR /root

# Copy files into container from context directory
COPY start_server.sh start_server.sh
COPY config.ini /opt/ibc/config.ini
COPY jts.ini /root/Jts/jts.ini

RUN dos2unix start_server.sh

CMD bash start_server.sh
