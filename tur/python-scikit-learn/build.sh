TERMUX_PKG_HOMEPAGE=https://scikit-learn.org
TERMUX_PKG_DESCRIPTION="Machine learning in Python"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@RexRexRexx"
TERMUX_PKG_VERSION=1.6.1
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=git+https://github.com/scikit-learn/scikit-learn
TERMUX_PKG_DEPENDS="libc++ (>= 29), libopenblas, python, python-numpy"
TERMUX_PKG_BUILD_DEPENDS="python-numpy-static"

# Get numpy version the same way python-scipy does
_NUMPY_VERSION=$(. $TERMUX_SCRIPTDIR/packages/python-numpy/build.sh; echo $TERMUX_PKG_VERSION)

TERMUX_PKG_PYTHON_COMMON_DEPS="wheel, 'Cython>=3.0.4', meson-python, build, joblib, threadpoolctl"
TERMUX_PKG_PYTHON_BUILD_DEPS="'pybind11>=2.10.4', 'numpy==$_NUMPY_VERSION'"

TERMUX_PKG_ON_DEVICE_BUILD_NOT_SUPPORTED=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="latest-release-tag"
TERMUX_PKG_EXCLUDED_ARCHES="i686"  # Optional: exclude problematic architectures

TERMUX_MESON_WHEEL_CROSSFILE="$TERMUX_PKG_TMPDIR/wheel-cross-file.txt"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dblas=openblas
-Dlapack=openblas
--cross-file $TERMUX_MESON_WHEEL_CROSSFILE
"

TERMUX_PKG_RM_AFTER_INSTALL="
bin/
"

source $TERMUX_SCRIPTDIR/common-files/setup_toolchain_gcc.sh

termux_step_pre_configure() {
	# Similar to scipy's fix for libunwind
	local _unwind_dir="$TERMUX_PKG_TMPDIR/_libunwind_libdir"
	local _NDK_ARCH=$TERMUX_ARCH
	test $_NDK_ARCH == 'i686' && _NDK_ARCH='i386'

	mkdir -p $_unwind_dir
	cp $NDK/toolchains/llvm/prebuilt/linux-x86_64/lib/clang/*/lib/linux/$_NDK_ARCH/libunwind.a \
		$_unwind_dir/libunwind.a

	_setup_toolchain_ndk_gcc_15
	LDFLAGS+=" -Wl,--no-as-needed,-lpython${TERMUX_PYTHON_VERSION},--as-needed"
	LDFLAGS="-L$TERMUX_PKG_TMPDIR/_libunwind_libdir -l:libunwind.a ${LDFLAGS}"
}

termux_step_configure() {
	termux_setup_meson

	cp -f $TERMUX_MESON_CROSSFILE $TERMUX_MESON_WHEEL_CROSSFILE
	sed -i 's|^\(\[binaries\]\)$|\1\npython = '\'$(command -v python)\''|g' \
		$TERMUX_MESON_WHEEL_CROSSFILE
	sed -i 's|^\(\[properties\]\)$|\1\nnumpy-include-dir = '\'$PYTHON_SITE_PKG/numpy/_core/include\''|g' \
		$TERMUX_MESON_WHEEL_CROSSFILE

	(unset PYTHONPATH && termux_step_configure_meson)
}

termux_step_make() {
	pushd $TERMUX_PKG_SRCDIR
	PYTHONPATH= python -m build -w -n -x --config-setting builddir=$TERMUX_PKG_BUILDDIR .
	popd
}

termux_step_make_install() {
	local _pyv="${TERMUX_PYTHON_VERSION/./}"
	local _whl="scikit_learn-${TERMUX_PKG_VERSION}-cp${_pyv}-cp${_pyv}-linux_$TERMUX_ARCH.whl"
	pip install --no-deps --prefix=$TERMUX_PREFIX $TERMUX_PKG_SRCDIR/dist/$_whl
}
