// Code generated by timoni. DO NOT EDIT.

//timoni:generate timoni vendor crd -f ./output/cert-manager/templates/crds.yaml

package v1

import "strings"

// A Certificate resource should be created to ensure an up to
// date and signed X.509 certificate is stored in the Kubernetes
// Secret resource named in `spec.secretName`.
// The stored certificate will be renewed before it expires (as
// configured by `spec.renewBefore`).
#Certificate: {
	// APIVersion defines the versioned schema of this representation
	// of an object. Servers should convert recognized schemas to the
	// latest internal value, and may reject unrecognized values.
	// More info:
	// https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources
	apiVersion: "cert-manager.io/v1"

	// Kind is a string value representing the REST resource this
	// object represents. Servers may infer this from the endpoint
	// the client submits requests to. Cannot be updated. In
	// CamelCase. More info:
	// https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds
	kind: "Certificate"
	metadata!: {
		name!: strings.MaxRunes(253) & strings.MinRunes(1) & {
			string
		}
		namespace!: strings.MaxRunes(63) & strings.MinRunes(1) & {
			string
		}
		labels?: {
			[string]: string
		}
		annotations?: {
			[string]: string
		}
	}

	// Specification of the desired state of the Certificate resource.
	// https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#spec-and-status
	spec!: #CertificateSpec
}

