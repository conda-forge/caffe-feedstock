## Refer to http://caffe.berkeleyvision.org/installation.html
# Contributions simplifying and improving our build system are welcome!

# cuDNN acceleration switch (uncomment to build with cuDNN).
# USE_CUDNN := 1

# CPU-only switch (uncomment to build without GPU support).
CPU_ONLY := 1

# uncomment to disable IO dependencies and corresponding data layers
# USE_OPENCV := 0
# USE_LEVELDB := 0
# USE_LMDB := 0
# This code is taken from https://github.com/sh1r0/caffe-android-lib
# USE_HDF5 := 0

# uncomment to allow MDB_NOLOCK when reading LMDB files (only if necessary)
#	You should not set this flag if you will be reading LMDBs with any
#	possibility of simultaneous read and write
# ALLOW_LMDB_NOLOCK := 1

# Uncomment if you're using OpenCV 3
OPENCV_VERSION := 4

# To customize your choice of compiler, uncomment and set the following.
# N.B. the default for Linux is g++ and the default for OSX is clang++
CUSTOM_CXX ?= $(GXX)

# CUDA directory contains bin/ and lib/ directories that we need.
# CUDA_DIR := /usr/local/cuda
# On Ubuntu 14.04, if cuda tools are installed via
# "sudo apt-get install nvidia-cuda-toolkit" then use this instead:
# CUDA_DIR := /usr

# CUDA architecture setting: going with all of them.
# For CUDA < 6.0, comment the *_50 through *_61 lines for compatibility.
# For CUDA < 8.0, comment the *_60 and *_61 lines for compatibility.
# For CUDA >= 9.0, comment the *_20 and *_21 lines for compatibility.
# CUDA_ARCH := -gencode arch=compute_20,code=sm_20 \
# 		-gencode arch=compute_20,code=sm_21 \
# 		-gencode arch=compute_30,code=sm_30 \
# 		-gencode arch=compute_35,code=sm_35 \
# 		-gencode arch=compute_50,code=sm_50 \
# 		-gencode arch=compute_52,code=sm_52 \
# 		-gencode arch=compute_60,code=sm_60 \
# 		-gencode arch=compute_61,code=sm_61 \
# 		-gencode arch=compute_61,code=compute_61

# BLAS choice:
# atlas for ATLAS (default)
# mkl for MKL
# open for OpenBlas
BLAS ?= open


# Homebrew puts openblas in a directory that is not on the standard search path
# BLAS_INCLUDE := $(shell brew --prefix openblas)/include
# BLAS_LIB := $(shell brew --prefix openblas)/lib

# NOTE: this is required only if you will compile the python interface.
# We need to be able to find Python.h and numpy/arrayobject.h.
# PYTHON_INCLUDE ?= /usr/include/python2.7 \
#		/usr/lib/python2.7/dist-packages/numpy/core/include
# Anaconda Python distribution is quite popular. Include path:
# Verify anaconda location, sometimes it's in root.
ANACONDA_HOME ?= $(PREFIX)
PYTHON_INCLUDE_LIB := $(shell python -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())")
NUMPY_INCLUDE_PATH := $(dir $(shell python -c 'import numpy.core; print(numpy.core.__file__)'))include
PYTHON_INCLUDE := $(ANACONDA_HOME)/include \
		  $(PYTHON_INCLUDE_LIB) \
		  $(NUMPY_INCLUDE_PATH)

# Custom (MKL/ATLAS/OpenBLAS) include and lib directories.
# Leave commented to accept the defaults for your choice of BLAS
# (which should work)!
BLAS_INCLUDE := $(ANACONDA_HOME)/include
BLAS_LIB := $(ANACONDA_HOME)/lib

# Uncomment to use Python 3 (default is Python 2)
PYTHON_FOLDER := $(basename $(PYTHON_INCLUDE_LIB))
PYTHON_LIBRARIES := boost_python $(PYTHON_FOLDER)

# PYTHON_LIBRARIES := boost_python3 python3.5m

# We need to be able to find libpythonX.X.so or .dylib.
PYTHON_LIB := $(ANACONDA_HOME)/lib

# Homebrew installs numpy in a non standard path (keg only)
# PYTHON_INCLUDE += $(dir $(shell python -c 'import numpy.core; print(numpy.core.__file__)'))/include
# PYTHON_LIB += $(shell brew --prefix numpy)/lib

# Uncomment to support layers written in Python (will link against Python libs)
WITH_PYTHON_LAYER := 1

# Whatever else you find you need goes here.
INCLUDE_DIRS := $(PYTHON_INCLUDE) \
		$(ANACONDA_HOME)/include/opencv4 \
		$(ANACONDA_HOME)/include/opencv4/opencv2
LIBRARY_DIRS := $(PYTHON_LIB)

# NCCL acceleration switch (uncomment to build with NCCL)
# https://github.com/NVIDIA/nccl (last tested version: v1.2.3-1+cuda8.0)
# USE_NCCL := 1

# Uncomment to use `pkg-config` to specify OpenCV library paths.
# (Usually not necessary -- OpenCV libraries are normally installed in one of the above $LIBRARY_DIRS.)
# USE_PKG_CONFIG := 1

# N.B. both build and distribute dirs are cleared on `make clean`
BUILD_DIR := build
DISTRIBUTE_DIR = distribute

# Uncomment for debugging. Does not work on OSX due to https://github.com/BVLC/caffe/issues/171
# DEBUG := 1

# The ID of the GPU that 'make runtest' will use to run unit tests.
TEST_GPUID := 0

# enable pretty build (comment to see full commands)
# Q ?= @
