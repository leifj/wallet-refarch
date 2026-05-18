---
title: A reference architecture for direct presentation credential flows
abbrev: Verifiable Digital Credentials
docname: draft-ietf-spice-vdcarch-latest
category: info
stream: IETF
v: 3

ipr: trust200902
# area: Security
keyword: direct presentation credentials

stand_alone: yes
smart_quotes: no
pi: [toc, sortrefs, symrefs]

author:

  -
     ins: L. Johansson
     name: Leif Johansson
     organization: Sunet
     email: leifj@sunet.se
     country: Sweden
  -
     ins: B. Zundel
     name: Brent W. Zundel
     organization: Yubico
     email: brent.zundel@gmail.com
     country: United States
  -
     ins: T. Cappalli
     name: Tim Cappalli
     organization: Okta
     email: timcappalli@cloudauth.dev
     country: United States

informative:
  DIDKEY:
    title: The did:key Method v0.7
    author:
      -
        ins: D. Longley
        name: Dave Longley
      -
        ins: D. Zagidulin
        name: Dmitri Zagidulin
      -
        ins: M. Sporny
        name: Manu Sporny
    target: https://w3c-ccg.github.io/did-key-spec/
  TSL:
    title: Token Status List
    author:
      -
        ins: T. Looker
        name: Tobias Looker
      -
        ins: P. Bastian
        name: Paul Bastian
      -
        ins: C. Bohrmann
        name: Christian Bohrmann
    target: https://datatracker.ietf.org/doc/draft-ietf-oauth-status-list/
  SAML: OASIS.sstc-core
  OPENIDC:
    title: OpenID Connect Core 1.0
    author:
      -
        ins: N. Sakimura
        name: Nat Sakimura
      -
        ins: J. Bradley
        name: John Bradley
      -
        ins: M. Jones
        name: Michael Jones
      -
        ins: B. de Medeiros
        name: Breno de Medeiros
      -
        ins: C. Mortimore
        name: Chuck Mortimore
    date: 2014
  PathToSSI:
    title: The Path to Self-Sovereign Identity
    author:
      -
        ins: C. Allen
        name: Christopher Allen
    target: http://www.lifewithalacrity.com/2016/04/the-path-to-self-soverereign-identity.html
  ARF:
    title: The European Digital identity Wallet architecture and Reference framework
    author:
      -
        ins: COM
        name: The European Commission
    target: https://digital-strategy.ec.europa.eu/en/library/european-digital-identity-wallet-architecture-and-reference-framework

normative:
  VCDM2:
    title: Verifiable Credentials Data Model v2.0
    author:
      -
        ins: M. Sporny
        name: Manu Sporny
      -
        ins: T. Thibodeau
        name: Ted Thibodeau Jr
      -
        ins: I. Herman
        name: Ivan Herman
      -
        ins: C. Cohen
        name: Gabe Cohen
      -
        ins: M. B. Jones
        name: Michael B. Jones
    target: https://www.w3.org/TR/vc-data-model-2.0/
  DID:
    title: Decentralized Identifiers (DIDs) v1.0
    author:
      -
        ins: M. Sporny
        name: Manu Sporny
      -
        ins: A. Guy
        name: Amy Guy
      -
        ins: M. Sabadello
        name: Markus Sabadello
      -
        ins: D. Reed
        name: Drummond Reed
    target: https://www.w3.org/TR/did-1.0/
  BSL:
    title: Bitstring Status List v1.0
    author:
      -
        ins: M. Sporny
        name: Manu Sporny
      -
        ins: D. Longley
        name: Dave Longley
      -
        ins: M. Prorock
        name: Michael Prorock
      -
        ins: M. Alkhraishi
        name: Mahmoud Alkhraishi
    target: https://www.w3.org/TR/vc-bitstring-status-list/
  CID:
    title: Controlled Identifiers v1.0
    author:
      -
        ins: M. Sporny
        name: Manu Sporny
      -
        ins: M. B. Jones
        name: Michael B. Jones
    target: https://www.w3.org/TR/cid-1.0/
  VCJOSE:
    title: Securing Verifiable Credentials using JOSE and COSE
    author:
      -
        ins: M. Prorock
        name: Michael Prorock
      -
        ins: C. Cohen
        name: Gabe Cohen
      -
        ins: M. B. Jones
        name: Michael B. Jones
    target: https://www.w3.org/TR/vc-jose-cose/
  SDJWT: I-D.ietf-oauth-selective-disclosure-jwt
  OIDC4VP:
    title: OpenID for Verifiable Presentations
    author:
      -
        ins: O. Terbu
        name: Oliver Terbu
      -
        ins: T. Lodderstedt
        name: Torsten Lodderstedt
      -
        ins: K. Yasuda
        name: Kristina Yasuda
      -
        ins: A. Lemmon
        name: Adam Lemmon
      -
        ins: T. Looker
        name: Tobias Looker
    target: https://openid.net/specs/openid-connect-4-verifiable-presentations-1_0-07.html#name-authors-addresses
  OIDC4VCI:
    title: OpenID for Verifiable Credential Issuance
    author:
      -
        ins: T. Lodderstedt
        name: Torsten Lodderstedt
      -
        ins: K. Yasuda
        name: Kristina Yasuda
      -
        ins: T. Looker
        name: Tobias Looker
    target: https://openid.net/specs/openid-4-verifiable-credential-issuance-1_0.html


