import platform
import os
import sys
import subprocess
from pprint import pprint

print('Python version:', platform.python_version())
print('max unicode:', sys.maxunicode)
print('architecture:', platform.architecture())
print('sys.version:', sys.version)
print('platform.machine():', platform.machine())

import _bisect
import _codecs_cn
import _codecs_hk
import _codecs_iso2022
import _codecs_jp
import _codecs_kr
import _codecs_tw
import _collections
import _csv
import _ctypes
import _ctypes_test
import _elementtree
import _functools
import _hashlib
import _heapq
import _hotshot
import _io
import _json
import _locale
import _lsprof
import _multibytecodec
import _multiprocessing
import _random
import _socket
import _sqlite3
import _ssl
import _struct
import _testcapi
import array
import audioop
import binascii
import bz2
import cPickle
import cStringIO
import cmath
import datetime
import future_builtins
import itertools
import math
import mmap
import operator
import parser
import pyexpat
#import resource
import select
import strop
#import syslog
import time
import unicodedata
import zlib
import gzip
from os import urandom

if sys.platform != 'win32':
    import crypt
    import fcntl
    import grp
    import nis

import ssl
print('OPENSSL_VERSION:', ssl.OPENSSL_VERSION)
