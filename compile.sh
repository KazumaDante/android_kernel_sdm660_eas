#################
#  Kazu-Kernel  #
#     EAS       #
#     R10       #
#################
# Clean out folder
rm -rf '/media/system/root1/android_kernel_sdm660_eas/out'
# Set defaults
cd "/media/system/root1/android_kernel_sdm660_eas"
wd=$(pwd)
out=$wd/out
BUILD="/media/system/root1/android_kernel_sdm660_eas"
# Set kernel source workspace
cd $BUILD
# Export ARCH <arm, arm64, x86, x86_64>
export ARCH=arm64
# Export SUBARCH <arm, arm64, x86, x86_64>
export SUBARCH=arm64
# Set kernal name
# export LOCALVERSION=-
# Export Username
export KBUILD_BUILD_USER=KazuDante
# Export Machine name
export KBUILD_BUILD_HOST=xdadevelopers
# Compiler String
CC=/media/system/root1/android_prebuilts_clang_host_linux-x86_clang-6364210/bin/clang
export KBUILD_COMPILER_STRING="$(${CC} --version | head -n 1 | perl -pe 's/\(http.*?\)//gs' | sed -e 's/  */ /g')"
# Make and Clean
make O=$out clean
make O=$out mrproper
# Make <defconfig>
make O=$out ARCH=arm64 lavender_defconfig
DATE_START=$(date +"%s")
# Build Kernel
make O=$out ARCH=arm64 \
CC="/media/system/root1/android_prebuilts_clang_host_linux-x86_clang-6364210/bin/clang" \
CLANG_TRIPLE=aarch64-linux-gnu- \
CROSS_COMPILE="/media/system/root1/aarch64-linux-android-4.9/bin/aarch64-linux-android-" \
CROSS_COMPILE_ARM32="/media/system/root1/aarch64-linux-android-4.9/bin/arm-linux-androideabi" \
-j$(nproc --all) Image.gz-dtb
DATE_END=$(date +"%s")
DIFF=$(($DATE_END - $DATE_START))
echo "Time: $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds."
# mounting to browser
cd "/media/system/root1/android_kernel_sdm660_eas/out/arch/arm64/boot"
python3 -m http.server 3333
