# 🖥️ Linux Server Monitoring Automation Tool

### Automated Linux Server Monitoring with Telegram & Discord Alerts

A Bash-based Linux Server Monitoring Automation Tool that continuously monitors system resources, detects threshold violations, and sends real-time notifications through Telegram and Discord.

Built using Linux utilities, Bash scripting, and automation techniques to simplify server health monitoring without requiring expensive monitoring platforms.

---

## 🚀 Project Overview

Managing Linux servers requires continuous monitoring of system resources such as CPU, RAM, and disk utilization.

Manually checking server health is time-consuming and inefficient, especially when managing multiple workloads.

This project solves that problem by providing an automated monitoring solution that:

- Monitors CPU utilization.
- Tracks RAM usage.
- Checks disk space utilization.
- Collects system load information.
- Monitors server uptime.
- Detects resource utilization above configured thresholds.
- Sends alerts through Telegram and Discord.
- Automatically executes monitoring tasks using Linux Cron Jobs.
- Maintains monitoring logs for troubleshooting and analysis.

The goal is to demonstrate practical Linux administration, Bash scripting, and DevOps automation concepts through a real-world project.

---

## ✨ Features

| Feature | Description |
|---|---|
| CPU Monitoring | Tracks CPU utilization using `/proc/stat`. |
| RAM Monitoring | Monitors memory utilization using `free`. |
| Disk Monitoring | Checks root filesystem utilization using `df`. |
| System Load | Collects current system load average. |
| Uptime Monitoring | Displays server uptime information. |
| Threshold Detection | Identifies resource usage exceeding configured limits. |
| Telegram Alerts | Sends automated notifications through Telegram Bot API. |
| Discord Alerts | Sends notifications through Discord Webhooks. |
| Automated Execution | Uses Cron Jobs for scheduled monitoring. |
| Logging | Stores monitoring activities and alerts in log files. |
| Configurable Thresholds | Allows users to customize resource usage limits. |

---

## 🏗️ Project Architecture

```text
                 LINUX SERVER
                      |
                      |
             Bash Monitoring Script
                      |
                      |
              Collect System Metrics
                      |
          ---------------------------
          |            |            |
         CPU          RAM          Disk
          |            |            |
          ---------------------------
                      |
                      |
               Threshold Checking
                      |
               Threshold Exceeded?
                      |
                -------------
                |           |
               YES          NO
                |           |
          Generate Alert   Normal
                |
          Notification System
                |
          -------------------
          |                 |
       Telegram           Discord
          |                 |
          -------------------
                |
          Alert Received
```

### Monitoring Workflow

1. The monitoring script starts execution.
2. System metrics are collected from Linux utilities and system files.
3. Collected metrics are compared against configured thresholds.
4. If a threshold is exceeded, an alert message is generated.
5. The notification module sends alerts to Telegram and Discord.
6. Monitoring activities are recorded in log files.
7. Cron automatically executes the script at configured intervals.

---

## 🛠️ Technologies Used

| Technology | Purpose |
|---|---|
| Linux (Ubuntu) | Operating System |
| Bash Scripting | Monitoring Automation |
| `/proc/stat` | CPU Statistics |
| `free` | Memory Monitoring |
| `df` | Disk Monitoring |
| `awk` | Data Processing and Calculations |
| `curl` | HTTP API Requests |
| `jq` | JSON Processing |
| Telegram Bot API | Telegram Notifications |
| Discord Webhooks | Discord Notifications |
| Cron | Scheduled Automation |
| Git & GitHub | Version Control |

---

## 📁 Project Structure

```text
linux-server-monitor/
│
├── monitor.sh
│
├── .env
│
├── .gitignore
│
└── logs/
    │
    └── monitor.log
```

### File Description

| File / Directory | Description |
|---|---|
| `monitor.sh` | Main Bash monitoring script. |
| `.env` | Stores notification credentials and monitoring thresholds. |
| `.gitignore` | Prevents sensitive files and logs from being committed. |
| `logs/` | Stores monitoring execution logs. |
| `monitor.log` | Contains monitoring activities and generated alerts. |

---

## ⚙️ Installation & Setup

### 1. Clone the Repository

```bash
git clone https://github.com/YOUR_USERNAME/linux-server-monitor.git
```

Navigate to the project directory:

```bash
cd linux-server-monitor
```

### 2. Install Dependencies

Update the package repositories:

```bash
sudo apt update
```

Install the required dependencies:

```bash
sudo apt install curl jq bc -y
```

Verify the installations:

```bash
curl --version
jq --version
bc --version
```

### 3. Configure Environment Variables

Create the environment configuration file:

```bash
nano .env
```

Add the following configuration:

```bash
# Telegram Configuration

TELEGRAM_BOT_TOKEN="YOUR_TELEGRAM_BOT_TOKEN"

TELEGRAM_CHAT_ID="YOUR_TELEGRAM_CHAT_ID"


# Discord Configuration

DISCORD_WEBHOOK_URL="YOUR_DISCORD_WEBHOOK_URL"


# Monitoring Thresholds

CPU_THRESHOLD=80

RAM_THRESHOLD=80

DISK_THRESHOLD=85
```

Replace the placeholder values with your actual credentials.

**Important:** Never expose your Telegram Bot Token or Discord Webhook URL publicly.

### 4. Configure File Permissions

Protect the environment configuration file:

```bash
chmod 600 .env
```

Make the monitoring script executable:

```bash
chmod +x monitor.sh
```

### 5. Create Logs Directory

```bash
mkdir -p logs
```

---

## 📲 Telegram Integration

This project uses the official Telegram Bot API to send automated server monitoring notifications.

### Setup Instructions

