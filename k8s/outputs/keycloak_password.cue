// Keycloak admin password secret for dev installation of Keycloak.
// The password is intentionally fake and should be changed after
// the mesh is installed.

package greymatter

import (
	corev1 "k8s.io/api/core/v1"
)

let Name = defaults.keycloak.keycloak_admin_secret

keycloak_admin_password: [
	corev1.#Secret & {
		apiVersion: "v1"
		kind:       "Secret"
		type:       "Opaque"
		metadata: {
			name:      Name
			namespace: mesh.spec.install_namespace
		}
		stringData: {
			password: "admin"
		}
	},
]
