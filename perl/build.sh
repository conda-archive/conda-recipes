#!/bin/bash

# Save Perl-related environment variables if they were previously set, 
# but unset them
OLD_PERL5LIB=$PERL5LIB
unset PERL5LIB
OLD_PERL_LOCAL_LIB_ROOT=$PERL_LOCAL_LIB_ROOT
unset PERL_LOCAL_LIB_ROOT
OLD_PERL_MB_OPT=$PERL_MB_OPT
unset PERL_MB_OPT
OLD_PERL_MM_OPT=$PERL_MM_OPT
unset PERL_MM_OPT

# Build perl
sh Configure -de -Dprefix=$PREFIX -Duserelocatableinc
make
make test
make install

# Install CPAN Minus to make building other packages that rely on this simpler
curl -L http://cpanmin.us | perl - App::cpanminus

# Restore environment variables
export PERL5LIB=$OLD_PERL5LIB
unset OLD_PERL5LIB
export PERL_LOCAL_LIB_ROOT=$OLD_PERL_LOCAL_LIB_ROOT
unset OLD_PERL_LOCAL_LIB_ROOT
export PERL_MB_OPT=$OLD_PERL_MB_OPT
unset OLD_PERL_MB_OPT
export PERL_MM_OPT=$OLD_PERL_MM_OPT
unset OLD_PERL_MM_OPT
