#!/bin/sh

SUPPORTED_NETWORKS="mainnet holesky"
EXTRA_OPTS="${EXTRA_OPTS:-}"

_validate_env_is_set() {
  env_name="$1"
  env_value="$2"

  if [ -z "$env_value" ]; then
    echo "[INFO - entrypoint] No value has been set for ${env_name}. Exiting..."
    sleep 60
    exit 1
  fi
}

setup_mev_boost() {
  # Relay urls - single entry or comma-separated list (scheme://pubkey@host)
  # The format validation is made by the MEV Boost binary
  _validate_env_is_set "RELAYS" "${RELAYS}"
  _validate_env_is_set "NETWORK" "${NETWORK}"

  # Check if the network is supported
  if ! echo "${SUPPORTED_NETWORKS}" | grep -q "${NETWORK}"; then
    echo "[INFO - entrypoint] The network '${NETWORK}' is not supported. Exiting."
    sleep 60
    exit 1
  fi

  EXTRA_OPTS="${EXTRA_OPTS} -${NETWORK}"
}

run_mev_boost() {
  flags="-addr 0.0.0.0:18550 \
    -relay-check \
    -relays $RELAYS $EXTRA_OPTS"

  echo "[INFO - entrypoint] Starting MEV Boost with flags: $flags"

  # shellcheck disable=SC2086
  exec /app/mev-boost $flags
}

setup_mev_boost
run_mev_boost
