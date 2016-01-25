# Create spyder app in 'alias' mode, so it uses the anaconda environment.
 ${PYTHON} create_app.py py2app --alias

MAC_APP_NAME=$(${PYTHON} -c "\
from __future__ import print_function; \
import os; \
from spyderlib.config.base import MAC_APP_NAME; \
print(os.path.splitext(MAC_APP_NAME)[0])")

mv dist/${MAC_APP_NAME}.app ${PREFIX}/bin/

# Script to open spyder.app from the terminal
LAUNCH_SCRIPT=${PREFIX}/bin/spyder-app
cat > ${LAUNCH_SCRIPT} << EOF
#!/bin/bash

# If spyder is already running, call the executable directly,
# which knows how to pass the user's arguments to the 
# already-running instance, and will then exit.
# (If spyder.app is already open, then it doesn't recognize 
# arguments passed via the 'open' command. But this method works.)
if pgrep '^'${MAC_APP_NAME}'$' > /dev/null; then
    ${PREFIX}/bin/${MAC_APP_NAME}.app/Contents/MacOS/${MAC_APP_NAME} "\$@"
else
    # spyder isn't running yet.
    # Use 'open' so it launches as if the user double-clicked it.
    open ${PREFIX}/bin/${MAC_APP_NAME}.app --args "\$@"
fi
EOF

chmod +x ${LAUNCH_SCRIPT}
