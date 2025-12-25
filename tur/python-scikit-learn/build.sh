TERMUX_PKG_HOMEPAGE=https://scikit-learn.org
TERMUX_PKG_DESCRIPTION="Machine learning in Python"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@RexRexRexx"
TERMUX_PKG_VERSION=1.6.1
TERMUX_PKG_SRCURL=https://github.com/scikit-learn/scikit-learn/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=88c1816c89d2b27f2506d155e1195d71fc9d935bbe1968ce02b0e9ddd659b2ff
TERMUX_PKG_DEPENDS="python, python-numpy, python-scipy"
TERMUX_PKG_BUILD_DEPENDS="python-numpy-static, python-scipy-static, clang"

termux_step_pre_configure() {
	# Install build dependencies
	python -m pip install --break-system-packages --user cython pybind11 numpy

	# Add user bin to PATH
	export PATH="$HOME/.local/bin:$PATH"
}

termux_step_make() {
	export PATH="$HOME/.local/bin:$PATH"
	export BLAS="$TERMUX_PREFIX/lib/libopenblas.so"
	export LAPACK="$TERMUX_PREFIX/lib/libopenblas.so"

	cd "$TERMUX_PKG_SRCDIR"

	# Direct pip install (builds in-place)
	python -m pip install --break-system-packages --no-build-isolation .
}

termux_step_make_install() {
	# Already installed in termux_step_make()
	echo "Package already installed during build phase"
}
