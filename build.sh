#!/usr/bin/env sh

VERSION=0.8.0
SOURCE=https://github.com/containers/bubblewrap/releases/download/v$VERSION/bubblewrap-$VERSION.tar.xz

echo Downloading Bubblewrap "$VERSION" ...
cd /build || exit
wget "$SOURCE"

echo Extracting Bubblewrap "$VERSION" ...
tar -xf bubblewrap-$VERSION.tar.xz
mv bubblewrap-$VERSION bubblewrap

echo Building Bubblewrap ...
cd /build/bubblewrap || exit
./configure
make "-j$(nproc)" || exit
strip bwrap
ldd bwrap

echo Packaging Bubblewrap ...
mkdir -p /export/usr/bin
cd /export || exit

cp /build/bubblewrap/bwrap usr/bin

mkdir legal
cat > legal/bubblewrap<< EOF
Source  : $SOURCE
Version : $VERSION
Package : https://github.com/vmify/bubblewrap/bubblewrap/download/$TAG/bubblewrap-$ARCH-$TAG.tar.gz
License :

EOF
cat /build/bubblewrap/COPYING >> legal/bubblewrap
gzip legal/bubblewrap

tar -czvf /bubblewrap.tar.gz *
