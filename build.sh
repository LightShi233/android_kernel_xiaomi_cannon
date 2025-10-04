#!/usr/bin/env bash
SECONDS=0

LOCAL_DIR="$HOME/"
TC_DIR=$LOCAL_DIR/toolchain
CLANG_DIR=$TC_DIR/clang-22
GCC_64_DIR=$TC_DIR/aarch64-linux-android-4.9
GCC_32_DIR=$TC_DIR/arm-linux-androideabi-4.9
DEFCONFIG=cannon_defconfig

export PATH=$CLANG_DIR/bin:$PATH
export LD_LIBRARY_PATH=$CLANG_DIR/lib:$LD_LIBRARY_PATH
export KBUILD_BUILD_USER=Light
export KBUILD_BUILD_HOST=Light-PC
export KBUILD_BUILD_VERSION=1

[ -d "$CLANG_DIR" ] || {
  mkdir -p "$CLANG_DIR"
  CLANG_URL="https://github.com/ZyCromerZ/Clang/releases/download/22.0.0git-20250920-release/Clang-22.0.0git-20250920.tar.gz"
  wget -qO clang.tar.gz "$CLANG_URL"
  tar -xzf clang.tar.gz -C $CLANG_DIR
}
[ -d "$GCC_64_DIR" ] || \
  git clone --depth=1 -b lineage-19.1 https://github.com/LineageOS/android_prebuilts_gcc_linux-x86_aarch64_aarch64-linux-android-4.9.git "$GCC_64_DIR"
[ -d "$GCC_32_DIR" ] || \
  git clone --depth=1 -b lineage-19.1 https://github.com/LineageOS/android_prebuilts_gcc_linux-x86_arm_arm-linux-androideabi-4.9.git "$GCC_32_DIR"

mkdir -p out
make O=out ARCH=arm64 $DEFCONFIG
make  -j2 O=out \
					  ARCH=arm64 \
					  CC=clang \
					  LD=ld.lld \
					  AR=llvm-ar \
					  AS=llvm-as \
					  NM=llvm-nm \
					  OBJCOPY=llvm-objcopy \
					  OBJDUMP=llvm-objdump \
					  STRIP=llvm-strip \
					  CROSS_COMPILE=aarch64-linux-gnu- \
					  CROSS_COMPILE_ARM32=arm-linux-gnueabi- \
					  CLANG_TRIPLE=aarch64-linux-gnu- \
					  Image.gz-dtb
