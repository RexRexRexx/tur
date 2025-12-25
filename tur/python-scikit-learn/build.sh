TERMUX_PKG_HOMEPAGE=https://scikit-learn.org/
TERMUX_PKG_DESCRIPTION="Machine learning in Python"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@RexRexRexx"
TERMUX_PKG_VERSION=1.6.1
TERMUX_PKG_SRCURL=https://github.com/scikit-learn/scikit-learn/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=...
TERMUX_PKG_DEPENDS="python, python-numpy, python-scipy, python-joblib, python-threadpoolctl"
TERMUX_PKG_BUILD_DEPENDS="python-cython, python-meson-python"
TERMUX_PKG_PYTHON_COMMON_DEPS="wheel"

RexRexRexx_step_pre_configure() {
	# CRITICAL: Skip meson sanity checks for cross-compilation
	export MESONPY_SKIP_SANITY_CHECK=1
	export SKLEARN_BUILD_PARALLEL=0

	# Create cross-compilation config for meson
	cat > ${TERMUX_PKG_TMPDIR}/meson-cross.ini << EOF
[properties]
skip_sanity_check = true
needs_exe_wrapper = true

[host_machine]
system = 'linux'
cpu_family = 'aarch64'
cpu = 'aarch64'
endian = 'little'
EOF

	export MESONPY_CROSS_ARGS="--cross-file ${TERMUX_PKG_TMPDIR}/meson-cross.ini"

	# Use specific compiler flags for Android
	export LDFLAGS+=" -lm -llog"
	export CFLAGS+=" -fPIC"
	export CXXFLAGS+=" -fPIC"
}

RexRexRexx_step_make() {
	# Build the package
	pip install . --no-deps --no-build-isolation
}

RexRexRexx_step_make_install() {
	# Install to Termux prefix
	pip install . --prefix=$TERMUX_PREFIX --no-deps --no-build-isolation
}
