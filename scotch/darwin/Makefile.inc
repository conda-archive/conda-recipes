prefix = $PREFIX

EXE		=
LIB		= .a
OBJ		= .o

MAKE		= make
AR		= ar
ARFLAGS		= -ruv
CAT		= cat
CCS		= gcc
CCP		= mpicc
CCD		= gcc
CFLAGS		= -O3 -fPIC -DCOMMON_PTHREAD_BARRIER -DCOMMON_PTHREAD -DSCOTCH_CHECK_AUTO -DCOMMON_RANDOM_FIXED_SEED -DCOMMON_TIMING_OLD -DSCOTCH_RENAME -DCOMMON_FILE_COMPRESS_BZ2 -DCOMMON_FILE_COMPRESS_GZ
CLIBFLAGS	=
LDFLAGS		= -lz -lm -pthread -lbz2
CP		= cp
LEX		= flex -Pscotchyy -olex.yy.c
LN		= ln
MKDIR		= mkdir
MV		= mv
RANLIB		= ranlib
YACC		= bison -pscotchyy -y -b y
