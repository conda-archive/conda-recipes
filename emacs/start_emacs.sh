#!/bin/bash



export LISPBOX_HOME=~/anaconda/envs/$CONDA_DEFAULT_ENV


export EMACSDATA=${LISPBOX_HOME}/share/emacs/24.3/etc/

export EMACSLOADPATH=\
${LISPBOX_HOME}/share/emacs/24.3/site-lisp:\
${LISPBOX_HOME}/share/emacs/site-lisp:\
${LISPBOX_HOME}/share/emacs/24.3/leim:\
${LISPBOX_HOME}/share/emacs/24.3/lisp:\
${LISPBOX_HOME}/share/emacs/24.3/lisp/toolbar:\
${LISPBOX_HOME}/share/emacs/24.3/lisp/textmodes:\
${LISPBOX_HOME}/share/emacs/24.3/lisp/progmodes:\
${LISPBOX_HOME}/share/emacs/24.3/lisp/play:\
${LISPBOX_HOME}/share/emacs/24.3/lisp/obsolete:\
${LISPBOX_HOME}/share/emacs/24.3/lisp/net:\
${LISPBOX_HOME}/share/emacs/24.3/lisp/mail:\
${LISPBOX_HOME}/share/emacs/24.3/lisp/language:\
${LISPBOX_HOME}/share/emacs/24.3/lisp/international:\
${LISPBOX_HOME}/share/emacs/24.3/lisp/gnus:\
${LISPBOX_HOME}/share/emacs/24.3/lisp/eshell:\
${LISPBOX_HOME}/share/emacs/24.3/lisp/emulation:\
${LISPBOX_HOME}/share/emacs/24.3/lisp/emacs-lisp:\
${LISPBOX_HOME}/share/emacs/24.3/lisp/calendar

emacs
