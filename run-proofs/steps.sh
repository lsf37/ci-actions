#!/bin/sh
#
# Copyright 2020, Data61, CSIRO (ABN 41 687 119 230)
#
# SPDX-License-Identifier: BSD-2-Clause

set -e

echo "::group::Setting up"
checkout-manifest.sh

if [ -n "${INPUT_ISA_BRANCH}" ]
then
  cd isabelle
  echo "Fetching ${INPUT_ISA_BRANCH} from remote \"verification\""
  git fetch -q --depth 1 verification ${INPUT_ISA_BRANCH}
  git checkout -q ${INPUT_ISA_BRANCH}
  cd ..
fi

if [ ${GITHUB_REPOSITORY} != ${GITHUB_REPOSITORY%/seL4} ]
then
  cd seL4/
  echo "Testing seL4"
else
  cd l4v/
  echo "Testing l4v"
fi

if [ -z ${GITHUB_BASE_REF} ]
then
  fetch-branch.sh
else
  fetch-pr.sh
fi
cd ..

# GitHub sets its own HOME, but we have .isabelle data pre-installed in the
# Docker image
if [ "$HOME" != "/root" ]
then
  ln -s /isabelle $HOME/.isabelle
fi

echo "Setting up Isabelle components"
isabelle/bin/isabelle components -a
echo "::endgroup::"

export L4V_ARCH=${INPUT_L4V_ARCH}

CACHE_DIR="${GITHUB_WORKSPACE}/cache/${L4V_ARCH}"
mkdir -p "${CACHE_DIR}"

FAIL=0

cd l4v
if [ "${INPUT_SESSION}" = "CRefine" ]
then
  # special treatment for CRefine session to speed up seL4 code change checks

  cd proof
  make CRefine || FAIL=1
  cd ..

  # remove large images that will need to be rebuilt anyway next time:
  rm -f ${CACHE_DIR}/*/CKernel
  rm -f ${CACHE_DIR}/*/CSpec
  rm -f ${CACHE_DIR}/*/CBaseRefine
  rm -f ${CACHE_DIR}/*/CRefine
else
  ./run_tests -v ${INPUT_SESSION} || FAIL=1
fi
cd ..

exit $FAIL
