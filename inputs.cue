package greymatter

import (
	corev1 "k8s.io/api/core/v1"
	"github.com/greymatter-io/common/api/meshv1"
)

config: {
	// Flags
	// use Spire-based mTLS (ours or another)
	spire: bool | *false @tag(spire,type=bool)
	// deploy our own server and agent
	deploy_spire: bool | *spire @tag(use_spire,type=bool)
	// if we're deploying into OpenShift, request extra permissions
	openshift: bool | *false @tag(openshift,type=bool)
	// deploy and configure Prometheus for historical metrics in the Dashboard
	enable_historical_metrics: bool | *true @tag(enable_historical_metrics,type=bool)
	// deploy and configure audit pipeline for observability telemetry
	enable_audits: bool | *true @tag(enable_audits,type=bool)
	// deploy and configure Keycloak for oAuth and user identity management
	enable_keycloak: bool | *false @tag(enable_keycloak,type=bool)
	// whether to automatically copy the image pull secret to watched namespaces for sidecar injection
	auto_copy_image_pull_secret: bool | *true @tag(auto_copy_image_pull_secret, type=bool)
	// namespace the operator will deploy into
	operator_namespace: string | *"gm-operator" @tag(operator_namespace, type=string)

	cluster_ingress_name: string | *"cluster" // For OpenShift deployments, this is used to look up the configured ingress domain

	// currently just controls k8s/outputs/operator.cue for debugging
	debug: bool | *false @tag(debug,type=bool)
	// test=true turns off GitOps, telling the operator to use the baked-in CUE
	test: bool | *false @tag(test,type=bool) // currently just turns off GitOps so CI integration tests can manipulate directly
}

mesh: meshv1.#Mesh & {
	metadata: {
		name: string | *"greymatter-mesh"
	}
	spec: {
		install_namespace: string | *"greymatter"
		watch_namespaces:  [...string] | *["default", "examples", "foobar-1", "foobar-2", "foobar-3", "foobar-4", "foobar-5", "foobar-6", "foobar-7", "foobar-8", "foobar-9", "foobar-10", "foobar-11", "foobar-12"]
		images: {
			proxy:       string | *"greymatter.jfrog.io/oci/greymatter-proxy:1.8.1"
			catalog:     string | *"greymatter.jfrog.io/oci/greymatter-catalog:3.0.8"
			dashboard:   string | *"greymatter.jfrog.io/oci/greymatter-dashboard:6.0.6"
			control:     string | *"greymatter.jfrog.io/oci/greymatter-control:1.8.3"
			control_api: string | *"greymatter.jfrog.io/oci/greymatter-control-api:1.8.3"
			redis:       string | *"index.docker.io/library/redis:6.2.7"
			prometheus:  string | *"index.docker.io/prom/prometheus:v2.40.1"
		}
	}
}

