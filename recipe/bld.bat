setlocal EnableDelayedExpansion

mkdir build
cd build

set "CC=clang-cl.exe"
set "CXX=clang-cl.exe"
set "CL=/MP"

::Configure
cmake ^
    -G Ninja ^
    -DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
    -DCMAKE_BUILD_TYPE=Release ^
    -DPYTHON_SITELIB=%SP_DIR% ^
    -DPYTHON_EXECUTABLE=%PYTHON% ^
    -DBUILD_PYTHON_INTERFACE=ON ^
    -DGENERATE_PYTHON_STUBS=ON ^
    -DBUILD_WITH_COLLISION_SUPPORT=ON ^
    -DBUILD_WITH_CASADI_SUPPORT=ON ^
    -DBUILD_WITH_AUTODIFF_SUPPORT=OFF ^
    -DBUILD_WITH_CODEGEN_SUPPORT=OFF ^
    -DBUILD_WITH_EXTRA_SUPPORT=ON ^
    -DBUILD_WITH_OPENMP_SUPPORT=ON ^
    -DBUILD_PYTHON_BINDINGS_WITH_BOOST_MPFR_SUPPORT=OFF ^
    -DBUILD_TESTING=OFF ^
    %SRC_DIR%
if errorlevel 1 exit 1

:: Build.
cmake --build . --config Release -j2
if errorlevel 1 exit 1

:: Install.
cmake --build . --config Release --target install
if errorlevel 1 exit 1
