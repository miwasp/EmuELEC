################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
#
#  This Program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2, or (at your option)
#  any later version.
#
#  This Program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with OpenELEC.tv; see the file COPYING.  If not, write to
#  the Free Software Foundation, 51 Franklin Street, Suite 500, Boston, MA 02110, USA.
#  http://www.gnu.org/copyleft/gpl.html
################################################################################

PKG_NAME="flycast"
PKG_VERSION="6b341667e88581c65cb5d4ad200cf3df665b2a35"
PKG_SHA256="bb4dddb9a9f184a6c54d982c220520f384f4b808d4b0004af477c82cdab7f1d4"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/libretro/flycast"
PKG_URL="$PKG_SITE/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain $OPENGLES"
PKG_LONGDESC="Flycast is a multiplatform Sega Dreamcast emulator "
PKG_TOOLCHAIN="make"
PKG_BUILD_FLAGS="-gold"

pre_configure_target() {
# Flycast defaults to -O3 but then CHD v5 do not seem to work on EmuELEC so we change it to -O2 to fix the issue
PKG_MAKE_OPTS_TARGET="HAVE_OPENMP=1 GIT_VERSION=${PKG_VERSION:0:7} FORCE_GLES=1 SET_OPTIM=-O2 HAVE_LTCG=0 WITH_DYNAREC=arm64 ARCH=arm"
}

pre_make_target() {
   export BUILD_SYSROOT=$SYSROOT_PREFIX

  if [ "$OPENGLES_SUPPORT" = "yes" ]; then
    PKG_MAKE_OPTS_TARGET+=" FORCE_GLES=1 LDFLAGS=-lrt"
  fi

  case $PROJECT in
    Amlogic-ng)
      PKG_MAKE_OPTS_TARGET+=" platform=odroid-n2 ARCH=arm"
      ;;
    Amlogic)
      PKG_MAKE_OPTS_TARGET+=" platform=arm64"
    ;;  
  esac
  
 if [ "$DEVICE" == "OdroidGoAdvance" ]; then
	PKG_MAKE_OPTS_TARGET+=" platform=classic_armv8_a35"
 fi 
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/lib/libretro
  cp flycast_libretro.so $INSTALL/usr/lib/libretro/
}
