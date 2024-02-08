package templates

import (
	rbacv1 "k8s.io/api/rbac/v1"
)

#ClusterRoleBinding: rbacv1.#ClusterRoleBinding & {
	#config: #Config

	apiVersion: "rbac.authorization.k8s.io/v1"
	kind:       "ClusterRoleBinding"
	metadata: name:   #config.metadata.name
	metadata: labels: #config.metadata.labels

	if #config.metadata.annotations != _|_ {
		metadata: annotations: #config.metadata.annotations
	}

	roleRef: {
		apiGroup: "rbac.authorization.k8s.io"
		kind:     "ClusterRole"
		name:     #config.metadata.name
	}
	subjects: [{
		kind:      "ServiceAccount"
		name:      #config.metadata.name
		namespace: #config.metadata.namespace
	}]
}
