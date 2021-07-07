<!--
  Copyright 2021, Proofcraft Pty Ltd
  SPDX-License-Identifier: CC-BY-SA-4.0
-->

# Run CAmkES CLI tests

This action expects to be run in the `camkes-tool` repository. It checks out
the repo, installs the `camkes-cli` Python package, and runs basic tests

## Arguments

* `test`: which test to run; one of `{new, existing}`

## Example

Put this into a `.github/workflows/` yaml file, e.g. `cli.yml`:

```yaml
name: CLI

on:
  schedule:
    - '2 1 * * *'

jobs:
  cli:
    name: CAmkES CLI
    runs-on: ubuntu-latest
    strategy:
          matrix:
            test: [new, existing]
    steps:
    - uses: seL4/ci-actions/camkes-cli@master
      with:
        test: ${{ matrix.test }}
```

## Build

Run `make` to build the Docker image for local testing. The image is deployed to
dockerhub automatically on push to the `master` branch when relevant files
change.
