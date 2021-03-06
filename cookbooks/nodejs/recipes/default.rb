#
# Author:: Marius Ducea (marius@promethost.com)
# Cookbook Name:: nodejs
# Recipe:: default
#
# Copyright 2010, Promet Solutions
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "build-essential"

case node[:platform]
  when "centos","redhat","fedora"
    package "openssl-devel"
  when "debian","ubuntu"
    package "libssl-dev"
end

bash "install nodejs from source" do
  cwd "/usr/local/src"
  user "root"
  code <<-EOH
    wget http://nodejs.org/dist/node-v#{@node[:nodejs_version]}.tar.gz && \
    tar zxf node-v#{@node[:nodejs_version]}.tar.gz && \
    cd node-v#{@node[:nodejs_version]} && \
    ./configure --prefix=#{@node[:nodejs_dir]} && \
    make && \
    make install
  EOH
  not_if "#{@node[:nodejs_dir]}/bin/node -v 2>&1 | grep 'v#{@node[:nodejs_version]}'"
end
