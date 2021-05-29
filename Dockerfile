# Start from Ubuntu image.
FROM ubuntu:20.04

# Author information.
LABEL maintainer="ijazvec@gmail.com"

# Configure terminal to support 256 colors so that application can use more
# colors.
ENV TERM xterm-256color

# Install all other packages.
RUN apt-get update && yes | unminimize && DEBIAN_FRONTEND=noninteractive \
	apt-get install -y --fix-missing\
		ca-certificates curl apt-transport-https build-essential wget git-core \
		unzip python less man-db htop cloc tree zsh\
		openssh-client shellcheck lsof p7zip zip gettext libtool \
		libtool-bin autoconf automake pkg-config cmake clang libclang-dev \
		universal-ctags telnet python3-neovim ripgrep locales sshpass \
		global sudo python3-virtualenv python3-dev gcc-multilib \
		clang-format git-extras tmate inotify-tools rsync vim gosu libncurses-dev libevent-dev\
		bear bison flex vim-nox mono-complete golang nodejs default-jdk npm gdb && \
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

WORKDIR /opt/workspace

#Install tmux 2.4
RUN git clone https://github.com/tmux/tmux.git /tmp/tmux && cd /tmp/tmux && git checkout 2.4 \
	&& sh autogen.sh && ./configure && make && make install

#Install Vundle 
RUN git clone https://github.com/VundleVim/Vundle.vim.git /etc/vim/bundle/Vundle.vim
#Add YouCompleteMe
RUN git clone https://github.com/ycm-core/YouCompleteMe.git /etc/vim/bundle/YouCompleteMe
RUN cd /etc/vim/bundle/YouCompleteMe && git submodule update --init --recursive && ./install.py --all
#Install .vimrc
COPY files/.vimrc /etc/vim/vimrc.local
#Install Vim plugins
RUN vim +PluginInstall +qall

#Install prezto
RUN git clone --recursive https://github.com/sorin-ionescu/prezto.git \
		/etc/zsh/prezto && \
	cd /etc/zsh/prezto; git checkout --detach 8a967fc && \
	echo "source /etc/zsh/prezto/runcoms/zlogin" > /etc/zsh/zlogin && \
	echo "source /etc/zsh/prezto/runcoms/zlogout" > /etc/zsh/zlogout && \
	echo "source /etc/zsh/prezto/runcoms/zshenv" > /etc/zsh/zshenv && \
	echo "source /etc/zsh/prezto/runcoms/zpreztorc" >> /etc/zsh/zshrc && \
	echo "source /etc/zsh/prezto/runcoms/zshrc" >> /etc/zsh/zshrc && \
	echo "source /etc/zsh/prezto/runcoms/zprofile" >> /etc/zsh/zprofile && \
	echo "ZPREZTODIR=/etc/zsh/prezto" >> "/etc/zsh/zshrc" && \
	echo "source \${ZPREZTODIR}/init.zsh" >> "/etc/zsh/zshrc" && \
	sed -ri "s/theme 'sorin'/theme 'skwp'/g" \
		/etc/zsh/prezto/runcoms/zpreztorc && \
	sed -ri '/directory/d' /etc/zsh/prezto/runcoms/zpreztorc && \
	sed -ri "s/'prompt'/'syntax-highlighting' \
		'history-substring-search' 'prompt'/g" /etc/zsh/prezto/runcoms/zpreztorc

#Install fzf
RUN git clone --branch 0.23.1 --depth 1 https://github.com/junegunn/fzf.git \
		/tmp/fzf && \
	/tmp/fzf/install --bin && \
	cp /tmp/fzf/bin/* /usr/local/bin && \
	mkdir -p /usr/share/fzf/ && \
	cp /tmp/fzf/shell/*.zsh /usr/share/fzf/ && \
	rm -rf /tmp/fzf && \
	echo "source /usr/share/fzf/key-bindings.zsh" >> /etc/zsh/zshrc && \
	echo "source /usr/share/fzf/completion.zsh" >> /etc/zsh/zshrc && \
	echo "export FZF_DEFAULT_COMMAND='rg --files --hidden --follow'" \
		>> /etc/zsh/zshrc && \
	echo "export FZF_DEFAULT_OPTS='--height 40% --reverse'" \
		>> /etc/zsh/zshrc


COPY files/entrypoint.sh /usr/local/bin
COPY files/tmux.conf /etc/tmux.conf
ENTRYPOINT ["entrypoint.sh"] 


