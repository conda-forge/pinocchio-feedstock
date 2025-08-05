#! /bin/sh

mkdir build
cd build

cmake ${CMAKE_ARGS} .. \
      -GNinja \
      -DCMAKE_BUILD_TYPE=Release \
      -DBUILD_PYTHON_INTERFACE=OFF \
      -DBUILD_WITH_COLLISION_SUPPORT=ON \
      -DBUILD_WITH_CASADI_SUPPORT=ON \
      -DBUILD_WITH_AUTODIFF_SUPPORT=OFF \
      -DBUILD_WITH_CODEGEN_SUPPORT=OFF \
      -DBUILD_WITH_EXTRA_SUPPORT=ON \
      -DBUILD_WITH_OPENMP_SUPPORT=ON \
      -DBUILD_WITH_SDF_SUPPORT=ON \
      -DBUILD_TESTING=OFF

ninja -j16
ninja install

if [[ $CONDA_BUILD_CROSS_COMPILATION == 1 ]]; then
  echo $BUILD_PREFIX
  echo $PREFIX
  sed -i.back 's|'"$BUILD_PREFIX"'|'"$PREFIX"'|g' $PREFIX/lib/cmake/pinocchio/pinocchioTargets.cmake
  rm $PREFIX/lib/cmake/pinocchio/pinocchioTargets.cmake.back
fi

