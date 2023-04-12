This repo is for review of requests for signing shim.  To create a request for review:

- clone this repo
- edit the template below
- add the shim.efi to be signed
- add build logs
- add any additional binaries/certificates/SHA256 hashes that may be needed
- commit all of that
- tag it with a tag of the form "myorg-shim-arch-YYYYMMDD"
- push that to github
- file an issue at https://github.com/rhboot/shim-review/issues with a link to your tag
- approval is ready when the "accepted" label is added to your issue

Note that we really only have experience with using GRUB2 on Linux, so asking
us to endorse anything else for signing is going to require some convincing on
your part.

Here's the template:

*******************************************************************************
### What organization or people are asking to have this signed?
*******************************************************************************
Hedgehog SONiC Foundation (https://githedgehog.com/)

*******************************************************************************
### What product or service is this for?
*******************************************************************************
We want to use the signed shim for booting:

- Hedgehog SONiC
- Hedgehog ONIE

*******************************************************************************
### What's the justification that this really does need to be signed for the whole world to be able to boot it?
*******************************************************************************
Bringing Secure Boot to SONiC capable devices is a major value add that we want to provide with Hedgehog SONiC.
Currently there is no open SONiC distribution which would allow an end-user to enable Secure Boot on their switches without using a MOK.
Additionally we have yet to encounter an ONIE installation on a switch which is Secure Boot capable.

*******************************************************************************
### Why are you unable to reuse shim from another distro that is already signed?
*******************************************************************************
Both ONIE as well as SONiC need customized compiled Linux kernels for every different device that we support.
In order to uphold the trusted boot chain we need to sign our Linux kernels with the certificate/key which we are going to embed into our shim which we want to submit for signing.

*******************************************************************************
### Who is the primary contact for security updates, etc.?
The security contacts need to be verified before the shim can be accepted. For subsequent requests, contact verification is only necessary if the security contacts or their PGP keys have changed since the last successful verification.

An authorized reviewer will initiate contact verification by sending each security contact a PGP-encrypted email containing random words.
You will be asked to post the contents of these mails in your `shim-review` issue to prove ownership of the email addresses and PGP keys.
*******************************************************************************
- Name: Marcus Heese
- Position: Linux Platform Engineer
- Email address: marcus@githedgehog.com
- PGP key fingerprint: ``

(Key should be signed by the other security contacts, pushed to a keyserver
like keyserver.ubuntu.com, and preferably have signatures that are reasonably
well known in the Linux community.)

*******************************************************************************
### Who is the secondary contact for security updates, etc.?
*******************************************************************************
- Name: Mike Dvorkin
- Position: CTO
- Email address: mike@githedgehog.com
- PGP key fingerprint: ``

(Key should be signed by the other security contacts, pushed to a keyserver
like keyserver.ubuntu.com, and preferably have signatures that are reasonably
well known in the Linux community.)

*******************************************************************************
### Were these binaries created from the 15.7 shim release tar?
Please create your shim binaries starting with the 15.7 shim release tar file: https://github.com/rhboot/shim/releases/download/15.7/shim-15.7.tar.bz2

This matches https://github.com/rhboot/shim/releases/tag/15.7 and contains the appropriate gnu-efi source.

*******************************************************************************
Yes, as can be seen in the `Dockerfile`. (TODO)

*******************************************************************************
### URL for a repo that contains the exact code which was built to get this binary:
*******************************************************************************
https://github.com/githedgehog/shim-review

*******************************************************************************
### What patches are being applied and why:
*******************************************************************************
All patches that are being applied can be seen in the `Dockerfile`, and can be found in the `shim-patches/` folder in this repository.
All patches are either necessary (like the NX compatibility patch) or are upstream bug fixes which are not part of any official shim release yet. (TODO)

*******************************************************************************
### If shim is loading GRUB2 bootloader what exact implementation of Secureboot in GRUB2 do you have? (Either Upstream GRUB2 shim_lock verifier or Downstream RHEL/Fedora/Debian/Canonical-like implementation)
*******************************************************************************
For both ONIE and SONiC we rely on the Debian maintained grub2 release which can be found [here](https://salsa.debian.org/grub-team/grub/-/tree/debian/2.06-7).
Debian has its own downstream implementation.

*******************************************************************************
### If shim is loading GRUB2 bootloader and your previously released shim booted a version of grub affected by any of the CVEs in the July 2020 grub2 CVE list, the March 2021 grub2 CVE list, the June 7th 2022 grub2 CVE list, or the November 15th 2022 list, have fixes for all these CVEs been applied?

* CVE-2020-14372
* CVE-2020-25632
* CVE-2020-25647
* CVE-2020-27749
* CVE-2020-27779
* CVE-2021-20225
* CVE-2021-20233
* CVE-2020-10713
* CVE-2020-14308
* CVE-2020-14309
* CVE-2020-14310
* CVE-2020-14311
* CVE-2020-15705
* CVE-2021-3418 (if you are shipping the shim_lock module)

* CVE-2021-3695
* CVE-2021-3696
* CVE-2021-3697
* CVE-2022-28733
* CVE-2022-28734
* CVE-2022-28735
* CVE-2022-28736
* CVE-2022-28737

* CVE-2022-2601
* CVE-2022-3775
*******************************************************************************
N/A.
We have no previously released shim.
This is our first submission.
However, the grub version have these patches applied.

*******************************************************************************
### If these fixes have been applied, have you set the global SBAT generation on your GRUB binary to 3?
*******************************************************************************
Yes. (TODO)

*******************************************************************************
### Were old shims hashes provided to Microsoft for verification and to be added to future DBX updates?
### Does your new chain of trust disallow booting old GRUB2 builds affected by the CVEs?
*******************************************************************************
Yes. (TODO)

*******************************************************************************
### If your boot chain of trust includes a Linux kernel:
### Is upstream commit [1957a85b0032a81e6482ca4aab883643b8dae06e "efi: Restrict efivar_ssdt_load when the kernel is locked down"](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=1957a85b0032a81e6482ca4aab883643b8dae06e) applied?
### Is upstream commit [75b0cea7bf307f362057cc778efe89af4c615354 "ACPI: configfs: Disallow loading ACPI tables when locked down"](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=75b0cea7bf307f362057cc778efe89af4c615354) applied?
### Is upstream commit [eadb2f47a3ced5c64b23b90fd2a3463f63726066 "lockdown: also lock down previous kgdb use"](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=eadb2f47a3ced5c64b23b90fd2a3463f63726066) applied?
*******************************************************************************
Yes. (TODO: check)

*******************************************************************************
### Do you build your signed kernel with additional local patches? What do they do?
*******************************************************************************
Both ONIE and SONiC come with a different set of patches per device.
This is expected as every switch has a different combination of hardware/ASIC that they need to support.

*******************************************************************************
### If you use vendor_db functionality of providing multiple certificates and/or hashes please briefly describe your certificate setup.
### If there are allow-listed hashes please provide exact binaries for which hashes are created via file sharing service, available in public with anonymous access for verification.
*******************************************************************************
We do not use this functionality at this point in time.

*******************************************************************************
### If you are re-using a previously used (CA) certificate, you will need to add the hashes of the previous GRUB2 binaries exposed to the CVEs to vendor_dbx in shim in order to prevent GRUB2 from being able to chainload those older GRUB2 binaries. If you are changing to a new (CA) certificate, this does not apply.
### Please describe your strategy.
*******************************************************************************
N/A.
This is our first submission.

*******************************************************************************
### What OS and toolchain must we use to reproduce this build?  Include where to find it, etc.  We're going to try to reproduce your build as closely as possible to verify that it's really a build of the source tree you tell us it is, so these need to be fairly thorough. At the very least include the specific versions of gcc, binutils, and gnu-efi which were used, and where to find those binaries.
### If the shim binaries can't be reproduced using the provided Dockerfile, please explain why that's the case and what the differences would be.
*******************************************************************************
We are using Ubuntu 22.04 as the toolchain for building the shim.
The build can be fully reproduced with the attached `Dockerfile`.
In fact it was used to generate the submitted shim binaries to begin with.

*******************************************************************************
### Which files in this repo are the logs for your build?
This should include logs for creating the buildroots, applying patches, doing the build, creating the archives, etc.
*******************************************************************************
You can find the build logs in the `build.log` of this repository.
It is an executed run of the docker image from the `Dockerfile`.

*******************************************************************************
### What changes were made since your SHIM was last signed?
*******************************************************************************
N/A.
This is our first submission and we have not yet a shim signed.

*******************************************************************************
### What is the SHA256 hash of your final SHIM binary?
*******************************************************************************
TODO

*******************************************************************************
### How do you manage and protect the keys used in your SHIM?
*******************************************************************************
The keys which are used in our shim reside on an HSM.
We have a backup HSM which has the same keys.
And we also have an encrypted offline backup of the keys.
There is only one authentication key for the HSM which can use the keys for signing operation which can only be achieved through our CI system on a tagged release (git tag).

*******************************************************************************
### Do you use EV certificates as embedded certificates in the SHIM?
*******************************************************************************
No.

*******************************************************************************
### Do you add a vendor-specific SBAT entry to the SBAT section in each binary that supports SBAT metadata ( grub2, fwupd, fwupdate, shim + all child shim binaries )?
### Please provide exact SBAT entries for all SBAT binaries you are booting or planning to boot directly through shim.
### Where your code is only slightly modified from an upstream vendor's, please also preserve their SBAT entries to simplify revocation.
*******************************************************************************
TODO

*******************************************************************************
### Which modules are built into your signed grub image?
*******************************************************************************
TODO

*******************************************************************************
### What is the origin and full version number of your bootloader (GRUB or other)?
*******************************************************************************
[[Debian grub 2.06-7](https://salsa.debian.org/grub-team/grub/-/tree/debian/2.06-7)

*******************************************************************************
### If your SHIM launches any other components, please provide further details on what is launched.
*******************************************************************************
It does not launch any other components.

*******************************************************************************
### If your GRUB2 launches any other binaries that are not the Linux kernel in SecureBoot mode, please provide further details on what is launched and how it enforces Secureboot lockdown.
*******************************************************************************
Grub launches only the Linux kernel in SecureBoot mode or it chainloads to another grub.
From the SONiC grub boot menu the user is able to chainload into the grub of ONIE when he needs to perform an ONIE function.
The chainloading will in fact chainload to the signed shim which will load grub again.

*******************************************************************************
### How do the launched components prevent execution of unauthenticated code?
*******************************************************************************
Debian's grub verifies signatures of kernels via the shim protocol.
It includes a set of common secure boot patches to achieve that.
All our signed Linux kernels either have all necessary lockdown patches dervived from the upstream Linux kernel or have them applied separately where necessary.

*******************************************************************************
### Does your SHIM load any loaders that support loading unsigned kernels (e.g. GRUB)?
*******************************************************************************
No.

*******************************************************************************
### What kernel are you using? Which patches does it includes to enforce Secure Boot?
*******************************************************************************
As mentioned above we need to use different kernel versions and patches for every different device that we support.
That means that we are going to apply patches for ACPI and lockdown so that signed kernel module loading is enforced when in secure boot mode if the upstream Linux kernel does not already have them applied.

*******************************************************************************
### Add any additional information you think we may need to validate this shim.
*******************************************************************************
