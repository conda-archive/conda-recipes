#!/bin/bash
sh Configure -de -Dprefix=$PREFIX
make
make test
make install