TERMUX_PKG_HOMEPAGE=https://scikit-learn.org
TERMUX_PKG_DESCRIPTION="Machine Learning in Python"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@YOUR_GITHUB_USERNAME"
TERMUX_PKG_VERSION="1.4.0"
TERMUX_PKG_SRCURL=https://files.pythonhosted.org/packages/source/s/scikit-learn/scikit-learn-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d4373c984eba20e393216edd51a3e3eede56cbe93d4247516d205643c3b93121
TERMUX_PKG_DEPENDS="libc++, openblas, python, python-pip"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PYTHON_COMMON_DEPS="Cython, numpy, scipy, joblib, threadpoolctl"
TERMUX_PKG_PYTHON_BUILD_DEPS="meson-python, ninja, pythran"

termux_step_pre_configure() {
	# Set OpenBLAS flags
	export NPY_BLAS_ORDER=openblas
	export NPY_LAPACK_ORDER=openblas
	export SCIPY_USE_PROPACK=1

	# Compiler flags for aarch64
	export CFLAGS="${CFLAGS} -Wno-deprecated-declarations -Wno-unreachable-code"
	export CXXFLAGS="${CXXFLAGS} -Wno-deprecated-declarations -Wno-unreachable-code"
	export LDFLAGS="${LDFLAGS} -lpython${TERMUX_PYTHON_VERSION}"
}

termux_step_make() {
	# Build the wheel
	pip wheel . \
		--no-build-isolation \
		--no-deps \
		--wheel-dir "${TERMUX_PKG_BUILDDIR}" \
		-v
}

termux_step_make_install() {
	# Install the wheel
	local whl="${TERMUX_PKG_BUILDDIR}/scikit_learn-${TERMUX_PKG_VERSION}-"*.whl
	pip install --no-deps --prefix="${TERMUX_PREFIX}" "${whl}"
}
