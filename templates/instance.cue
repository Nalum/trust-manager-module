package templates

// Instance takes the config values and outputs the Kubernetes objects.
#Instance: {
	config: #Config

	objects: {
		for name, crd in customresourcedefinition {
			"\(name)": crd
			"\(name)": metadata: labels: config.metadata.labels
			if config.metadata.annotations != _|_ {
				"\(name)": metadata: annotations: config.metadata.annotations
			}
		}
	}

	objects: {
		issuer: #Issuer & {
			#config: config
		}
		certificate: #Certificate & {
			#config: config
		}
		clusterRole: #ClusterRole & {
			#config: config
		}
		clusterRoleBinding: #ClusterRoleBinding & {
			#config: config
		}
		role: #Role & {
			#config: config
		}
		roleBinding: #RoleBinding & {
			#config: config
		}
		leaderElectionRole: #LeaderElectionRole & {
			#config: config
		}
		leaderElectionRoleBinding: #LeaderElectionRoleBinding & {
			#config: config
		}
		serviceAccount: #ServiceAccount & {
			#config: config
		}
		webhookService: #WebhookService & {
			#config: config
		}
		deployment: #Deployment & {
			#config: config
		}
		validatingWebhookConfiguration: #ValidatingWebhookConfiguration & {
			#config: config
		}
	}

	if config.app.webhook.tls.approverPolicy.enabled {
		objects: {
			certificateRequestPolicy: #CertificateRequestPolicy & {
				#config: config
			}
			certReqClusterRole: #CertReqClusterRole & {
				#config: config
			}
			certReqClusterRoleBinding: #CertReqClusterRoleBinding & {
				#config: config
			}
		}
	}

	if config.app.metrics.service.enabled {
		objects: metricsService: #MetricsService & {
			#config: config
		}
	}

	if config.app.metrics.service.enabled && config.app.metrics.service.serviceMonitor.enabled {
		objects: metricsServiceMonitor: #MetricsServiceMonitor & {
			#config: config
		}
	}

	tests: {
	}
}
