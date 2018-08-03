package: libwebsockets
version: "%(tag_basename)s"
tag: "v2.4.2"
source: https://github.com/warmcat/libwebsockets
build_requires:
  - CMake
  - "GCC-Toolchain:(?!osx)"
  - "OpenSSL:(?!osx)"
---
#!/bin/bash -e
cmake $SOURCEDIR/                                                   \
      -DCMAKE_INSTALL_PREFIX="$INSTALLROOT"                         \
      -DCMAKE_BUILD_TYPE=RELEASE                                    \
      -DLWS_WITH_STATIC=ON                                          \
      -DLWS_WITH_SHARED=OFF                                         \
      ${OPENSSL_ROOT:+-DOPENSSL_ROOT_DIR=$OPENSSL_ROOT}             \
      ${OPENSSL_ROOT:+-DOPENSSL_INCLUDE_DIRS=$OPENSSL_ROOT/include} \
      ${OPENSSL_ROOT:+-DOPENSSL_LIBRARIES=$OPENSSL_ROOT/lib}        \
      -DLWS_HAVE_OPENSSL_ECDH_H=OFF                                 \
      -DLWS_WITHOUT_TESTAPPS=ON
make ${JOBS+-j $JOBS} install
rm -rf $INSTALLROOT/share
