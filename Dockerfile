FROM ubuntu:22.04

ARG TARGETPLATFORM
ARG BUILDPLATFORM
RUN echo "Building shim for $TARGETPLATFORM on $BUILDPLATFORM"

# copy everything from the local folder that we need for the build
ADD hedgehog-sb-ca.der sbat.hedgehog.csv /build/
ADD shim-patches /build/shim-patches
WORKDIR /build

# display all copied files
RUN find /build

# install toolchain - Ubuntu 22.04 should be a good toolchain to work with
RUN apt-get update -y && apt-get install -y --no-install-recommends dos2unix build-essential binutils gcc gnu-efi bsdmainutils wget pesign ca-certificates ruby
RUN gem install pedump

# show all installed packages for the build log
RUN dpkg -l

# download and extract the shim tarball
# FIXME: it would be great if the shim repo actually provides checksum files as they are expecting us to build from a tarball
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
RUN sha256sum shimx64.efi
RUN pedump shimx64.efi
RUN pedump --extract section:.sbat shimx64.efi

RUN apt-get install -y --no-install-recommends libelf-dev
RUN VENDOR_CERT_FILE=/build/hedgehog-sb-ca.der EFIDIR=hedgehog make install
RUN sha256sum /boot/efi/EFI/hedgehog/shimx64.efi
RUN pedump /boot/efi/EFI/hedgehog/shimx64.efi