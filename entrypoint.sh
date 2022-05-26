#!/bin/bash

theme=$1
resume=$2
format=$3
output=$4

if [ -z "$output" ]; then
    cat<<EOF
       Usage: $0 <theme> <resume> <format> <output>
       Notes:
          an npm package jsonresume-theme-<theme> must exist
          output must be either html or pdf
EOF
    exit 1
fi

theme_package=jsonresume-theme-${theme}
npm_bin_dir=$(npm bin)

#pushd $(dirname $resume)
test -f package.json || npm init -f
npm install "${theme_package}"

"${npm_bin_dir}"/resume export --resume "${resume}" --theme ./node_modules/"${theme_package}" --format "${format}" "${output}"
