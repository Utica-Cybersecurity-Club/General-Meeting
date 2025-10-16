# 🧪 Network Segmentation Lab Setup
> For educational use only — do not use on production or internet-connected machines.

This guide walks you through setting up pfSense and giving open instructions for what students should be able to accomplish through 


## ✅ What You Will Need

- VMware Workstation Pro installed (run as Administrator when editing Virtual Network Editor).
- Host OS: Windows 10/11 (instructions assume Windows host).
- At least 8 GB RAM on host (2 GB recommended for pfSense VM).
- 7‑Zip or similar for extracting .gz archives.
- Internet access to download pfSense packages.


## 1. 🧾 Download & prepare pfSense ISO

Download the Current Stable pfSense Community Edition AMD64 ISO/IPMI from Netgate (choose AMD64 / ISO).

[https://pfsense.org/download/](https://pfsense.org/download/)

If the download is *.iso.gz, extract it (right‑click → 7‑Zip → Extract) to get a .iso file (e.g., pfSense-CE-2.7.x-RELEASE-amd64.iso).

Verify file size (~1 GB) — a truncated file causes install problems.


## 2. 📦 Set Up the Virtual Machine

Using **VMware**:

 Open VMWare → click **"New"**

new virtual machine
1. Custom (advanced)
2. Hardware compatibility: **Workstation 17.5 or later**
3. Installer disc image file (iso): **I will install the operating system later**
4. Select a Guest Operating System: **Other** > **FreeBSD 14 64-bit**
5. Virtual Machine Name: **pfSense**
6. Processors
   - Number of Processors: **1**
   - Number of Cores per Processor: **1**
7. Memory for this Virtual Machine: **512 MB**
8. Network Connection: **NAT**
9. I/O Controller Types: **ISC Logic (Recommended)**
10. SCSI Controller: **LSI Logic (Recommended)**
11. Select a Disk: **Create a new virtual disk**
12. Max Disk Size: **15 GB**
   - Store Virtual Disk as a single file
13. Customize Hardware
- CD/DVD: **Use ISO Image File**, and browse to the the iso file for pfsense: **Add** > **Network Adapter**: Select Custom: **VMnet1**

Many of the steps are the same on VirtualBox, but the button or setting might have different names.

## 4. 🔎 Start the Lab

Open the Situation File and try to apply what was learned from the presentation.

For further assistance, ask an officer for help or try searching through the [https://docs.netgate.com/pfsense/en/latest/](Documentation) as a challenge!