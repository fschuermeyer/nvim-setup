#!/bin/bash
# check brew is installed otherwise install it
if ! command -v brew &>/dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

# Array von Tools
tools=(
  "git"
  "wget"
  "php"
  "composer"
  "curl"
  "htop"
  "gh"
  "tree"
  "displayplacer"
  "speedtest"
  "jordanbaird-ice"
  "rust"
)

# Array von CLI Helfern
cli_helpers=(
  "zoxide"
  "bat"
  "lsd"
  "jq"
)

# Array von Packages
packages=(
  "neovim"
  "lazygit"
  "fzf"
  "ripgrep"
  "golangci-lint"
  "gnu-sed"
  "fd"
  "luarocks"
  "hadolint"
)

# Funktion zur Installation eines Tools
install_tool() {
  local tool=$1
  if ! brew list --formula | grep -q "^${tool}\$"; then
    echo "Installing $tool..."
    brew install "$tool"
  else
    echo "$tool is already installed."
  fi
}

# Installiere Tools
echo "Installing tools..."
for tool in "${tools[@]}"; do
  install_tool "$tool"
done

# Installiere CLI Helpers
echo "Installing CLI helpers..."
for tool in "${cli_helpers[@]}"; do
  install_tool "$tool"
done

# Installiere Packages
echo "Installing packages..."
for tool in "${packages[@]}"; do
  install_tool "$tool"
done

if npm list -g neovim &>/dev/null || yarn global list | grep -q "neovim"; then
  echo "Neovim npm package is already installed."
else
  if command -v yarn &>/dev/null; then
    echo "Yarn is installed, installing neovim with yarn."
    yarn global add neovim
  else
    echo "Yarn is not installed, installing neovim with npm."
    npm install -g neovim
  fi
fi

# install python provider for nvim
if ! command -v pyenv &>/dev/null; then
  echo "Installing pyenv..."
  brew install pyenv
fi

# check that python 3.11.0 is installed
if ! pyenv versions | grep -q "3.11.0"; then
  echo "Installing python 3.11.0..."
  pyenv install 3.11.0
  pyenv global 3.11.0
fi

# setup pip
if ! command -v pip &>/dev/null; then
  echo "Installing pip..."
  curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
  python3 get-pip.py
  rm get-pip.py
fi

# install pynvim for python provider on python 3.11.0
if ! python3 -c "import pynvim" &>/dev/null; then
  echo "pynvim not found. Installing..."
  python3 -m pip install --user --upgrade pynvim
else
  echo "pynvim is already installed."
fi

echo "All installations are complete."
