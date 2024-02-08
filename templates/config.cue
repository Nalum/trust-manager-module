package templates

import (
	corev1 "k8s.io/api/core/v1"
	timoniv1 "timoni.sh/core/v1alpha1"
)

#AppVersion: *"v0.8.0" | string
#Duration:   string & =~"^[+-]?((\\d+h)?(\\d+m)?(\\d+s)?(\\d+ms)?(\\d+(us|µs))?(\\d+ns)?)$"

// Config defines the schema and defaults for the Instance values.
#Config: {
	// The kubeVersion is a required field, set at apply-time
	// via timoni.cue by querying the user's Kubernetes API.
	kubeVersion!: string
	// Using the kubeVersion you can enforce a minimum Kubernetes minor version.
	// By default, the minimum Kubernetes version is set to 1.20.
	clusterVersion: timoniv1.#SemVer & {#Version: kubeVersion, #Minimum: "1.20.0"}

	// The moduleVersion is set from the user-supplied module version.
	// This field is used for the `app.kubernetes.io/version` label.
	moduleVersion!: string

	// The Kubernetes metadata common to all resources.
	// The `metadata.name` and `metadata.namespace` fields are
	// set from the user-supplied instance name and namespace.
	metadata: timoniv1.#Metadata & {#Version: moduleVersion}

	// The labels allows adding `metadata.labels` to all resources.
	// The `app.kubernetes.io/name` and `app.kubernetes.io/version` labels
	// are automatically generated and can't be overwritten.
	metadata: labels: timoniv1.#Labels
	metadata: labels: (timoniv1.#StdLabelPartOf): "trust-manager"

	// The annotations allows adding `metadata.annotations` to all resources.
	metadata: annotations?: timoniv1.#Annotations

	// The selector allows adding label selectors to Deployments and Services.
	// The `app.kubernetes.io/name` label selector is automatically generated
	// from the instance name and can't be overwritten.
	selector: timoniv1.#Selector & {#Name: metadata.name}

	// Number of replicas of trust-manager to run.
	replicaCount: *1 | int

	// Reference to one or more secrets to be used when pulling images
	// ref: https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/
	imagePullSecrets?: [...corev1.#LocalObjectReference]

	image!: timoniv1.#Image
	image: {
		repository: *"quay.io/jetstack/trust-manager" | string
		tag:        #AppVersion
		digest:     *"sha256:e45773dbc05105a19e0750fdb2524ba056ae1568f37b7ed99d42ad64264734fc" | string
	}

	defaultPackage: {
		// Whether to load the default trust package during pod initialization and include it in main container args. This container enables the 'useDefaultCAs' source on Bundles.
		enabled: *true | false
		image!:  timoniv1.#Image
		image: {
			repository: *"quay.io/jetstack/cert-manager-package-debian" | string
			tag:        *"20210119.0" | string
			digest:     *"sha256:aa3466521072e0f54666092acde1e394314d5f4247034ed1379a90919fa904a4" | string
		}
	}

	secretTargets: {
		// If set to true, enable writing trust bundles to Kubernetes Secrets as a target.
		// trust-manager can only write to secrets which are explicitly allowed via either authorizedSecrets or authorizedSecretsAll.
		// NOTE: Enabling secret targets will grant trust-manager read access to all secrets in the cluster.
		enabled: *false | true
		// If set to true, grant read/write permission to all secrets across the cluster. Use with caution!
		// If set, ignores the authorizedSecrets list.
		authorizedSecretsAll: *false | true
		// A list of secret names which trust-manager will be permitted to read and write across all namespaces.
		// These will be the only allowable Secrets that can be used as targets. If the list is empty (and authorizedSecretsAll is false),
		// trust-manager will not be able to write to secrets and will only be able to read secrets in the trust namespace for use as sources.
		authorizedSecrets: [...string]
	}

	// The resources allows setting the container resource requirements.
	// By default, the container requests 100m CPU and 128Mi memory.
	resources: timoniv1.#ResourceRequirements & {
		requests: {
			cpu:    *"100m" | timoniv1.#CPUQuantity
			memory: *"128Mi" | timoniv1.#MemoryQuantity
		}
	}

	// Configure the priority class of the pod; see https://kubernetes.io/docs/concepts/scheduling-eviction/pod-priority-preemption/#priorityclass
	priorityClassName?: string

	// Configure the nodeSelector; defaults to any Linux node (trust-manager doesn't support Windows nodes)
	// +docs:property
	nodeSelector: timoniv1.#Labels & {
		"kubernetes.io/os": "linux"
	}

	// Kubernetes Affinty; see https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.27/#affinity-v1-core
	// for example:
	//   affinity:
	//     nodeAffinity:
	//      requiredDuringSchedulingIgnoredDuringExecution:
	//        nodeSelectorTerms:
	//        - matchExpressions:
	//          - key: foo.bar.com/role
	//            operator: In
	//            values:
	//            - master
	// Kubernetes Affinty; see https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.27/#affinity-v1-core
	affinity: *{
		nodeAffinity: requiredDuringSchedulingIgnoredDuringExecution: nodeSelectorTerms: [{
			matchExpressions: [{
				key:      corev1.#LabelOSStable
				operator: "In"
				values: ["linux"]
			}]
		}]
	} | corev1.#Affinity

	// List of Kubernetes Tolerations, if required; see https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.27/#toleration-v1-core
	// for example:
	//   tolerations:
	//   - key: foo.bar.com/role
	//     operator: Equal
	//     value: master
	//     effect: NoSchedule
	// List of Kubernetes Tolerations; see https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.27/#toleration-v1-core
	tolerations: [...corev1.#Toleration]

	// List of Kubernetes TopologySpreadConstraints; see https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.27/#topologyspreadconstraint-v1-core
	// For example:
	//   topologySpreadConstraints:
	//   - maxSkew: 2
	//     topologyKey: topology.kubernetes.io/zone
	//     whenUnsatisfiable: ScheduleAnyway
	//     labelSelector:
	//       matchLabels:
	//         app.kubernetes.io/instance: cert-manager
	//         app.kubernetes.io/component: controller
	// List of Kubernetes TopologySpreadConstraints; see https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.27/#topologyspreadconstraint-v1-core
	topologySpreadConstraints: [...corev1.#TopologySpreadConstraint]

	// Whether to filter expired certificates from the trust bundle.
	filterExpiredCertificates: *false | true

	app: {
		// Verbosity of trust-manager logging; takes a value from 1-5, with higher being more verbose
		logLevel: *1 | int & >=1 & <=5

		readinessProbe: corev1.#Probe & {
			httpGet: {
				port: *6060 | int
				path: *"/readyz" | string
			}
			initialDelaySeconds: *3 | int
			periodSeconds:       *7 | int
		}

		trust: {
			// Namespace used as trust source. Note that the namespace _must_ exist
			// before installing trust-manager.
			namespace: *metadata.namespace | string
		}

		securityContext: {
			// If false, disables the default seccomp profile, which might be required to run on certain platforms
			seccompProfileEnabled: *true | false
		}

		// Pod labels to add to trust-manager pods.
		podLabels: timoniv1.#Labels
		// Pod annotations to add to trust-manager pods.
		podAnnotations: timoniv1.#Annotations

		webhook: {
			// Host that the webhook listens on.
			host: *"0.0.0.0" | string
			// Port that the webhook listens on.
			port: *6443 | int
			// Timeout of webhook HTTP request.
			timeoutSeconds: *5 | int

			service: {
				// Type of Kubernetes Service used by the Webhook
				type: *corev1.#ServiceTypeClusterIP | corev1.#enumServiceType
			}

			tls: {
				approverPolicy: {
					// Whether to create an approver-policy CertificateRequestPolicy allowing auto-approval of the trust-manager webhook certificate. If you have approver-policy installed, you almost certainly want to enable this.
					enabled: *false | true

					// Namespace in which cert-manager was installed. Only used if app.webhook.tls.approverPolicy.enabled is true
					certManagerNamespace: *"cert-manager" | string

					// Name of cert-manager's ServiceAccount. Only used if app.webhook.tls.approverPolicy.enabled is true
					certManagerServiceAccount: *"cert-manager" | string
				}
			}

			// Specifies if the app should be started in hostNetwork mode. Required for use in some managed kubernetes clusters (such as AWS EKS) with custom CNI.
			hostNetwork: *false | true
		}

		// +docs:section=Metrics

		metrics: {
			// Port for exposing Prometheus metrics on 0.0.0.0 on path '/metrics'.
			port: *9402 | int
			// Service to expose metrics endpoint.
			service: {
				// Create a Service resource to expose metrics endpoint.
				enabled: *true | false
				// Service type to expose metrics.
				type: *corev1.#ServiceTypeClusterIP | corev1.#enumServiceType
				// ServiceMonitor resource for this Service.
				serviceMonitor: {
					// Create a Prometheus ServiceMonitor for trust-manager
					enabled: *false | true
					// Sets the value of the "prometheus" label on the ServiceMonitor, this
					// is used as separate Prometheus instances can select difference
					// ServiceMonitors using labels
					prometheusInstance: *"default" | string
					// Interval to scrape the metrics
					interval: *"10s" | #Duration
					// Timeout for a metrics scrape
					scrapeTimeout: *"5s" | #Duration
					// Additional labels to add to the ServiceMonitor
					labels: timoniv1.#Labels
				}
			}
		}
	}
}