--- abstract

This document defines a reference architecture for direct presentation flows of
digital credentials. The architecture introduces the concept of a presentation
mediator as the active component responsible for managing, presenting, and
selectively disclosing credentials while preserving a set of security and
privacy promises that will also be defined.

--- middle

# Conventions

{::boilerplate bcp14-tagged}

# Introduction

Verifiable digital credentials, which assert claims about individuals,
organizations, or devices, have become essential tools in modern identity
systems. Whether verifying an individual's qualifications, attesting to an
enterprise's compliance, or authorizing an IoT device, these credentials rely on
secure, efficient, and privacy-preserving mechanisms for their use.

Traditional federated identity systems often rely on intermediaries or
delegation, which can compromise user privacy or introduce inefficiencies. This
document presents an architecture for direct presentation flows, where
credentials are presented directly to verifiers without unnecessary
intermediaries, empowering the credential subject or their authorized
representative to maintain control over the credential's use.

At the heart of this architecture is the presentation mediator, an active
software component responsible for facilitating secure and privacy-aware
interactions. This mediator works in tandem with passive credential stores,
verifiers, and issuers, creating a scalable and interoperable system that can
adapt to diverse regulatory and operational environments.

# Terminology and Roles

Credential manager:
: An application, hardware device, or service which securely stores, organizes,
manages, and enables presentation of credentials. Digital wallets, password
managers, and passkeys managers are examples of credential managers.

Issuer:
: The entity that cryptographically signs a verifiable digital credential,
thereby asserting its claims about a subject

Issuer service:
: The underlying platform or infrastructure service which enables an Issuer to
issue a verifiable digital credential.

Verifiable digital credential (VDC):
: A cryptographically verifiable, tamper-evident assertion of claims about a
subject, signed by an Issuer. VDCs are stored in a Credential Manager.

Verifier:
: The entity that cryptographically validates the authenticity and integrity of
a verifiable digital credential. A verifier is typically, but not always, the
relying party.

Verifier service:
: The underlying platform or infrastructure service which enables a Verifier to
validate a verifiable digital credential.

## Naming the elephant in the room

The term "digital wallet" or "digital identity wallet" is often used to denote a
container for digital objects representing information about a subject. Such
objects are often called "digital credentials". The use of the word "wallet" is
both historic, stemming from the origin of some types of wallet in the "crypto"
or digital asset community, as well as meant to make the user think of a
physical wallet where digital credentials correspond to things like credit
cards, currency, loyalty cards, identity cards etc.

Arguably the use of the term wallet is often confusing since it may lead to
assumptions about the fungibility of identity or that credentials are exchanged
as part of a monetary transaction. In this specification we will use the term
"presentation mediator" when traditionally the term "identity wallet" or
"wallet" has been used.

