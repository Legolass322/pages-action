#!/bin/bash
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

set -e
set -o pipefail

VERSION=0.0.0

if [ -z "${JUDGES}" ]; then
    JUDGES=judges
fi

if [ -z "$1" ]; then
    SELF=$(pwd)
else
    SELF=$1
fi

# Convert the factbase to a few human-readable formats
if [ -z "${GITHUB_WORKSPACE}" ]; then
    echo 'Probably you are running this script not from GitHub Actions.'
    echo "Use 'make' instead: it configures all environment variables correctly."
    exit 1
fi
cd "${GITHUB_WORKSPACE}"

declare -a gopts=()
if [ -n "${INPUT_VERBOSE}" ]; then
    gopts+=("--verbose")
    export GLI_DEBUG=true
fi

# Convert the factbase to a few human-readable formats
if [ -z "${INPUT_OUTPUT}" ]; then
    echo "It is mandatory to specify the 'output' argument, which is the name"
    echo "of a directory where YAML, JSON, and other human-readable files"
    echo "are going to be generated by the plugin"
    exit 1
fi
mkdir -p "${INPUT_OUTPUT}"

name=$(basename "${INPUT_FACTBASE}")
name="${name%.*}"

for f in yaml xml json html; do
    "${JUDGES}" "${gopts[@]}" print \
        --format "${f}" \
        --columns "${INPUT_COLUMNS}" \
        --hidden "${INPUT_HIDDEN}" \
        "${INPUT_FACTBASE}" \
        "${INPUT_OUTPUT}/${name}.${f}"
done

declare -a options=()
while IFS= read -r o; do
    v=$(echo "${o}" | xargs)
    if [ "${v}" = "" ]; then continue; fi
    options+=("--option=${v}")
done <<< "${INPUT_OPTIONS}"

"${JUDGES}" "${gopts[@]}" update \
    --no-log \
    --no-summary \
    --max-cycles 1 \
    "${options[@]}" \
    "${SELF}/judges/" "${INPUT_FACTBASE}"
"${JUDGES}" "${gopts[@]}" print \
    --format xml \
    "${INPUT_FACTBASE}" \
    "${INPUT_OUTPUT}/${name}.rich.xml"

# Build a summary HTML.
css=$(cat "${SELF}/target/css/main.css")
js=$(cat "${SELF}/target/js/main.js")
html=${INPUT_OUTPUT}/${name}-index.html
java -jar "${SELF}/target/saxon.jar" \
    "-s:${INPUT_OUTPUT}/${name}.rich.xml" \
    "-xsl:${SELF}/target/xsl/index.xsl" \
    "-o:${html}" \
    "version=${VERSION}" \
    "fbe=$(cd "${SELF}" && bundle info fbe | head -1 | cut -f5 -d' ' | sed s/[\(\)]//g)" \
    "name=${name}" \
    "logo=${INPUT_LOGO}" \
    "css=${css}" \
    "js=${js}"
echo "HTML generated at ${html}"
rm "${INPUT_OUTPUT}/${name}.rich.xml"
