# Test multibuild utilities
export PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'
export MB_PYTHON_VERSION=$PYTHON_VERSION
set -x
source common_utils.sh
source tests/utils.sh

source tests/test_common_utils.sh
source tests/test_fill_submodule.sh
if [ -n "$IS_OSX" ]; then
    source osx_utils.sh
    get_macpython_environment $PYTHON_VERSION $VENV
    source tests/test_python_install.sh
    source tests/test_fill_pyver.sh
    source tests/test_fill_pypy_ver.sh
    source tests/test_osx_utils.sh
else
    source manylinux_utils.sh
    source tests/test_manylinux_utils.sh
fi
if [ -n "$TEST_BUILDS" ]; then
    if [ -n "$IS_OSX" ]; then
        source tests/test_library_builders.sh
        source travis_osx_steps.sh
        pre_build
    elif [ ! -x "$(command -v docker)" ]; then
        echo "Skipping build tests; no docker available"
    else
        source travis_linux_steps.sh
        build_multilinux $PLAT "source tests/test_library_builders.sh"
        build_multilinux $PLAT "pre_build"
    fi
fi

# Exit 1 if any test errors
barf
# Don't need Travis' machinery trace
set +x
