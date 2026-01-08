#! /bin/sh

mkdir build
cd build

# Cross compiling for linux-ppc64le crash the agent
if [[ "${target_platform}" == linux-ppc64le ]]; then
  CPU_COUNT=1
fi

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

ninja -j$CPU_COUNT
ninja install

if [[ $CONDA_BUILD_CROSS_COMPILATION == 1 ]]; then
  echo $BUILD_PREFIX
  echo $PREFIX
  sed -i.back 's|'"$BUILD_PREFIX"'|'"$PREFIX"'|g' $PREFIX/lib/cmake/pinocchio/pinocchioTargets.cmake
  rm $PREFIX/lib/cmake/pinocchio/pinocchioTargets.cmake.back
fi

