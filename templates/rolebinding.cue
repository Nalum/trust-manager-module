package templates

import (
	rbacv1 "k8s.io/api/rbac/v1"
	timoniv1 "timoni.sh/core/v1alpha1"
)

#RoleBinding: rbacv1.#RoleBinding & {
	#config: #Config

	apiVersion: "rbac.authorization.k8s.io/v1"
	kind:       "RoleBinding"
	metadata:   #config.metadata
	roleRef: {
		apiGroup: "rbac.authorization.k8s.io"
		kind:     "Role"
		name:     #config.metadata.name
	}
	subjects: [{
		kind:      "ServiceAccount"
		name:      #config.metadata.name
		namespace: #config.metadata.namespace
	}]
}

#LeaderElectionRoleBinding: rbacv1.#RoleBinding & {
	#config: #Config

	#meta: timoniv1.#MetaComponent & {
		#Meta:      #config.metadata
		#Component: "leaderelection"
	}

	apiVersion: "rbac.authorization.k8s.io/v1"
	kind:       "RoleBinding"
	metadata:   #meta
	roleRef: {
		apiGroup: "rbac.authorization.k8s.io"
		kind:     "Role"
		name:     #meta.name
	}
	subjects: [{
		kind:      "ServiceAccount"
		name:      #config.metadata.name
		namespace: #config.metadata.namespace
	}]
}
