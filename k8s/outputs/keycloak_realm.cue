// Keycloak realm used to seed a realm and client when installing Keycloak
// into the mesh. This configuration is not used for SaaS Keycloak providers.

package greymatter

_sslRequired: *"none" | string
if defaults.edge.enable_tls {_sslRequired: "external"}

realm_data: {
	"id":                                  "fd023dcc-aaec-4001-aafe-56988e38eaea"
	"realm":                               "greymatter"
	"notBefore":                           0
	"defaultSignatureAlgorithm":           "RS256"
	"revokeRefreshToken":                  false
	"refreshTokenMaxReuse":                0
	"accessTokenLifespan":                 300
	"accessTokenLifespanForImplicitFlow":  900
	"ssoSessionIdleTimeout":               1800
	"ssoSessionMaxLifespan":               36000
	"ssoSessionIdleTimeoutRememberMe":     0
	"ssoSessionMaxLifespanRememberMe":     0
	"offlineSessionIdleTimeout":           2592000
	"offlineSessionMaxLifespanEnabled":    false
	"offlineSessionMaxLifespan":           5184000
	"clientSessionIdleTimeout":            0
	"clientSessionMaxLifespan":            0
	"clientOfflineSessionIdleTimeout":     0
	"clientOfflineSessionMaxLifespan":     0
	"accessCodeLifespan":                  60
	"accessCodeLifespanUserAction":        300
	"accessCodeLifespanLogin":             1800
	"actionTokenGeneratedByAdminLifespan": 43200
	"actionTokenGeneratedByUserLifespan":  300
	"oauth2DeviceCodeLifespan":            600
	"oauth2DevicePollingInterval":         5
	"enabled":                             true
	"sslRequired":                         _sslRequired
	"registrationAllowed":                 false
	"registrationEmailAsUsername":         false
	"rememberMe":                          false
	"verifyEmail":                         false
	"loginWithEmailAllowed":               true
	"duplicateEmailsAllowed":              false
	"resetPasswordAllowed":                false
	"editUsernameAllowed":                 false
	"bruteForceProtected":                 false
	"permanentLockout":                    false
	"maxFailureWaitSeconds":               900
	"minimumQuickLoginWaitSeconds":        60
	"waitIncrementSeconds":                60
	"quickLoginCheckMilliSeconds":         1000
	"maxDeltaTimeSeconds":                 43200
	"failureFactor":                       30
	"defaultRole": {
		"id":          "3dfe69a9-2dc6-4e2c-a230-63274f4da21d"
		"name":        "default-roles-greymatter"
		"description": "${role_default-roles}"
		"composite":   true
		"clientRole":  false
		"containerId": "fd023dcc-aaec-4001-aafe-56988e38eaea"
	}
	"requiredCredentials": [
		"password",
	]
	"otpPolicyType":            "totp"
	"otpPolicyAlgorithm":       "HmacSHA1"
	"otpPolicyInitialCounter":  0
	"otpPolicyDigits":          6
	"otpPolicyLookAheadWindow": 1
	"otpPolicyPeriod":          30
	"otpSupportedApplications": [
		"FreeOTP",
		"Google Authenticator",
	]
	"webAuthnPolicyRpEntityName": "keycloak"
	"webAuthnPolicySignatureAlgorithms": [
		"ES256",
	]
	"webAuthnPolicyRpId":                            ""
	"webAuthnPolicyAttestationConveyancePreference": "not specified"
	"webAuthnPolicyAuthenticatorAttachment":         "not specified"
	"webAuthnPolicyRequireResidentKey":              "not specified"
	"webAuthnPolicyUserVerificationRequirement":     "not specified"
	"webAuthnPolicyCreateTimeout":                   0
	"webAuthnPolicyAvoidSameAuthenticatorRegister":  false
	"webAuthnPolicyAcceptableAaguids": []
	"webAuthnPolicyPasswordlessRpEntityName": "keycloak"
	"webAuthnPolicyPasswordlessSignatureAlgorithms": [
		"ES256",
	]
	"webAuthnPolicyPasswordlessRpId":                            ""
	"webAuthnPolicyPasswordlessAttestationConveyancePreference": "not specified"
	"webAuthnPolicyPasswordlessAuthenticatorAttachment":         "not specified"
	"webAuthnPolicyPasswordlessRequireResidentKey":              "not specified"
	"webAuthnPolicyPasswordlessUserVerificationRequirement":     "not specified"
	"webAuthnPolicyPasswordlessCreateTimeout":                   0
	"webAuthnPolicyPasswordlessAvoidSameAuthenticatorRegister":  false
	"webAuthnPolicyPasswordlessAcceptableAaguids": []
	"scopeMappings": [
		{
			"clientScope": "offline_access"
			"roles": [
				"offline_access",
			]
		},
	]
	"clientScopes": [
		{
			"id":          "5a89bdcc-202c-41b6-8bcd-db6b2eda5487"
			"name":        "web-origins"
			"description": "OpenID Connect scope for add allowed web origins to the access token"
			"protocol":    "openid-connect"
			"attributes": {
				"include.in.token.scope":    "false"
				"display.on.consent.screen": "false"
				"consent.screen.text":       ""
			}
			"protocolMappers": [
				{
					"id":              "0d665bc7-573a-443a-bec6-df5271ea9fa1"
					"name":            "allowed web origins"
					"protocol":        "openid-connect"
					"protocolMapper":  "oidc-allowed-origins-mapper"
					"consentRequired": false
					"config": {}
				},
			]
		},
		{
			"id":          "8f263a4d-30b5-4c8b-924b-6edc0568c12f"
			"name":        "offline_access"
			"description": "OpenID Connect built-in scope: offline_access"
			"protocol":    "openid-connect"
			"attributes": {
				"consent.screen.text":       "${offlineAccessScopeConsentText}"
				"display.on.consent.screen": "true"
			}
		},
		{
			"id":          "ddc0b593-fb45-47d3-a3c3-d885cec9ad68"
			"name":        "profile"
			"description": "OpenID Connect built-in scope: profile"
			"protocol":    "openid-connect"
			"attributes": {
				"include.in.token.scope":    "true"
				"display.on.consent.screen": "true"
				"consent.screen.text":       "${profileScopeConsentText}"
			}
			"protocolMappers": [
				{
					"id":              "fa4f3714-bfed-4a06-9a31-57a79083a8ce"
					"name":            "given name"
					"protocol":        "openid-connect"
					"protocolMapper":  "oidc-usermodel-property-mapper"
					"consentRequired": false
					"config": {
						"userinfo.token.claim": "true"
						"user.attribute":       "firstName"
						"id.token.claim":       "true"
						"access.token.claim":   "true"
						"claim.name":           "given_name"
						"jsonType.label":       "String"
					}
				},
				{
					"id":              "0c3f11cc-38c5-4c8f-8c91-bc6232cfeed5"
					"name":            "locale"
					"protocol":        "openid-connect"
					"protocolMapper":  "oidc-usermodel-attribute-mapper"
					"consentRequired": false
					"config": {
						"userinfo.token.claim": "true"
						"user.attribute":       "locale"
						"id.token.claim":       "true"
						"access.token.claim":   "true"
						"claim.name":           "locale"
						"jsonType.label":       "String"
					}
				},
				{
					"id":              "7846212a-5bca-481f-9014-2443f4ef9fde"
					"name":            "website"
					"protocol":        "openid-connect"
					"protocolMapper":  "oidc-usermodel-attribute-mapper"
					"consentRequired": false
					"config": {
						"userinfo.token.claim": "true"
						"user.attribute":       "website"
						"id.token.claim":       "true"
						"access.token.claim":   "true"
						"claim.name":           "website"
						"jsonType.label":       "String"
					}
				},
				{
					"id":              "212e3c99-6a6a-418b-874a-9363e303d138"
					"name":            "picture"
					"protocol":        "openid-connect"
					"protocolMapper":  "oidc-usermodel-attribute-mapper"
					"consentRequired": false
					"config": {
						"userinfo.token.claim": "true"
						"user.attribute":       "picture"
						"id.token.claim":       "true"
						"access.token.claim":   "true"
						"claim.name":           "picture"
						"jsonType.label":       "String"
					}
				},
				{
					"id":              "4a55dfd9-34b0-47de-8df0-40f31c84d616"
					"name":            "profile"
					"protocol":        "openid-connect"
					"protocolMapper":  "oidc-usermodel-attribute-mapper"
					"consentRequired": false
					"config": {
						"userinfo.token.claim": "true"
						"user.attribute":       "profile"
						"id.token.claim":       "true"
						"access.token.claim":   "true"
						"claim.name":           "profile"
						"jsonType.label":       "String"
					}
				},
				{
					"id":              "e9df0e7d-9655-4249-8209-9f69bd5d6545"
					"name":            "updated at"
					"protocol":        "openid-connect"
					"protocolMapper":  "oidc-usermodel-attribute-mapper"
					"consentRequired": false
					"config": {
						"userinfo.token.claim": "true"
						"user.attribute":       "updatedAt"
						"id.token.claim":       "true"
						"access.token.claim":   "true"
						"claim.name":           "updated_at"
						"jsonType.label":       "long"
					}
				},
				{
					"id":              "53b8851e-03da-468f-b3e4-251d68a1a9f5"
					"name":            "full name"
					"protocol":        "openid-connect"
					"protocolMapper":  "oidc-full-name-mapper"
					"consentRequired": false
					"config": {
						"id.token.claim":       "true"
						"access.token.claim":   "true"
						"userinfo.token.claim": "true"
					}
				},
				{
					"id":              "a1dceec0-3067-4ee0-b6f5-1c82d17a4241"
					"name":            "zoneinfo"
					"protocol":        "openid-connect"
					"protocolMapper":  "oidc-usermodel-attribute-mapper"
					"consentRequired": false
					"config": {
						"userinfo.token.claim": "true"
						"user.attribute":       "zoneinfo"
						"id.token.claim":       "true"
						"access.token.claim":   "true"
						"claim.name":           "zoneinfo"
						"jsonType.label":       "String"
					}
				},
				{
					"id":              "9e1a326c-4396-4197-b546-d98516eb0229"
					"name":            "family name"
					"protocol":        "openid-connect"
					"protocolMapper":  "oidc-usermodel-property-mapper"
					"consentRequired": false
					"config": {
						"userinfo.token.claim": "true"
						"user.attribute":       "lastName"
						"id.token.claim":       "true"
						"access.token.claim":   "true"
						"claim.name":           "family_name"
						"jsonType.label":       "String"
					}
				},
				{
					"id":              "13717d32-ffe0-4dd5-b944-c85e615bf839"
					"name":            "birthdate"
					"protocol":        "openid-connect"
					"protocolMapper":  "oidc-usermodel-attribute-mapper"
					"consentRequired": false
					"config": {
						"userinfo.token.claim": "true"
						"user.attribute":       "birthdate"
						"id.token.claim":       "true"
						"access.token.claim":   "true"
						"claim.name":           "birthdate"
						"jsonType.label":       "String"
					}
				},
				{
					"id":              "f911e6e7-1515-4ed8-9d1f-dd219d8dee68"
					"name":            "gender"
					"protocol":        "openid-connect"
					"protocolMapper":  "oidc-usermodel-attribute-mapper"
					"consentRequired": false
					"config": {
						"userinfo.token.claim": "true"
						"user.attribute":       "gender"
						"id.token.claim":       "true"
						"access.token.claim":   "true"
						"claim.name":           "gender"
						"jsonType.label":       "String"
					}
				},
				{
					"id":              "3dabfe64-e93e-45df-a236-6c2e460d6c07"
					"name":            "middle name"
					"protocol":        "openid-connect"
					"protocolMapper":  "oidc-usermodel-attribute-mapper"
					"consentRequired": false
					"config": {
						"userinfo.token.claim": "true"
						"user.attribute":       "middleName"
						"id.token.claim":       "true"
						"access.token.claim":   "true"
						"claim.name":           "middle_name"
						"jsonType.label":       "String"
					}
				},
				{
					"id":              "3689d7fc-3517-4eb1-a12b-e567ee94117a"
					"name":            "nickname"
					"protocol":        "openid-connect"
					"protocolMapper":  "oidc-usermodel-attribute-mapper"
					"consentRequired": false
					"config": {
						"userinfo.token.claim": "true"
						"user.attribute":       "nickname"
						"id.token.claim":       "true"
						"access.token.claim":   "true"
						"claim.name":           "nickname"
						"jsonType.label":       "String"
					}
				},
				{
					"id":              "acb60891-ed8e-4d7d-b464-5dc1ad1249fa"
					"name":            "username"
					"protocol":        "openid-connect"
					"protocolMapper":  "oidc-usermodel-property-mapper"
					"consentRequired": false
					"config": {
						"userinfo.token.claim": "true"
						"user.attribute":       "username"
						"id.token.claim":       "true"
						"access.token.claim":   "true"
						"claim.name":           "preferred_username"
						"jsonType.label":       "String"
					}
				},
			]
		},
		{
			"id":          "1554d085-7deb-4766-a90c-9ce20e1a53fc"
			"name":        "roles"
			"description": "OpenID Connect scope for add user roles to the access token"
			"protocol":    "openid-connect"
			"attributes": {
				"include.in.token.scope":    "false"
				"display.on.consent.screen": "true"
				"consent.screen.text":       "${rolesScopeConsentText}"
			}
			"protocolMappers": [
				{
					"id":              "5705a6ed-dc2a-4963-95ba-fe9eb374fe24"
					"name":            "realm roles"
					"protocol":        "openid-connect"
					"protocolMapper":  "oidc-usermodel-realm-role-mapper"
					"consentRequired": false
					"config": {
						"user.attribute":     "foo"
						"access.token.claim": "true"
						"claim.name":         "realm_access.roles"
						"jsonType.label":     "String"
						"multivalued":        "true"
					}
				},
				{
					"id":              "83149c3d-0a07-49d9-a0d4-5ae972917671"
					"name":            "audience resolve"
					"protocol":        "openid-connect"
					"protocolMapper":  "oidc-audience-resolve-mapper"
					"consentRequired": false
					"config": {}
				},
				{
					"id":              "413cfb90-5df6-4504-b214-c9ba0c6011af"
					"name":            "client roles"
					"protocol":        "openid-connect"
					"protocolMapper":  "oidc-usermodel-client-role-mapper"
					"consentRequired": false
					"config": {
						"user.attribute":     "foo"
						"access.token.claim": "true"
						"claim.name":         "resource_access.${client_id}.roles"
						"jsonType.label":     "String"
						"multivalued":        "true"
					}
				},
			]
		},
		{
			"id":          "3bff2fac-e2b0-44a1-855a-8aa782f1cc54"
			"name":        "address"
			"description": "OpenID Connect built-in scope: address"
			"protocol":    "openid-connect"
			"attributes": {
				"include.in.token.scope":    "true"
				"display.on.consent.screen": "true"
				"consent.screen.text":       "${addressScopeConsentText}"
			}
			"protocolMappers": [
				{
					"id":              "b3fff267-8d5c-4bd7-99fa-87c6c3dd38a4"
					"name":            "address"
					"protocol":        "openid-connect"
					"protocolMapper":  "oidc-address-mapper"
					"consentRequired": false
					"config": {
						"user.attribute.formatted":   "formatted"
						"user.attribute.country":     "country"
						"user.attribute.postal_code": "postal_code"
						"userinfo.token.claim":       "true"
						"user.attribute.street":      "street"
						"id.token.claim":             "true"
						"user.attribute.region":      "region"
						"access.token.claim":         "true"
						"user.attribute.locality":    "locality"
					}
				},
			]
		},
		{
			"id":          "e80868a8-3a91-41ed-9ae4-cfa5d1397207"
			"name":        "email"
			"description": "OpenID Connect built-in scope: email"
			"protocol":    "openid-connect"
			"attributes": {
				"include.in.token.scope":    "true"
				"display.on.consent.screen": "true"
				"consent.screen.text":       "${emailScopeConsentText}"
			}
			"protocolMappers": [
				{
					"id":              "4703821e-d5c4-45ec-b6e2-3aa44aa21458"
					"name":            "email verified"
					"protocol":        "openid-connect"
					"protocolMapper":  "oidc-usermodel-property-mapper"
					"consentRequired": false
					"config": {
						"userinfo.token.claim": "true"
						"user.attribute":       "emailVerified"
						"id.token.claim":       "true"
						"access.token.claim":   "true"
						"claim.name":           "email_verified"
						"jsonType.label":       "boolean"
					}
				},
				{
					"id":              "f1e0c3c9-c556-4d2e-95f1-d3d2f4885272"
					"name":            "email"
					"protocol":        "openid-connect"
					"protocolMapper":  "oidc-usermodel-property-mapper"
					"consentRequired": false
					"config": {
						"userinfo.token.claim": "true"
						"user.attribute":       "email"
						"id.token.claim":       "true"
						"access.token.claim":   "true"
						"claim.name":           "email"
						"jsonType.label":       "String"
					}
				},
			]
		},
		{
			"id":          "6d03df24-6125-4197-b71e-8cf0eec95f27"
			"name":        "microprofile-jwt"
			"description": "Microprofile - JWT built-in scope"
			"protocol":    "openid-connect"
			"attributes": {
				"include.in.token.scope":    "true"
				"display.on.consent.screen": "false"
			}
			"protocolMappers": [
				{
					"id":              "fb6d7bf0-3515-4ad9-b450-1b5b5fee6534"
					"name":            "upn"
					"protocol":        "openid-connect"
					"protocolMapper":  "oidc-usermodel-property-mapper"
					"consentRequired": false
					"config": {
						"userinfo.token.claim": "true"
						"user.attribute":       "username"
						"id.token.claim":       "true"
						"access.token.claim":   "true"
						"claim.name":           "upn"
						"jsonType.label":       "String"
					}
				},
				{
					"id":              "2976b5eb-0058-41d1-9b70-c90f9173a3f4"
					"name":            "groups"
					"protocol":        "openid-connect"
					"protocolMapper":  "oidc-usermodel-realm-role-mapper"
					"consentRequired": false
					"config": {
						"multivalued":        "true"
						"user.attribute":     "foo"
						"id.token.claim":     "true"
						"access.token.claim": "true"
						"claim.name":         "groups"
						"jsonType.label":     "String"
					}
				},
			]
		},
		{
			"id":          "c8bbd294-d17f-4078-9f59-b60a31521f46"
			"name":        "phone"
			"description": "OpenID Connect built-in scope: phone"
			"protocol":    "openid-connect"
			"attributes": {
				"include.in.token.scope":    "true"
				"display.on.consent.screen": "true"
				"consent.screen.text":       "${phoneScopeConsentText}"
			}
			"protocolMappers": [
				{
					"id":              "44503192-ba7d-4c25-8af9-8ef7729deb9c"
					"name":            "phone number"
					"protocol":        "openid-connect"
					"protocolMapper":  "oidc-usermodel-attribute-mapper"
					"consentRequired": false
					"config": {
						"userinfo.token.claim": "true"
						"user.attribute":       "phoneNumber"
						"id.token.claim":       "true"
						"access.token.claim":   "true"
						"claim.name":           "phone_number"
						"jsonType.label":       "String"
					}
				},
				{
					"id":              "539e6c2c-43b4-40d6-9d97-f84aee045e16"
					"name":            "phone number verified"
					"protocol":        "openid-connect"
					"protocolMapper":  "oidc-usermodel-attribute-mapper"
					"consentRequired": false
					"config": {
						"userinfo.token.claim": "true"
						"user.attribute":       "phoneNumberVerified"
						"id.token.claim":       "true"
						"access.token.claim":   "true"
						"claim.name":           "phone_number_verified"
						"jsonType.label":       "boolean"
					}
				},
			]
		},
		{
			"id":          "a9e96a5c-564d-4565-88d6-d17ed1e0dc9b"
			"name":        "role_list"
			"description": "SAML role list"
			"protocol":    "saml"
			"attributes": {
				"consent.screen.text":       "${samlRoleListScopeConsentText}"
				"display.on.consent.screen": "true"
			}
			"protocolMappers": [
				{
					"id":              "7af6262c-6f28-4717-bff1-65af7a18dedd"
					"name":            "role list"
					"protocol":        "saml"
					"protocolMapper":  "saml-role-list-mapper"
					"consentRequired": false
					"config": {
						"single":               "false"
						"attribute.nameformat": "Basic"
						"attribute.name":       "Role"
					}
				},
			]
		},
		{
			"id":          "88378846-0dde-413b-9275-d38e0e2d92aa"
			"name":        "acr"
			"description": "OpenID Connect scope for add acr (authentication context class reference) to the token"
			"protocol":    "openid-connect"
			"attributes": {
				"include.in.token.scope":    "false"
				"display.on.consent.screen": "false"
			}
			"protocolMappers": [
				{
					"id":              "94ab0193-ec72-40ca-9bcd-e10e16e2e2d8"
					"name":            "acr loa level"
					"protocol":        "openid-connect"
					"protocolMapper":  "oidc-acr-mapper"
					"consentRequired": false
					"config": {
						"id.token.claim":     "true"
						"access.token.claim": "true"
					}
				},
			]
		},
	]
	"defaultDefaultClientScopes": [
		"role_list",
		"profile",
		"email",
		"roles",
		"web-origins",
		"acr",
	]
	"defaultOptionalClientScopes": [
		"offline_access",
		"address",
		"phone",
		"microprofile-jwt",
	]
	"browserSecurityHeaders": {
		"contentSecurityPolicyReportOnly": ""
		"xContentTypeOptions":             "nosniff"
		"xRobotsTag":                      "none"
		"xFrameOptions":                   "SAMEORIGIN"
		"contentSecurityPolicy":           "frame-src 'self'; frame-ancestors 'self'; object-src 'none';"
		"xXSSProtection":                  "1; mode=block"
		"strictTransportSecurity":         "max-age=31536000; includeSubDomains"
	}
	"smtpServer": {}
	"eventsEnabled": false
	"eventsListeners": [
		"jboss-logging",
	]
	"enabledEventTypes": []
	"adminEventsEnabled":        false
	"adminEventsDetailsEnabled": false
	"identityProviders": []
	"identityProviderMappers": []
	"components": {
		"org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy": [
			{
				"id":         "5c17eed4-0f0a-40b6-b829-23f67606ab75"
				"name":       "Allowed Protocol Mapper Types"
				"providerId": "allowed-protocol-mappers"
				"subType":    "anonymous"
				"subComponents": {}
				"config": {
					"allowed-protocol-mapper-types": [
						"oidc-usermodel-attribute-mapper",
						"saml-user-attribute-mapper",
						"saml-role-list-mapper",
						"oidc-sha256-pairwise-sub-mapper",
						"saml-user-property-mapper",
						"oidc-address-mapper",
						"oidc-usermodel-property-mapper",
						"oidc-full-name-mapper",
					]
				}
			},
			{
				"id":         "31ac838c-e477-4a60-afe2-dd9c2bc9b8e1"
				"name":       "Full Scope Disabled"
				"providerId": "scope"
				"subType":    "anonymous"
				"subComponents": {}
				"config": {}
			},
			{
				"id":         "dbb60ff2-118e-4560-a0bb-ed44ea696e18"
				"name":       "Allowed Client Scopes"
				"providerId": "allowed-client-templates"
				"subType":    "authenticated"
				"subComponents": {}
				"config": {
					"allow-default-scopes": [
						"true",
					]
				}
			},
			{
				"id":         "b7b2f9dc-f457-473b-b296-2dbbd41fe9f5"
				"name":       "Allowed Protocol Mapper Types"
				"providerId": "allowed-protocol-mappers"
				"subType":    "authenticated"
				"subComponents": {}
				"config": {
					"allowed-protocol-mapper-types": [
						"saml-user-property-mapper",
						"saml-role-list-mapper",
						"saml-user-attribute-mapper",
						"oidc-sha256-pairwise-sub-mapper",
						"oidc-address-mapper",
						"oidc-usermodel-attribute-mapper",
						"oidc-usermodel-property-mapper",
						"oidc-full-name-mapper",
					]
				}
			},
			{
				"id":         "5ae80fb6-8928-4be4-9b74-c1d5323f20e9"
				"name":       "Consent Required"
				"providerId": "consent-required"
				"subType":    "anonymous"
				"subComponents": {}
				"config": {}
			},
			{
				"id":         "84a0568a-87b5-43c9-be79-c334e24783d0"
				"name":       "Trusted Hosts"
				"providerId": "trusted-hosts"
				"subType":    "anonymous"
				"subComponents": {}
				"config": {
					"host-sending-registration-request-must-match": [
						"true",
					]
					"client-uris-must-match": [
						"true",
					]
				}
			},
			{
				"id":         "5bce1a6a-ec3f-4ee3-9ab0-b303b2a7510d"
				"name":       "Max Clients Limit"
				"providerId": "max-clients"
				"subType":    "anonymous"
				"subComponents": {}
				"config": {
					"max-clients": [
						"200",
					]
				}
			},
			{
				"id":         "ed529ed6-015a-4fcd-a834-643da4a196df"
				"name":       "Allowed Client Scopes"
				"providerId": "allowed-client-templates"
				"subType":    "anonymous"
				"subComponents": {}
				"config": {
					"allow-default-scopes": [
						"true",
					]
				}
			},
		]
		"org.keycloak.keys.KeyProvider": [
			{
				"id":         "d7a1d995-2bb4-43d0-a173-83aad7e5380f"
				"name":       "aes-generated"
				"providerId": "aes-generated"
				"subComponents": {}
				"config": {
					"priority": [
						"100",
					]
				}
			},
			{
				"id":         "ce1d5843-10b5-4537-8226-b8c0ad2e6d7d"
				"name":       "rsa-enc-generated"
				"providerId": "rsa-enc-generated"
				"subComponents": {}
				"config": {
					"priority": [
						"100",
					]
					"algorithm": [
						"RSA-OAEP",
					]
				}
			},
			{
				"id":         "0fcc36be-86e9-460e-b540-437e535fd630"
				"name":       "hmac-generated"
				"providerId": "hmac-generated"
				"subComponents": {}
				"config": {
					"priority": [
						"100",
					]
					"algorithm": [
						"HS256",
					]
				}
			},
			{
				"id":         "b856ccae-bff4-4d4c-95f5-db9c67aaace7"
				"name":       "rsa-generated"
				"providerId": "rsa-generated"
				"subComponents": {}
				"config": {
					"priority": [
						"100",
					]
				}
			},
		]
	}
	"internationalizationEnabled": false
	"supportedLocales": []
	"authenticationFlows": [
		{
			"id":          "0b890e36-89dc-4ef2-a71a-623d3f942b15"
			"alias":       "Account verification options"
			"description": "Method with which to verity the existing account"
			"providerId":  "basic-flow"
			"topLevel":    false
			"builtIn":     true
			"authenticationExecutions": [
				{
					"authenticator":     "idp-email-verification"
					"authenticatorFlow": false
					"requirement":       "ALTERNATIVE"
					"priority":          10
					"autheticatorFlow":  false
					"userSetupAllowed":  false
				},
				{
					"authenticatorFlow": true
					"requirement":       "ALTERNATIVE"
					"priority":          20
					"autheticatorFlow":  true
					"flowAlias":         "Verify Existing Account by Re-authentication"
					"userSetupAllowed":  false
				},
			]
		},
		{
			"id":          "73932835-7130-4a69-bcf5-bb398a247d82"
			"alias":       "Authentication Options"
			"description": "Authentication options."
			"providerId":  "basic-flow"
			"topLevel":    false
			"builtIn":     true
			"authenticationExecutions": [
				{
					"authenticator":     "basic-auth"
					"authenticatorFlow": false
					"requirement":       "REQUIRED"
					"priority":          10
					"autheticatorFlow":  false
					"userSetupAllowed":  false
				},
				{
					"authenticator":     "basic-auth-otp"
					"authenticatorFlow": false
					"requirement":       "DISABLED"
					"priority":          20
					"autheticatorFlow":  false
					"userSetupAllowed":  false
				},
				{
					"authenticator":     "auth-spnego"
					"authenticatorFlow": false
					"requirement":       "DISABLED"
					"priority":          30
					"autheticatorFlow":  false
					"userSetupAllowed":  false
				},
			]
		},
		{
			"id":          "22406f43-0192-4581-9ee5-e7e7d945a731"
			"alias":       "Browser - Conditional OTP"
			"description": "Flow to determine if the OTP is required for the authentication"
			"providerId":  "basic-flow"
			"topLevel":    false
			"builtIn":     true
			"authenticationExecutions": [
				{
					"authenticator":     "conditional-user-configured"
					"authenticatorFlow": false
					"requirement":       "REQUIRED"
					"priority":          10
					"autheticatorFlow":  false
					"userSetupAllowed":  false
				},
				{
					"authenticator":     "auth-otp-form"
					"authenticatorFlow": false
					"requirement":       "REQUIRED"
					"priority":          20
					"autheticatorFlow":  false
					"userSetupAllowed":  false
				},
			]
		},
		{
			"id":          "4099fa18-88e5-49a5-a76f-7fb9af2b697a"
			"alias":       "Direct Grant - Conditional OTP"
			"description": "Flow to determine if the OTP is required for the authentication"
			"providerId":  "basic-flow"
			"topLevel":    false
			"builtIn":     true
			"authenticationExecutions": [
				{
					"authenticator":     "conditional-user-configured"
					"authenticatorFlow": false
					"requirement":       "REQUIRED"
					"priority":          10
					"autheticatorFlow":  false
					"userSetupAllowed":  false
				},
				{
					"authenticator":     "direct-grant-validate-otp"
					"authenticatorFlow": false
					"requirement":       "REQUIRED"
					"priority":          20
					"autheticatorFlow":  false
					"userSetupAllowed":  false
				},
			]
		},
		{
			"id":          "4554051d-a4a4-4aa5-99c5-742a5c562668"
			"alias":       "First broker login - Conditional OTP"
			"description": "Flow to determine if the OTP is required for the authentication"
			"providerId":  "basic-flow"
			"topLevel":    false
			"builtIn":     true
			"authenticationExecutions": [
				{
					"authenticator":     "conditional-user-configured"
					"authenticatorFlow": false
					"requirement":       "REQUIRED"
					"priority":          10
					"autheticatorFlow":  false
					"userSetupAllowed":  false
				},
				{
					"authenticator":     "auth-otp-form"
					"authenticatorFlow": false
					"requirement":       "REQUIRED"
					"priority":          20
					"autheticatorFlow":  false
					"userSetupAllowed":  false
				},
			]
		},
		{
			"id":          "a59a8ece-b667-418d-8bba-39aa29c06087"
			"alias":       "Handle Existing Account"
			"description": "Handle what to do if there is existing account with same email/username like authenticated identity provider"
			"providerId":  "basic-flow"
			"topLevel":    false
			"builtIn":     true
			"authenticationExecutions": [
				{
					"authenticator":     "idp-confirm-link"
					"authenticatorFlow": false
					"requirement":       "REQUIRED"
					"priority":          10
					"autheticatorFlow":  false
					"userSetupAllowed":  false
				},
				{
					"authenticatorFlow": true
					"requirement":       "REQUIRED"
					"priority":          20
					"autheticatorFlow":  true
					"flowAlias":         "Account verification options"
					"userSetupAllowed":  false
				},
			]
		},
		{
			"id":          "14058c21-2b4a-4689-b642-7c3cd77b9752"
			"alias":       "Reset - Conditional OTP"
			"description": "Flow to determine if the OTP should be reset or not. Set to REQUIRED to force."
			"providerId":  "basic-flow"
			"topLevel":    false
			"builtIn":     true
			"authenticationExecutions": [
				{
					"authenticator":     "conditional-user-configured"
					"authenticatorFlow": false
					"requirement":       "REQUIRED"
					"priority":          10
					"autheticatorFlow":  false
					"userSetupAllowed":  false
				},
				{
					"authenticator":     "reset-otp"
					"authenticatorFlow": false
					"requirement":       "REQUIRED"
					"priority":          20
					"autheticatorFlow":  false
					"userSetupAllowed":  false
				},
			]
		},
		{
			"id":          "b4ab33b6-8d63-4da8-985d-b1901d6d5c85"
			"alias":       "User creation or linking"
			"description": "Flow for the existing/non-existing user alternatives"
			"providerId":  "basic-flow"
			"topLevel":    false
			"builtIn":     true
			"authenticationExecutions": [
				{
					"authenticatorConfig": "create unique user config"
					"authenticator":       "idp-create-user-if-unique"
					"authenticatorFlow":   false
					"requirement":         "ALTERNATIVE"
					"priority":            10
					"autheticatorFlow":    false
					"userSetupAllowed":    false
				},
				{
					"authenticatorFlow": true
					"requirement":       "ALTERNATIVE"
					"priority":          20
					"autheticatorFlow":  true
					"flowAlias":         "Handle Existing Account"
					"userSetupAllowed":  false
				},
			]
		},
		{
			"id":          "6f7be890-99ea-4101-91a7-e454a772cf19"
			"alias":       "Verify Existing Account by Re-authentication"
			"description": "Reauthentication of existing account"
			"providerId":  "basic-flow"
			"topLevel":    false
			"builtIn":     true
			"authenticationExecutions": [
				{
					"authenticator":     "idp-username-password-form"
					"authenticatorFlow": false
					"requirement":       "REQUIRED"
					"priority":          10
					"autheticatorFlow":  false
					"userSetupAllowed":  false
				},
				{
					"authenticatorFlow": true
					"requirement":       "CONDITIONAL"
					"priority":          20
					"autheticatorFlow":  true
					"flowAlias":         "First broker login - Conditional OTP"
					"userSetupAllowed":  false
				},
			]
		},
		{
			"id":          "2cf48d55-bc3b-4991-b39d-bab4032e5fe9"
			"alias":       "browser"
			"description": "browser based authentication"
			"providerId":  "basic-flow"
			"topLevel":    true
			"builtIn":     true
			"authenticationExecutions": [
				{
					"authenticator":     "auth-cookie"
					"authenticatorFlow": false
					"requirement":       "ALTERNATIVE"
					"priority":          10
					"autheticatorFlow":  false
					"userSetupAllowed":  false
				},
				{
					"authenticator":     "auth-spnego"
					"authenticatorFlow": false
					"requirement":       "DISABLED"
					"priority":          20
					"autheticatorFlow":  false
					"userSetupAllowed":  false
				},
				{
					"authenticator":     "identity-provider-redirector"
					"authenticatorFlow": false
					"requirement":       "ALTERNATIVE"
					"priority":          25
					"autheticatorFlow":  false
					"userSetupAllowed":  false
				},
				{
					"authenticatorFlow": true
					"requirement":       "ALTERNATIVE"
					"priority":          30
					"autheticatorFlow":  true
					"flowAlias":         "forms"
					"userSetupAllowed":  false
				},
			]
		},
		{
			"id":          "f31b06fd-9553-4668-908d-dd33f1c0525c"
			"alias":       "clients"
			"description": "Base authentication for clients"
			"providerId":  "client-flow"
			"topLevel":    true
			"builtIn":     true
			"authenticationExecutions": [
				{
					"authenticator":     "client-secret"
					"authenticatorFlow": false
					"requirement":       "ALTERNATIVE"
					"priority":          10
					"autheticatorFlow":  false
					"userSetupAllowed":  false
				},
				{
					"authenticator":     "client-jwt"
					"authenticatorFlow": false
					"requirement":       "ALTERNATIVE"
					"priority":          20
					"autheticatorFlow":  false
					"userSetupAllowed":  false
				},
				{
					"authenticator":     "client-secret-jwt"
					"authenticatorFlow": false
					"requirement":       "ALTERNATIVE"
					"priority":          30
					"autheticatorFlow":  false
					"userSetupAllowed":  false
				},
				{
					"authenticator":     "client-x509"
					"authenticatorFlow": false
					"requirement":       "ALTERNATIVE"
					"priority":          40
					"autheticatorFlow":  false
					"userSetupAllowed":  false
				},
			]
		},
		{
			"id":          "0cb28830-4791-432b-9cc5-d30740e09808"
			"alias":       "direct grant"
			"description": "OpenID Connect Resource Owner Grant"
			"providerId":  "basic-flow"
			"topLevel":    true
			"builtIn":     true
			"authenticationExecutions": [
				{
					"authenticator":     "direct-grant-validate-username"
					"authenticatorFlow": false
					"requirement":       "REQUIRED"
					"priority":          10
					"autheticatorFlow":  false
					"userSetupAllowed":  false
				},
				{
					"authenticator":     "direct-grant-validate-password"
					"authenticatorFlow": false
					"requirement":       "REQUIRED"
					"priority":          20
					"autheticatorFlow":  false
					"userSetupAllowed":  false
				},
				{
					"authenticatorFlow": true
					"requirement":       "CONDITIONAL"
					"priority":          30
					"autheticatorFlow":  true
					"flowAlias":         "Direct Grant - Conditional OTP"
					"userSetupAllowed":  false
				},
			]
		},
		{
			"id":          "16e6fee7-3495-4d5a-8a02-864b1221b601"
			"alias":       "docker auth"
			"description": "Used by Docker clients to authenticate against the IDP"
			"providerId":  "basic-flow"
			"topLevel":    true
			"builtIn":     true
			"authenticationExecutions": [
				{
					"authenticator":     "docker-http-basic-authenticator"
					"authenticatorFlow": false
					"requirement":       "REQUIRED"
					"priority":          10
					"autheticatorFlow":  false
					"userSetupAllowed":  false
				},
			]
		},
		{
			"id":          "1da77749-f417-4e2a-9b14-752beef3c9d8"
			"alias":       "first broker login"
			"description": "Actions taken after first broker login with identity provider account, which is not yet linked to any Keycloak account"
			"providerId":  "basic-flow"
			"topLevel":    true
			"builtIn":     true
			"authenticationExecutions": [
				{
					"authenticatorConfig": "review profile config"
					"authenticator":       "idp-review-profile"
					"authenticatorFlow":   false
					"requirement":         "REQUIRED"
					"priority":            10
					"autheticatorFlow":    false
					"userSetupAllowed":    false
				},
				{
					"authenticatorFlow": true
					"requirement":       "REQUIRED"
					"priority":          20
					"autheticatorFlow":  true
					"flowAlias":         "User creation or linking"
					"userSetupAllowed":  false
				},
			]
		},
		{
			"id":          "64bba61e-a2b3-47d4-a5fc-b29f1457bad2"
			"alias":       "forms"
			"description": "Username, password, otp and other auth forms."
			"providerId":  "basic-flow"
			"topLevel":    false
			"builtIn":     true
			"authenticationExecutions": [
				{
					"authenticator":     "auth-username-password-form"
					"authenticatorFlow": false
					"requirement":       "REQUIRED"
					"priority":          10
					"autheticatorFlow":  false
					"userSetupAllowed":  false
				},
				{
					"authenticatorFlow": true
					"requirement":       "CONDITIONAL"
					"priority":          20
					"autheticatorFlow":  true
					"flowAlias":         "Browser - Conditional OTP"
					"userSetupAllowed":  false
				},
			]
		},
		{
			"id":          "8baec75c-8278-412e-830a-757e97386ad1"
			"alias":       "http challenge"
			"description": "An authentication flow based on challenge-response HTTP Authentication Schemes"
			"providerId":  "basic-flow"
			"topLevel":    true
			"builtIn":     true
			"authenticationExecutions": [
				{
					"authenticator":     "no-cookie-redirect"
					"authenticatorFlow": false
					"requirement":       "REQUIRED"
					"priority":          10
					"autheticatorFlow":  false
					"userSetupAllowed":  false
				},
				{
					"authenticatorFlow": true
					"requirement":       "REQUIRED"
					"priority":          20
					"autheticatorFlow":  true
					"flowAlias":         "Authentication Options"
					"userSetupAllowed":  false
				},
			]
		},
		{
			"id":          "ea810742-c2e9-4dce-be55-2d3dbb7ed85f"
			"alias":       "registration"
			"description": "registration flow"
			"providerId":  "basic-flow"
			"topLevel":    true
			"builtIn":     true
			"authenticationExecutions": [
				{
					"authenticator":     "registration-page-form"
					"authenticatorFlow": true
					"requirement":       "REQUIRED"
					"priority":          10
					"autheticatorFlow":  true
					"flowAlias":         "registration form"
					"userSetupAllowed":  false
				},
			]
		},
		{
			"id":          "b7c76856-3139-4b7d-8d3a-08a0ded10c9d"
			"alias":       "registration form"
			"description": "registration form"
			"providerId":  "form-flow"
			"topLevel":    false
			"builtIn":     true
			"authenticationExecutions": [
				{
					"authenticator":     "registration-user-creation"
					"authenticatorFlow": false
					"requirement":       "REQUIRED"
					"priority":          20
					"autheticatorFlow":  false
					"userSetupAllowed":  false
				},
				{
					"authenticator":     "registration-profile-action"
					"authenticatorFlow": false
					"requirement":       "REQUIRED"
					"priority":          40
					"autheticatorFlow":  false
					"userSetupAllowed":  false
				},
				{
					"authenticator":     "registration-password-action"
					"authenticatorFlow": false
					"requirement":       "REQUIRED"
					"priority":          50
					"autheticatorFlow":  false
					"userSetupAllowed":  false
				},
				{
					"authenticator":     "registration-recaptcha-action"
					"authenticatorFlow": false
					"requirement":       "DISABLED"
					"priority":          60
					"autheticatorFlow":  false
					"userSetupAllowed":  false
				},
			]
		},
		{
			"id":          "e8c56d4d-e565-468f-8146-7911e5c2ac8e"
			"alias":       "reset credentials"
			"description": "Reset credentials for a user if they forgot their password or something"
			"providerId":  "basic-flow"
			"topLevel":    true
			"builtIn":     true
			"authenticationExecutions": [
				{
					"authenticator":     "reset-credentials-choose-user"
					"authenticatorFlow": false
					"requirement":       "REQUIRED"
					"priority":          10
					"autheticatorFlow":  false
					"userSetupAllowed":  false
				},
				{
					"authenticator":     "reset-credential-email"
					"authenticatorFlow": false
					"requirement":       "REQUIRED"
					"priority":          20
					"autheticatorFlow":  false
					"userSetupAllowed":  false
				},
				{
					"authenticator":     "reset-password"
					"authenticatorFlow": false
					"requirement":       "REQUIRED"
					"priority":          30
					"autheticatorFlow":  false
					"userSetupAllowed":  false
				},
				{
					"authenticatorFlow": true
					"requirement":       "CONDITIONAL"
					"priority":          40
					"autheticatorFlow":  true
					"flowAlias":         "Reset - Conditional OTP"
					"userSetupAllowed":  false
				},
			]
		},
		{
			"id":          "8283ca55-a755-47ff-9c0f-1b055db2d6b0"
			"alias":       "saml ecp"
			"description": "SAML ECP Profile Authentication Flow"
			"providerId":  "basic-flow"
			"topLevel":    true
			"builtIn":     true
			"authenticationExecutions": [
				{
					"authenticator":     "http-basic-authenticator"
					"authenticatorFlow": false
					"requirement":       "REQUIRED"
					"priority":          10
					"autheticatorFlow":  false
					"userSetupAllowed":  false
				},
			]
		},
	]
	"authenticatorConfig": [
		{
			"id":    "0884059b-6591-434e-acc0-00d7db051f4f"
			"alias": "create unique user config"
			"config": {
				"require.password.update.after.registration": "false"
			}
		},
		{
			"id":    "fa9850c5-b16c-4d91-932a-cb98fbfeb402"
			"alias": "review profile config"
			"config": {
				"update.profile.on.first.login": "missing"
			}
		},
	]
	"requiredActions": [
		{
			"alias":         "CONFIGURE_TOTP"
			"name":          "Configure OTP"
			"providerId":    "CONFIGURE_TOTP"
			"enabled":       true
			"defaultAction": false
			"priority":      10
			"config": {}
		},
		{
			"alias":         "terms_and_conditions"
			"name":          "Terms and Conditions"
			"providerId":    "terms_and_conditions"
			"enabled":       false
			"defaultAction": false
			"priority":      20
			"config": {}
		},
		{
			"alias":         "UPDATE_PASSWORD"
			"name":          "Update Password"
			"providerId":    "UPDATE_PASSWORD"
			"enabled":       true
			"defaultAction": false
			"priority":      30
			"config": {}
		},
		{
			"alias":         "UPDATE_PROFILE"
			"name":          "Update Profile"
			"providerId":    "UPDATE_PROFILE"
			"enabled":       true
			"defaultAction": false
			"priority":      40
			"config": {}
		},
		{
			"alias":         "VERIFY_EMAIL"
			"name":          "Verify Email"
			"providerId":    "VERIFY_EMAIL"
			"enabled":       true
			"defaultAction": false
			"priority":      50
			"config": {}
		},
		{
			"alias":         "delete_account"
			"name":          "Delete Account"
			"providerId":    "delete_account"
			"enabled":       false
			"defaultAction": false
			"priority":      60
			"config": {}
		},
		{
			"alias":         "webauthn-register"
			"name":          "Webauthn Register"
			"providerId":    "webauthn-register"
			"enabled":       true
			"defaultAction": false
			"priority":      70
			"config": {}
		},
		{
			"alias":         "webauthn-register-passwordless"
			"name":          "Webauthn Register Passwordless"
			"providerId":    "webauthn-register-passwordless"
			"enabled":       true
			"defaultAction": false
			"priority":      80
			"config": {}
		},
		{
			"alias":         "update_user_locale"
			"name":          "Update User Locale"
			"providerId":    "update_user_locale"
			"enabled":       true
			"defaultAction": false
			"priority":      1000
			"config": {}
		},
	]
	"browserFlow":              "browser"
	"registrationFlow":         "registration"
	"directGrantFlow":          "direct grant"
	"resetCredentialsFlow":     "reset credentials"
	"clientAuthenticationFlow": "clients"
	"dockerAuthenticationFlow": "docker auth"
	"attributes": {
		"cibaBackchannelTokenDeliveryMode": "poll"
		"cibaExpiresIn":                    "120"
		"cibaAuthRequestedUserHint":        "login_hint"
		"oauth2DeviceCodeLifespan":         "600"
		"oauth2DevicePollingInterval":      "5"
		"parRequestUriLifespan":            "60"
		"cibaInterval":                     "5"
	}
	"keycloakVersion":          "19.0.3"
	"userManagedAccessAllowed": false
	"clientProfiles": {
		"profiles": []
	}
	"clientPolicies": {
		"policies": []
	}
}