// Specification of the desired state of the Certificate resource.
// https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#spec-and-status
#CertificateSpec: {
	// Defines extra output formats of the private key and signed
	// certificate chain to be written to this Certificate's target
	// Secret.
	// This is an Alpha Feature and is only enabled with the
	// `--feature-gates=AdditionalCertificateOutputFormats=true`
	// option set on both the controller and webhook components.
	additionalOutputFormats?: [...{
		// Type is the name of the format type that should be written to
		// the Certificate's target Secret.
		type: "DER" | "CombinedPEM"
	}]

	// Requested common name X509 certificate subject attribute. More
	// info:
	// https://datatracker.ietf.org/doc/html/rfc5280#section-4.1.2.6
	// NOTE: TLS clients will ignore this value when any subject
	// alternative name is set (see
	// https://tools.ietf.org/html/rfc6125#section-6.4.4).
	// Should have a length of 64 characters or fewer to avoid
	// generating invalid CSRs. Cannot be set if the `literalSubject`
	// field is set.
	commonName?: string

	// Requested DNS subject alternative names.
	dnsNames?: [...string]

	// Requested 'duration' (i.e. lifetime) of the Certificate. Note
	// that the issuer may choose to ignore the requested duration,
	// just like any other requested attribute.
	// If unset, this defaults to 90 days. Minimum accepted duration
	// is 1 hour. Value must be in units accepted by Go
	// time.ParseDuration https://golang.org/pkg/time/#ParseDuration.
	duration?: string

	// Requested email subject alternative names.
	emailAddresses?: [...string]

	// Whether the KeyUsage and ExtKeyUsage extensions should be set
	// in the encoded CSR.
	// This option defaults to true, and should only be disabled if
	// the target issuer does not support CSRs with these X509
	// KeyUsage/ ExtKeyUsage extensions.
	encodeUsagesInRequest?: bool

	// Requested IP address subject alternative names.
	ipAddresses?: [...string]

	// Requested basic constraints isCA value. The isCA value is used
	// to set the `isCA` field on the created CertificateRequest
	// resources. Note that the issuer may choose to ignore the
	// requested isCA value, just like any other requested attribute.
	// If true, this will automatically add the `cert sign` usage to
	// the list of requested `usages`.
	isCA?: bool

	// Reference to the issuer responsible for issuing the
	// certificate. If the issuer is namespace-scoped, it must be in
	// the same namespace as the Certificate. If the issuer is
	// cluster-scoped, it can be used from any namespace.
	// The `name` field of the reference must always be specified.
	issuerRef: {
		// Group of the resource being referred to.
		group?: string

		// Kind of the resource being referred to.
		kind?: string

		// Name of the resource being referred to.
		name: string
	}

	// Additional keystore output formats to be stored in the
	// Certificate's Secret.
	keystores?: {
		// JKS configures options for storing a JKS keystore in the
		// `spec.secretName` Secret resource.
		jks?: {
			// Create enables JKS keystore creation for the Certificate. If
			// true, a file named `keystore.jks` will be created in the
			// target Secret resource, encrypted using the password stored in
			// `passwordSecretRef`. The keystore file will be updated
			// immediately. If the issuer provided a CA certificate, a file
			// named `truststore.jks` will also be created in the target
			// Secret resource, encrypted using the password stored in
			// `passwordSecretRef` containing the issuing Certificate
			// Authority
			create: bool

			// PasswordSecretRef is a reference to a key in a Secret resource
			// containing the password used to encrypt the JKS keystore.
			passwordSecretRef: {
				// The key of the entry in the Secret resource's `data` field to
				// be used. Some instances of this field may be defaulted, in
				// others it may be required.
				key?: string

				// Name of the resource being referred to. More info:
				// https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names
				name: string
			}
		}

		// PKCS12 configures options for storing a PKCS12 keystore in the
		// `spec.secretName` Secret resource.
		pkcs12?: {
			// Create enables PKCS12 keystore creation for the Certificate. If
			// true, a file named `keystore.p12` will be created in the
			// target Secret resource, encrypted using the password stored in
			// `passwordSecretRef`. The keystore file will be updated
			// immediately. If the issuer provided a CA certificate, a file
			// named `truststore.p12` will also be created in the target
			// Secret resource, encrypted using the password stored in
			// `passwordSecretRef` containing the issuing Certificate
			// Authority
			create: bool

			// PasswordSecretRef is a reference to a key in a Secret resource
			// containing the password used to encrypt the PKCS12 keystore.
			passwordSecretRef: {
				// The key of the entry in the Secret resource's `data` field to
				// be used. Some instances of this field may be defaulted, in
				// others it may be required.
				key?: string

				// Name of the resource being referred to. More info:
				// https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names
				name: string
			}
		}
	}

	// Requested X.509 certificate subject, represented using the LDAP
	// "String Representation of a Distinguished Name" [1].
	// Important: the LDAP string format also specifies the order of
	// the attributes in the subject, this is important when issuing
	// certs for LDAP authentication. Example:
	// `CN=foo,DC=corp,DC=example,DC=com` More info [1]:
	// https://datatracker.ietf.org/doc/html/rfc4514 More info:
	// https://github.com/cert-manager/cert-manager/issues/3203 More
	// info: https://github.com/cert-manager/cert-manager/issues/4424
	// Cannot be set if the `subject` or `commonName` field is set.
	// This is an Alpha Feature and is only enabled with the
	// `--feature-gates=LiteralCertificateSubject=true` option set on
	// both the controller and webhook components.
	literalSubject?: string

	// Private key options. These include the key algorithm and size,
	// the used encoding and the rotation policy.
	privateKey?: {
		// Algorithm is the private key algorithm of the corresponding
		// private key for this certificate.
		// If provided, allowed values are either `RSA`, `ECDSA` or
		// `Ed25519`. If `algorithm` is specified and `size` is not
		// provided, key size of 2048 will be used for `RSA` key
		// algorithm and key size of 256 will be used for `ECDSA` key
		// algorithm. key size is ignored when using the `Ed25519` key
		// algorithm.
		algorithm?: "RSA" | "ECDSA" | "Ed25519"

		// The private key cryptography standards (PKCS) encoding for this
		// certificate's private key to be encoded in.
		// If provided, allowed values are `PKCS1` and `PKCS8` standing
		// for PKCS#1 and PKCS#8, respectively. Defaults to `PKCS1` if
		// not specified.
		encoding?: "PKCS1" | "PKCS8"

		// RotationPolicy controls how private keys should be regenerated
		// when a re-issuance is being processed.
		// If set to `Never`, a private key will only be generated if one
		// does not already exist in the target `spec.secretName`. If one
		// does exists but it does not have the correct algorithm or
		// size, a warning will be raised to await user intervention. If
		// set to `Always`, a private key matching the specified
		// requirements will be generated whenever a re-issuance occurs.
		// Default is `Never` for backward compatibility.
		rotationPolicy?: "Never" | "Always"

		// Size is the key bit size of the corresponding private key for
		// this certificate.
		// If `algorithm` is set to `RSA`, valid values are `2048`, `4096`
		// or `8192`, and will default to `2048` if not specified. If
		// `algorithm` is set to `ECDSA`, valid values are `256`, `384`
		// or `521`, and will default to `256` if not specified. If
		// `algorithm` is set to `Ed25519`, Size is ignored. No other
		// values are allowed.
		size?: int
	}

	// How long before the currently issued certificate's expiry
	// cert-manager should renew the certificate. For example, if a
	// certificate is valid for 60 minutes, and `renewBefore=10m`,
	// cert-manager will begin to attempt to renew the certificate 50
	// minutes after it was issued (i.e. when there are 10 minutes
	// remaining until the certificate is no longer valid).
	// NOTE: The actual lifetime of the issued certificate is used to
	// determine the renewal time. If an issuer returns a certificate
	// with a different lifetime than the one requested, cert-manager
	// will use the lifetime of the issued certificate.
	// If unset, this defaults to 1/3 of the issued certificate's
	// lifetime. Minimum accepted value is 5 minutes. Value must be
	// in units accepted by Go time.ParseDuration
	// https://golang.org/pkg/time/#ParseDuration.
	renewBefore?: string

	// The maximum number of CertificateRequest revisions that are
	// maintained in the Certificate's history. Each revision
	// represents a single `CertificateRequest` created by this
	// Certificate, either when it was created, renewed, or Spec was
	// changed. Revisions will be removed by oldest first if the
	// number of revisions exceeds this number.
	// If set, revisionHistoryLimit must be a value of `1` or greater.
	// If unset (`nil`), revisions will not be garbage collected.
	// Default value is `nil`.
	revisionHistoryLimit?: int

	// Name of the Secret resource that will be automatically created
	// and managed by this Certificate resource. It will be populated
	// with a private key and certificate, signed by the denoted
	// issuer. The Secret resource lives in the same namespace as the
	// Certificate resource.
	secretName: string

	// Defines annotations and labels to be copied to the
	// Certificate's Secret. Labels and annotations on the Secret
	// will be changed as they appear on the SecretTemplate when
	// added or removed. SecretTemplate annotations are added in
	// conjunction with, and cannot overwrite, the base set of
	// annotations cert-manager sets on the Certificate's Secret.
	secretTemplate?: {
		// Annotations is a key value map to be copied to the target
		// Kubernetes Secret.
		annotations?: {
			[string]: string
		}

		// Labels is a key value map to be copied to the target Kubernetes
		// Secret.
		labels?: {
			[string]: string
		}
	}

	// Requested set of X509 certificate subject attributes. More
	// info:
	// https://datatracker.ietf.org/doc/html/rfc5280#section-4.1.2.6
	// The common name attribute is specified separately in the
	// `commonName` field. Cannot be set if the `literalSubject`
	// field is set.
	subject?: {
		// Countries to be used on the Certificate.
		countries?: [...string]

		// Cities to be used on the Certificate.
		localities?: [...string]

		// Organizational Units to be used on the Certificate.
		organizationalUnits?: [...string]

		// Organizations to be used on the Certificate.
		organizations?: [...string]

		// Postal codes to be used on the Certificate.
		postalCodes?: [...string]

		// State/Provinces to be used on the Certificate.
		provinces?: [...string]

		// Serial number to be used on the Certificate.
		serialNumber?: string

		// Street addresses to be used on the Certificate.
		streetAddresses?: [...string]
	}

	// Requested URI subject alternative names.
	uris?: [...string]

	// Requested key usages and extended key usages. These usages are
	// used to set the `usages` field on the created
	// CertificateRequest resources. If `encodeUsagesInRequest` is
	// unset or set to `true`, the usages will additionally be
	// encoded in the `request` field which contains the CSR blob.
	// If unset, defaults to `digital signature` and `key
	// encipherment`.
	usages?: [..."signing" | "digital signature" | "content commitment" | "key encipherment" | "key agreement" | "data encipherment" | "cert sign" | "crl sign" | "encipher only" | "decipher only" | "any" | "server auth" | "client auth" | "code signing" | "email protection" | "s/mime" | "ipsec end system" | "ipsec tunnel" | "ipsec user" | "timestamping" | "ocsp signing" | "microsoft sgc" | "netscape sgc"]
}
