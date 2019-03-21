#!/usr/bin/env bash

# Install command-line tools using Homebrew.

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

# Save Homebrew’s installed location.
BREW_PREFIX=$(brew --prefix)

# Install GNU core utilities (those that come with macOS are outdated).
# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
brew install coreutils
ln -s "${BREW_PREFIX}/bin/gsha256sum" "${BREW_PREFIX}/bin/sha256sum"

# Install some other useful utilities like `sponge`.
brew install moreutils
# Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed.
brew install findutils
# Install GNU `sed`, overwriting the built-in `sed`.
brew install gnu-sed --with-default-names

# Install Bash 4. (https://johndjameson.com/blog/updating-your-shell-with-homebrew/)
brew install bash
brew install bash-completion2

# Switch to using brew-installed bash as default shell
if ! fgrep -q "${BREW_PREFIX}/bin/bash" /etc/shells; then
  echo "${BREW_PREFIX}/bin/bash" | sudo tee -a /etc/shells;
  chsh -s "${BREW_PREFIX}/bin/bash";
fi;

# Install `wget` with IRI support.
brew install wget --with-iri

# Install GnuPG to enable PGP-signing commits.
brew install gnupg

# Install more recent versions of some macOS tools.
brew install vim --with-override-system-vi
brew install grep
brew install openssh
brew install screen
brew install php
brew install gmp

# Install font tools.
brew tap bramstein/webfonttools
brew install sfnt2woff
brew install sfnt2woff-zopfli
brew install woff2

# Install some CTF tools; see https://github.com/ctfs/write-ups.
brew install aircrack-ng
brew install bfg
brew install binutils
brew install binwalk
brew install cifer
brew install dex2jar
brew install dns2tcp
brew install fcrackzip
brew install foremost
brew install hashpump
brew install hydra
brew install john
brew install knock
brew install netpbm
brew install nmap
brew install pngcheck
brew install socat
brew install sqlmap
brew install tcpflow
brew install tcpreplay
brew install tcptrace
brew install ucspi-tcp # `tcpserver` etc.
brew install xpdf
brew install xz

# Install other useful binaries.
brew install ack
#brew install exiv2
brew install imagemagick --with-webp
brew install p7zip
brew install pigz
brew install pv
brew install rename
brew install rlwrap
brew install ssh-copy-id
brew install tree
brew install vbindiff
brew install zopfli

#### Developer Tools ####

brew install git
brew install git-lfs


# TODO: java and set javahome, certs, etc
brew tap AdoptOpenJDK/openjdk
brew cask install adoptopenjdk8
echo 'export JAVA_HOME="$(/usr/libexec/java_home)"' >> ~/.bash_profile
source ~/.bashrc
#./install_certs.sh java

brew install maven

# TinyTeX
curl -sL "https://github.com/yihui/tinytex/raw/master/tools/install-unx.sh" | sh
tlmgr update --self --all

# Compliers
# Install, set up aliases, and reload shell to pickup aliases
brew install gcc ccache cmake pkg-config autoconf automake
echo '
# use gcc aliases instead of symlinking
alias gcc="gcc-8"
alias gcov="gcov-8"
alias g++="g++-8"
alias cpp="cpp-8"
alias c++="c++-8"
' >>  ~/.extra
/usr/local/bin/bash -l

# Install R development tools
# https://github.com/adamhsparks/setup_macOS_for_R
sudo installer -pkg /Library/Developer/CommandLineTools/Packages/macOS_SDK_headers_for_macOS_10.14.pkg -target /
brew cask install xquartz
brew install libxml2 libiconv libxslt
brew install openblas --with-openmp
# Tap sethrfore/homebrew-r-srf for R and cairo
brew tap sethrfore/homebrew-r-srf
brew install sethrfore/r-srf/cairo

# Install R
brew install sethrfore/r-srf/r --with-openblas --with-java \
    --with-cairo --with-libtiff --with-pango

# Configure Java for R
R CMD javareconf

mkdir -p $HOME/Library/R/3.x/library

brew install llvm

# Install geospatial libraries
brew tap osgeo/osgeo4mac
brew install geos proj gdal udunits

brew install libressl libssh2
brew install imagemagick --with-fontconfig --with-ghostscript \
    --with-librsvg --with-pango --with-webp
brew install pandoc pandoc-citeproc jq protobuf libgit2

echo '
export PATH="/usr/local/sbin:$PATH"
export PATH="/usr/local/bin:$PATH"
export PATH="/usr/local/opt/gdal2/bin:$PATH"
export PATH="/usr/local/opt/libxml2/bin:$PATH"

export LDFLAGS="-L/usr/local/opt/libxml2/lib"
export CPPFLAGS="-I/usr/local/opt/libxml2/include"

export PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:/usr/local/opt/icu4c/lib/pkgconfig:/opt/X11/lib/pkgconfig:/usr/local/opt/libxml2/lib/pkgconfig"
export GDAL_DRIVER_PATH="/usr/local/lib/gdalplugins"

export R_LIBS_USER="$HOME/Library/R/3.x/library"
' >>  ~/.bash_profile

# Install RStudio
brew cask install rstudio

mkdir -p ~/.R

echo '
LLVM_LOC = /usr/local/opt/llvm
CC=$(LLVM_LOC)/bin/clang -fopenmp
CXX=$(LLVM_LOC)/bin/clang++ -fopenmp
CFLAGS=-g -O3 -Wall -pedantic -std=gnu99 -mtune=native -pipe
CXXFLAGS=-g -O3 -Wall -pedantic -std=c++11 -mtune=native -pipe
LDFLAGS=-L/usr/local/opt/gettext/lib -L$(LLVM_LOC)/lib -Wl,-rpath,$(LLVM_LOC)/lib
CPPFLAGS=-I/usr/local/opt/gettext/include -I$(LLVM_LOC)/include
' >> ~/.R/Makevars
R --vanilla << EOF
install.packages('data.table', repos = 'https://cloud.r-project.org/')
q()
EOF
echo '
CC=/usr/local/opt/llvm/bin/clang
CXX=/usr/local/opt/llvm/bin/clang++
CFLAGS=-g -O3 -Wall -pedantic -std=gnu99 -mtune=native -pipe
CXXFLAGS=-g -O3 -Wall -pedantic -std=c++11 -mtune=native -pipe
LDFLAGS=-L/usr/local/opt/gettext/lib -L/usr/local/opt/llvm/lib -Wl,-rpath,/usr/local/opt/llvm/lib
CPPFLAGS=-I/usr/local/opt/gettext/include -I/usr/local/opt/llvm/include
' > ~/.R/Makevars

# Remove outdated versions from the cellar.
brew cleanup
