## HTTP Transfer Profile

This profile defines a [Transfer Profile](../signaling.md#transfer-profile-registry) for transferring data
over HTTP. It is a **transport-protocol profile**: it is bound only to the HTTP wire protocol and does not define any
dataspace usecase or business semantics beyond transport.

The profile supports both transfer directions:

- **pull** — the provider [=Data Plane=] exposes an HTTP API from which the consumer retrieves data.
- **push** — the consumer [=Data Plane=] exposes an HTTP API to which the provider sends data.

In both directions the exposed API MUST be served over HTTPS.

The key words “MUST”, “MUST NOT”, “REQUIRED”, “SHALL”, “SHALL NOT”, “SHOULD”, “SHOULD NOT”, “RECOMMENDED”, “NOT
RECOMMENDED”, “MAY”, and “OPTIONAL” in this document are to be interpreted as described in
[RFC 8174](https://datatracker.ietf.org/doc/html/rfc8174).

## Profile URL

> This section is normative.

This profile is rooted at the following **profile URL**, under which this document is published:

```
https://w3id.org/dspace-sig/profile/http
```

## Transfer Profiles

> This section is normative.

This profile declares the following `profile` values, formed by appending `-push` and `-pull` to the profile URL:

- `https://w3id.org/dspace-sig/profile/http-push`
- `https://w3id.org/dspace-sig/profile/http-pull`

A [=Data Plane=] that supports this profile advertises one or both of these values in the `profiles` property of
its [Data Plane Registration Message](../signaling.md#the-data-plane-registration-message). The same values are
referenced from `DataFlowPrepareMessage` and `DataFlowStartMessage` via the `profile` property.

A [=Data Plane=] MUST NOT advertise a `profile` value for a direction it does not support.

## Endpoint Type and DataAddress

> This section is normative.

The `DataAddress` `endpointType` value identifies the transfer direction using the `-push` or `-pull` postfix and MUST
be one of the two `profile` values declared above:

- For a pull transfer, the `endpointType` MUST be `https://w3id.org/dspace-sig/profile/http-pull`.
- For a push transfer, the `endpointType` MUST be `https://w3id.org/dspace-sig/profile/http-push`.

The `endpoint` property MUST be a valid HTTP URL that uses the HTTPS scheme. A receiving party MUST reject a
`DataAddress` whose `endpoint` does not use the HTTPS scheme.

This profile defines the following `endpointProperties` within the `DataAddress`:

- `authorization` — OPTIONAL: An access token the requesting party presents to the API exposed at `endpoint`. If
  present, `authType` MUST also be present.
- `authType` — REQUIRED if `authorization` is present: The token presentation type. Implementations MUST support the
  value `bearer`, in which case the token is presented in the HTTP `Authorization` header as defined in
  [RFC 6750](https://datatracker.ietf.org/doc/html/rfc6750).

Properties not defined by this profile and not defined by a profile it references MUST be ignored by a receiving party.

The JSON Schema for the `DataAddress` defined by this profile is published at:

```
https://w3id.org/dspace-sig/profile/http/data-address-schema.json
```

The schema references the base `DataAddress` schema governed by this specification.

### Pull

For a pull transfer, the provider [=Data Plane=] generates the `DataAddress` as part of the transition to the STARTED
state, as described in [Pull Protocol Messaging](../signaling.md#pull-protocol-messaging). The `endpointType` MUST be
`https://w3id.org/dspace-sig/profile/http-pull`, and `endpoint` MUST be the HTTPS URL of the provider API from which the
consumer retrieves data.

The consumer initiates the transfer by issuing HTTP requests to `endpoint`, presenting the `authorization` token, if
present, according to `authType`.

The following is a NON-NORMATIVE example of a pull `DataAddress`:

```json
{
  "@type": "DataAddress",
  "endpointType": "https://w3id.org/dspace-sig/profile/http-pull",
  "endpoint": "https://provider.example.com/data/asset-123",
  "endpointProperties": [
    {
      "name": "authorization",
      "value": "TOKEN-ABCDEFG"
    },
    {
      "name": "authType",
      "value": "bearer"
    }
  ]
}
```

### Push

For a push transfer, the consumer [=Data Plane=] generates the `DataAddress` as part of the transition to the PREPARED
state, as described in [Push Protocol Messaging](../signaling.md#push-protocol-messaging). The `endpointType` MUST be
`https://w3id.org/dspace-sig/profile/http-push`, and `endpoint` MUST be the HTTPS URL of the consumer API to which the
provider sends data.

The provider sends data by issuing HTTP requests to `endpoint`, presenting the `authorization` token, if present,
according to `authType`.

The following is a NON-NORMATIVE example of a push `DataAddress`:

```json
{
  "@type": "DataAddress",
  "endpointType": "https://w3id.org/dspace-sig/profile/http-push",
  "endpoint": "https://consumer.example.com/ingest/process-456",
  "endpointProperties": [
    {
      "name": "authorization",
      "value": "TOKEN-ABCDEFG"
    },
    {
      "name": "authType",
      "value": "bearer"
    }
  ]
}
```

## Token Renewal

> This section is normative.

A `DataAddress` defined by this profile MAY additionally carry the `endpointProperties` defined by the
[Token Renewal](./token-renewal.md) profile. When the `refreshToken` property is present, the requesting party SHOULD
renew the `authorization` access token as described in that profile. Token renewal is typically applicable to pull
transfers, where the consumer presents the access token to the provider API.

## Metadata

> This section is normative.

This profile does not define `metadata` semantics. Any `metadata` carried in `DataFlowPrepareMessage` or
`DataFlowStartMessage` is out of scope for this profile and MUST NOT be required for an HTTP transfer.

## Labels

> This section is normative.

This profile does not assign meaning to `labels` values.

## Scope

> This section is normative.

This profile is a **transport-protocol profile**, bound only to the HTTP wire protocol. Usecase profiles that build on
HTTP transport SHOULD reference this profile rather than redefining transport-level concerns.