## Terminology used in this specification

To anchor this architecture, we define key terms:

- A presentation mediator is an active software component that manages the
presentation of credentials to the verifier on behalf of the credential subject.
- A credential store is a passive repository for securely storing credentials.
It supports the presentation mediator by providing access to stored credentials
without performing active operations.
- The credential subject is the entity the credential pertains to, such as an
individual or organization.
- A presenter is the actor that delivers a credential to a verifier. While often
the credential subject, the presenter could also be an authorized agent or
software acting on their behalf.
- A credential is a signed, structured document containing claims about a
subject, issued by a trusted entity.
- An attestation is a statement about a credential, often used to validate or
certify its properties, such as its integrity or scope.
- A presentation proof is a derived artifact that proves claims from a
credential in a specific interaction with a verifier.

# Actors and Entities

## Subject and Presenter

The credential subject is the entity that the credential describes, such as an
individual, an organization, or even an IoT device. However, the presenter—the
actor delivering the credential to the verifier—may not always be the credential
subject. For example, an administrator might present credentials on behalf of an
organization, or a software agent might act as a presenter in automated
workflows.

This distinction between the credential subject and the presenter allows the
architecture to support complex use cases, such as power-of-attorney scenarios
or enterprise credentialing systems.

## Presentation Mediator (Credential Presentation User Agent)

The presentation mediator (mediator for short) is the core active component of
this architecture. It initiates and mediates credential presentations, ensuring
compliance with credential subject preferences and system policies. For example,
it might enforce selective disclosure, revealing only the subject's date of
birth to a verifier while withholding other personal details. The presenter
controls a presentation mediator.

Often the presenter and subject is one and the same entity, eg a natural person
controlling her own credentials. There are several situations where the
presenter and subject are different entities however, for instance cases where
presentation is delegated from a legal entity to an officer of a company or when
care staff helps somebody with disabilities present personal credentials.

Unlike a credential store, the presentation mediator is responsible for
orchestrating interactions with verifiers, performing cryptographic operations,
and generating presentation proofs.

The mediator is used by the subject to communicate with issuers and by the
presenter to communicate with verifiers. The nature of the control the
presenter/subject has over the mediator varies but minimally the subject must be
able to initiate the receipt of credentials from an issuer and the presenter has
to be able to generation and transmission of presentation proofs to a verifier.

The mediator acts on behalf of the subject when receiving credentials from an
issuer and the issuance process typically involves authenticating the subject to
the issuer. This can happen by the use of some delegated authentication exchange
whereby the subject is represented by some other entity.

## Credential Recipient Mediator (Credential Recipient User Agent)

## Credential Store

The credential store is a passive repository where credentials are securely
stored. Its primary function is to provide the presentation mediator with access
to the credentials it needs to generate presentation proofs. By separating
storage from active mediation, the architecture enhances modularity and allows
credential stores to be managed independently from presentation logic.

## Credentials and Presentation Proofs

A digital identity credential (abbreviated as 'credential' in this document) is
an object representing a set of claims associated with a subject. The credential
MAY contain claims that uniquely identify a single subject. A digital identity
credential is typically cryptographically bound both to the issuer and to the
mediator where it is stored. A presentation proof (abbreviated as 'presentation'
in this document) is a proof that a particular issuer has provided a particular
set of credentials to the mediator. A presentation can be verified by at least
one verifier. A presentation proof can be based on data present in a single
credential or in multiple or even on the result of computations based on a set
of credentials. A common example is a presentation proof that a subject is
legally permitted to take driving lessons. This is a binary attribute which is
the result of a computation involving knowledge of both the biological age of
the subject as well as legal restrictions that apply to the jurisdiction where
the verifier is operating.

## Issuer and Verifier

An issuer is a set of protocol endpoints that allow a mediator to receive a
credential. Credentials issued by the issuer are cryptographically bound to that
issuer and to the receiving mediator.

A verifier is a set of protocol endpoints that allow a mediator to send a
presentation to a verifier. A verifier is typically a component used to provide
an application with data about the subject - for instance in the context of an
authentication process.

