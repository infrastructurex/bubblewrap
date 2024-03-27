#!/usr/bin/env sh

VERSION=0.9.0
SOURCE=https://github.com/containers/bubblewrap/releases/download/v$VERSION/bubblewrap-$VERSION.tar.xz

echo Downloading Bubblewrap "$VERSION" ...
cd /build || exit
wget "$SOURCE"

echo Extracting Bubblewrap "$VERSION" ...
tar -xf bubblewrap-$VERSION.tar.xz
mv bubblewrap-$VERSION bubblewrap

echo Building Bubblewrap ...
cd /build/bubblewrap || exit

patch -p1 < ../root_uid_gid.patch

meson setup _builddir
meson compile -C _builddir
meson test -C _builddir
strip _builddir/bwrap
ldd _builddir/bwrap

echo Packaging Bubblewrap ...
mkdir -p /export/usr/bin
cd /export || exit

cp /build/bubblewrap/_builddir/bwrap usr/bin
chmod 4755 usr/bin/bwrap

mkdir legal
cat > legal/bubblewrap<< EOF
Source  : $SOURCE
Version : $VERSION
Package : https://github.com/infrastructurex/bubblewrap/bubblewrap/download/$TAG/bubblewrap-$ARCH-$TAG.tar.gz
License :

EOF
cat /build/bubblewrap/COPYING >> legal/bubblewrap
gzip legal/bubblewrap

tar -czvf /bubblewrap.tar.gz *
