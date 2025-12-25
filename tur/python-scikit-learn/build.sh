TERMUX_PKG_HOMEPAGE=https://scikit-learn.org
TERMUX_PKG_DESCRIPTION="Machine learning in Python"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@RexRexRexx"
TERMUX_PKG_VERSION=1.6.1
TERMUX_PKG_SRCURL=https://github.com/scikit-learn/scikit-learn/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ff4a3272d5c6c0df6ef42a5ab0d11a4bac61505568f7f4a12c7f7bf0c9e2d978

# RUNTIME dependencies (must exist in termux-main or tur-packages)
TERMUX_PKG_DEPENDS="python, python-numpy, python-scipy"

# BUILD dependencies (ONLY list packages that exist in termux-main)
# cython, pybind11, etc., are NOT in termux-main, so we install them via pip.
TERMUX_PKG_BUILD_DEPENDS="python-numpy-static, python-scipy-static, clang"

termux_step_make() {
	export BLAS="$TERMUX_PREFIX/lib/libopenblas.so"
	export LAPACK="$TERMUX_PREFIX/lib/libopenblas.so"

	# Install all Python build tools via pip
	pip install build cython pybind11
	python -m build --wheel --no-isolation
}

termux_step_make_install() {
	local wheel_file=$(ls dist/*.whl | head -1)
	pip install --prefix="$TERMUX_PREFIX" "$wheel_file"
}
