# Conda Recipes

Community-maintained repository of conda package build recipes
for 592+ conda packages.

* Package maintainers SHOULD upgrade packages
  when appropriate.

* Conda packages MAY run other scripts at build time
  in `build.bat` (Windows) and `build.sh` (OSX, Linux)

  http://conda.pydata.org/docs/build.html

* Some of these recipes do intersect with
  [Conda packages included with Anaconda](http://docs.continuum.io/anaconda/pkg-docs.html).

* You can [search for Conda packages hosted in free public BinStar Channels](https://binstar.org/search?q=).


## Requirements

* [conda](https://github.com/conda/conda) >= 1.7
  -- https://github.com/conda/conda#installation

* [conda-build](https://github.com/conda/conda-build)
  -- https://github.com/conda/conda-build#installation

## Creating Conda Recipes
See http://conda.pydata.org/docs/build.html for information
on how to make a conda recipe, or just look at the [examples](#examples) here.

    # Generate a conda recipe from PyPi (Python)
    cd conda-recipes/
    conda skeleton pypi arrow
    conda skeleton pypi rdflib-jsonld

    # Generate a conda recipe from CRAN (R)
    cd conda-recipes/r-packages
    conda skeleton cran r-chron
    conda skeleton cran r-dplyr

    # Generate a conda recipe from CPAN (Perl)
    conda skeleton cpan DateTime
    conda skeleton cpan RDF::Helper


### Examples
Conda recipes that build from git:

* [conda/meta.yaml](https://github.com/conda/conda-recipes/blob/master/conda/meta.yaml)
* [cookiecutter/meta.yaml](https://github.com/conda/conda-recipes/blob/master/cookiecutter/meta.yaml)
* [rstudio/meta.yaml](https://github.com/conda/conda-recipes/blob/master/rstudio/meta.yaml)

Conda recipes that build from PyPI, CRAN, CPAN:

* [arrow/meta.yaml](https://github.com/conda/conda-recipes/blob/master/arrow/meta.yaml)
* [r-packages/r-chron/meta.yaml](https://github.com/conda/conda-recipes/blob/master/r-packages/r-chron/meta.yaml)
* [r-packages/r-dplyr/meta.yaml](https://github.com/conda/conda-recipes/blob/master/r-packages/r-dplyr/meta.yaml)
* [perl/meta.yaml](https://github.com/conda/conda-recipes/blob/master/perl/meta.yaml)


## Building Conda Recipes
To build conda packages from a conda recipe:

```bash
git clone ssh://git@github.com/conda/conda-recipes
recipe_name="conda"
conda build "conda-recipes/${recipe_name}"
ls -al ${CONDA_ROOT}/conda-bld/** | grep "${recipe_name}"
```


## License
This project (`conda-recipes`) is in the **Public Domain**.   Note that this statement
does not reflect in any way, shape or form the licenses of the
projects which are being built from these recipes.  For example, even
though a project `foo` might have an MIT, Apache,
[or any other license](http://choosealicense.com/licenses/),
the recipe for project `foo` (within this repository) is Public Domain.

* The [`conda skeleton`](http://conda.pydata.org/docs/commands/build/conda-skeleton.html)
commands copy any declared package license metadata into the `meta.yaml` file.

* Package creators and maintainers SHOULD include license information
in their respective ``meta.yaml`` files. For example, from
[conda-recipes/conda/meta.yaml](https://github.com/conda/conda-recipes/blob/master/conda/meta.yaml)
(Public Domain):

```yaml
    about:
      home: http://conda.pydata.org/
      license: BSD
```
