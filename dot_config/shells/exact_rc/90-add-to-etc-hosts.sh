add-static-host() {
  if [ $# -ne 1 ]; then
    echo "Usage: add-static-host <hostname>"
    return 1
  fi

  local hostname="$1"
  echo "[*] Resolving $hostname using getent, drill, dig"

  # Initialize variables
  local getent_ip=""
  local drill_ip=""
  local dig_ip=""

  # Resolve using getent
  if command -v getent >/dev/null 2>&1; then
    getent_ip=$(getent ahosts "$hostname" | awk '/STREAM/ { print $1; exit }')
    echo "[*] getent: $getent_ip"
  else
    echo "[!] getent: not found"
  fi

  # Resolve using drill
  if command -v drill >/dev/null 2>&1; then
    drill_ip=$(drill "$hostname" | awk '/^;; ANSWER SECTION:/ { getline; print $5; exit }')
    echo "[*] drill: $drill_ip"
  else
    echo "[!] drill: not found"
  fi

  # Resolve using dig
  if command -v dig >/dev/null 2>&1; then
    dig_ip=$(dig +short "$hostname" | head -n 1)
    echo "[*] dig: $dig_ip"
  else
    echo "[!] dig: not found"
  fi

  # Select preferred IP (IPv4 if available)
  local preferred_ip=""
  for ip in "$drill_ip" "$getent_ip" "$dig_ip"; do
    if [[ $ip =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
      preferred_ip="$ip"
      break
    fi
  done

  # If no IPv4 found, use any IP
  if [ -z "$preferred_ip" ]; then
    preferred_ip="${drill_ip:-${getent_ip:-${dig_ip}}}"
  fi

  if [ -z "$preferred_ip" ]; then
    echo "[!] Could not resolve IP address for $hostname"
    return 1
  fi

  echo "[ ] Adding ipv4: $preferred_ip as the preferred IP"
  echo "[ ] Removing reference to $hostname from /etc/hosts"

  # Backup /etc/hosts
  sudo cp /etc/hosts /etc/hosts.bak

  # Remove existing entries for the hostname
  sudo sed -i "/[[:space:]]$hostname$/d" /etc/hosts

  echo "[ ] Appending to /etc/hosts"
  echo "$preferred_ip $hostname" | sudo tee -a /etc/hosts >/dev/null
}
