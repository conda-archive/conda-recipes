#!/bin/bash

XDMCP_CFLAGS=-fwe-do-not-want-xdmcp XDMCP_LIBS="-L/tmp/does-not-exist -ldoes-not-exist" \
  ./configure --prefix="$PREFIX"
make
make install
