package templates

import (
	rbacv1 "k8s.io/api/rbac/v1"
)

#ClusterRole: rbacv1.#ClusterRole & {
	#config: #Config

	apiVersion: "rbac.authorization.k8s.io/v1"
	kind:       "ClusterRole"
	metadata: name:   #config.metadata.name
	metadata: labels: #config.metadata.labels

	if #config.metadata.annotations != _|_ {
		metadata: annotations: #config.metadata.annotations
	}

	rules: [
		{
			apiGroups: ["trust.cert-manager.io"]
			resources: ["bundles"]
			verbs: ["get", "list", "watch"]
		}, {
			// Permissions to update finalizers are required for trust-manager to work correctly
			// on OpenShift, even though we don't directly use finalizers at the time of writing
			apiGroups: ["trust.cert-manager.io"]
			resources: ["bundles/finalizers"]
			verbs: ["update"]
		}, {
			apiGroups: ["trust.cert-manager.io"]
			resources: ["bundles/status"]
			verbs: ["patch"]
		}, {
			apiGroups: ["trust.cert-manager.io"]
			resources: ["bundles"]
			// We also need update here so we can perform migrations from old CSA to SSA.
			verbs: ["update"]
		}, {
			apiGroups: [""]
			resources: ["configmaps"]
			// We also need update here so we can perform migrations from old CSA to SSA.
			verbs: ["get", "list", "create", "update", "patch", "watch", "delete"]
		}, {
			apiGroups: [""]
			resources: ["namespaces"]
			verbs: ["get", "list", "watch"]
		}, {
			apiGroups: [""]
			resources: ["events"]
			verbs: ["create", "patch"]
		},

		if #config.secretTargets.enabled && #config.secretTargets.authorizedSecretsAll {
			{
				apiGroups: [""]
				resources: ["secrets"]
				verbs: ["get", "list", "create", "patch", "watch", "delete"]
			}
		},

		if #config.secretTargets.enabled && !#config.secretTargets.authorizedSecretsAll && #config.secretTargets.authorizedSecrets != _|_ {
			{
				apiGroups: [""]
				resources: ["secrets"]
				verbs: ["get", "list", "watch"]
			}
		},

		if #config.secretTargets.enabled && !#config.secretTargets.authorizedSecretsAll && #config.secretTargets.authorizedSecrets != _|_ {
			{
				apiGroups: [""]
				resources: ["secrets"]
				verbs: ["create", "patch", "delete"]
				resourceNames: #config.secretTargets.authorizedSecrets
			}
		},
	]

}
