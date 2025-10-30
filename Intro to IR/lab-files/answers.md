# 🧩 Incident Response Lesson — Instructor Answer Key

**Scenario Summary:**  
Students are provided a set of logs from a corporate web server (`web1`).  
An external IP (`203.0.113.42`) exploits a vulnerable file upload function, uploads a PHP webshell, and establishes a possible outbound connection to a command-and-control (C2) server.  

Their task is to determine:
1. Which phase of the Incident Response Lifecycle the team is currently in.
2. What evidence supports that determination.
3. What actions are required to progress through the remaining phases.


## 🧭 Incident Response Lifecycle Reference

| Phase | Goal | Example Questions |
|:------|:-----|:------------------|
| **Identification** | Detect and verify that an incident has occurred. | What do the logs show that confirms malicious activity? |
| **Containment** | Limit the spread of the threat. | How can we isolate the system or block further compromise? |
| **Eradication** | Remove the root cause and artifacts of the incident. | How do we clean the system and eliminate persistence? |
| **Recovery** | Safely restore operations. | How do we validate and bring services back online? |
| **Preparation (Lessons Learned)** | Improve readiness and reduce future risk. | What preventive controls or procedures can we strengthen? |


## 1️⃣ access.log — Web Server Access

**Key Suspicious Entries:**
[Mon Apr 21 08:08:04 2025] 203.0.113.42 - - "POST /upload.php HTTP/1.1" 200 1789 "-" "curl/7.68.0"
[Mon Apr 21 08:08:05 2025] 203.0.113.42 - - "GET /uploads/2025-04-21/README.php HTTP/1.1" 200 382 "-"
[Mon Apr 21 08:08:42 2025] 203.0.113.42 - - "GET /uploads/2025-04-21/README.php?cmd=id HTTP/1.1" 200 12 "-"


**Notes:**
- The attacker uploads a PHP file (`README.php`) via the `/upload.php` endpoint.
- Subsequent requests with `?cmd=` show command execution through the webshell.
- Normal traffic (e.g., `/index.html`, `/robots.txt`) is **noise** to make the dataset feel realistic.
- Students should recognize that this marks the **Identification phase** — a confirmed malicious action.

**Observation:**
> “An external IP uploaded and executed a PHP file, which means we’re in the Identification phase of incident response.”


## 2️⃣ auth.log — Authentication Logs

**Suspicious Indicators:**
Apr 21 08:01:21 web1 sshd[1345]: Failed password for invalid user test from 203.0.113.42 port 51118 ssh2
Apr 21 08:02:13 web1 sshd[1350]: Failed password for invalid user admin from 203.0.113.42 port 51121 ssh2


**Notes:**
- These failed SSH attempts come from the same attacker IP.
- They are *red herrings* — these attempts were unsuccessful and are **not the primary intrusion vector**.
- This log helps reinforce that **multiple indicators** can appear in an investigation; correlation is key.

**Observation:**
> “There were failed SSH attempts, but the compromise likely occurred through the file upload, not SSH.”


## 3️⃣ syslog — System Activity and Process Behavior

**Key Suspicious Lines:**
Apr 21 08:08:05 web1 kernel: php-fpm: executing command /var/www/html/uploads/2025-04-21/README.php
Apr 21 08:08:07 web1 kernel: process php[3456] spawned /bin/sh (pid=3470)
Apr 21 08:11:55 web1 kernel: audit: type=1302 syscall=49 success=yes pid=3456 user=www-data comm="php"


**Notes:**
- The PHP process (`www-data`) spawning `/bin/sh` indicates **remote code execution**.
- This confirms the earlier upload resulted in command execution.
- The audit log showing `syscall=49` suggests a **network connection** initiated by that process — possible outbound C2.
- Students should correlate the timestamps (08:08–08:12) with access and IDS logs.

**Observation:**
> “The PHP process created a shell, showing that the attacker executed system-level commands.”


## 4️⃣ ids.log — Intrusion Detection Alerts

**Critical Alerts:**
[2025-04-21 08:08:04] ET WEB_SPECIFIC_APPS PHP Upload Suspicious
[2025-04-21 08:08:44] ET SHELLCODE Possible PHP WebShell Command Execution
[2025-04-21 08:09:10] ET POLICY Outbound Connection on Non-Standard Port 4444


**Notes:**
- IDS detects a suspicious PHP upload, then a webshell command execution.
- The outbound connection on port `4444` could indicate a reverse shell or C2.
- These alerts **corroborate** what’s seen in `access.log` and `syslog`, completing the identification picture.

**Observation:**
> “IDS alerts match the same timeline and confirm an active compromise through a webshell.”


## 🧠 Phase-by-Phase Walkthrough

### 🔹 Identification
**Goal:** Recognize and confirm a real incident.  
**Evidence Found:**
- Upload of a `.php` file (access.log)
- Command execution (`cmd=id`, `cmd=uname -a`)
- PHP process spawning shell (syslog)
- IDS alerts for webshell and outbound C2 (ids.log)

**Conclusion:**  
> Incident confirmed — external attacker gained remote command execution via file upload vulnerability.


### 🔹 Containment
**Goal:** Limit damage and stop further attacker actions.  
**Recommended Actions:**
1. Isolate the web server from the network (disconnect or block outbound).
2. Block outbound connections to `198.51.100.7:443` and inbound from `203.0.113.42`.
3. Preserve volatile evidence:
   - Memory image
   - Running processes (`ps`)
   - Network connections (`netstat`)
   - Web directory contents
4. Notify the Incident Response and Web Application teams.

**Rationale:**
> “We must contain by isolating the server and blocking C2 before the attacker escalates or moves laterally.”

### 🔹 Eradication
**Goal:** Remove root cause and all malicious artifacts.  
**Steps:**
1. Delete `/var/www/html/uploads/2025-04-21/README.php`.
2. Scan for other webshells or backdoors.
3. Patch `upload.php` to prevent arbitrary file uploads.
4. Reset compromised credentials and SSH keys.
5. Verify that no persistence mechanisms were installed.

**Rationale:**
> “Removing the uploaded PHP file and fixing the vulnerable upload endpoint eliminates the attacker’s access.”


### 🔹 Recovery
**Goal:** Return the system safely to operation.  
**Steps:**
1. Restore affected files from a known-good backup.
2. Validate system integrity and conduct vulnerability scans.
3. Monitor for renewed connections or suspicious requests.
4. Reintroduce the web server to production in a controlled manner.

**Rationale:**
> “After confirming the system is clean, we bring it back online with enhanced monitoring.”


### 🔹 Preparation (Lessons Learned)
**Goal:** Strengthen defenses and improve future readiness.  
**Recommendations:**
- Enforce strict file type validation for uploads.
- Disable execution permissions in upload directories.
- Implement Web Application Firewall (WAF) rules for suspicious patterns.
- Improve log correlation and IDS alert visibility.
- Conduct regular IR tabletop exercises.
- Document this event in the IR playbook for training and auditing.

**Rationale:**
> "If we had better upload validation or faster alerting, how could this have been prevented?"

---

**Summary:**
- The attacker’s path is linear: reconnaissance → upload → execute → connect out.
- Students may chase SSH brute-force entries; use that to highlight *noise vs. signal*.
- Reinforce the importance of **log correlation** and **timeline building**.
- Stress that **containment timing** can make or break the success of incident response.