# Presentation Flows

Credential presentation flows describe how information from credentials are
transmitted from the mediator to the verifier. This architecture focuses on
direct presentation flows, but it also accommodates variations such as delegated
and assisted presentations.

## Direct Presentation Flow
~~~ aasvg

                    +-------+                        +--------+                                              +------+                            +--------+           +---------+
                    |Subject|                        |Mediator|                                              |Issuer|                            |Verifier|           |Presenter|
                    +---+---+                        +----+---+                                              +---+--+                            +----+---+           +----+----+
                        |                                 |                                                      |                                    |                    |
          +-----------+-+---------------------------------+------------------------------------------------------+------------------------------------+--+                 |
          | ISSUANCE  | |                                 |                                                      |                                    |  |                 |
          +-----------+ |<<initiate credential request>>  |                                                      |                                    |  |                 |
          |             +-------------------------------->|                                                      |                                    |  |                 |
          |             |                                 |                                                      |                                    |  |                 |
          |             |                                 |                  request credential                  |                                    |  |                 |
          |             |                                 +----------------------------------------------------->|                                    |  |                 |
          |             |                                 |                                                      |                                    |  |                 |
          |             |                                 |                                                      +------+                             |  |                 |
          |             |                                 |                                                      |      | <<generate credential>>     |  |                 |
          |             |                                 |                                                      |<-----+                             |  |                 |
          |             |                                 |                                                      |                                    |  |                 |
          |             |                                 |                     credential                       |                                    |  |                 |
          |             |                                 |<-----------------------------------------------------+                                    |  |                 |
          +-------------+---------------------------------+------------------------------------------------------+------------------------------------+--+                 |
                        |                                 |                                                      |                                    |                    |
                        |                                 |                                                      |                                    |                    |
                        |               +---------------+-+------------------------------------------------------+------------------------------------+--------------------+--------------+
                        |               | VERIFICATION  | |                                                      |                                    |                    |              |
                        |               +---------------+ |                                                      |            request presentation    |                    |              |
                        |               |                 |<------------------------------------------------------------------------------------------+                    |              |
                        |               |                 |                                                      |                                    |                    |              |
                        |               |                 |             <<prompt to select credential(s)>>       |                                    |                    |              |
                        |               |                 +--------------------------------------------------------------------------------------------------------------->|              |
                        |               |                 |                                                      |                                    |                    |              |
                        |               |                 |            <<select claims from credential(s)>>      |                                    |                    |              |
                        |               |                 |<---------------------------------------------------------------------------------------------------------------+              |
                        |               |                 |                                                      |                                    |                    |              |
                        |               |                 +-----+                                                |                                    |                    |              |
                        |               |                 |     |<<generate presentation proof selection>>       |                                    |                    |              |
                        |               |                 |<----+                                                |                                    |                    |              |
                        |               |                 |                                                      |                                    |                    |              |
                        |               |                 |                                  presentation proof  |                                    |                    |              |
                        |               |                 +------------------------------------------------------------------------------------------>|                    |              |
                        |               +-----------------+------------------------------------------------------+------------------------------------+--------------------+--------------+
                    +---+---+                        +----+---+                                              +---+--+                            +----+---+           +----+----+
                    |Subject|                        |Mediator|                                              |Issuer|                            |Verifier|           |Presenter|
                    +-------+                        +--------+                                              +------+                            +--------+           +---------+
~~~

{::comment}
// plantuml source
group issuance
   Subject --> Mediator: <<initiate credential request>>
   activate Mediator
   Issuer <-- Mediator: request credential
   activate Issuer
   Issuer --> Issuer: <<generate credential>>
   return credential
   deactivate Issuer
   deactivate Mediator
   deactivate Subject
end
group verification
   Verifier --> Mediator: request presentation
   activate Mediator
   Mediator --> Presenter: <<prompt to select credential(s)>>
   activate Presenter
   Mediator <-- Presenter: <<select claims from credential(s)>>
   deactivate Presenter
   Mediator --> Mediator: <<generate presentation proof selection>>
   return presentation proof
   deactivate Mediator
