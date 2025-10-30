# 🧩 Cybersecurity Exercise — Incident Response Investigation

## Scenario

You are part of your organization’s **Incident Response Team**.  
Earlier this morning, the SOC (Security Operations Center) detected **unusual web traffic** coming from a production web server (`web1`).  
Initial alerts suggested a possible **PHP upload and execution** event.

You have been provided with four log files from the affected host:

- `access.log` — Web server access history  
- `auth.log` — Authentication attempts and logins  
- `syslog` — System events and process activity  
- `ids.log` — Intrusion Detection System alerts  

Your job is to:
1. Analyze the logs to find indicators of compromise.
2. Determine which phase of the **Incident Response Lifecycle** the team is in.
3. Recommend appropriate next steps through the remaining phases.


## 🧭 The Incident Response Lifecycle

| **Phase** | **Goal** |
|------------|----------|
| **Identification** | Detect and verify that an incident has occurred. |
| **Containment** | Limit the spread or impact of the incident. |
| **Eradication** | Remove the root cause and any malicious artifacts. |
| **Recovery** | Restore systems and services safely. |
| **Preparation (Lessons Learned)** | Improve defenses and readiness to prevent future incidents. |


## 🕵️ Part 1: Identification

**Task:** Examine the four log files and list your findings that indicate potential malicious activity.

| **Evidence Found** | **Log Source** | **Timestamp(s)** | **Why It’s Suspicious** |
|---------------------|----------------|------------------|--------------------------|
| Example: `POST /upload.php` from 203.0.113.42 | `access.log` | 08:08:04 | Suggests someone uploaded a file to the server |
| | | | |
| | | | |

**Questions:**
1. What patterns or anomalies do you notice across multiple logs?  
2. Which IP addresses appear suspicious?  
3. Is there evidence that the attacker successfully executed code?


## 🔒 Part 2: Containment

**Task:** Once the compromise is confirmed, identify the steps you would take to **contain** the incident.

| **Containment Action** | **Goal / Justification** |
|-------------------------|--------------------------|
| Example: Disconnect the web server from the network | Prevent further attacker access or data exfiltration |
| | |
| | |

**Questions:**
1. Which connections or processes should be stopped first?  
2. What volatile evidence should be preserved before taking containment actions?


## 🧹 Part 3: Eradication

**Task:** List actions needed to remove the attacker’s access and the root cause of the incident.

| **Eradication Step** | **What It Accomplishes** |
|-----------------------|--------------------------|
| Example: Delete `/var/www/html/uploads/README.php` | Removes the webshell used by the attacker |
| | |
| | |

**Questions:**
1. What vulnerabilities allowed this compromise?  
2. What configuration or patch changes are required?


## ⚙️  Part 4: Recovery

**Task:** Plan how to safely return the system to operation.

| **Recovery Step** | **Goal / Validation Method** |
|--------------------|------------------------------|
| Example: Restore server from known-good backup | Ensures the system is clean before reconnecting to the network |
| | |
| | |

**Questions:**
1. How can you confirm the system is no longer compromised?  
2. What monitoring should remain in place after recovery?


## 🛡️ Part 5: Preparation & Lessons Learned

**Task:** Reflect on how your organization could improve to prevent similar incidents in the future.

| **Improvement Area** | **Recommendation** |
|-----------------------|--------------------|
| Example: Web application hardening | Restrict uploads to non-executable file types |
| | |
| | |

**Questions:**
1. What policy, procedure, or control failed or was missing?  
2. What would have allowed faster detection or response?  
3. How would you update your IR plan or runbook after this event?

---

## 🧾 Optional Challenge

1. Reconstruct the **timeline of the attack** from start to finish using timestamps across logs.  
2. Identify which log gave the *earliest* indication of compromise.  
3. Determine what data or system access the attacker could have gained if the intrusion went unnoticed.


