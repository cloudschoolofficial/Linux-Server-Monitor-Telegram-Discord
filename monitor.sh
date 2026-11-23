#!/bin/bash

set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

CONFIG_FILE="$SCRIPT_DIR/monitor.conf"

LOG_DIR="$SCRIPT_DIR/logs"

STATE_DIR="$SCRIPT_DIR/state"

LOG_FILE="$LOG_DIR/monitor.log"

HOSTNAME="$(hostname -s)"

#Step 2 Directory Creation and Configuration Loading

mkdir -p "$LOG_DIR" "$STATE_DIR"

if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "Configuration file not found!"
    exit 1
fi

source "$CONFIG_FILE"

#Step 3Logging Function

log() {
    local MESSAGE="$1"

    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $MESSAGE" \
    | tee -a "$LOG_FILE"
}

#Step 4 Error Handling

trap 'log "ERROR: Script failed at line $LINENO"' ERR


#Step 5 CPU Monitoring

get_cpu_usage() {

    local USER_1 NICE_1 SYSTEM_1 IDLE_1 IOWAIT_1 IRQ_1 SOFTIRQ_1 STEAL_1
    local USER_2 NICE_2 SYSTEM_2 IDLE_2 IOWAIT_2 IRQ_2 SOFTIRQ_2 STEAL_2

    read -r _ USER_1 NICE_1 SYSTEM_1 IDLE_1 IOWAIT_1 IRQ_1 SOFTIRQ_1 STEAL_1 _ _ < /proc/stat

    local TOTAL_1=$((USER_1 + NICE_1 + SYSTEM_1 + IDLE_1 + IOWAIT_1 + IRQ_1 + SOFTIRQ_1 + STEAL_1))

    local IDLE_TOTAL_1=$((IDLE_1 + IOWAIT_1))

    sleep 1

    read -r _ USER_2 NICE_2 SYSTEM_2 IDLE_2 IOWAIT_2 IRQ_2 SOFTIRQ_2 STEAL_2 _ _ < /proc/stat

    local TOTAL_2=$((USER_2 + NICE_2 + SYSTEM_2 + IDLE_2 + IOWAIT_2 + IRQ_2 + SOFTIRQ_2 + STEAL_2))

    local IDLE_TOTAL_2=$((IDLE_2 + IOWAIT_2))

    local TOTAL_DIFF=$((TOTAL_2 - TOTAL_1))

    local IDLE_DIFF=$((IDLE_TOTAL_2 - IDLE_TOTAL_1))

    if (( TOTAL_DIFF <= 0 )); then
        echo 0
        return
    fi

    awk -v total="$TOTAL_DIFF" -v idle="$IDLE_DIFF" \
    'BEGIN { printf "%.0f", ((total-idle)/total)*100 }'
}    

#Step 6 Memory Monitoring


get_memory_usage() {

    awk '
    /MemTotal:/ {
        TOTAL=$2
    }

    /MemAvailable:/ {
        AVAILABLE=$2
    }

    END {
        if (TOTAL > 0) {
            printf "%.0f", ((TOTAL - AVAILABLE) / TOTAL) * 100
        }
        else {
            print 0
        }
    }
    ' /proc/meminfo
}


#Step 7 Disk Monitoring

get_disk_usage() {

    df -P / | awk 'NR==2 {
        gsub("%", "", $5)
        print $5
    }'
}

#STEP 8: Telegram and Discord Notification Function


send_alert() {

    local MESSAGE="$1"

    log "Sending Alert: $MESSAGE"

    if [[ -n "${TELEGRAM_BOT_TOKEN:-}" && -n "${TELEGRAM_CHAT_ID:-}" ]]; then

        if ! curl -fsS --max-time 10 \
            -X POST \
            "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" \
            -d "chat_id=${TELEGRAM_CHAT_ID}" \
            --data-urlencode "text=${MESSAGE}" >/dev/null
        then
            log "Telegram notification failed"
        fi

    fi

    if [[ -n "${DISCORD_WEBHOOK_URL:-}" ]]; then

        if ! curl -fsS --max-time 10 \
            -X POST \
            --data-urlencode "content=${MESSAGE}" \
            "$DISCORD_WEBHOOK_URL" >/dev/null
        then
            log "Discord notification failed"
        fi

    fi
}


#STEP 9: Threshold and Recovery Logic

check_metric() {

    local NAME="$1"
    local VALUE="$2"
    local THRESHOLD="$3"
    local UNIT="$4"

    local STATE_FILE="$STATE_DIR/${NAME}.state"

    local CURRENT_STATE
    local PREVIOUS_STATE="UNKNOWN"

    if [[ -f "$STATE_FILE" ]]; then
        PREVIOUS_STATE="$(cat "$STATE_FILE")"
    fi

    if (( VALUE >= THRESHOLD )); then
        CURRENT_STATE="ALERT"
    else
        CURRENT_STATE="OK"
    fi

    if [[ "$CURRENT_STATE" == "ALERT" && "$PREVIOUS_STATE" != "ALERT" ]]; then

        send_alert "CRITICAL: ${NAME} usage is ${VALUE}${UNIT}. Threshold: ${THRESHOLD}${UNIT}. Server: ${HOSTNAME}"

        log "${NAME} entered ALERT state."

    elif [[ "$CURRENT_STATE" == "OK" && "$PREVIOUS_STATE" == "ALERT" ]]; then

        send_alert "RECOVERY: ${NAME} usage is back to ${VALUE}${UNIT}. Server: ${HOSTNAME}"

        log "${NAME} recovered."

    fi

    echo "$CURRENT_STATE" > "$STATE_FILE"
}


#STEP 10: Main Monitoring Workflow

main() {

    log "======================================"

    log "Linux Server Monitoring Started"

    local CPU_USAGE
    local MEMORY_USAGE
    local DISK_USAGE

    CPU_USAGE="$(get_cpu_usage)"

    MEMORY_USAGE="$(get_memory_usage)"

    DISK_USAGE="$(get_disk_usage)"

    log "CPU Usage: ${CPU_USAGE}%"

    log "Memory Usage: ${MEMORY_USAGE}%"

    log "Disk Usage: ${DISK_USAGE}%"

    check_metric "CPU" "$CPU_USAGE" "$CPU_THRESHOLD" "%"

    check_metric "MEMORY" "$MEMORY_USAGE" "$MEMORY_THRESHOLD" "%"

    check_metric "DISK" "$DISK_USAGE" "$DISK_THRESHOLD" "%"

    log "Monitoring Completed Successfully"

    log "======================================"
}

main "$@"
