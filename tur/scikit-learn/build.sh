TERMUX_PKG_HOMEPAGE=https://scikit-learn.org
TERMUX_PKG_DESCRIPTION="Machine Learning in Python"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@RexRexRexx"
TERMUX_PKG_VERSION="1.2.2"
TERMUX_PKG_SRCURL=https://files.pythonhosted.org/packages/source/s/scikit-learn/scikit-learn-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=8429aea30ec24e7a8c7ed8a3fa6213adf3814a6efbea09e16e0a0c71e1a1a3d7
TERMUX_PKG_DEPENDS="python"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PYTHON_COMMON_DEPS="wheel, setuptools, Cython==0.29.36, scipy, joblib, threadpoolctl"

termux_step_post_get_source() {
	# Fix int_t compatibility issue
	# Replace cnp.int_t with cnp.intp_t throughout the codebase
	find sklearn -name "*.pyx" -o -name "*.pxd" | xargs sed -i 's/cnp\.int_t/cnp.intp_t/g'
	find sklearn -name "*.pyx" -o -name "*.pxd" | xargs sed -i 's/\bint_t\b/intp_t/g'
}

termux_step_pre_configure() {
	export SKLEARN_NO_OPENMP=1
	export SKLEARN_BUILD_PARALLEL=1

	export CFLAGS="${CFLAGS} -Wno-unreachable-code"
	export CXXFLAGS="${CXXFLAGS} -Wno-unreachable-code"

	LDFLAGS+=" -lpython${TERMUX_PYTHON_VERSION}"
}

termux_step_make() {
	python setup.py bdist_wheel -d "${TERMUX_PKG_BUILDDIR}"
}

termux_step_make_install() {
	pip install --no-deps --prefix="${TERMUX_PREFIX}" "${TERMUX_PKG_BUILDDIR}"/scikit_learn-*.whl
}
