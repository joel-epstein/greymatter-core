// Elasticsearch password secret for Audit App/Pipeline.
// This secret is created at install-time of the mesh to ensure that
// the Audit App/Pipeline pods start successfully. The password is
// intentionally fake and needs to be changed after the mesh is installed.

package greymatter

import (
	corev1 "k8s.io/api/core/v1"
)

let Name = defaults.audits.elasticsearch_password_secret

elasticsearch_password: [
	corev1.#Secret & {
		apiVersion: "v1"
		kind:       "Secret"
		type:       "Opaque"
		metadata: {
			name:      Name
			namespace: mesh.spec.install_namespace
		}
		stringData: {
			password: "CHANGE_ME"
		}
	},
]
