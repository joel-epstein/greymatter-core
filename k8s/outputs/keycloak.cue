// Manifests for the Keycloak deployment

package greymatter

import (
	appsv1 "k8s.io/api/apps/v1"
	corev1 "k8s.io/api/core/v1"
	"encoding/json"
)

let Name = "keycloak"
keycloak: [
	appsv1.#Deployment & {
		apiVersion: "apps/v1"
		kind:       "Deployment"
		metadata: {
			name:      Name
			namespace: mesh.spec.install_namespace
		}
		spec: {
			selector: {
				matchLabels: {"greymatter.io/cluster": Name}
			}
			template: {
				metadata: {
					labels: {
						"greymatter.io/cluster":  Name
						"greymatter.io/workload": "\(config.operator_namespace).\(mesh.metadata.name).\(Name)"
					}
				}
				spec: #spire_permission_requests & {
					containers: [
						#sidecar_container_block & {
							_Name: Name
							ports: [{
								// keycloak listens on a non-default sidecar port
								name:          "proxy"
								containerPort: defaults.edge.oidc.upstream_port
							}]
						},
						{
							name:  Name
							image: defaults.images.keycloak
							ports: [{
								name:          Name
								containerPort: 8080
							}]
							args: ["start-dev --import-realm"]
							env: [
								{name: "KEYCLOAK_ADMIN", value: "admin"},
								{name: "KEYCLOAK_ADMIN_PASSWORD"
									valueFrom: {
										secretKeyRef: {
											name: defaults.keycloak.keycloak_admin_secret
											key:  "password"
										}
									}
								},
								{name: "KC_PROXY", value:              "edge"},
								{name: "KC_HOSTNAME_URL", value:       defaults.edge.oidc.endpoint},
								{name: "KC_HOSTNAME_ADMIN_URL", value: defaults.edge.oidc.endpoint},
								{name: "KC_DB", value:                 "postgres"},
								{name: "KC_DB_URL", value:             "jdbc:postgresql://localhost:\(defaults.keycloak.database_ingress_port)/keycloak"},
								{name: "KC_DB_USERNAME", value:        defaults.keycloak.database_user},
								{name: "KC_DB_PASSWORD"
									valueFrom: {
										secretKeyRef: {
											name: defaults.keycloak.keycloak_postgres_secret
											key:  "password"
										}
									}
								}]
							resources: {
								limits: {cpu: "500m", memory: "2Gi"}
								requests: {cpu: "200m", memory: "1Gi"}

							}
							imagePullPolicy: defaults.image_pull_policy
							volumeMounts: [
								{
									name:      "\(Name)-realm-config"
									mountPath: "/opt/keycloak/data/import"
								},
							]
						},
					]
					volumes: [
							{
							name: "\(Name)-realm-config"
							configMap: {name: Name}
						},

					] + #sidecar_volumes
					imagePullSecrets: [{name: defaults.image_pull_secret_name}]
				}
			}
		}
	},

	corev1.#Service & {
		apiVersion: "v1"
		kind:       "Service"
		metadata: {
			name:      Name
			namespace: mesh.spec.install_namespace
		}
		spec: {
			selector: {
				"greymatter.io/cluster": Name
			}
			ports: [
				{
					name:       Name
					port:       defaults.edge.oidc.upstream_port
					targetPort: defaults.edge.oidc.upstream_port
				},
			]
			type: "LoadBalancer"
		}
	},

	corev1.#ConfigMap & {
		apiVersion: "v1"
		kind:       "ConfigMap"
		metadata: {
			name:      Name
			namespace: mesh.spec.install_namespace
		}
		data: {
			"greymatter-realm.json": json.Marshal({realm_data})
		}
	},
]
