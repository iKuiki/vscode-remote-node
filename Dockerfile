#-----------------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See LICENSE in the project root for license information.
#-----------------------------------------------------------------------------------------

FROM node:lts

# Configure apt
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
   && apt-get -y install --no-install-recommends apt-utils 2>&1 \
   # Configure apt
   # ENV DEBIAN_FRONTEND=noninteractive
   # Install git, process tools, zsh, locales and then Clean up
   && apt-get -y install git procps zsh less locales \
   # Remove outdated yarn from /opt and install via package
   # so it can be easily updated via apt-get upgrade yarn
   && rm -rf /opt/yarn-* \
   && rm -f /usr/local/bin/yarn \
   && rm -f /usr/local/bin/yarnpkg \
   && apt-get install -y curl apt-transport-https lsb-release \
   && curl -sS https://dl.yarnpkg.com/$(lsb_release -is | tr '[:upper:]' '[:lower:]')/pubkey.gpg | apt-key add - 2>/dev/null \
   && echo "deb https://dl.yarnpkg.com/$(lsb_release -is | tr '[:upper:]' '[:lower:]')/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
   && apt-get update \
   && apt-get -y install --no-install-recommends yarn \
   # Clean up
   && apt-get autoremove -y \
   && apt-get clean -y \
   && rm -rf /var/lib/apt/lists/* \
   # Add zh_CN locale support
   && echo 'zh_CN.UTF-8 UTF-8' >> /etc/locale.gen \
   && locale-gen
ENV DEBIAN_FRONTEND=dialog

# Install Oh-My-Zsh
RUN sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Install eslint
RUN npm install -g eslint

# Install cnpm
RUN npm install -g cnpm --registry=https://registry.npm.taobao.org

# Set yarn registry to taobao registry
RUN yarn config set registry 'https://registry.npm.taobao.org'
