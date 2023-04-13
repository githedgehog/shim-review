FROM ubuntu:22.04

ARG TARGETARCH
ARG BUILDARCH
# adding a default value like this allows us to use this Dockerfile even without buildkit
# assuming that someone is on an x86_64 system
# NOTE: check the Makefile for dedicated buildkit targets to build for multiple platforms
ARG EFIARCH=x64
RUN echo "Building shim for \"${TARGETARCH}\" on \"${BUILDARCH}\" (EFIARCH: \"${EFIARCH}\")"

# copy everything from the local folder that we need for the build
ADD hedgehog-sb-ca.der sbat.hedgehog.csv /build/
ADD shim-patches /build/shim-patches
WORKDIR /build

# display all copied files
RUN find /build

# install toolchain - Ubuntu 22.04 should be a good toolchain to work with
RUN apt-get update -y && apt-get install -y --no-install-recommends dos2unix build-essential binutils gcc gnu-efi bsdmainutils wget pesign ca-certificates ruby libelf-dev
RUN gem install pedump

# show all installed packages for the build log
RUN dpkg -l

# download and extract the shim tarball
# FIXME: it would be great if the shim repo actually provides checksum files as they are expecting us to build from a tarball
# but we have no good way of knowing if we actually downloaded a good and untampered version
RUN wget https://github.com/rhboot/shim/releases/download/15.7/shim-15.7.tar.bz2
RUN echo "87cdeb190e5c7fe441769dde11a1b507ed7328e70a178cd9858c7ac7065cfade  shim-15.7.tar.bz2" > tarball-checksums
RUN sha256sum --check tarball-checksums
RUN tar xvf shim-15.7.tar.bz2
WORKDIR /build/shim-15.7

# apply our patches
RUN for patch_file in /build/shim-patches/*; do echo "Applying patch file ${patch_file##*/}..." && patch -Np1 -i $patch_file; done

# copy our SBAT file
RUN cp --force --verbose /build/sbat.hedgehog.csv ./data/sbat.csv && cat ./data/sbat.csv

# build the shim
RUN make VENDOR_CERT_FILE=/build/hedgehog-sb-ca.der

# install the shim - technically not necessary at all, but makes for a nice artifact directory
RUN VENDOR_CERT_FILE=/build/hedgehog-sb-ca.der EFIDIR=hedgehog make install
WORKDIR /boot/efi/EFI/hedgehog

# calculate and show the SHA-256 sum
RUN echo "SHA-256 sum of shim${EFIARCH}.efi:" && sha256sum shim${EFIARCH}.efi

# with this output we can verify that the NX compatibility flag is indeed set
RUN pedump shim${EFIARCH}.efi

# with this output we can verify our SBAT section
RUN echo "SBAT section of shim${EFIARCH}.efi:" && pedump --extract section:.sbat shim${EFIARCH}.efi
