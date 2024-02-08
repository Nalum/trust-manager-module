package templates

import (
	corev1 "k8s.io/api/core/v1"
	timoniv1 "timoni.sh/core/v1alpha1"
	admissionregistrationv1 "k8s.io/api/admissionregistration/v1"
)

#WebhookService: corev1.#Service & {
	#config: #Config

	#meta: timoniv1.#MetaComponent & {
		#Meta:      #config.metadata
		#Component: "webhook"
	}

	apiVersion: "v1"
	kind:       "Service"
	metadata:   #meta
	spec: {
		type: #config.app.webhook.service.type
		ports: [{
			port:       443
			targetPort: #config.app.webhook.port
			if #config.app.webhook.service.nodePort != _|_ {
				nodePort: #config.app.webhook.service.nodePort
			}
			protocol: "TCP"
			name:     "webhook"
		}]
		selector: #config.metadata.#LabelSelector
	}
}

#ValidatingWebhookConfiguration: admissionregistrationv1.#ValidatingWebhookConfiguration & {
	#config: #Config

	#meta: timoniv1.#MetaClusterComponent & {
		#Meta:      #config.metadata
		#Component: "webhook"
	}

	apiVersion: "admissionregistration.k8s.io/v1"
	kind:       "ValidatingWebhookConfiguration"
	metadata:   #meta
	metadata: annotations: "cert-manager.io/inject-ca-from": "\(#config.metadata.namespace)/\(#config.metadata.name)"

	webhooks: [{
		name: "trust.cert-manager.io"

		rules: [{
			apiGroups: ["trust.cert-manager.io"]
			apiVersions: ["*"]
			operations: ["CREATE", "UPDATE"]
			resources: ["*/*"]
		}]

		admissionReviewVersions: ["v1"]
		timeoutSeconds: #config.app.webhook.timeoutSeconds
		failurePolicy:  "Fail"
		sideEffects:    "None"

		clientConfig: service: {
			name:      #meta.name
			namespace: #config.metadata.namespace
			path:      "/validate-trust-cert-manager-io-v1alpha1-bundle"
		}
	}]
}
