package templates

import (
	appsv1 "k8s.io/api/apps/v1"
)

#Deployment: appsv1.#Deployment & {
	#config: #Config

	apiVersion: "apps/v1"
	kind:       "Deployment"
	metadata:   #config.metadata
	spec: {
		replicas: #config.replicaCount
		selector: matchLabels: #config.metadata.#LabelSelector
		template: {
			metadata: labels: #config.metadata.labels

			if #config.metadata.annotations != _|_ {
				metadata: annotations: #config.metadata.annotations
			}

			spec: {
				serviceAccountName: #config.metadata.name
				if #config.defaultPackage.enabled {
					initContainers: [{
						name:            "cert-manager-package-debian"
						image:           #config.defaultPackage.image.reference
						imagePullPolicy: #config.defaultPackage.image.pullPolicy
						args: [
							"/copyandmaybepause",
							"/debian-package",
							"/packages",
						]
						volumeMounts: [{
							mountPath: "/packages"
							name:      "packages"
							readOnly:  false
						}]
						securityContext: {
							allowPrivilegeEscalation: false
							capabilities: drop: ["ALL"]
							readOnlyRootFilesystem: true
							runAsNonRoot:           true
							if #config.app.securityContext.seccompProfileEnabled {
								seccompProfile: type: "RuntimeDefault"
							}
						}
					}]
				}
				containers: [{
					name:            #config.metadata.name
					image:           #config.image.reference
					imagePullPolicy: #config.image.pullPolicy
					ports: [{
						containerPort: #config.app.webhook.port
					}, {
						containerPort: #config.app.metrics.port
					}]
					readinessProbe: #config.app.readinessProbe
					command: ["trust-manager"]
					args: [
						"--log-level=\(#config.app.logLevel)",
						"--metrics-port=\(#config.app.metrics.port)",
						"--readiness-probe-port=\(#config.app.readinessProbe.httpGet.port)",
						"--readiness-probe-path=\(#config.app.readinessProbe.httpGet.path)",
						// trust
						"--trust-namespace=\(#config.app.trust.namespace)",
						// webhook
						"--webhook-host=\(#config.app.webhook.host)",
						"--webhook-port=\(#config.app.webhook.port)",
						"--webhook-certificate-dir=/tls",
						if #config.defaultPackage.enabled {
							"--default-package-location=/packages/cert-manager-package-debian.json"
						},
						if #config.secretTargets.enabled {
							"--secret-targets-enabled=true"
						},
						if #config.filterExpiredCertificates {
							"--filter-expired-certificates=true"
						},
					]
					volumeMounts: [{
						mountPath: "/tls"
						name:      "tls"
						readOnly:  true
					}, {
						mountPath: "/packages"
						name:      "packages"
						readOnly:  true
					}]
					resources: #config.resources
					securityContext: {
						allowPrivilegeEscalation: false
						capabilities: drop: ["ALL"]
						readOnlyRootFilesystem: true
						runAsNonRoot:           true
						if #config.app.securityContext.seccompProfileEnabled {
							seccompProfile: type: "RuntimeDefault"
						}
					}
				}]
				if #config.priorityClassName != _|_ {
					priorityClassName: #config.priorityClassName
				}
				if #config.nodeSelector != _|_ {
					nodeSelector: #config.nodeSelector
				}
				if #config.affinity != _|_ {
					affinity: #config.affinity
				}
				if #config.tolerations != _|_ {
					tolerations: #config.tolerations
				}
				if #config.topologySpreadConstraints != _|_ {
					topologySpreadConstraints: #config.topologySpreadConstraints
				}
				volumes: [{
					name: "packages"
					emptyDir: {}
				}, {
					name: "tls"
					secret: {
						defaultMode: 420
						secretName:  "\(#config.metadata.name)-tls"
					}
				}]
				if #config.app.webhook.hostNetwork {
					hostNetwork: true
					dnsPolicy:   "ClusterFirstWithHostNet"
				}
			}
		}
	}
}
