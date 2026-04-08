#!/bin/bash
set -euo pipefail

brew_install="https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"
omz_install="https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh"
p10k_repo="https://github.com/romkatv/powerlevel10k.git"
bastion_user="bastion"
bastion_home="/home/${bastion_user}"

# Create bastion user with passwordless sudo
if ! id -u "${bastion_user}" >/dev/null 2>&1; then
  useradd -m -s /usr/bin/zsh "${bastion_user}"
fi

# Ensure sudo exists (already installed in Dockerfile, but harmless)
if ! command -v sudo >/dev/null 2>&1; then
  apt-get update
  apt-get install -y --no-install-recommends sudo
  rm -rf /var/lib/apt/lists/*
fi

usermod -aG sudo "${bastion_user}"
echo "${bastion_user} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/90-${bastion_user}
chmod 440 /etc/sudoers.d/90-${bastion_user}

# Install Oh My Zsh
su - "${bastion_user}" -c "sh -c \"\$(curl -fsSL ${omz_install})\" '' --unattended"

# Install Powerlevel10k
su - "${bastion_user}" -c "git clone --depth=1 --branch v1.20.0 '${p10k_repo}' '${bastion_home}/.oh-my-zsh/custom/themes/powerlevel10k'"

# Set theme in .zshrc
su - "${bastion_user}" -c "sed -i 's|ZSH_THEME=\".*\"|ZSH_THEME=\"powerlevel10k/powerlevel10k\"|' '${bastion_home}/.zshrc'"

# Install zsh plugins (pinned to latest stable tags as of 20260408)
su - "${bastion_user}" -c "git clone --branch v0.7.1 https://github.com/zsh-users/zsh-autosuggestions ${bastion_home}/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
su - "${bastion_user}" -c "git clone --branch v1.56 https://github.com/zdharma-continuum/fast-syntax-highlighting.git ${bastion_home}/.oh-my-zsh/custom/plugins/fast-syntax-highlighting"
su - "${bastion_user}" -c "git clone --depth 1 --branch 25.03.19 -- https://github.com/marlonrichert/zsh-autocomplete.git ${bastion_home}/.oh-my-zsh/custom/plugins/zsh-autocomplete"
su - "${bastion_user}" -c "git clone --depth 1 --branch v0.71.0 https://github.com/junegunn/fzf.git ${bastion_home}/.fzf && ${bastion_home}/.fzf/install --all --no-bash --no-fish"

# Install brew package manager
su - "${bastion_user}" -c "/bin/bash -c \"\$(curl -fsSL $brew_install)\""

cp -v /tmp/bootstrap/assets/.p10k.zsh "${bastion_home}/.p10k.zsh"
cp -v /tmp/bootstrap/assets/aliases.zsh "${bastion_home}/.oh-my-zsh/custom/aliases.zsh"
cp -v /tmp/bootstrap/assets/exports.zsh "${bastion_home}/.oh-my-zsh/custom/exports.zsh"
cp -v /tmp/bootstrap/assets/functions.zsh "${bastion_home}/.oh-my-zsh/custom/functions.zsh"
cp -v /tmp/bootstrap/assets/.zshrc "${bastion_home}/.zshrc"

mkdir -p  "${bastion_home}/bin"

chown -R "${bastion_user}:${bastion_user}" "${bastion_home}"

# Ensure default shell is zsh
chsh -s /usr/bin/zsh "${bastion_user}"
