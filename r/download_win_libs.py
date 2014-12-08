import requests

def download_file(url):
    urlparts = requests.packages.urllib3.util.url.parse_url(url)
    local_filename = urlparts.path.split('/')[-1]
    # jpeg won't download otherwise
    headers = {'User-agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/40.0.2214.10 Safari/537.36'}

    print("Downloading %s" % local_filename)
    r = requests.get(url, stream=True, headers=headers, allow_redirects=True)
    r.raise_for_status()
    with open(local_filename, 'wb') as f:
        for chunk in r.iter_content(chunk_size=1024):
            if chunk: # filter out keep-alive new chunks
                f.write(chunk)
                f.flush()
    return local_filename

for url in [
    'https://downloads.sf.net/project/libpng/libpng16/1.6.15/libpng-1.6.15.tar.gz',
    'http://www.ijg.org/files/jpegsrc.v9a.tar.gz',
    'http://download.osgeo.org/libtiff/tiff-4.0.3.tar.gz',
    ]:
    download_file(url)
