If the most recent version of logging on CRAN was released in 2013, then:
    Download the tar.bz2 file here: https://anaconda.org/edurand/r-logging/files
    Unzip the file using tar into a new folder called logging: tar -xvfj linux-64/r-logging-0.7_103-r3.2.2_0.tar.bz2 logging/
    Modify info/index.json - replace R 3.2.2 version callouts with the current version of R installed on your system.
    Modify tarit.py to name the files and folders correctly to create the new tar.bz2 file.
    Run tarit.py to create the tar.bz2 file for your version of R.
Else:
    Run conda skeleton cran logging
    Move the files in r-logging/r-logging into r-logging.  Remove the folder r-logging/r-logging.
    Modify the source: section of the meta.yaml file to look like
            source:
              path: logging
    Download the most recent release of logging from CRAN. https://cran.r-project.org/web/packages/logging/
    Unzip into r-logging/logging
    Run conda build r-logging from the folder above r-logging.
