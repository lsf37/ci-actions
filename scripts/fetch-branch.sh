#!/bin/sh
#
# Copyright 2020, Data61, CSIRO (ABN 41 687 119 230)
#
# SPDX-License-Identifier: BSD-2-Clause

# Fetches the SHA in ${GITHUB_SHA} into a repo manifest checkout.
# Does nothing if INPUT_XML is set, because that means we have already done this.

if [ -z "${INPUT_XML}" ]
then

  # Assumes a repo manifest checkout, and current working dir in the repo
  # to fetch the branch/sha for.

  URL="https://github.com/${GITHUB_REPOSITORY}.git"

  # if an explicit SHA is set as INPUT (e.g. for pull request target), prefer that over GITHUB_SHA
  if [ -n "${INPUT_SHA}" ]
  then
    FETCH=${INPUT_SHA}
  else
    FETCH=${GITHUB_SHA}
  fi

  echo "Fetching ${FETCH} from ${URL}"
  git fetch -q --depth 1 ${URL} ${FETCH}
  git checkout -q ${FETCH}
  if [ -n "${BRANCH_NAME}" ]
  then
    git checkout -b "${BRANCH_NAME}"
  fi
fi
