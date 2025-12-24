TERMUX_PKG_HOMEPAGE=https://scikit-learn.org
TERMUX_PKG_DESCRIPTION="Machine learning in Python"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@RexRexRexx"
TERMUX_PKG_VERSION=1.6.1
TERMUX_PKG_SRCURL=https://github.com/scikit-learn/scikit-learn/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ff4a3272d5c6c0df6ef42a5ab0d11a4bac61505568f7f4a12c7f7bf0c9e2d978
TERMUX_PKG_DEPENDS="python, python-numpy, python-scipy, python-joblib, python-threadpoolctl"
TERMUX_PKG_BUILD_DEPENDS="pybind11, cython, clang, pkg-config"
TERMUX_PKG_PYTHON_BUILD_DEPS="numpy, scipy"   # short-circuits py-build
termux_step_make() {
    export BLAS=LAPACK=$PREFIX/lib/libopenblas.so
    python -m build --wheel --outdir dist
}
termux_step_make_install() {
    pip install --prefix $PREFIX dist/*.whl
}
