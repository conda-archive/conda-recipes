import requests

def download_file(url):
    local_filename = url.split('/')[-1]
    # jpeg won't download otherwise
    headers = {'User-agent': 'Mozilla/5.0'}

    print("Downloading %s" % local_filename)
    r = requests.get(url, stream=True, headers=headers)
    r.raise_for_status()
    with open(local_filename, 'wb') as f:
        for chunk in r.iter_content(chunk_size=1024):
            if chunk: # filter out keep-alive new chunks
                f.write(chunk)
                f.flush()
    return local_filename

for url in [
    'http://superb-dca2.dl.sourceforge.net/project/libpng/libpng16/1.6.15/libpng-1.6.15.tar.gz',
    'http://www.ijg.org/files/jpegsrc.v9a.tar.gz',
    'http://download.osgeo.org/libtiff/tiff-4.0.3.tar.gz',
    ]:
    download_file(url)
