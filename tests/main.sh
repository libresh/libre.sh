#!/bin/bash -eux

# testing static
/data/indiehosters/tests/image.sh static

# clean static tests
/data/indiehosters/tests/clean-image.sh static

# testing static-git
/data/indiehosters/tests/image.sh static-git

# clean static tests
/data/indiehosters/tests/clean-image.sh static-git

# testing wordpress
/data/indiehosters/tests/image.sh wordpress

# clean static tests
/data/indiehosters/tests/clean-image.sh wordpress
