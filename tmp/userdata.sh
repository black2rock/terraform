#!/bin/bash

sudo su -

# ansibleインストール
yum install -y ansible git 

# rbenvと関連プラグインのダウンロード
cd /opt
git clone https://github.com/sstephenson/rbenv.git
mkdir -p /opt/rbenv/plugins
cd /opt/rbenv/plugins
git clone https://github.com/sstephenson/ruby-build.git

# .bashrcへのrbenv関連設定追加
grep "rbenv global config" ${HOME}/.bashrc > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo >> ~/.bashrc
  echo "# rbenv global config" >> ~/.bashrc
  echo 'export RBENV_ROOT="/opt/rbenv"' >> ~/.bashrc
  echo 'export PATH="${RBENV_ROOT}/bin:${PATH}"' >> ~/.bashrc
  echo 'eval "$(rbenv init -)"' >> ~/.bashrc
fi

# Ruby関連モジュールのインストール
yum install -y gcc make openssl-devel libffi-devel ruby-devel readline-devel rubygems sqlite-devel bzip2

# Rubyのインストール
/bin/bash -lc "rbenv install 2.3.0"
/bin/bash -lc "rbenv rehash"
/bin/bash -lc "rbenv global 2.3.0"

gem install serverspec

exit 0