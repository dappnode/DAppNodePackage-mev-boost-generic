#!/bin/sh

SUPPORTED_NETWORKS="mainnet holesky"
EXTRA_OPTS="${EXTRA_OPTS:-}"

validate_env_is_set() {
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
  validate_env_is_set "RELAYS" "${RELAYS}"
  validate_env_is_set "NETWORK" "${NETWORK}"

  # Check if the network is supported
  if ! echo "${SUPPORTED_NETWORKS}" | grep -q "${NETWORK}"; then
    echo "[INFO - entrypoint] The network '${NETWORK}' is not supported. Exiting."
    sleep 60
    exit 1
  fi

  EXTRA_OPTS="${EXTRA_OPTS} -${NETWORK}"
}

run_mev_boost() {
  echo "[INFO - entrypoint] Starting MEV Boost with relays: ${RELAYS}"

  # shellcheck disable=SC2086
  exec /app/mev-boost -addr 0.0.0.0:18550 \
    -relay-check \
    -relays "${RELAYS}" ${EXTRA_OPTS}
}

setup_mev_boost
run_mev_boost
