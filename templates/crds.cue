package templates

customresourcedefinition: "bundles.trust.cert-manager.io": {
	apiVersion: "apiextensions.k8s.io/v1"
	kind:       "CustomResourceDefinition"
	metadata: {
		annotations: "controller-gen.kubebuilder.io/version": "v0.13.0"
		name: "bundles.trust.cert-manager.io"
	}
	spec: {
		group: "trust.cert-manager.io"
		names: {
			kind:     "Bundle"
			listKind: "BundleList"
			plural:   "bundles"
			singular: "bundle"
		}
		scope: "Cluster"
		versions: [{
			additionalPrinterColumns: [{
				description: "Bundle Target Key"
				jsonPath:    ".status.target.configMap.key"
				name:        "Target"
				type:        "string"
			}, {
				description: "Bundle has been synced"
				jsonPath:    ".status.conditions[?(@.type == \"Synced\")].status"
				name:        "Synced"
				type:        "string"
			}, {
				description: "Reason Bundle has Synced status"
				jsonPath:    ".status.conditions[?(@.type == \"Synced\")].reason"
				name:        "Reason"
				type:        "string"
			}, {
				description: "Timestamp Bundle was created"
				jsonPath:    ".metadata.creationTimestamp"
				name:        "Age"
				type:        "date"
			}]
			name: "v1alpha1"
			schema: openAPIV3Schema: {
				type: "object"
				required: ["spec"]
				properties: {
					apiVersion: {
						description: "APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources"

						type: "string"
					}
					kind: {
						description: "Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds"

						type: "string"
					}
					metadata: type: "object"
					spec: {
						description: "Desired state of the Bundle resource."
						type:        "object"
						required: [
							"sources",
							"target",
						]
						properties: {
							sources: {
								description: "Sources is a set of references to data whose data will sync to the target."

								type: "array"
								items: {
									description: "BundleSource is the set of sources whose data will be appended and synced to the BundleTarget in all Namespaces."

									type: "object"
									properties: {
										configMap: {
											description: "ConfigMap is a reference (by name) to a ConfigMap's `data` key, or to a list of ConfigMap's `data` key using label selector, in the trust Namespace."

											type: "object"
											required: ["key"]
											properties: {
												key: {
													description: "Key is the key of the entry in the object's `data` field to be used."

													type: "string"
												}
												name: {
													description: "Name is the name of the source object in the trust Namespace. This field must be left empty when `selector` is set"

													type: "string"
												}
												selector: {
													description: "Selector is the label selector to use to fetch a list of objects. Must not be set when `Name` is set."

													type: "object"
													properties: {
														matchExpressions: {
															description: "matchExpressions is a list of label selector requirements. The requirements are ANDed."

															type: "array"
															items: {
																description: "A label selector requirement is a selector that contains values, a key, and an operator that relates the key and values."

																type: "object"
																required: [
																	"key",
																	"operator",
																]
																properties: {
																	key: {
																		description: "key is the label key that the selector applies to."

																		type: "string"
																	}
																	operator: {
																		description: "operator represents a key's relationship to a set of values. Valid operators are In, NotIn, Exists and DoesNotExist."

																		type: "string"
																	}
																	values: {
																		description: "values is an array of string values. If the operator is In or NotIn, the values array must be non-empty. If the operator is Exists or DoesNotExist, the values array must be empty. This array is replaced during a strategic merge patch."

																		type: "array"
																		items: type: "string"
																	}
																}
															}
														}
														matchLabels: {
															description: "matchLabels is a map of {key,value} pairs. A single {key,value} in the matchLabels map is equivalent to an element of matchExpressions, whose key field is \"key\", the operator is \"In\", and the values array contains only \"value\". The requirements are ANDed."

															type: "object"
															additionalProperties: type: "string"
														}
													}
													"x-kubernetes-map-type": "atomic"
												}
											}
										}
										inLine: {
											description: "InLine is a simple string to append as the source data."

											type: "string"
										}
										secret: {
											description: "Secret is a reference (by name) to a Secret's `data` key, or to a list of Secret's `data` key using label selector, in the trust Namespace."

											type: "object"
											required: ["key"]
											properties: {
												key: {
													description: "Key is the key of the entry in the object's `data` field to be used."

													type: "string"
												}
												name: {
													description: "Name is the name of the source object in the trust Namespace. This field must be left empty when `selector` is set"

													type: "string"
												}
												selector: {
													description: "Selector is the label selector to use to fetch a list of objects. Must not be set when `Name` is set."

													type: "object"
													properties: {
														matchExpressions: {
															description: "matchExpressions is a list of label selector requirements. The requirements are ANDed."

															type: "array"
															items: {
																description: "A label selector requirement is a selector that contains values, a key, and an operator that relates the key and values."

																type: "object"
																required: [
																	"key",
																	"operator",
																]
																properties: {
																	key: {
																		description: "key is the label key that the selector applies to."

																		type: "string"
																	}
																	operator: {
																		description: "operator represents a key's relationship to a set of values. Valid operators are In, NotIn, Exists and DoesNotExist."

																		type: "string"
																	}
																	values: {
																		description: "values is an array of string values. If the operator is In or NotIn, the values array must be non-empty. If the operator is Exists or DoesNotExist, the values array must be empty. This array is replaced during a strategic merge patch."

																		type: "array"
																		items: type: "string"
																	}
																}
															}
														}
														matchLabels: {
															description: "matchLabels is a map of {key,value} pairs. A single {key,value} in the matchLabels map is equivalent to an element of matchExpressions, whose key field is \"key\", the operator is \"In\", and the values array contains only \"value\". The requirements are ANDed."

															type: "object"
															additionalProperties: type: "string"
														}
													}
													"x-kubernetes-map-type": "atomic"
												}
											}
										}
										useDefaultCAs: {
											description: "UseDefaultCAs, when true, requests the default CA bundle to be used as a source. Default CAs are available if trust-manager was installed via Helm or was otherwise set up to include a package-injecting init container by using the \"--default-package-location\" flag when starting the trust-manager controller. If default CAs were not configured at start-up, any request to use the default CAs will fail. The version of the default CA package which is used for a Bundle is stored in the defaultCAPackageVersion field of the Bundle's status field."

											type: "boolean"
										}
									}
								}
							}
							target: {
								description: "Target is the target location in all namespaces to sync source data to."

								type: "object"
								properties: {
									additionalFormats: {
										description: "AdditionalFormats specifies any additional formats to write to the target"

										type: "object"
										properties: {
											jks: {
												description: "JKS requests a JKS-formatted binary trust bundle to be written to the target. The bundle has \"changeit\" as the default password. For more information refer to this link https://cert-manager.io/docs/faq/#keystore-passwords"

												type: "object"
												required: ["key"]
												properties: {
													key: {
														description: "Key is the key of the entry in the object's `data` field to be used."

														type: "string"
													}
													password: {
														description: "Password for JKS trust store"
														type:        "string"
														default:     "changeit"
														maxLength:   128
														minLength:   1
													}
												}
											}
											pkcs12: {
												description: "PKCS12 requests a PKCS12-formatted binary trust bundle to be written to the target. The bundle is by default created without a password."

												type: "object"
												required: ["key"]
												properties: {
													key: {
														description: "Key is the key of the entry in the object's `data` field to be used."

														type: "string"
													}
													password: {
														description: "Password for PKCS12 trust store"
														type:        "string"
														default:     ""
														maxLength:   128
													}
												}
											}
										}
									}
									configMap: {
										description: "ConfigMap is the target ConfigMap in Namespaces that all Bundle source data will be synced to."

										type: "object"
										required: ["key"]
										properties: key: {
											description: "Key is the key of the entry in the object's `data` field to be used."

											type: "string"
										}
									}
									namespaceSelector: {
										description: "NamespaceSelector will, if set, only sync the target resource in Namespaces which match the selector."

										type: "object"
										properties: matchLabels: {
											description: "MatchLabels matches on the set of labels that must be present on a Namespace for the Bundle target to be synced there."

											type: "object"
											additionalProperties: type: "string"
										}
									}
									secret: {
										description: "Secret is the target Secret that all Bundle source data will be synced to. Using Secrets as targets is only supported if enabled at trust-manager startup. By default, trust-manager has no permissions for writing to secrets and can only read secrets in the trust namespace."

										type: "object"
										required: ["key"]
										properties: key: {
											description: "Key is the key of the entry in the object's `data` field to be used."

											type: "string"
										}
									}
								}
							}
						}
					}
					status: {
						description: "Status of the Bundle. This is set and managed automatically."
						type:        "object"
						properties: {
							conditions: {
								description: "List of status conditions to indicate the status of the Bundle. Known condition types are `Bundle`."

								type: "array"
								items: {
									description: "BundleCondition contains condition information for a Bundle."

									type: "object"
									required: [
										"lastTransitionTime",
										"reason",
										"status",
										"type",
									]
									properties: {
										lastTransitionTime: {
											description: "LastTransitionTime is the timestamp corresponding to the last status change of this condition."

											type:   "string"
											format: "date-time"
										}
										message: {
											description: "Message is a human-readable description of the details of the last transition, complementing reason."

											type:      "string"
											maxLength: 32768
										}
										observedGeneration: {
											description: "If set, this represents the .metadata.generation that the condition was set based upon. For instance, if .metadata.generation is currently 12, but the .status.condition[x].observedGeneration is 9, the condition is out of date with respect to the current state of the Bundle."

											type:    "integer"
											format:  "int64"
											minimum: 0
										}
										reason: {
											description: "Reason is a brief machine-readable explanation for the condition's last transition. The value should be a CamelCase string. This field may not be empty."

											type:      "string"
											maxLength: 1024
											minLength: 1
											pattern:   "^[A-Za-z]([A-Za-z0-9_,:]*[A-Za-z0-9_])?$"
										}
										status: {
											description: "Status of the condition, one of True, False, Unknown."

											type: "string"
											enum: [
												"True",
												"False",
												"Unknown",
											]
										}
										type: {
											description: "Type of the condition, known values are (`Synced`)."
											type:        "string"
											maxLength:   316
											pattern:     "^([a-z0-9]([-a-z0-9]*[a-z0-9])?(\\.[a-z0-9]([-a-z0-9]*[a-z0-9])?)*/)?(([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9])$"
										}
									}
								}
								"x-kubernetes-list-map-keys": ["type"]
								"x-kubernetes-list-type": "map"
							}
							defaultCAVersion: {
								description: "DefaultCAPackageVersion, if set and non-empty, indicates the version information which was retrieved when the set of default CAs was requested in the bundle source. This should only be set if useDefaultCAs was set to \"true\" on a source, and will be the same for the same version of a bundle with identical certificates."

								type: "string"
							}
						}
					}
				}
			}
			served:  true
			storage: true
			subresources: status: {}
		}]
	}
}
