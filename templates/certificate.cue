package templates

import (
	issuerv1 "cert-manager.io/issuer/v1"
	certv1 "cert-manager.io/certificate/v1"
	certreqv1 "cert-manager.io/certificaterequest/v1"
	policyv1 "k8s.io/api/policy/v1"
)

#Issuer: issuerv1.#Issuer & {
	#config: #Config

	metadata: #config.metadata
	spec: selfSigned: {}
}

#Certificate: certv1.#Certificate & {
	#config: #Config

	metadata: #config.metadata
	spec: {
		commonName: "\(#config.metadata.name).\(#config.metadata.namespace).svc"
		dnsNames: ["\(#config.metadata.name).\(#config.metadata.namespace).svc"]
		secretName:           "\(#config.metadata.name)-tls"
		revisionHistoryLimit: 1
		issuerRef: {
			name:  "\(#config.metadata.name)"
			kind:  "Issuer"
			group: "cert-manager.io"
		}
	}
}

#CertificateRequestPolicy: certreqv1.#CertificateRequestPolicy & {
	#config: #Config

	metadata: #config.metadata
	spec: {
		allowed: {
			commonName: {
				value:    "\(#config.metadata.name).\(#config.metadata.namespace).svc"
				required: true
			}
			dnsNames: {
				values: ["\(#config.metadata.name).\(#config.metadata.namespace).svc"]
				required: true
			}
		}
		selector: {
			issuerRef: {
				name:  #config.metadata.name
				kind:  "Issuer"
				group: "cert-manager.io"
			}
		}
	}
}

#CertReqClusterRole: policyv1.#ClusterRole & {
	#config: #Config

	apiVersion: "rbac.authorization.k8s.io/v1"
	kind:       "ClusterRole"
	metadata:   #config.metadata
	rules: [{
		apiGroups: ["policy.cert-manager.io"]
		resources: ["certificaterequestpolicies"]
		verbs: ["use"]
		resourceNames: ["trust-manager-policy"]
	}]
}

#CertReqClusterRoleBinding: policyv1.#ClusterRoleBinding & {
	#config: #Config

	apiVersion: "rbac.authorization.k8s.io/v1"
	kind:       "ClusterRoleBinding"
	metadata:   #config.metadata
	roleRef: {
		apiGroup: "rbac.authorization.k8s.io"
		kind:     "ClusterRole"
		name:     "trust-manager-policy-role"
	}
	subjects: [{
		kind:      "ServiceAccount"
		name:      #config.app.webhook.tls.approverPolicy.certManagerServiceAccount
		namespace: #config.app.webhook.tls.approverPolicy.certManagerNamespace
	}]
}
