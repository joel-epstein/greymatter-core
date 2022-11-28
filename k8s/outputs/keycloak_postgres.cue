// Manifests for the Keycloak Postgres deployment

package greymatter

import (
	appsv1 "k8s.io/api/apps/v1"
)

let Name = defaults.keycloak.keycloak_postgres_cluster_name

keycloak_postgres: [
	appsv1.#StatefulSet & {
		apiVersion: "apps/v1"
		kind:       "StatefulSet"
		metadata: {
			name:      Name
			namespace: mesh.spec.install_namespace
		}
		spec: {
			serviceName: Name
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
					securityContext: {
						runAsUser:  2000
						runAsGroup: 0
						fsGroup:    2000
					}
					containers: [
						#sidecar_container_block & {
							_Name: Name
							ports: [{
								name: "proxy"
								// postgres listens on a non-default sidecar port
								containerPort: defaults.keycloak.database_ingress_port
							}]
						},
						{
							name:  Name
							image: defaults.images.keycloak_postgres
							ports: [{
								name:          "postgres"
								containerPort: 5432
							}]
							env: [
								{name: "POSTGRES_USER", value: defaults.keycloak.database_user},
								{name: "POSTGRES_PASSWORD"
									valueFrom: {
										secretKeyRef: {
											name: defaults.keycloak.keycloak_postgres_secret
											key:  "password"
										}
									}
								},
								{name: "POSTGRES_DB", value: defaults.keycloak.database_name},
								{name: "PGDATA", value:      "/var/lib/postgresql/data/pgdata"},
							]
							resources: {
								limits: {cpu: "200m", memory: "1Gi"}
								requests: {cpu: "50m", memory: "128Mi"}

							}
							imagePullPolicy: defaults.image_pull_policy
							volumeMounts: [
								{
									name:      "\(config.operator_namespace)-\(Name)-data"
									mountPath: "/var/lib/postgresql/data"
									subPath:   "pgData"
								},
							]
						},
					]
					volumes: #sidecar_volumes
					imagePullSecrets: [{name: defaults.image_pull_secret_name}]
				}
			}
			volumeClaimTemplates: [
				{
					apiVersion: "v1"
					kind:       "PersistentVolumeClaim"
					metadata: name: "\(config.operator_namespace)-\(Name)-data"
					spec: {
						accessModes: ["ReadWriteOnce"]
						resources: requests: storage: "10Gi"
					}
				},
			]
		}
	},
]
