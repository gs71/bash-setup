#!/bin/bash
PATH=/usr/bin:/usr/sbin
LANG=C

SEP="--------------------------------------------------------------------------------"
LOGFILE="/home/svc_supcockpit/maj.log"

function title {
  (
  echo $SEP
  echo "$1"
  echo $SEP
  ) | tee -a $LOGFILE
}

function logprint {
  echo "[$(date '+%F %X')] $1" | tee -a $LOGFILE
}

if [ -e "$LOGFILE" ]; then
  echo "Renaming $LOGFILE"
  mv $LOGFILE{,-$(date '+%F_%X')}
fi

touch $LOGFILE

logprint "Update script $0 started"

title "APT update"
logprint "Starting apt-get update"
apt-get update | tee -a $LOGFILE

title "APT upgrade"
logprint "Starting apt-get upgrade"
#apt-get -y upgrade | tee -a $LOGFILE

title "APT purge"
logprint "Starting apt-get purge"
apt-get -y purge ~c | tee -a $LOGFILE

title "Systemd services"
systemctl list-units --full --type=service | grep '\.service ' | tee -a $LOGFILE

title "System information"
echo; df -h -T -x fuse.snapfuse -x tmpfs -x overlay
echo; echo "Memory:"; free -h

title "ALERTES"
(
echo "Hostname: $(hostname)"
echo "OS: $(lsb_release -ds 2> /dev/null)"
echo "Kernel: $(uname -r)"
echo "Uptime: $(uptime -p)"
echo "APT packages: $(dpkg --list | grep -c ^ii)"
[ -x /usr/bin/snap] && echo "Snap packages: $(snap list | grep -c -v ^Name)"
timedatectl | sed 's/^[ \t]*//'
) | tee -a $LOGFILE

title "APT details"
grep '^\[' $LOGFILE | tee -a $LOGFILE

LAST_KERNEL=$(dpkg -l | grep "linux-image-[^g]" | grep ^ii | cut -d " " -f 3 | sort | tail -n 1)
if [[ -n "$LAST_KERNEL" && "$(uname -r)" != "$LAST_KERNEL" ]]; then
  echo
  echo "WARNING: kernel $LAST_KERNEL has been installed: reboot needed!" | tee -a $LOGFILE
  echo
fi

APT_ERRORS=$(grep -E '(error|Err:|cannot|failed to write)' $LOGFILE)
if [ -n "$APT_ERRORS" ]; then
  title "APT errors"
  echo "$APT_ERRORS" | tee -a $LOGFILE
fi

FAILED_SERVICES=$(grep "\.service .* failed " $LOGFILE)
if [ -n "$FAILED_SERVICES" ]; then
  title "Systemd failed services"
  echo "$FAILED_SERVICES" | tee -a $LOGFILE
fi

SYSTEMD_ERRORS=$(journalctl --no-pager -p err --since today)
if [ -n "$SYSTEMD_ERRORS" ]; then
  title "Systemd errors"
  echo "$SYSTEMD_ERRORS" | tee -a $LOGFILE
fi