defaults: {
	image_pull_secret_name: string | *"gm-docker-secret"
	image_pull_policy:      corev1.#enumPullPolicy | *corev1.#PullAlways
	xds_host:               "controlensemble.\(mesh.spec.install_namespace).svc.cluster.local"
	sidecar_list:           [...string] | *["dashboard", "catalog", "controlensemble", "edge", "redis", "prometheus", "jwtsecurity", "observables"]
	proxy_port_name:        "proxy" // the name of the ingress port for sidecars - used by service discovery
	redis_cluster_name:     "greymatter-datastore"
	redis_host:             "\(redis_cluster_name).\(mesh.spec.install_namespace).svc.cluster.local"
	redis_port:             6379
	redis_db:               0
	redis_username:         ""
	redis_password:         ""
	// key names for applied-state backups to Redis - they only need to be unique.
	gitops_state_key_gm:      "\(config.operator_namespace).gmHashes"
	gitops_state_key_k8s:     "\(config.operator_namespace).k8sHashes"
	gitops_state_key_sidecar: "\(config.operator_namespace).sidecarHashes"

	ports: {
		default_ingress: 10808
		edge_ingress:    defaults.ports.default_ingress
		redis_ingress:   10910
		metrics:         8081
	}

	images: {
		cli:               string | *"greymatter.jfrog.io/oci/greymatter-cli:4.5.7"
		operator:          string | *"greymatter.jfrog.io/oci/greymatter-operator:0.14.0" @tag(operator_image)
		vector:            string | *"timberio/vector:0.22.0-debian"
		observables:       string | *"greymatter.jfrog.io/oci/greymatter-audits:1.1.5"
		keycloak:          string | *"quay.io/keycloak/keycloak:19.0.3"
		keycloak_postgres: string | *"postgres:15.0"
	}

	// The external_host field instructs greymatter to install Prometheus or
	// uses an external one. If enable_historical_metrics is true and external_host
	// is empty, then greymatter will install Prometheus into the greymatter
	// namespace. If enable_historical_metrics is true and external_host has a
	// value, greymatter will not install Prometheus into the greymatter namespace
	// and will connect to the external Prometheus via a sidecar
	// (e.g. external_host: prometheus.metrics.svc).
	prometheus: {
		external_host: ""
		port:          9090
		tls: {
			enabled:     false
			cert_secret: "gm-prometheus-certs"
		}
	}

	// audits configuration applies to greymatter's observability pipeline and are
	// used when config.enable_audits is true.  
	audits: {
		// index determines the index ID in Elasticsearch. The default naming convention
		// will generate a new index each month. The index configuration can be changed
		// to create more or less indexes depending on your storage and performance requirements.
		index: "gm-audits-%Y-%m"
		// elasticsearch_host can be an IP address or DNS hostname to your Elasticsearch instance.
		// It's set to a non-empty value so that the audit-pipeline starts successfully.
		elasticsearch_host: "738aae73258b4cbe860493454f601052.centralus.azure.elastic-cloud.com"
		// elasticsearch_port is the port of your Elasticsearch instance.
		elasticsearch_port: 443
		// elasticsearch_endpoint is the full endpoint containing protocol, host, and port
		// of your Elasticsearch instance. This is used by to sync audit data
		// with Elasticsearch.
		elasticsearch_endpoint: "https://\(elasticsearch_host):\(elasticsearch_port)"
		// Default Elasticsearch password secret name.
		elasticsearch_password_secret: "elasticsearch-password"
		// elasticsearch_tls_verify_certificate determines if the audit agent verifies
		// Elasticsearch's TLS certificate during the TLS handshake. If your Elasticsearch is
		// using a self-signed certificate, set this to false.
		elasticsearch_tls_verify_certificate: false
	}

	// Keycloak configuration for a Keycloak instance installed into the
	// the greymatter mesh. These configurations are only relevant to Keycloak
	// inside the mesh, not an externally hosted Keycloak instance. These
	// configurations will be used when enable_keycloak is true.
	keycloak: {
		// database_name: name of Postgres database
		database_name: "keycloak"
		// database_user: user for Postgres database
		database_user: "keycloak"
		// database_ingress_port: port for sidecar ingress to Postgres
		database_ingress_port: 10809
		// database_egress_cluster is the name of the cluster used by the
		// Keycloak sidecar to send requests out to the Keycloak database's
		// sidecar.
		database_egress_cluster: "keycloak-postgres_egress"
		// keycloak_postgres_cluster_name: upstream cluster name for sidecar
		// egress from Keycloak to Postgres
		keycloak_postgres_cluster_name: "keycloak-postgres"
		// Default Keycloak admin password secret name
		keycloak_admin_secret: "keycloak-admin-password"
		// Default Keycloak Postgres password secret name
		keycloak_postgres_secret: "keycloak-postgres-password"
	}

	edge: {
		key: "edge"
		// edge.enable_tls toggles internal mtls connections between greymatter core components
		// by default the internal and external secrets are the same however if you want to
		// have different certs for the ingress and internal connections (this is the case for prod)
		// then you will need to add those certs to another secret and specity that
		// below at defaults.core_internal_tls_certs.cert_secret.
		enable_tls:  false
		secret_name: "gm-edge-ingress-certs"
		oidc: {
			// upstream_host is the FQDN of your OIDC service.
			upstream_host: "foobar.oidc.com"
			// upstream_port is the port your OIDC service is listening on.
			upstream_port: 443
			// endpoint is the protocol, host, and port of your OIDC service.
			// If the upstream_port is 443, it's unnecessary to provide it. If
			// the upstream_port is not 443, you must provide it with: "https://\(upstream_host):\(upstream_port)".
			endpoint: "https://\(upstream_host)"
			// edge_domain is the FQDN of your edge service. It's used by
			// greymatter's OIDC filters, and will be used to redirect the user
			// back to the mesh, upon successful authentication.
			edge_domain: "foobar.com"
			// realm is the ID of a realm in your OIDC provider.
			realm: "greymatter"
			// client_id is the ID of a client in a realm in your OIDC provider.
			client_id: "greymatter"
			// client_secret is the secret key of a client in a realm in your
			// OIDC provider. 
			client_secret: ""
			// enable_remote_jwks is a toggle that automatically enables remote
			// JSON Web Key Sets (JWKS) verification with your OIDC provider.
			// Alternatively, you can disable this and use local_jwks below.
			// It's advised to enable remote JWKS because it is reslient to 
			// key rotation.
			enable_remote_jwks: false
			// remote_jwks_cluster is the name of the egress cluster used by
			// the edge proxy to make connections to your OIDC service.
			remote_jwks_cluster: "edge_egress_to_oidc"
			// remote_jwks_egress_port is the port used by the edge proxy to make egress
			// connections to your upstream OIDC service's JWKS endpoint. This is fairly
			// static and you should not have to change the value.
			remote_jwks_egress_port: 8443
			// jwt_authn_provider contains configuration for JWT authentication.
			// This is used in conjunction with remote JWKS or local JWKS.
			jwt_authn_provider: {
				keycloak: {
					audiences: ["greymatter"]
					// If using local JWKS verification, disable enable_remote_jwks above and
					// uncomment local_jwks below. You will need to paste the JWKS JSON
					// from your OIDC provider inside the inline_string's starting and ending
					// triple quotes.
					// local_jwks: {
					//  inline_string: #"""
					//   {}
					//   """#
					// }
				}
			}
		}
	} // edge

	spire: {
		// Namespace of the Spire server
		namespace: "spire"
		// Trust domain must match what's configured at the server
		trust_domain: "greymatter.io"
		// The mount path of the spire socket for communication with the agent
		socket_mount_path: "/run/spire/socket"
		// When config.deploy_spire=true, we inject a secret. This sets the name of that secret
		ca_secret_name: "server-ca"
		// should we request a host mount for the socket, or normal volume mount? If true, also requests hostPID permission
		host_mount_socket: true
	}

	core_internal_tls_certs: {
		// use npe cert for internal mtls
		// Name of kubernetes secret to be mounted
		cert_secret: string | *defaults.edge.secret_name
	}

} // defaults
