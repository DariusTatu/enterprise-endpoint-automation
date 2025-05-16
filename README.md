# Enterprise Endpoint Automation

This repo is a real-world showcase of automation solutions for enterprise-grade endpoint management. These are tools and scripts I’ve built or used in production to solve problems in environments with 10k+ macOS, Windows, iOS, and Android devices across multiple global regions.

💡 **Built by:** Darius Tatu – Endpoint Engineer | MDM Specialist | Automation-Driven

---

## 🔧 Projects

### ✅ Intune Autopilot Automation
> Automate the entire Windows device lifecycle: hash upload, profile assignment, and reboot into OOBE – all from script.

📁 `intune-autopilot-automation/`  
- `hash-upload-script.ps1`: Extract and upload device hash
- `assign-profile.ps1`: Auto-assign to Autopilot profile via Graph API

---

### ✅ Jamf Pro: LAPS Password Rotation + Secure Storage
> Rotate local admin passwords on macOS and store securely in a Vault or remote target.

📁 `jamf-laps-password-rotation/`  
- `rotate-password.sh`: Rotate local admin credentials on schedule
- `vault-integration-example.sh`: Send credentials to secure storage

---

### ✅ Conditional Access Policy Audit
> Export CA policies, report user compliance, and flag stale policies.

📁 `conditional-access-audit/`  
- `export-ca-policies.ps1`: Pull all policies via MS Graph
- `user-compliance-report.ps1`: Generate compliance CSV per user

---

## 💬 About Me

I'm an Endpoint Engineer working with Jamf Pro, Microsoft Intune, and Azure — designing secure, automated, and scalable environments. This repo is my way of showing what I build instead of just talking about it.

🔗 [LinkedIn](https://www.linkedin.com/in/tatu-petru-darius/)  
🛠️ [GitHub](https://github.com/DariusTatu)

---

## License

This project is licensed under the MIT License.
