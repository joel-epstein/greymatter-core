package greymatter

let Name = defaults.redis_cluster_name
let RedisIngressName = "\(Name)_ingress"

redis_config: [
	// Redis TCP ingress
	#domain & { 
    domain_key: RedisIngressName
    port: defaults.ports.redis_ingress
  },
	#cluster & {
		cluster_key: RedisIngressName, _upstream_port: 6379
		_enable_circuit_breakers: true
		circuit_breakers: {
			max_connections:      4096
			max_pending_requests: 4096
			max_requests:         4096
			max_retries:          2
			max_connection_pools: 4096
			track_remaining:      false
		}	
	},
	// unused route must exist for the cluster to be registered
	#route & {route_key: RedisIngressName},
	// see below for details on this listener config
	redis_listener_object,
	#proxy & {
		proxy_key: Name
		domain_keys: [RedisIngressName]
		listener_keys: [RedisIngressName]
	},
]

// The Redis listener is special among greymatter config because we have to update it with new Spire
// configuration every time we add a sidecar to the mesh (for metrics beacons). That's why it's separated
// out here: We need to be able to unify a new defaults.sidecar_list and re-apply this listener.
redis_listener_object: #listener & {
	listener_key: RedisIngressName
	port:         defaults.ports.redis_ingress
	// this _actually_ connects the cluster to the listener
	_tcp_upstream: RedisIngressName
	// custom secret instead of listener helpers because we need to accept multiple subjects in this listener
	if config.spire {
		secret: #spire_secret & {
			_name:     Name
			_subjects: defaults.sidecar_list
		}
	}
}
