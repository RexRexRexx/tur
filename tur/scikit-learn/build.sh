TERMUX_PKG_HOMEPAGE=https://scikit-learn.org
TERMUX_PKG_DESCRIPTION="Machine Learning in Python"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@RexRexRexx"
TERMUX_PKG_VERSION="1.3.2"
TERMUX_PKG_SRCURL=https://files.pythonhosted.org/packages/source/s/scikit-learn/scikit-learn-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=a2f54c76accc15a34bfb9066e6c7a56c1e7235dda5762b990792330b52ccfb05
TERMUX_PKG_DEPENDS="python"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PYTHON_COMMON_DEPS="wheel, Cython==0.29.36, numpy, scipy, joblib, threadpoolctl"

termux_step_pre_configure() {
	export SKLEARN_NO_OPENMP=1
	LDFLAGS+=" -lpython${TERMUX_PYTHON_VERSION}"
}

termux_step_make() {
	pip wheel . --no-build-isolation --no-deps --wheel-dir "${TERMUX_PKG_BUILDDIR}" -v
}

termux_step_make_install() {
	pip install --no-deps --prefix="${TERMUX_PREFIX}" "${TERMUX_PKG_BUILDDIR}"/scikit_learn-*.whl
}
