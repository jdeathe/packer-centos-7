# CentOS-7 Minimal Base Box

This provides the configuration and Makefile to build a [Vagrant](https://www.vagrantup.com) minimal base box using [Packer](https://www.packer.io). The base box is intended for server (terminal) use only so is restricted to a single locale (with `en_US` being the default) which allows for a smaller box size.

There are templates provided for the following with `x86_64` architecture:
- CentOS-7.9.2009
- CentOS-7.7.1908
- CentOS-7.6.1810
- CentOS-7.5.1804
- CentOS-7.4.1708
- CentOS-7.3.1611
- CentOS-7.2.1511

There is currently no requirement to support older minor release versions or alternative architectures but they could be added if necessary.

## Usage Instructions

### Prerequisites

The build environment required is Mac OSX or GNU Linux (Fedora 37).

To build the box files you will need the following installed. Version numbers are those used to build on Fedora 37.

- [VirtualBox](https://www.virtualbox.org) (7.0.4_rpmfusion)
- [LibVirt](https://libvirt.org) (8.6.0)
- [Vagrant](https://www.vagrantup.com) (2.2.19)
- [Packer](https://www.packer.io) (1.8.5)

_NOTE_: You may need to create the VirtualBox NAT Network 10.0.2.0/24 if it doesn't already exist.

### Build

To build the latest, `x86_64` base box run `make` or `make build`.

```
$ make
```

To build a specific release version, use the `BOX_VERSION_RELEASE` variable.

```
$ BOX_VERSION_RELEASE=7.2.1511 make
```

For usage instructions run `make help`.

```
$ make help
```

#### Box Variants

To build a box variant from an alternative box template use `BOX_VARIANT`. The default is `Minimal` but there is an alternative `Minimal-Cloud-Init` template to build boxes that include Cloud-Init. The variant `Minimal-AMI` will generate an ova image suitable for importing into [AWS](https://aws.amazon.com/).

```
$ BOX_VARIANT=Minimal-Cloud-Init make
```

#### Provider

To build a box for the `libvirt` provider use `BOX_PROVIDER`.

```
$ BOX_PROVIDER=libvirt make
```

### Local Install

To install from a box file, generated by a successful build, use `make install` supplied with the same environment variables used to build the require box. This will add the box and output a minimal Vagrantfile template that can be used to create a Vagrantfile in a suitable directory for testing.

```
$ BOX_VARIANT=Minimal-Cloud-Init make install
```

_NOTE_: If running vagrant via `sudo` do the same here to ensure the box is installed for the expected user.