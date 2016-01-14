# https://gist.github.com/fish2000/1628330
from pyflann import *
from numpy import *
from numpy.random import *
dataset = rand(10000, 128)
testset = rand(1000, 128)
flann = FLANN()
result,dists = flann.nn(dataset,testset,5,algorithm="kmeans",
branching=32, iterations=7, checks=16)
