import os
import shutil
import yaml
from invoke import task, run

# CONDA_BLD_DIR="/home/ivo/miniconda3/conda-bld"
CONDA_BLD_DIR = r"C:\Users\Admin\Miniconda2\conda-bld"
RECIPE_DIR = r"C:\conda-recipes"
BUILD_PLATFORM = "win-64"
ANACONDA_USER="clinicalgraphics"   

def _check_anaconda_release_exists(user, package, version_number, build_number):
    """usage: if not _check_anaconda_release_exists(user, pkg, version, build_number):"""
    import binstar_client
    binstar = binstar_client.utils.get_binstar()
    try:
        release_info = binstar.release(user, package, version_number)
        if release_info:
            for build_info in release_info["distributions"]:
                if build_info["attrs"]["build_number"] == build_number:
                    return True
    except binstar_client.errors.NotFound:
        return False
    return False    
    
    

@task(help={"pkg":"Name of the package"})
def init(pkg):     
    # Check if we don't already have it in the recipe dir, if so delete it
    if pkg in os.listdir(RECIPE_DIR):
        pkg_path = os.path.join(RECIPE_DIR, pkg)
        shutil.rmtree(pkg_path)        
    try:
        run("""conda skeleton pypi {}""".format(pkg))
    except:    
        pass

@task(help={"pkg":"Name of the package", 
            "version":"Version of the package",
            "python_version":"Version of python used",
            "build_number":"Number of the build"})
def upload(pkg, version, python_version, build_number):     
    platforms=["win-32", "win-64", "linux-32", "linux-64", "osx-64"]
    for platform in platforms:    
        for package in os.listdir(os.path.join(CONDA_BLD_DIR, platform)):
            py_build = "py{}_{}".format(python_version, build_number)
            if pkg in package and version in package and py_build in package:
                pkg_path = os.path.join(CONDA_BLD_DIR, platform, package)
                try:
                    run("""anaconda upload {} -u {}""".format(pkg_path, ANACONDA_USER))
                except:
                    pass

@task(help={"pkg":"Name of the package", 
            "version":"Version of the package",
            "python_version":"Version of python used",
            "build_number":"Number of the build"})
def convert(pkg, version, python_version, build_number):     
    platforms=["win-32", "win-64", "linux-32", "linux-64", "osx-64"]
    for platform in platforms:    
        for package in os.listdir(os.path.join(CONDA_BLD_DIR, platform)):
            py_build = "py{}_{}".format(python_version, build_number)
            if pkg in package and version in package and py_build in package:
                pkg_path = os.path.join(CONDA_BLD_DIR, platform, package)
                try:
                    run("""conda convert {} -p {}""".format(pkg_path, platform))
                except:
                    pass


@task(help={"pkg":"Name of the package", 
            "pure":"Whether the package is pure Python or not"})
def build(pkg, pure=True): 
    # configure these lists for the pythons and platforms you want to support
    pythons=["27", "34", "35"]    
    with open(os.path.join(pkg, "meta.yaml"), "r") as infile:        
        recipe = yaml.load(infile)
        version = recipe["package"]["version"]
        # build is optional, so is number
        build_number = recipe.get("build", {}).get("number", 0)       
    
    # We build the package for each version
    for python_version in pythons:
        run("conda build {} --python {} --no-anaconda-upload".format(pkg, python_version))
        # And if its pure python, we convert it to all other platforms
        if pure: 
            convert(pkg, version, python_version, build_number)

        # Lastly we call our own upload task
        upload(pkg, version, python_version, build_number)
