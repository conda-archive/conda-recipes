import setuptools


setup_params = dict(
    name='opencv',
    description="OpenCV-Python is a library of Python bindings designed to solve computer vision problems.",
    url="http://bitbucket.org/kang/python-keyring-lib",
    keywords="keyring Keychain GnomeKeyring Kwallet password storage",
    author="Kang Zhang",
    author_email="jobo.zh@gmail.com",
    maintainer='Jason R. Coombs',
    maintainer_email='jaraco@jaraco.com',
    license="PSF and MIT",
    classifiers=[
        "Development Status :: 5 - Production/Stable",
        "Intended Audience :: Developers",
        "Programming Language :: Python :: 2.6",
        "Programming Language :: Python :: 2.7",
        "Programming Language :: Python :: 3",
        "License :: OSI Approved :: Python Software Foundation License",
        "License :: OSI Approved :: MIT License",
    ],
    platforms=["Many"],
    packages=setuptools.find_packages(),
    extras_require={'test': test_requirements},
    tests_require=test_requirements,
    setup_requires=[
        'hgtools',
    ] + pytest_runner,
    entry_points={
        'console_scripts': [
            'keyring=keyring.cli:main',
        ],
    },
)


if __name__ == '__main__':
    setuptools.setup(**setup_params)
