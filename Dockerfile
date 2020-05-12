ARG ONEC_VERSION

FROM alpine:latest as downloader
LABEL maintainer="Ruslan Zhdanov <nl.ruslan@yandex.ru> (@TheDemonCat)"

ARG ONEC_USERNAME
ARG ONEC_PASSWORD
ARG VERSION
ENV installer_type=edt

RUN apk --no-cache add bash curl grep \
  && mkdir /edt \
  && cd /edt \
  && curl -O "https://raw.githubusercontent.com/TheDemonCat/onec_downloader/master/download.sh" \
  && chmod +x download.sh \
  && sync; ./download.sh \
  && for file in *.tar.gz; do tar -zxf "$file"; done \
  && rm -rf *.tar.gz

FROM adoptopenjdk:14-hotspot as base

LABEL maintainer="Ruslan Zhdanov <nl.ruslan@yandex.ru> (@TheDemonCat)"

# Установим поддержку русского языка
RUN set -xe \
    && apt-get update \
    && apt install -y --no-install-recommends \
        libgtk-3-0 \
        locales \
        language-pack-ru \
    && rm -rf /var/lib/apt/lists/* \
        /var/cache/debconf \
      /tmp/* \
    && localedef -i ru_RU -c -f UTF-8 -A /usr/share/locale/locale.alias ru_RU.UTF-8

ENV LANGUAGE ru_RU.UTF-8
ENV LANG ru_RU.UTF-8
ENV LC_ALL ru_RU.UTF-8

COPY --from=downloader /edt /edt/

RUN cd /edt \ 
    && sync; ./1ce-installer-cli install  \
    && cd .. \
    && rm -rf /edt

RUN mkdir -p /root/.1cv8/1C/1cv8/conf/

ENV PATH /opt/1C/1CE/components/1c-enterprise-ring-0.11.8+4-x86_64:$PATH

ENV RING_OPTS="-Duser.country=ru -Duser.language=RU"

ARG onec_uid="1000"
ARG onec_gid="1000"

RUN groupadd -r grp1cv8 --gid=$onec_gid \
  && useradd -r -g grp1cv8 --uid=$onec_uid --home-dir=/home/usr1cv8 --shell=/bin/bash usr1cv8 \
  && mkdir -p /var/log/1C /home/usr1cv8/.1cv8/1C/1cv8/conf \
  && chown -R usr1cv8:grp1cv8 /var/log/1C /home/usr1cv8

USER usr1cv8 
