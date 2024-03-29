// Code generated by timoni. DO NOT EDIT.

//timoni:generate timoni vendor crd -f ./trust-manager/templates/trust.cert-manager.io_bundles.yaml

package v1alpha1

import "strings"

#Bundle: {
	// APIVersion defines the versioned schema of this representation
	// of an object. Servers should convert recognized schemas to the
	// latest internal value, and may reject unrecognized values.
	// More info:
	// https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources
	apiVersion: "trust.cert-manager.io/v1alpha1"

	// Kind is a string value representing the REST resource this
	// object represents. Servers may infer this from the endpoint
	// the client submits requests to. Cannot be updated. In
	// CamelCase. More info:
	// https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds
	kind: "Bundle"
	metadata!: {
		name!: strings.MaxRunes(253) & strings.MinRunes(1) & {
			string
		}
		namespace?: strings.MaxRunes(63) & strings.MinRunes(1) & {
			string
		}
		labels?: {
			[string]: string
		}
		annotations?: {
			[string]: string
		}
	}

	// Desired state of the Bundle resource.
	spec!: #BundleSpec
}

// Desired state of the Bundle resource.
#BundleSpec: {
	// Sources is a set of references to data whose data will sync to
	// the target.
	sources: [...{
		// ConfigMap is a reference (by name) to a ConfigMap's `data` key,
		// or to a list of ConfigMap's `data` key using label selector,
		// in the trust Namespace.
		configMap?: {
			// Key is the key of the entry in the object's `data` field to be
			// used.
			key: string

			// Name is the name of the source object in the trust Namespace.
			// This field must be left empty when `selector` is set
			name?: string

			// Selector is the label selector to use to fetch a list of
			// objects. Must not be set when `Name` is set.
			selector?: {
				// matchExpressions is a list of label selector requirements. The
				// requirements are ANDed.
				matchExpressions?: [...{
					// key is the label key that the selector applies to.
					key: string

					// operator represents a key's relationship to a set of values.
					// Valid operators are In, NotIn, Exists and DoesNotExist.
					operator: string

					// values is an array of string values. If the operator is In or
					// NotIn, the values array must be non-empty. If the operator is
					// Exists or DoesNotExist, the values array must be empty. This
					// array is replaced during a strategic merge patch.
					values?: [...string]
				}]

				// matchLabels is a map of {key,value} pairs. A single {key,value}
				// in the matchLabels map is equivalent to an element of
				// matchExpressions, whose key field is "key", the operator is
				// "In", and the values array contains only "value". The
				// requirements are ANDed.
				matchLabels?: {
					[string]: string
				}
			}
		}

		// InLine is a simple string to append as the source data.
		inLine?: string

		// Secret is a reference (by name) to a Secret's `data` key, or to
		// a list of Secret's `data` key using label selector, in the
		// trust Namespace.
		secret?: {
			// Key is the key of the entry in the object's `data` field to be
			// used.
			key: string

			// Name is the name of the source object in the trust Namespace.
			// This field must be left empty when `selector` is set
			name?: string

			// Selector is the label selector to use to fetch a list of
			// objects. Must not be set when `Name` is set.
			selector?: {
				// matchExpressions is a list of label selector requirements. The
				// requirements are ANDed.
				matchExpressions?: [...{
					// key is the label key that the selector applies to.
					key: string

					// operator represents a key's relationship to a set of values.
					// Valid operators are In, NotIn, Exists and DoesNotExist.
					operator: string

					// values is an array of string values. If the operator is In or
					// NotIn, the values array must be non-empty. If the operator is
					// Exists or DoesNotExist, the values array must be empty. This
					// array is replaced during a strategic merge patch.
					values?: [...string]
				}]

				// matchLabels is a map of {key,value} pairs. A single {key,value}
				// in the matchLabels map is equivalent to an element of
				// matchExpressions, whose key field is "key", the operator is
				// "In", and the values array contains only "value". The
				// requirements are ANDed.
				matchLabels?: {
					[string]: string
				}
			}
		}

		// UseDefaultCAs, when true, requests the default CA bundle to be
		// used as a source. Default CAs are available if trust-manager
		// was installed via Helm or was otherwise set up to include a
		// package-injecting init container by using the
		// "--default-package-location" flag when starting the
		// trust-manager controller. If default CAs were not configured
		// at start-up, any request to use the default CAs will fail. The
		// version of the default CA package which is used for a Bundle
		// is stored in the defaultCAPackageVersion field of the Bundle's
		// status field.
		useDefaultCAs?: bool
	}]

	// Target is the target location in all namespaces to sync source
	// data to.
	target: {
		// AdditionalFormats specifies any additional formats to write to
		// the target
		additionalFormats?: {
			// JKS requests a JKS-formatted binary trust bundle to be written
			// to the target. The bundle has "changeit" as the default
			// password. For more information refer to this link
			// https://cert-manager.io/docs/faq/#keystore-passwords
			jks?: {
				// Key is the key of the entry in the object's `data` field to be
				// used.
				key: string

				// Password for JKS trust store
				password?: strings.MaxRunes(128) & strings.MinRunes(1) | *"changeit"
			}

			// PKCS12 requests a PKCS12-formatted binary trust bundle to be
			// written to the target. The bundle is by default created
			// without a password.
			pkcs12?: {
				// Key is the key of the entry in the object's `data` field to be
				// used.
				key: string

				// Password for PKCS12 trust store
				password?: strings.MaxRunes(128) | *""
			}
		}
		configMap?: {
			// Key is the key of the entry in the object's `data` field to be
			// used.
			key: string
		}
		namespaceSelector?: {
			// MatchLabels matches on the set of labels that must be present
			// on a Namespace for the Bundle target to be synced there.
			matchLabels?: {
				[string]: string
			}
		}
		secret?: {
			// Key is the key of the entry in the object's `data` field to be
			// used.
			key: string
		}
	}
}
