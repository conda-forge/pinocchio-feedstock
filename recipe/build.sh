#!/bin/sh

mkdir build
cd build

cmake ${CMAKE_ARGS} .. \
      -DCMAKE_BUILD_TYPE=Release \
      -DBUILD_WITH_URDF_SUPPORT=ON \
      -DBUILD_WITH_COLLISION_SUPPORT=ON \
      -DBUILD_WITH_OPENMP_SUPPORT=ON \
      -DBUILD_TESTING=OFF \
      -DPYTHON_EXECUTABLE=$PYTHON

make -j${CPU_COUNT}
make install
