package templates

import (
	servicemonitorv1 "monitoring.coreos.com/servicemonitor/v1"
	timoniv1 "timoni.sh/core/v1alpha1"
)

#MetricsServiceMonitor: servicemonitorv1.#ServiceMonitor & {
	#config: #Config

	#meta: timoniv1.#MetaComponent & {
		#Meta:      #config.metadata
		#Component: "metrics"
	}

	metadata: #meta
	metadata: labels: prometheus: #config.app.metrics.service.serviceMonitor.prometheusInstance
	spec: {
		jobLabel: #config.metadata.name
		selector: matchLabels: #meta.#LabelSelector
		namespaceSelector: matchNames: [#meta.namespace]
		endpoints: [{
			targetPort:    #config.app.metrics.port
			path:          "/metrics"
			interval:      #config.app.metrics.service.serviceMonitor.interval
			scrapeTimeout: #config.app.metrics.service.serviceMonitor.scrapeTimeout
		}]
	}
}