end
{:/comment}

The mediator (acting on behalf of the subject) requests a credential from the
issuer. The way this flow is initiated is implementation dependent and in some
cases (notably in {{OIDC4VCI}}) the flow often starts with the subject visiting
a web page at the issuer where the subject is first authenticated and then
presented with means to launch a credential issuance request using their
mediator. These details are left out from the diagram above.

The credential is generated by the issuer presumably based on information the
issuer has about the credential subject but exactly how the credential is
generated is implementation dependent and out of scope for this specification.
The claims in the credential typically comes from some source with which the
issuer has a trust relationship. The term "authentic source" is sometimes used
when there is a need to distinguish the source of the claims in a credential
from the source of the credential which by definition is the issuer.

The mediator receives a credential from the issuer. The credential is bound both
to the mediator and to the issuer in such a way that presentation proofs
generated from the credential can be used to verify said bindings.

At some later point, the subject wants to use the credentials in their mediator
to provide identity data to an application. The application has a verifier (a
specific software component responsible for verifying presentation proofs)
associated with it. The mediator - often after involving the user in some form
of interaction to choose which credential(s) to use and what parts of the
credential(s) to include - generates a presentation proof and sends it to the
verifier. The precise way this flow is initiated is again implementation
dependent and in some cases (notably {{OIDC4VP}}) the flow starts with the
subject visiting the application and hitting a "login" button which directs the
users device to launch the mediator to complete the flow. These details are left
out of the diagram above.

Upon receipt of the presentation the verifier verifies the issuer and mediator
binding (aka holder binding) of the proof and - if the implementation supports
revocation - the current validity of the underlying credential(s). If successful
the data in the proof is made available to the application.

## Delegated or Assisted Presentation Flow

Delegated flows occur when a third party, such as an enterprise or legal
representative, is authorized to present credentials on behalf of the credential
subject. The presentation mediator ensures that delegation is properly scoped
and authorized, preventing misuse.

Assisted flows involve granting limited rights to a third party to act on behalf
of the credential subject. This may take the form of a secondary credential that
grants access to the mediator for the purpose of generating and transmitting
presentation proofs on behalf of the credential subject.

# Normative Requirements

## Subject control

The mediator SHOULD provide the subject with the means to control which data
from a credential is used in a presentation proof.

The mediator MUST NOT be able to generate a presentation proof without the
participation and approval of the credential subject.

## Selective Disclosure

A conformant implementation SHOULD identify a format for representing digital
credentials that make it possible for the subject to select a subset of the data
present in the credential for inclusion in a presentation proof.

Note that there are situations where selective disclosure isn't applicable, for
instance when the credential subject is legally compelled to present a
credential. Exactly when selective disclosure is available as an option and what
aspects of the credential is meaningful to select is an implementation issue and
out of scope.

## Issuer Binding

A verifier MUST be able to verify the identity of the issuer of the credential
from a presentation proof.

## Mediator Binding

The verifier MUST be able to verify that the mediator sending the presentation
proof is the same mediator that received the credential from which the
presentation proof was derived.

Note that this is often termed 'holder' binding because the mediator is
sometimes called the holder.

## Non-linkability and data minimization

The verifier MUST NOT be able to infer information about data or subjects not
present in the presentation. This includes any association between the mediator
or subject and other issuers and verifiers not associated with the presentation.
In particular, colluding verifiers MUST NOT be able to infer data not present in
presentation proofs.

## Revocation

A conformant implementation SHOULD provide a way for an issuer to revoke an
issued digital credential in such a way that subsequent attempts by a verifier
to verify the authenticity of proofs based on that credential fail.

# Profiles

Several profiles of this reference architecture exist. We present some below.

## OpenID and SD-JWT

A minimal profile of the direct presentation credential architecture is as
follows:

  1. Digital credentials are represented as SD-JWT objects {{SDJWT}}
  2. An issuer implements the OP side of {{OIDC4VCI}}
  3. A verifier implements RP side of {{OIDC4VP}}
  4. A mediator implements the RP side of {{OIDC4VCI}} and the OP side of {{OIDC4VP}}

