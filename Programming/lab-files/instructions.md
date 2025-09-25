# 🧪 Vulnerable Ubuntu Lab Setup
> For educational use only — do not use on production or internet-connected machines.

This guide walks you through setting up a vulnerable Ubuntu 18.04 virtual machine and running a pre-made script to simulate common misconfigurations and insecure services.


## ✅ What You Will Need

- A computer with at least **4GB RAM** and **20GB free disk space**
- **VMware** (or another VM tool like VirtualBox)
- **Ubuntu 18.04 ISO** (Bionic Beaver)
- The provided **`vuln_lab_setup.sh`** script


## 1. 🧾 Download Ubuntu 18.04 ISO

Ubuntu 18.04 has reached end-of-life, so you'll need to use the archive:

- **Download here:**  
  [Ubuntu 18.04.6 Download Link](https://releases.ubuntu.com/18.04.6/?_gl=1*19ip6hm*_gcl_au*MTE4NTIyOTI0MS4xNzA3MTMxMDQx&_ga=2.149898549.2084151835.1707729318-1126754318.1683186906)

Save this file somewhere you can find it again.


## 2. 📦 Set Up the Virtual Machine

Using **VMware**:

 Open VirtualBox → click **"New"**.
2. Name: `VulnLab`, Type: `Linux`, Version: `Ubuntu (64-bit)`
3. Memory: at least **2048 MB**
4. Create a **dynamically allocated** virtual hard disk (20 GB)
5. After creating the VM, go to **Settings > Storage**:
   - Mount the **Ubuntu 18.04 ISO** as the optical drive.
6. Start the VM and install Ubuntu as usual:
   - Choose **Minimal Installation** if asked.
   - Username: `student`, Password: `student` (or your choice)


## 3. 📁 Get the Script into the VM

1. Download from [Github](https://github.com/Utica-Cybersecurity-Club/General-Meeting/tree/main/Programming\lab-files\vuln-ubuntu.sh)
2. `chmod +x vuln_lab_setup.sh`
3. `sudo ./vuln_lab_setup.sh`

After running the script:
1. Shutdown the VM
2. Right-click the VM → choose "Settings"
3. Go to the "Network Adapter" tab
4. In the Network Adapter section:
    - Select: Custom: Specific virtual network
    - Choose: VMnet1 or any unused internal-only network you've configured
5. Take a snapshot before exploring or testing anything

The VM will be isolated from the internet so the only machine that can communicate with it would be other VMs on the same virutal network

## 4. 🔎 What’s Inside the Lab?

| Service         | Vulnerability / Misconfig       | Learning Opportunity              |
| --------------- | ------------------------------- | --------------------------------- |
| SSH             | Password auth, weak passwords   | Brute force, credential reuse     |
| MySQL           | Root login with weak password   | DB enumeration, local file read   |
| Apache + PHP    | Web shell & vulnerable WP       | RCE, LFI, WP exploitation         |
| VSFTPD          | Anonymous upload, weak config   | File drop, pivot                  |
| Cron            | Writable root-executed script   | Privilege escalation              |
| Sudoers         | `vim` allowed for lazyadmin     | `vim` shell escape → root         |
| WordPress 4.7.0 | CVE-2017-1001000 (REST API RCE) | Public exploit, command injection |
