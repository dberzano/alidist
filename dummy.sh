package: Dummy
version: "v0.2.0"
requires:
  - golang
---
#!/bin/bash -e

# This is a dummy recipe. It deploys no real package and has no repository. It is just for testing.

# For version v0.2.0

# Dummy binary
mkdir -p $INSTALLROOT/bin
cat > $INSTALLROOT/bin/dummy-info <<EOF
#!/bin/bash -e
echo 'This is Dummy $PKGVERSION (rev. @@PKGREVISION@$PKGHASH@@)' >&2
EOF
chmod +x $INSTALLROOT/bin/dummy-info

# Extra RPM dependencies
cat > $INSTALLROOT/.rpm-extra-deps <<EOF
axel >= 2.4
python36 <= 3.7
jq >= 1.5
EOF

mkdir -p etc/modulefiles
cat > etc/modulefiles/$PKGNAME <<EoF
#%Module1.0
proc ModulesHelp { } {
  global version
  puts stderr "ALICE Modulefile for $PKGNAME $PKGVERSION-@@PKGREVISION@$PKGHASH@@"
}
set version $PKGVERSION-@@PKGREVISION@$PKGHASH@@
module-whatis "ALICE Modulefile for $PKGNAME $PKGVERSION-@@PKGREVISION@$PKGHASH@@"
# Dependencies
module load BASE/1.0

# Our environment
set DUMMY_ROOT \$::env(BASEDIR)/$PKGNAME/\$version
prepend-path PATH \$DUMMY_ROOT/bin
prepend-path LD_LIBRARY_PATH \$DUMMY_ROOT/lib
$([[ ${ARCHITECTURE:0:3} == osx ]] && echo "prepend-path DYLD_LIBRARY_PATH \$DUMMY_ROOT/lib")
EoF
mkdir -p $INSTALLROOT/etc/modulefiles && rsync -a --delete etc/modulefiles/ $INSTALLROOT/etc/modulefiles
