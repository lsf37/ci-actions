#!/bin/sh
#
# Copyright 2021, Proofcraft Pty Ltd
#
# SPDX-License-Identifier: BSD-2-Clause

set -e

echo "::group::Setting up"
checkout.sh

git config --global user.name "repo"
git config --global user.email "repo@no.mail"
git config --global color.ui false

pip3 install --user --upgrade camkes-cli
echo "::endgroup::"

if [ "${INPUT_TEST}" == "new "]
then
  camkes-cli new hello --template hello_world

  expect -c "\
      set timeout 180\
      cd hello\
      spawn $HOME/.local/bin/camkes-cli run x86\
      expect {\
          \"Hello, World!\" { close }\
          default {exit 1}\
      }"
elif [ "${INPUT_TEST}" == "existing" ]
then
  camkes-cli init

  expect -c "\
      set timeout 180\
      spawn $HOME/.local/bin/camkes-cli run x86\
      expect {\
          \"Hello, World!\" { close }\
          default {exit 1}\
      }"\
else
  echo "No tests run"
fi