A mediator conforming to this profile is essentially an openid connect
store-and-prove proxy with a user interface allowing the subject control over
selective disclosure.

This minimal profile fulfills several of the requirements in the previous
section:

- Selective disclosure is provided by the use of SD-JWT objects to represent
credential and presentation objects.
- Issuer binding is provided by a combination of digital signatures on SD-JWTs
and OpenID connect authentication between the mediator and issuer.
- Non-linkability is provided by not reusing SD-JWTs from the issuer for
multiple presentations. The mediator MAY obtain multiple copies of the same
SD-JWT credentials from the mediator at the same time. These can then be used to
generate separate presentation objects, never reusing the same SD-JWT credential
for separate verifiers.

  This profile does not provide any solution for revocation and it leaves the
  question of how OpenID connect entities (issuers, verifiers and mediator)
  trust each other. There are also real scalability issues involved in how the
  digital signature keys are managed but as a minimal profile it illustrates the
  components necessary to make a direct presentation architecture work.

## The Basic Profile plus W3C Verifiable Credentials

An expansion of the minimal profile above:

  1. Digital credentials follow {{VCDM2}}
  2. These credentials are represented as SD-JWT objects {{SDJWT}} following {{VCJOSE}}
  3. The issuer uses a {{CID}} to identify themselves and the keys they used to sign the digital credential.
  4. The holder uses a {{DID}} such as {{DIDKEY}} to identify themselves.
  5. The issuer uses {{TSL}} or {{BSL}} to communicate credential status changes.
  6. An issuer implements the OP side of {{OIDC4VCI}}
  7. A verifier implements RP side of {{OIDC4VP}}
  8. A mediator implements the RP side of {{OIDC4VCI}} and the OP side of {{OIDC4VP}}

A mediator conforming to this profile is also essentially an OpenID Connect
store-and-proove proxy with a user interface allowing the subject control over
selective disclosure, with some additional benefits.

This profile fulfills several of the requirements in the previous section:

  * Selective disclosure is provided by the use of SD-JWT objects to represent
  credential and presentation objects.
  * Issuer binding is provided by a combination of digital signatures on SD-JWTs
  and OpenID connect authentication between the mediator and issuer.
  * Mediator binding is provided by the use of a DID for the holder.
  * Non-linkability is provided by not reusing SD-JWTs from the issuer for
  multiple presentations. The mediator MAY obtain multiple copies of the same
  SD-JWT credentials from the mediator at the same time. These can then be used
  to generate separate presentation objects, never reusing the same SD-JWT
  credential for separate verifiers.
  * Revocation and other changes to credential status are communicated via
  status credentials.
  * It answers the question of trust by included a CID for issuer
  identification, which also addresses some of the scalability issues involved
  in managing the digital signature keys.

## Anoncreds

TODO: write about hyperledger & anoncreds

## The EU Digital Identity Wallet

The EU Digital Identity Wallet (EUDI Wallet) as defined by the architecture
reference framework {{ARF}} is an evolving profile for a direct presentation
architecture that includes several aspects of the minimal profile above. Note
that the EUDI Wallet specification is in flux and subject to significant change.

# Security Considerations

One of the main security considerations of a direct presentation credential
architecture is how to establish the transactional trust between both the
entities (mediators, issuers and verifiers) as well as the technical trust
necessary for the cryptographic binding between the digital credentials and
their associated presentation. Digital credentials are sometimes long-lived
which also raises the issue of revocation with its associated security
requirements.

# IANA Considerations

None so far

--- back

# Acknowledgments
{:numbered="false"}

Several people have contributed to this text through discussion. The authors
especially wish to acknowledge the following individuals who have helped shape
the thinking around trust and identity in general and this topic in particular.

- Pamela Dingle
- Heather Flanagan
- Peter Altman
- Giuseppe DeMarco
- Lucy Lynch
- R.L. 'Bob' Morgan
- Jeff Hodges
