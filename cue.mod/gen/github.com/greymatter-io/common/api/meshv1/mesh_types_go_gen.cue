package meshv1

import metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"

// MeshSpec defines the desired state of a Grey Matter mesh.
#MeshSpec: {
	// A list of OCI image strings and their respective pull secret names.
	// These are treated as overrides to the specified "release_version".
	// +optional
	images?: #Images @go(Images)

	// A list of pull secrets to try for fetching core services.
	// +optional
	image_pull_secrets?: [...string] @go(ImagePullSecrets,[]string)

	// Label this mesh as belonging to a particular zone.
	// +kubebuilder:default=default-zone
	zone: string @go(Zone)

	// Namespace where mesh core components and dependencies should be installed.
	install_namespace: string @go(InstallNamespace)

	// Namespaces to include in the mesh network.
	// +optional
	watch_namespaces?: [...string] @go(WatchNamespaces,[]string)

	// Add user tokens to the JWT Security Service.
	// +optional
	user_tokens?: [...#UserToken] @go(UserTokens,[]UserToken)
}

#UserToken: {
	label: string @go(Label)
	values: {[string]: [...string]} @go(Values,map[string][]string)
}

#Images: {
	proxy?:        string @go(Proxy)
	catalog?:      string @go(Catalog)
	control?:      string @go(Control)
	control_api?:  string @go(ControlAPI)
	dashboard?:    string @go(Dashboard)
	jwt_security?: string @go(JWTSecurity)
	redis?:        string @go(Redis)
	prometheus?:   string @go(Prometheus)
}

// MeshStatus describes the observed state of a Grey Matter mesh.
#MeshStatus: {
	sidecar_list?: [...string] @go(SidecarList,[]string)
}

// Mesh defines a Grey Matter mesh's desired state and describes its observed state.
#Mesh: {
	metav1.#TypeMeta
	metadata?: metav1.#ObjectMeta @go(ObjectMeta)

	// +kubebuilder:validation:Required
	spec?:   #MeshSpec   @go(Spec)
	status?: #MeshStatus @go(Status)
}

// MeshList contains a list of Mesh custom resources managed by the Grey Matter Operator.
#MeshList: {
	metav1.#TypeMeta
	metadata?: metav1.#ListMeta @go(ListMeta)
	items: [...#Mesh] @go(Items,[]Mesh)
}
