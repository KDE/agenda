#! /bin/bash

set -x

### Update sources
wget -qO /etc/apt/sources.list.d/nitrux-main-compat-repo.list https://raw.githubusercontent.com/Nitrux/iso-tool/development/configs/files/sources/nitrux-repo.list

wget -qO /etc/apt/sources.list.d/nitrux-testing-repo.list https://raw.githubusercontent.com/Nitrux/iso-tool/development/configs/files/sources/nitrux-testing-repo.list

curl -L https://packagecloud.io/nitrux/repo/gpgkey | apt-key add -;
curl -L https://packagecloud.io/nitrux/compat/gpgkey | apt-key add -;
curl -L https://packagecloud.io/nitrux/testing/gpgkey | apt-key add -;

apt -qq update

### Install Package Build Dependencies #2

apt -qq -yy install --no-install-recommends \
	mauikit-calendar-git
	mauikit-filebrowsing-git \
	mauikit-git

rm -rf {LICENSE,README.md}

### Compile Source

mkdir -p build && cd build

cmake \
	-DCMAKE_INSTALL_PREFIX=/usr \
	-DENABLE_BSYMBOLICFUNCTIONS=OFF \
	-DQUICK_COMPILER=ON \
	-DCMAKE_BUILD_TYPE=Release \
	-DCMAKE_INSTALL_SYSCONFDIR=/etc \
	-DCMAKE_INSTALL_LOCALSTATEDIR=/var \
	-DCMAKE_EXPORT_NO_PACKAGE_REGISTRY=ON \
	-DCMAKE_FIND_PACKAGE_NO_PACKAGE_REGISTRY=ON \
	-DCMAKE_INSTALL_RUNSTATEDIR=/run "-GUnix Makefiles" \
	-DCMAKE_VERBOSE_MAKEFILE=ON \
	-DCMAKE_INSTALL_LIBDIR=lib/x86_64-linux-gnu ..

make -j$(nproc)

make install

### Run checkinstall and Build Debian Package

>> description-pak printf "%s\n" \
	'Calendar application built with MauiKit.' \
	'' \
	''

checkinstall -D -y \
	--install=no \
	--fstrans=yes \
	--pkgname=agenda-git \
	--pkgversion=$PACKAGE_VERSION \
	--pkgarch=amd64 \
	--pkgrelease="1" \
	--pkglicense=LGPL-3 \
	--pkggroup=utils \
	--pkgsource=agenda \
	--pakdir=. \
	--maintainer=uri_herrera@nxos.org \
	--provides=agenda \
	--requires="libc6,libkf5akonadicore5,libkf5akonadicontact5,libkf5calendarsupport5,libkf5coreaddons5,libkf5eventviews5,libkf5i18n5,libkf5kiocore5,libqt5core5a,libqt5gui5,libqt5qml5,libqt5sql5,libqt5widgets5,mauikit-accounts-git \(\>= 2.2.1+git\),mauikit-calendar-git \(\>= 2.2.1+git\),mauikit-filebrowsing-git \(\>= 2.2.1+git\),mauikit-git \(\>= 2.2.1+git\)" \
	--nodoc \
	--strip=no \
	--stripso=yes \
	--reset-uids=yes \
	--deldesc=yes
