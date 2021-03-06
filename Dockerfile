#-----------------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See LICENSE in the project root for license information.
#-----------------------------------------------------------------------------------------

FROM node:lts

# Configure apt
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get -y install --no-install-recommends apt-utils 2>&1 \
    #
    # Verify git and needed tools are installed
    && apt-get install -y git procps zsh less locales git-flow vim \
    #
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
    #
    # Install eslint globally
    && npm install -g eslint \
    #
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

# Install nrm yrs
RUN npm install -g nrm yrs

# Set npm & yarn registry to cnpm
RUN nrm use cnpm && yrs use cnpm

# Set time zone
ENV TZ=Asia/Shanghai

# Set the default shell to zsh rather than sh
ENV SHELL /bin/zsh
