TERMUX_PKG_HOMEPAGE=https://scikit-learn.org
TERMUX_PKG_DESCRIPTION="Machine Learning in Python"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@RexRexRexx"
TERMUX_PKG_VERSION="1.3.2"
TERMUX_PKG_SKIP_SRC_EXTRACT=true
TERMUX_PKG_DEPENDS="python, python-pip, openblas"
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
	pip install \
	--prefix="${TERMUX_PREFIX}" \
	--no-cache-dir \
	--no-build-isolation \
	"scikit-learn==${TERMUX_PKG_VERSION}"
}
