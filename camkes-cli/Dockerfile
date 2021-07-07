# Copyright 2021, Proofcraft Pty Ltd
#
# SPDX-License-Identifier: BSD-2-Clause

# The context for this Dockerfile is the repo root

FROM trustworthysystems/camkes

COPY scripts/*.sh camkes-cli/steps.sh /usr/bin/
RUN pip3 install wheel

RUN mkdir /workspace
WORKDIR /workspace

ENTRYPOINT steps.sh
