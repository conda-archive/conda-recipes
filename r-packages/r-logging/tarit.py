import tarfile
import os

print 'creating archive'
out = tarfile.open('linux-64_r-logging-0.7_103-r3.3.2_0.tar.bz2', mode='w:bz2')
fl = []
for root, dirs, files in os.walk("logging"):
    for file in files:
         fl.append(os.path.join(root, file))
print fl
os.chdir('logging')
for file in fl:
    try:
        out.add(file[8:])
    except:
        raise
print 'closing'
out.close()

print
print 'Contents:'
os.chdir('..')
t = tarfile.open('linux-64_r-logging-0.7_103-r3.3.2_0.tar.bz2', 'r')
for member_info in t.getmembers():
    print member_info.name
