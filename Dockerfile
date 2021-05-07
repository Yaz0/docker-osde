# Start from Ubuntu image.
FROM ubuntu:20.04

# Author information.
LABEL maintainer="ijazvec@gmail.com"

# Configure terminal to support 256 colors so that application can use more
# colors.
ENV TERM xterm-256color

# Install all other packages.
RUN apt-get update && yes | unminimize && DEBIAN_FRONTEND=noninteractive \
	apt-get install -y \
		ca-certificates curl apt-transport-https build-essential wget git-core \
		unzip python less man-db htop tmux cloc tree \
		openssh-client shellcheck lsof p7zip zip gettext libtool \
		libtool-bin autoconf automake pkg-config cmake clang libclang-dev \
		universal-ctags telnet python3-neovim ripgrep locales sshpass \
		global sudo python3-virtualenv python3-dev gcc-multilib \
		clang-format git-extras tmate inotify-tools rsync vim && \
	rm -rf /var/lib/apt/lists/*

# Configure system locale.
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
	dpkg-reconfigure --frontend=noninteractive locales && \
	update-locale LANG=en_US.UTF-8

ENV LANG=en_US.UTF-8 \
	LANGUAGE=en_US:en \
	LC_ALL=en_US.UTF-8 \
	LC_CTYPE=en_US.UTF-8 \
	LC_MESSAGES=en_US.UTF-8 \
	LC_COLLATE=en_US.UTF-8

#Configure 'vim' as default editor
ENV EDITOR=vim \
	VISUAL=vim

# Install Hugo.
RUN wget https://github.com/gohugoio/hugo/releases/download/v0.80.0/hugo_0.80.0_Linux-64bit.deb \
	-O /tmp/hugo.deb && \
	dpkg -i /tmp/hugo.deb && \
	rm -rf /tmp/hugo.deb
EXPOSE 1313

WORKDIR /home/Workspace