1. Open Telegram.
2. Search for `@BotFather`.
3. Create a new bot using `/newbot`.
4. Copy the generated Bot Token.
5. Start a conversation with your newly created bot.
6. Retrieve your Chat ID using the Telegram Bot API.
7. Add both credentials to the `.env` file.

Official Documentation:

https://core.telegram.org/bots/api

---

## 💬 Discord Integration

Discord Webhooks are used to deliver automated monitoring notifications to a configured Discord channel.

### Setup Instructions

1. Open your Discord server.
2. Navigate to Server Settings.
3. Open Integrations.
4. Select Webhooks.
5. Create a new Webhook.
6. Select the notification channel.
7. Copy the Webhook URL.
8. Add the URL to your `.env` configuration file.

Official Documentation:

https://support.discord.com/hc/en-us/articles/228383668-Intro-to-Webhooks

---

## ▶️ Running the Monitoring Script

Execute the monitoring script manually:

```bash
./monitor.sh
```

The script collects system metrics, checks configured thresholds, and generates notifications when required.

### Example Terminal Output

```text
Starting system monitoring

Hostname: ubuntu-server

CPU Usage: 35.4%

RAM Usage: 42.6%

Disk Usage: 65%

System Load: 0.45

Uptime: up 2 hours

All system metrics are within normal limits

Monitoring completed successfully
```

*Output values are illustrative examples.*

---

## 🔔 Monitoring Threshold Configuration

Resource utilization thresholds can be customized through the `.env` file.

Example:

```bash
CPU_THRESHOLD=80

RAM_THRESHOLD=80

DISK_THRESHOLD=85
```

### Example Alert Conditions

| Resource | Configured Threshold | Alert Condition |
|---|---:|---|
| CPU | 80% | CPU usage ≥ 80% |
| RAM | 80% | RAM usage ≥ 80% |
| Disk | 85% | Disk usage ≥ 85% |

When a configured threshold is reached or exceeded, the monitoring script generates an alert.

---

## ⏰ Automating Monitoring with Cron

To automate monitoring, configure a Linux Cron Job.

### Step 1: Open Crontab

```bash
crontab -e
```

### Step 2: Add the Cron Schedule

```bash
*/5 * * * * /bin/bash /absolute/path/linux-server-monitor/monitor.sh
```

Replace the example path with your actual project path.

### Cron Expression Explained

```text
*/5 * * * *
```

| Field | Value | Meaning |
|---|---|---|
| Minute | `*/5` | Every 5 minutes |
| Hour | `*` | Every hour |
| Day | `*` | Every day |
| Month | `*` | Every month |
| Weekday | `*` | Every weekday |

Now the monitoring script will execute automatically every five minutes.

Make sure the Cron service is running:

```bash
sudo systemctl enable --now cron
```

---

## 📊 Monitoring Logs

All monitoring activities are stored in:

```text
logs/monitor.log
```

View complete logs:

```bash
cat logs/monitor.log
```

View the latest 20 entries:

```bash
tail -n 20 logs/monitor.log
```

Monitor logs in real time:

```bash
tail -f logs/monitor.log
```

Logs help troubleshoot execution problems and understand server monitoring activities.

---

## 🧪 Testing & Validation

To test the notification system, temporarily lower the configured thresholds.

Example:

```bash
CPU_THRESHOLD=1

RAM_THRESHOLD=1

DISK_THRESHOLD=1
```

Execute the monitoring script:

```bash
./monitor.sh
```

The low thresholds should trigger alerts under normal system conditions.

Verify that notifications are received on both Telegram and Discord.

After testing, restore your original threshold values.

---

## 🔐 Security Considerations

Security is important when working with server automation and external APIs.

Follow these practices:

- Never commit `.env` files to GitHub.
- Never expose Telegram Bot Tokens publicly.
- Never share Discord Webhook URLs.
- Use appropriate Linux file permissions.
- Restrict access to monitoring logs.
- Use secure credential management in production environments.
- Rotate credentials immediately if they are accidentally exposed.

Recommended `.gitignore` configuration:

```gitignore
.env
logs/
```

---

## ⚠️ Current Limitations

This project is an educational monitoring automation tool and has some limitations:

- Disk monitoring currently checks the root filesystem (`/`).
- Monitoring is based on configured resource thresholds.
- Repeated alerts can occur when a resource remains above its threshold.
- Alert cooldown and recovery notifications are not implemented.
- Multiple-server centralized monitoring is not included.
- Monitoring depends on server connectivity for external notifications.

This project is not intended to replace enterprise monitoring platforms.

---

## 🔮 Future Improvements

Planned enhancements for future versions:

- [ ] Network traffic monitoring.
- [ ] Linux service monitoring.
- [ ] Alert cooldown mechanism.
- [ ] Recovery notifications.
- [ ] Log rotation.
- [ ] Multiple server monitoring.
- [ ] Email notifications.
- [ ] Docker-based deployment.
- [ ] Centralized monitoring dashboard.
- [ ] Prometheus and Grafana integration.

---

## 🎯 Learning Outcomes

By building this project, you will gain practical experience with:

- Linux system administration.
- Bash scripting and automation.
- Linux process and resource monitoring.
- CPU, RAM, and disk utilization.
- Linux `/proc` filesystem.
- Environment variables and configuration management.
- HTTP requests and REST API integration.
- JSON processing.
- Telegram Bot API integration.
- Discord Webhook integration.
- Linux Cron Jobs.
- File permissions and security.
- Git and GitHub workflows.

---

## 👨‍💻 Author

**Ajay Yadav**

Aspiring DevOps & MLOps Engineer

Interested in Linux, Automation, Cloud Infrastructure, DevOps, and MLOps.

---

## ⭐ Support

If you find this project useful, consider giving it a ⭐ on GitHub.

Your support and feedback are appreciated!

---

**Built with ❤️ using Linux & Bash Scripting.**
