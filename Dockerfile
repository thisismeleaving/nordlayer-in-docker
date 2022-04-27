FROM cypress/included:9.5.3

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get install -y apt-utils libcap2-bin procps wget curl nano net-tools network-manager \
                       libreadline-dev libreadline8 readline-common

RUN wget https://downloads.nordlayer.com/linux/latest/nordlayer-latest_1.0.0_all.deb
RUN apt-get install ./nordlayer-latest_1.0.0_all.deb
RUN apt-get update || echo "some apt-get paths failed to update"

RUN apt-get install nordlayer || echo "nordlayer install failed with errors"

COPY etc/init.d/nordlayerd /etc/init.d/nordlayerd
COPY nordlayer.db /var/lib/nordlayer/
RUN chown -R root:root /usr/sbin/nordlayerd && chmod +x /usr/sbin/nordlayerd
RUN chown -R root:root /usr/sbin/nordlayer-openvpn && chmod +x /usr/sbin/nordlayer-openvpn
RUN chmod +x /etc/init.d/nordlayerd
RUN usermod -a -G nordlayer $(whoami)

ENV NORDLAYER_IPROUTE=/usr/bin/nordlayer-ip
ENV TERM=vt100