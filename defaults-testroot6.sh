package: defaults-testroot6
version: v1
disable:
  - arrow
env:
  CXXFLAGS: "-fPIC -g -O2 -std=c++11"
  CFLAGS: "-fPIC -g -O2"
  CMAKE_BUILD_TYPE: "RELWITHDEBINFO"
overrides:
  AliRoot:
    version: "%(tag_basename)s_TESTROOT6"
    tag: v5-09-47b
  AliPhysics:
    version: "%(tag_basename)s_TESTROOT6"
    tag: v5-09-47b-01
---
