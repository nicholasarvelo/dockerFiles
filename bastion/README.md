# Bastion

An Ubuntu 22.04-based Docker image for interactive shell access to private infrastructure. Comes pre-configured with Zsh, Oh My Zsh, Powerlevel10k, and common network debugging tools.

## What's Included

### System Tools

| Tool | Purpose |
|------|---------|
| `bind9-utils` | DNS lookups (`dig`, `nslookup`) |
| `curl` | HTTP requests |
| `git` | Version control |
| `iproute2` | Network config (`ip`, `ss`) |
| `neovim` | Text editor |
| `netcat` | TCP/UDP connections |
| `net-tools` | Legacy networking (`ifconfig`, `netstat`) |
| `nmap` | Port scanning |
| `telnet` | Connection testing |
| `tmux` | Terminal multiplexer |

### Shell Environment

- **Zsh** with [Oh My Zsh](https://ohmyz.sh/)
- **[Powerlevel10k](https://github.com/romkatv/powerlevel10k)** theme (`v1.20.0`)
- **[fzf](https://github.com/junegunn/fzf)** fuzzy finder (`v0.71.0`)
- **[Homebrew](https://brew.sh/)** for installing additional packages at runtime

### Zsh Plugins

| Plugin | Version | Purpose |
|--------|---------|---------|
| [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) | `v0.7.1` | Fish-like command suggestions |
| [fast-syntax-highlighting](https://github.com/zdharma-continuum/fast-syntax-highlighting) | `v1.56` | Real-time syntax highlighting |
| [zsh-autocomplete](https://github.com/marlonrichert/zsh-autocomplete) | `25.03.19` | Type-ahead completion |

Also enabled: `aws`, `colorize`, `command-not-found`, `git` (built-in Oh My Zsh plugins).

## Build

```bash
docker build -t bastion .
```

## Run

```bash
docker run -it --rm bastion
```

## Push to ECR

```bash
AWS_ACCOUNT_ID=123456789012
AWS_REGION=us-east-1
PLATFORM=linux/amd64,linux/arm64
IMAGE_TAG=$(date +%y.%j.%S)
ECR_REPO=${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/bastion

aws ecr get-login-password --region ${AWS_REGION} \
  | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com

docker buildx build --platform ${PLATFORM} \
  --tag "${ECR_REPO}:latest" \
  --tag "${ECR_REPO}:${IMAGE_TAG}" \
  --push .
```

## Customization

Shell customizations live in `shell/` and are copied into the container at build time:

| File | Destination | Purpose |
|------|-------------|---------|
| `shell/zshrc` | `~/.zshrc` | Main Zsh config |
| `shell/p10k.zsh` | `~/.p10k.zsh` | Powerlevel10k prompt config |
| `shell/exports.zsh` | `~/.oh-my-zsh/custom/exports.zsh` | Environment variables |
| `shell/functions.zsh` | `~/.oh-my-zsh/custom/functions.zsh` | Shell functions |

Files in `~/.oh-my-zsh/custom/` are automatically sourced by Oh My Zsh on shell startup.

The container runs as the `bastion` user with passwordless `sudo` access.
