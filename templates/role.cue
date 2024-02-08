package templates

import (
	rbacv1 "k8s.io/api/rbac/v1"
	timoniv1 "timoni.sh/core/v1alpha1"
)

#Role: rbacv1.#Role & {
	#config: #Config

	apiVersion: "rbac.authorization.k8s.io/v1"
	kind:       "Role"
	metadata:   #config.metadata
	rules: [{
		apiGroups: [""]
		resources: ["secrets"]
		verbs: ["get", "list", "watch"]
	}]
}

#LeaderElectionRole: rbacv1.#Role & {
	#config: #Config

	#meta: timoniv1.#MetaComponent & {
		#Meta:      #config.metadata
		#Component: "leaderelection"
	}

	apiVersion: "rbac.authorization.k8s.io/v1"
	kind:       "Role"
	metadata:   #meta
	rules: [{
		apiGroups: ["coordination.k8s.io"]
		resources: ["leases"]
		verbs: ["get", "create", "update", "watch", "list"]
	}]
}
