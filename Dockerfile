# MIT License
#
# Copyright (c) 2024 Zerocracy
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

FROM ruby:3.3

LABEL "repository"="https://github.com/zerocracy/pages-action"
LABEL "maintainer"="Yegor Bugayenko"

# hadolint disable=DL3008
RUN apt-get update -y --fix-missing \
  && apt-get -y install --no-install-recommends \
    openjdk-17-jdk \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN gem install sass:1.76.0 judges:0.0.29 \
  && wget --no-verbose -O /usr/local/Saxon.jar \
    https://repo.maven.apache.org/maven2/net/sf/saxon/Saxon-HE/9.8.0-5/Saxon-HE-9.8.0-5.jar

WORKDIR /home
COPY entry.sh /home
COPY xsl /home/xsl

ENTRYPOINT ["/home/entry.sh"]
