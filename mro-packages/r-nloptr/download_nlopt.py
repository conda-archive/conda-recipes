import requests

def download_file(url, fn=None):
    urlparts = requests.packages.urllib3.util.url.parse_url(url)
    local_filename = fn or urlparts.path.split('/')[-1]

    print("Downloading %s" % local_filename)
    r = requests.get(url, stream=True, allow_redirects=True)
    r.raise_for_status()
    with open(local_filename, 'wb') as f:
        for chunk in r.iter_content(chunk_size=1024):
            if chunk: # filter out keep-alive new chunks
                f.write(chunk)
                f.flush()
    return local_filename

if __name__ == '__main__':
    download_file('http://ab-initio.mit.edu/nlopt/nlopt-2.4.2.tar.gz')
    download_file('http://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.guess;hb=HEAD',
        fn='config.guess')
    download_file('http://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.sub;hb=HEAD',
        fn='config.sub')
