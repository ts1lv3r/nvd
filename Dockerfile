FROM amd64/ubuntu:22.04

ENV PATH /usr/local/bin:$PATH

# Language Package
RUN apt-get update \
    && apt-get install -y locales \
    && locale-gen ja_JP.UTF-8
ENV LANG ja_JP.UTF-8
ENV LANGUAGE ja_JP:ja
ENV LC_ALL ja_JP.UTF-8

# Ubuntu Pacakge
RUN apt-get update \
    && apt-get install -y zsh         \
                          fzf         \
                          git         \
                          curl        \
                          ripgrep     \
                          python3     \
                          python3-pip

# Environment Variables
ENV USER nvd
ENV HOME /home/$USER
ENV SHELL /usr/bin/zsh

# Apply ZSH
RUN zsh
RUN sed -i.bak "s|$HOME:|$HOME:$SHELL|" /etc/passwd

# Neovim
RUN curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage \
    && chmod u+x nvim.appimage \
    && ./nvim.appimage --appimage-extract \
    && rm ./nvim.appimage \
    && ln -s /squashfs-root/AppRun /usr/bin/nvim

# Neovim Helper
RUN git clone https://github.com/pyenv/pyenv.git ~/.pyenv \
    && apt-get install -y nodejs npm \
    && npm update -g npm \
    && npm install -g tree-sitter \
    && npm install -g tree-sitter-cli

# New User
RUN useradd -m $USER \
    && gpasswd -a $USER sudo \
    && echo "$USER:passwd" | chpasswd \
    && chown -R $USER $HOME
USER $USER
WORKDIR $HOME

# MyDotfiles
RUN git clone https://github.com/ts1lv3r/dotfiles.git \
    && ln -s $HOME/dotfiles/.config $HOME/.config \
    && sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
