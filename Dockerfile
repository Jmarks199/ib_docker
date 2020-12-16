FROM amazonlinux:2.0.20200722.0 AS builder

# Utils for Installing Components
RUN yum install -y wget && \
    yum install -y tar && \
    yum install -y which && \
    yum install -y xorg-x11-server-Xvfb && \
    yum install -y dos2unix && \
    yum install -y unzip

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

# Start Multistage Build
FROM amazonlinux:2.0.20200722.0

ENV TWS_MAJOR_VRSN=978
ENV IBC_INI=/opt/ibc/config.ini
ENV TWOFA_TIMEOUT_ACTION=exit
ENV IBC_PATH=/opt/ibc
ENV TWS_PATH=/root/Jts
ENV TWS_SETTINGS_PATH=/root/Jts
ENV LOG_PATH=/opt/ibc/Logs
ENV APP=GATEWAY

# TWS Dependencies
RUN yum install -y socat && \
    yum install -y xorg-x11-server-Xvfb && \
    yum install -y libXrender && \
    yum install -y libXtst && \
    yum install -y libXi && \
    yum install -y telnet

COPY --from=builder /root /root
COPY --from=builder /opt/ibc /opt/ibc
COPY --from=builder /usr/local/i4j_jres/ /usr/local/i4j_jres/

ENTRYPOINT ["/root/start_server.sh"]
