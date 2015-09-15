for f in ${PREFIX}/x86_64/lib/*; do
    if [ ! -f $f ]; then
     ln -sv ${PREFIX}/x86_64/lib/$f ${PREFIX}/lib/
    fi
done
