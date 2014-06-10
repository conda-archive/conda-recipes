conda-vpython-recipes
=====================

Use these recipes to build [vpython](http://vpython.org) for the
[anaconda python distribution](https://store.continuum.io/cshop/anaconda/).

In more detail, assuming you have anaconda installed and you have downloaded this repo:

```bash
conda update conda  # a good habit, always
conda install conda-build  # unless you already have it, of course
cd conda-vpython-recipes  # or whathever you called it 
conda build boost-vpython # boost needs to be built before vpython
conda build fonttools polygon2 ttfquery vpython
```
