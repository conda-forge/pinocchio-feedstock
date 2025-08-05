mkdir build
cd build

set "CC=clang-cl.exe"
set "CXX=clang-cl.exe"

:: Configure
:: Turn OpenMP OFF because of https://github.com/stack-of-tasks/pinocchio/issues/2440
cmake ^
    -G Ninja ^
    -DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
    -DCMAKE_BUILD_TYPE=Release ^
    -DBUILD_PYTHON_INTERFACE=OFF ^
    -DBUILD_WITH_COLLISION_SUPPORT=ON ^
    -DBUILD_WITH_CASADI_SUPPORT=ON ^
    -DBUILD_WITH_AUTODIFF_SUPPORT=OFF ^
    -DBUILD_WITH_CODEGEN_SUPPORT=OFF ^
    -DBUILD_WITH_EXTRA_SUPPORT=ON ^
    -DBUILD_WITH_OPENMP_SUPPORT=OFF ^
    -DBUILD_WITH_SDF_SUPPORT=ON ^
    -DBUILD_TESTING=OFF ^
    %SRC_DIR%
if errorlevel 1 exit 1

:: Build.
ninja -j2
if errorlevel 1 exit 1

:: Install.
ninja install
if errorlevel 1 exit 1

