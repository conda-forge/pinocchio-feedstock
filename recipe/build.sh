#!/bin/sh

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
fi

# cppadcodegen package doesn't exists on linux_aarch64 and linux_ppc64le architecture
export BUILD_WITH_CODEGEN_SUPPORT=1
if [[ $HOST =~ linux ]]; then
  if [[ $HOST =~ aarch64 || $HOST =~ ppc64le ]]; then
    export BUILD_WITH_CODEGEN_SUPPORT=0
  fi
fi

cmake ${CMAKE_ARGS} .. \
      -DCMAKE_BUILD_TYPE=Release \
      -DBUILD_WITH_COLLISION_SUPPORT=ON \
      -DBUILD_WITH_CASADI_SUPPORT=ON \
      -DBUILD_WITH_AUTODIFF_SUPPORT=ON \
      -DBUILD_WITH_CODEGEN_SUPPORT=ON \
      -DBUILD_WITH_EXTRA_SUPPORT=ON \
      -DBUILD_WITH_OPENMP_SUPPORT=ON \
      -DBUILD_PYTHON_BINDINGS_WITH_BOOST_MPFR_SUPPORT=ON \
      -DPython3_NumPy_INCLUDE_DIR=$TARGET_NUMPY_INCLUDE_DIRS \
      -DBUILD_TESTING=OFF \
      -DGENERATE_PYTHON_STUBS=$GENERATE_PYTHON_STUBS \
      -DPYTHON_EXECUTABLE=$PYTHON

make -j${CPU_COUNT}
make install

if [[ $CONDA_BUILD_CROSS_COMPILATION == 1 ]]; then
  echo $BUILD_PREFIX
  echo $PREFIX
  sed -i.back 's|'"$BUILD_PREFIX"'|'"$PREFIX"'|g' $PREFIX/lib/cmake/pinocchio/pinocchioTargets.cmake
  rm $PREFIX/lib/cmake/pinocchio/pinocchioTargets.cmake.back
fi
