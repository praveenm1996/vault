path "secret/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

# Allow access to all KV v2 secret engines
path "secret/data/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "secret/metadata/*" {
  capabilities = ["list", "read"]
}

# Allow access to all paths in other secret engines (e.g., kv, database, etc.)
path "sys/mounts/*" {
  capabilities = ["read", "list"]
}

path "*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}