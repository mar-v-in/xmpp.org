# Dockerfile to build a docker image from XSF/xmpp.org Master
#
# Dave Cridland <dave.cridland@surevine.com>
# Copyright 2017 Surevine Ltd

# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

FROM debian:bullseye
MAINTAINER Dave Cridland <dave.cridland@surevine.com>

# Set environment variables
ENV DEBIAN_FRONTEND noninteractive

# Update system
RUN apt-get update && apt-get dist-upgrade -y && apt-get autoremove -y && apt-get clean

# Install dependencies.
RUN apt-get install -y hugo lua5.2 lua-expat python3 python3-pip

# Build and copy in place.
WORKDIR /var/tmp/src/xmpp.org
COPY . /var/tmp/src/xmpp.org
RUN pip3 install -r /var/tmp/src/xmpp.org/tools/requirements.txt
RUN cd /var/tmp/src/xmpp.org && make publish

FROM nginx
COPY deploy/xsf.conf /etc/nginx/conf.d/default.conf
COPY --from=0 /var/tmp/src/xmpp.org/public/ /var/www/html/
