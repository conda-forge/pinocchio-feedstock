#! /bin/sh

# It's important to remove build to avoid uninstalling
# libpinocchio file. This create some strange issues with conda-forge.
rm -rf build
mkdir build
cd build

export BUILD_NUMPY_INCLUDE_DIRS=$( $PYTHON -c "import numpy; print (numpy.get_include())")
export TARGET_NUMPY_INCLUDE_DIRS=$SP_DIR/numpy/core/include

echo $BUILD_NUMPY_INCLUDE_DIRS
echo $TARGET_NUMPY_INCLUDE_DIRS

export GENERATE_PYTHON_STUBS=1
if [[ $CONDA_BUILD_CROSS_COMPILATION == 1 ]]; then
  echo "Copying files from $BUILD_NUMPY_INCLUDE_DIRS to $TARGET_NUMPY_INCLUDE_DIRS"
  mkdir -p $TARGET_NUMPY_INCLUDE_DIRS
  cp -r $BUILD_NUMPY_INCLUDE_DIRS/numpy $TARGET_NUMPY_INCLUDE_DIRS
  export GENERATE_PYTHON_STUBS=0
  export Python3_NumPy_INCLUDE_DIR=$TARGET_NUMPY_INCLUDE_DIRS
else
  export Python3_NumPy_INCLUDE_DIR=$BUILD_NUMPY_INCLUDE_DIRS
fi

cmake ${CMAKE_ARGS} .. \
      -GNinja \
      -DCMAKE_BUILD_TYPE=Release \
      -DBUILD_PYTHON_INTERFACE=ON \
      -DBUILD_STANDALONE_PYTHON_INTERFACE=ON \
      -DBUILD_WITH_COLLISION_SUPPORT=ON \
      -DBUILD_WITH_CASADI_SUPPORT=ON \
      -DBUILD_WITH_AUTODIFF_SUPPORT=OFF \
      -DBUILD_WITH_CODEGEN_SUPPORT=OFF \
      -DBUILD_WITH_EXTRA_SUPPORT=ON \
      -DBUILD_WITH_OPENMP_SUPPORT=ON \
      -DBUILD_WITH_SDF_SUPPORT=ON \
      -DBUILD_PYTHON_BINDINGS_WITH_BOOST_MPFR_SUPPORT=OFF \
      -DPython3_NumPy_INCLUDE_DIR=$Python3_NumPy_INCLUDE_DIR \
      -DBUILD_TESTING=OFF \
      -DGENERATE_PYTHON_STUBS=$GENERATE_PYTHON_STUBS \
      -DPYTHON_EXECUTABLE=$PYTHON

ninja -j$CPU_COUNT
ninja install
