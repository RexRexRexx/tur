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
	# Install ALL build dependencies via pip
	python -m pip install --break-system-packages --user cython pybind11 numpy meson-python

	# Critical: Add user bin directory to PATH for cython, f2py, etc.
	export PATH="$HOME/.local/bin:$PATH"

	# Optional: Verify installations
	echo "Checking PATH: $PATH"
	which cython || echo "WARNING: cython not found in PATH"
	python -c "import numpy; print('numpy:', numpy.__version__)" || echo "numpy import failed"
	python -c "import mesonpy; print('meson-python found')" 2>/dev/null || echo "WARNING: mesonpy import failed"
}

termux_step_make() {
	export PATH="$HOME/.local/bin:$PATH"
	export BLAS="$TERMUX_PREFIX/lib/libopenblas.so"
	export LAPACK="$TERMUX_PREFIX/lib/libopenblas.so"

	cd "$TERMUX_PKG_SRCDIR"

	# Use pip install with --no-build-isolation to use our pre-installed tools
	python -m pip install --break-system-packages --no-build-isolation .
}

termux_step_make_install() {
	# Already installed in termux_step_make()
	echo "Package installed during build phase"

	# Optional: Verify installation
	local site_packages=$(python -c "import site; print(site.getsitepackages()[0])" 2>/dev/null || echo "")
	if [ -n "$site_packages" ] && [ -d "$TERMUX_PREFIX/$site_packages/sklearn" ]; then
		echo "scikit-learn installed successfully to $TERMUX_PREFIX/$site_packages/sklearn"
	else
		echo "Warning: Could not verify scikit-learn installation location"
	fi
}
