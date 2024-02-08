package templates

import (
	corev1 "k8s.io/api/core/v1"
	timoniv1 "timoni.sh/core/v1alpha1"
)

#MetricsService: corev1.#Service & {
	#config: #Config

	#meta: timoniv1.#MetaComponent & {
		#Meta:      #config.metadata
		#Component: "metrics"
	}

	apiVersion: "v1"
	kind:       "Service"
	metadata:   #meta
	spec: {
		type: #config.app.metrics.service.type
		ports: [{
			port:       #config.app.metrics.port
			targetPort: #config.app.metrics.port
			protocol:   "TCP"
			name:       "metrics"
		}]
		selector: #config.metadata.#LabelSelector
	}
}
