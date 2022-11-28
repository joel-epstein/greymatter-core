// greymatter configuration for Keycloak's sidecar

package greymatter

import (
	"strings"
)

let Name = "keycloak"
let KeycloakIngressName = "\(Name)_ingress"
let EgressToRedisName = "\(Name)_egress_to_redis"
let EgressToPostgresName = "\(Name)_egress_to_keycloak_postgres"

keycloak_config: [
	// Keycloak HTTP ingress
	#domain & {
		domain_key: KeycloakIngressName
		port:       defaults.edge.oidc.upstream_port
	},
	#listener & {
		listener_key:          KeycloakIngressName
		_spire_self:           Name
		_gm_observables_topic: Name
		_is_ingress:           true
		port:                  defaults.edge.oidc.upstream_port
	},
	#cluster & {cluster_key: KeycloakIngressName, _upstream_port: 8080},
	#route & {route_key:     KeycloakIngressName},

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

	// egress -> postgres
	#domain & {
		domain_key: EgressToPostgresName
		port:       defaults.keycloak.database_ingress_port
	},
	#cluster & {
		cluster_key:  EgressToPostgresName
		name:         defaults.keycloak.keycloak_postgres_cluster_name
		_spire_self:  Name
		_spire_other: defaults.keycloak.keycloak_postgres_cluster_name
	},
	// unused route must exist for the cluster to be registered with sidecar
	#route & {route_key: EgressToPostgresName},
	#listener & {
		listener_key: EgressToPostgresName
		// egress listeners are local-only
		ip:            "127.0.0.1"
		port:          defaults.keycloak.database_ingress_port
		_tcp_upstream: defaults.keycloak.keycloak_postgres_cluster_name
	},

	// shared proxy object
	#proxy & {
		proxy_key: Name
		domain_keys: [KeycloakIngressName, EgressToRedisName, EgressToPostgresName]
		listener_keys: [KeycloakIngressName, EgressToRedisName, EgressToPostgresName]
	},

	#catalog_entry & {
		name:                      "Keycloak"
		mesh_id:                   mesh.metadata.name
		service_id:                Name
		version:                   strings.Split(defaults.images.keycloak, ":")[1]
		description:               "Keycloak oAuth and user identity management service."
		api_endpoint:              defaults.edge.oidc.endpoint
		business_impact:           "critical"
		enable_instance_metrics:   true
		enable_historical_metrics: true
	},

	// Edge config for keycloak ingress
	#cluster & {
		cluster_key:  Name
		_spire_other: Name
	},

	#route & {
		domain_key: defaults.edge.key
		route_key:  Name
		route_match: {
			path: "/services/keycloak/"
		}
		redirects: [
			{
				from:          "^/services/keycloak$"
				to:            route_match.path
				redirect_type: "permanent"
			},
		]
		prefix_rewrite: "/"
	},
]
