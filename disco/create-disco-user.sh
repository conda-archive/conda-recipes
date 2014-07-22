#!/bin/bash

RELSRV=$PREFIX/var/disco

adduser --system --user-group --shell /bin/bash --home ${RELSRV} \
    --no-create-home disco
chown -R disco:disco ${RELSRV}
