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
	# Install cython
	python -m pip install --break-system-packages --user cython pybind11

	# Find cython binary
	CYTHON_BIN=$(python -c "import cython; import os; print(os.path.join(os.path.dirname(cython.__file__), '..', '..', 'bin', 'cython'))" 2>/dev/null || echo "$HOME/.local/bin/cython")

	# Make sure it's executable and in PATH
	export PATH="$HOME/.local/bin:$PATH"
	export CYTHON="$CYTHON_BIN"

	echo "CYTHON set to: $CYTHON"
	ls -la "$(which cython 2>/dev/null || echo /not/found)" || true
}

termux_step_make() {
	# Keep environment variables
	export PATH="$HOME/.local/bin:$PATH"
	export BLAS="$TERMUX_PREFIX/lib/libopenblas.so"
	export LAPACK="$TERMUX_PREFIX/lib/libopenblas.so"

	# Set CYTHON for meson
	if [ -n "$CYTHON" ]; then
		export CYTHON
	elif which cython >/dev/null 2>&1; then
		export CYTHON=$(which cython)
	fi

	python -m pip install --break-system-packages build
	python -m build --wheel --no-isolation
}

termux_step_make_install() {
	local wheel_file=$(ls dist/*.whl | head -1)
	python -m pip install --break-system-packages --prefix="$TERMUX_PREFIX" "$wheel_file"
}
