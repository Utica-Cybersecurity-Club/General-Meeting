# 🧪 Network Segmentation Lab: Zero Trust Implementation for TechNova Solutions

## 📘 Scenario Overview

You’ve been hired as a **network security intern** at **TechNova Solutions**, a mid-sized IT consulting company. TechNova is transitioning to a **Zero Trust security model** to improve internal network segmentation and protect against insider threats and external attacks.

Your goal: **Design and implement VLAN segmentation, firewall rules, and security monitoring on a virtualized pfSense firewall.**


## 🏢 Company Network Structure

The company network includes the following components:

- **Employee Devices** – Corporate LAN  
- **Guest Wi-Fi** – For visitors and contractors  
- **IoT Devices** – Smart printers, security cameras, etc.  
- **Servers** – File servers, internal applications, databases  
- **Management Network** – Used by admins and IT operations


## 📋 Lab Requirements

### 1. 🔀 Network Segmentation (VLANs)

Create separate VLANs for each network type:

| VLAN | Network Type      | VLAN ID |
|------|-------------------|---------|
| 10   | Employee LAN      | VLAN 10 |
| 20   | Guest Wi-Fi       | VLAN 20 |
| 30   | IoT Devices       | VLAN 30 |
| 40   | Servers           | VLAN 40 |
| 50   | Management        | VLAN 50 |

> 🔒 All VLANs should be isolated from each other by default.


### 2. 🔥 Firewall Rules (Zero Trust Policy)

**Default Policy:** Deny all inter-VLAN traffic.

**Allow only:**

- **Employees VLAN (10)** → **Servers VLAN (40)**  
  - Only on required ports (e.g., **SMB, HTTP/S, SSH**)

- **Management VLAN (50)** → **All other VLANs**  
  - For monitoring and administrative access

- **Guest VLAN (20)** → **Internet only**  
  - No access to internal networks

- **IoT VLAN (30)** → **Internet only**  
  - No access to internal networks

> 🚫 Deny all other cross-VLAN communication.


### 3. 🛡️ IDS/IPS Configuration

**Install and configure** either **Snort** or **Suricata** on your pfSense firewall.

**Tasks:**

- Monitor traffic across **all VLANs**
- Enable detection for:
  - Malware signatures
  - Port scans
  - Brute-force attempts
  - Suspicious payloads
- Set up **automatic blocking** for high-severity alerts
- Enable **logging of all IDS/IPS events**


### 4. 📊 Logging & Monitoring

- Enable firewall and IDS/IPS logging
- Logs should be:
  - Viewable in the **pfSense dashboard**
  - Exportable to a **syslog server** or file
- Set up **alerts** for detected attacks to notify the security team


### 5. 🔐 Access Control

- Require **admin authentication** to access pfSense:
  - Use strong passwords or **LDAP**
  - Enable **MFA** (if feasible)
- Restrict pfSense management access to the **Management VLAN (50)** only


## 🧑‍💻 Student Tasks

### Network Configuration

- [ ] Create VLAN interfaces on pfSense for all 5 segments
- [ ] Assign **IP subnets** to each VLAN
- [ ] Configure **DHCP** for each VLAN

### Firewall Rules

- [ ] Implement **Zero Trust** policy:
  - Deny all inter-VLAN traffic by default
  - Allow only specified traffic between VLANs

### IDS/IPS Setup

- [ ] Install **Snort** or **Suricata**
- [ ] Choose appropriate rule sets
- [ ] Enable **detection** and **prevention**
- [ ] Configure alerting and **automatic blocking**

### Logging & Monitoring

- [ ] Enable detailed **logging** for firewall and IDS/IPS events
- [ ] Configure log **export** to syslog or local file

### Access Control

- [ ] Limit pfSense access to **Management VLAN**
- [ ] Enforce **secure login** (strong password, MFA if available)

### Testing & Documentation

- [ ] Test access **between VLANs**
- [ ] Demonstrate **blocked unauthorized traffic**
- [ ] Show detection and **logging of suspicious activity**


## ✅ Deliverables

- A fully segmented network with enforced access rules
- Working IDS/IPS setup with real-time detection
- Security-focused firewall and access control policies
- Documentation showing:
  - Network layout
  - Test results
  - Screenshots of blocked/detected activity
