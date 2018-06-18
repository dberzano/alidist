package: parquet-cpp
version: v1.4.0
tag: apache-parquet-cpp-1.4.0
source: https://github.com/apache/parquet-cpp
requires:
  - boost
  - arrow
build_requires:
  - CMake
  - "GCC-Toolchain:(?!osx)"
  - thrift
---
mkdir -p "$INSTALLROOT"
case $ARCHITECTURE in
  osx*)
    export THRIFT_HOME=$(brew --prefix thrift)
    [[ ! $BOOST_ROOT ]] && BOOST_ROOT=$(brew --prefix boost)
  ;;
esac

cmake $SOURCEDIR                                \
      -DCMAKE_INSTALL_PREFIX=$INSTALLROOT       \
      ${CMAKE_GENERATOR:+-G "$CMAKE_GENERATOR"} \
      -DPARQUET_BUILD_TESTS=OFF                 \
      -DARROW_HOME=${ARROW_ROOT}
cmake --build . -- ${JOBS:+-j$JOBS} install

# Modulefile
MODULEDIR="$INSTALLROOT/etc/modulefiles"
MODULEFILE="$MODULEDIR/$PKGNAME"
mkdir -p "$MODULEDIR"
cat > "$MODULEFILE" <<EoF
#%Module1.0
proc ModulesHelp { } {
  global version
  puts stderr "ALICE Modulefile for $PKGNAME $PKGVERSION-@@PKGREVISION@$PKGHASH@@"
}
set version $PKGVERSION-@@PKGREVISION@$PKGHASH@@
module-whatis "ALICE Modulefile for $PKGNAME $PKGVERSION-@@PKGREVISION@$PKGHASH@@"
# Dependencies
module load BASE/1.0 ${BOOST_VERSION:+boost/$BOOST_VERSION-$BOOST_REVISION} arrow/$ARROW_VERSION-$ARROW_REVISION
# Our environment
set PARQUET_ROOT \$::env(BASEDIR)/$PKGNAME/\$version
prepend-path LD_LIBRARY_PATH \$PARQUET_ROOT/lib
$([[ ${ARCHITECTURE:0:3} == osx ]] && echo "prepend-path DYLD_LIBRARY_PATH \$PARQUET_ROOT/lib")
EoF
