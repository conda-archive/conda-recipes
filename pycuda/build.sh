#!/bin/bash

# It is assumed that OS has some stuff already installed:
# $ wget http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm -O /tmp/epel.rpm
# $ rpm -Uvh /tmp/epel.rpm
# $ wget http://developer.download.nvidia.com/compute/cuda/repos/rhel6/x86_64/cuda-repo-rhel6-5.5-0.x86_64.rpm
# $ sudo rpm --install cuda-repo-rhel6-5.5-0.x86_64.rpm
# $ sudo yum clean expire-cache
# $ sudo yum install cuda
# $ echo '/usr/local/lib' > /etc/ld.so.conf.d/usrlocal.conf
# $ echo '/usr/local/cuda/lib' > /etc/ld.so.conf.d/cuda.conf
# $ ldconfig -v
# $ echo 'export PATH="${PATH}:/usr/local/cuda/bin" > /etc/profile.d/cuda.sh
# $ yum install boost boost-devel boost-system boost-python

export CFLAGS="-m64 -pipe -O2 -march=x86-64"
export CXXFLAGS="${CFLAGS}"

touch requirements.txt;

${PYTHON} configure.py;
${PYTHON} setup.py install;

mkdir -vp ${PREFIX}/bin;

POST_LINK="${PREFIX}/bin/.pycuda-post-link.sh"
cp -v ${RECIPE_DIR}/post-link.sh ${POST_LINK};
chmod -v 0755 ${POST_LINK};

