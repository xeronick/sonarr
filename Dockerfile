FROM linuxserver/sonarr:preview

ENV MMT_PATH /multi_mp4_transcoder
ENV MMT_RS Sonarr
ENV MMT_UPDATE false

RUN \
  apt-get update && \
  apt-get install -y \
  ffmpeg \
  git \
  python3 \
  python3-pip \
  openssl \
  php7.4-cli \
  nano \
  wget

RUN \
  mkdir ${MMT_PATH} && \
  git clone https://github.com/xeronick/multi_mp4_transcoder.git ${MMT_PATH} && \
  python3 -m pip install --user --upgrade pip && \
  python3 -m pip install --user virtualenv && \
  python3 -m virtualenv ${MMT_PATH}/venv && \
  ${MMT_PATH}/venv/bin/pip install -r ${MMT_PATH}/setup/requirements.txt && \
  wget https://johnvansickle.com/ffmpeg/builds/ffmpeg-git-amd64-static.tar.xz -O /tmp/ffmpeg.tar.xz && \
  tar -xJf /tmp/ffmpeg.tar.xz -C /usr/local/bin --strip-components 1 && \
  chgrp users /usr/local/bin/ffmpeg && \
  chgrp users /usr/local/bin/ffprobe && \
  chmod g+x /usr/local/bin/ffmpeg && \
  chmod g+x /usr/local/bin/ffprobe && \
  ln -s /downloads /data && \
  ln -s /config_mp4_automator/config/autoProcess.ini ${MMT_PATH}/autoProcess.ini && \
  rm -rf \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/*

VOLUME config_mp4_automator

COPY extras/ ${MMT_PATH}/
COPY root/ /