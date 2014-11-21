# Maintainer: Adrien Bak <adrien.bak+aur@gmail.com>
pkgname=pacbackup
pkgver=1.0.3
pkgrel=1.0
pkgdesc=""
arch=('any')
url=""
license=('BSD')
groups=()
depends=('python>=3.4' 'git>=2.1.0' 'pyalpm>=0.6.2')
makedepends=()
provides=()
conflicts=()
replaces=()
backup=()
options=(!emptydirs)
install=
source=("https://github.com/abak/pacbackup/archive/$pkgver.tar.gz")
md5sums=('8c759be019ec3d827e552ad5c606cf18')

package() {
  cd "$srcdir/$pkgname-$pkgver"
  python setup.py install --root="$pkgdir/" --optimize=1
}

