ifdef(`PKGNAME',,`errprint(`PKGNAME not defined
')m4exit(`1')')dnl
define(`LLVM_MAJOR',regexp(PKGNAME,`llvm\([0-9]+\)', `\1'))dnl
define(`LLVM_PATCH',ifelse(LLVM_MAJOR, `15',`7',`0'))dnl
dnl
pkgname=PKGNAME
pkgver=LLVM_MAJOR.0
pkgrel=1
pkgdesc='The LLVM Project is a collection of modular and reusable compiler and toolchain technologies'
url='https://github.com/llvm/llvm-project'
arch=('x86_64' 'arm' 'armv6h' 'armv7h' 'aarch64' 'pentium4' 'i686')
license=('custom:Apache 2.0 with LLVM Exception')
depends=('libxml2' 'libedit' 'perl' 'python')
makedepends=('git' 'cmake' 'ccache' 'ninja' 'libffi' 'libedit' 'python' 'jsoncpp')
options=('strip')
source=('https://github.com/llvm/llvm-project/releases/download/llvmorg-LLVM_MAJOR.0.LLVM_PATCH/llvm-LLVM_MAJOR.0.LLVM_PATCH.src.tar.xz')
cksums=('SKIP')

build() {
    cd "$srcdir/llvm-LLVM_MAJOR.0.LLVM_PATCH.src"
    mkdir -p "build"
    cmake -E chdir build \
          cmake -G Ninja \
          -DCMAKE_INSTALL_PREFIX=/usr/PKGNAME \
          -DCMAKE_BUILD_TYPE=Release \
          -DLLVM_CCACHE_BUILD=ON \
          -DLLVM_INCLUDE_BENCHMARKS=OFF \
          -DLLVM_BUILD_LLVM_DYLIB=ON \
          -DLLVM_LINK_LLVM_DYLIB=ON \
          -DLLVM_INCLUDE_TESTS=OFF \
          -DLLVM_INCLUDE_EXAMPLES=OFF \
          -DLLVM_ENABLE_FFI=ON \
            ..
    cmake --build build --parallel $(nproc)
}

package() {
    cd "$srcdir/llvm-LLVM_MAJOR.0.LLVM_PATCH.src/build"
    DESTDIR=$pkgdir cmake --install .
}
