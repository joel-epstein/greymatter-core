// greymatter configuration for Keycloak Postgres's sidecar

package greymatter

import (
	"strings"
)

let Name = defaults.keycloak.keycloak_postgres_cluster_name
let KeycloakPostgresIngressName = "\(Name)_ingress"
let EgressToRedisName = "\(Name)_egress_to_redis"

keycloak_postgres_config: [

	// TCP ingress
	#domain & {
		domain_key: KeycloakPostgresIngressName
		port:       defaults.keycloak.database_ingress_port
	},
	#listener & {
		listener_key:  KeycloakPostgresIngressName
		port:          defaults.keycloak.database_ingress_port
		_spire_self:   Name
		_tcp_upstream: KeycloakPostgresIngressName
	},
	#cluster & {cluster_key: KeycloakPostgresIngressName, _upstream_port: 5432},
	#route & {route_key:     KeycloakPostgresIngressName},

	// egress -> redis
	#domain & {
		domain_key: EgressToRedisName
		port:       defaults.ports.redis_ingress
	},
	#cluster & {
		cluster_key:  EgressToRedisName
		name:         defaults.redis_cluster_name
		_spire_self:  Name
		_spire_other: defaults.redis_cluster_name
	},
	// unused route must exist for the cluster to be registered with sidecar
	#route & {route_key: EgressToRedisName},
	#listener & {
		listener_key: EgressToRedisName
		// egress listeners are local-only
		ip:            "127.0.0.1"
		port:          defaults.ports.redis_ingress
		_tcp_upstream: defaults.redis_cluster_name
	},

	// shared proxy object
	#proxy & {
		proxy_key: Name
		domain_keys: [KeycloakPostgresIngressName, EgressToRedisName]
		listener_keys: [KeycloakPostgresIngressName, EgressToRedisName]
	},

	#catalog_entry & {
		name:                      "Keycloak Postgres"
		mesh_id:                   mesh.metadata.name
		service_id:                Name
		version:                   strings.Split(defaults.images.keycloak_postgres, ":")[1]
		description:               "Postgres database for Keycloak."
		api_endpoint:              "/services/\(Name)"
		business_impact:           "critical"
		enable_instance_metrics:   true
		enable_historical_metrics: true
	},

	// Edge config for ingress
	#cluster & {
		cluster_key:  Name
		_spire_other: Name
	},

	#route & {
		domain_key: defaults.edge.key
		route_key:  Name
		route_match: {
			path: "/services/\(Name)/"
		}
		redirects: [
			{
				from:          "^/services/\(Name)$"
				to:            route_match.path
				redirect_type: "permanent"
			},
		]
		prefix_rewrite: "/"
	},

]
