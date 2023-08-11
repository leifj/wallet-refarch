---
title: A reference architecture for direct presentation credential flows
abbrev: wallet-refarch
docname: draft-johansson-wallet-refarch-latest
category: info
stream: IETF
v: 3

ipr: trust200902
area: Applications
keyword: wallet verifiable credentials

stand_alone: yes
smart_quotes: no
pi: [toc, sortrefs, symrefs]

author:

  -
     ins: L. Johansson
     name: Leif Johansson
     organization: Sunet
     email: leifj@sunet.se

informative:
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
normative:
  RFC2119:

--- abstract

This document provides a general reference architecture for direct presentation credential flows, often called "digital identity wallets".

--- middle

# Introduction

The term "digital wallet" or "digital identity wallet" is often used to denote a container for digital objects representing information about a subject. Such objects are often called "digital credentials". The use of the word "wallet" is both historic, stemming from the origin of some types of wallet in the "crypto" or digital asset community, aswell as meant to make the user think of a physical wallet where digital credentials correspond to things like credit cards, currency, loyalty cards, identity cards etc. The wallet concept is a powerful conceptual tool and this document does not claim to define or constrain all aspects of the use of the term "digital wallet". Instead this document is attempting to define a reference architecture for a type of digital identity architectures where a form of digital wallet is used to facilitate the flow of digital _identity_ credentials. Specifically, this document does not concern itself with digital currency schemes or "crypto" wallets.

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in RFC 2119, BCP 14 {{RFC2119}}.

# A Note on History

The origins of the notion of digital identity goes back to the mid 1990s. Historically, Internet protocols were never designed with the concept of digital identity in mind. Internet protocols were designed to deal with authentication and (sometimes) authorization, i.e. the question of what entity is accessing the protocol and what they are allowed to do.

Some protocols (eg kerberos or X.509) had a notion of subject _identifiers_ (eg principal names for kerberos) which typically uniquely identify a single subject in the context of the protocol flows. Identifier systems in Internet protocols were also never designed to be unified - each security protocol typically designed a separate structure of identifiers.

Identifier schemes such as kerberos principal names or X.509 distinguished names are often assumed to be unique across multiple protocol endpoints. This introduces linkability across multiple protocol endpoints. Historically this was never seen as an issue.

When web applications were build that required some form of user authentication the notion of externalized or _federated_ user authentication was established as a way to offload the work involved in user management from each web application to some form of centralized service. Early on this was sometimes called "single sign on" - a term used to describe the (desirable) property of authentication flows that users can login in (sign on) once and have the "logged in" state recognized across multiple applications.

In the late 1990s multiple protocols for "web single sign-on" were developed. Soon the need to connect such "SSO-systems" across multiple administrative and technical realms was recognized. This led to the development of standard federation protocols such as the Security Assertion Markup Language {{SAML}} and Open ID Connect {{OPENIDC}}.

The notion of digital identity evolved as a generalization of the "single sign-on" concept because modern federation protocols (OIDC, SAML etc) are able to transport not only shared state about the sign-in status of a user (eg in the form of a login-cookie) but can also be used to share information about the subject (user) accessing the service. In some cases these protocols made it possible to fully externalize identity management from the application into an "identity provider"; a centralized service responsible for maintaining information about users and _releasing_ such information in the form of _attributes_ to trusted services (aka relying parties).

Federated identity is therefore defined as an architecture for digital identity where information about data subjects is maintained by identity providers and shared with relying parties (sometimes called service providers) as needed to allow subjects to be authenticated and associated with appropriate authorization at the relying party.

Here is an illustration of how most federation protocols work. In this example the Subject is requesting some resource at the RP that requires authentication. The RP issues an authentication requests which is sent to the IdP. The IdP prompts the user to present login credentials (username/password or some other authentication token) and after successfully verifying that the Subject matches the login credentials in the IdPs database the IdP returns an authentication response to the RP.

In this example we are not considering the precise way in which protocol messages are transported between IdP and RP, nor do we consider how the Subject is represented in the interaction between the IdP and RP (eg if a user-agent is involved).

~~~~ plantuml
Subject -> RP: Initiate authentication flow
RP -> IdP: Authentication request
IdP --> Subject: Prompt for login credentials
Subject --> IdP: Presents login credentials
RP <-- IdP: Authentication response
Subject <-- RP: Success!
~~~~

Note that

* The Subject only presents login credentials to the RP
* The IdP learns which RP the subject is requesting access to
* The RP trusts the IdP to accurately represent information about the Subject

The limitation of this type of architecture and the need to evolve the architecture into direct presentation flow is primarily the second point: the IdP has information about every RP the Subject has ever used. Together with the use of linkable attributes at the RP this becomes a major privacy leak and a signifficant drawback of this type of architecture.

# Actors and Entities in Direct Presentation Flow

In a direct presentation identity architecture, the subject (aka user) controls a digital identity wallet that acts as a container and a control mechanism for digital identity credentials. The precise nature of the control the user has over the digital identity wallet varies but minimally the user must be able to initiate the receipt of digital credentials from an issuer and the transmission of  digital credentials to the verifier.

Typically, digital credentials are not sent "as is" to verifiers. Instead, digital credential presentation objects are derived from existing digital credentials. Presentation credentials are created in such a way that they are crypographically bound both to the original digital credential obtained from the issuer and often also to the digital identity wallet used to store the credential.

The verifier, upon receipt of a digital credential presentation object, is able to verify both that the digital credential presentation object was sent by a known and trusted wallet and also that the digital credential presentation object was derived from a digital credential from a known and trusted issuer.

~~~~ plantuml
:subject:
[wallet]
[issuer]
[verifier]
artifact cred [
digital credential
]
artifact pres [
digital credential presentation
]
issuer --> wallet: "issues"
issuer --> cred: "creates"
wallet --> verifier: "presents"
subject --0 wallet: controls
cred --* wallet: contained in
cred --> pres: "creates"
verifier --> pres: verifies
~~~~

The basic direct presentation flows looks like this:

~~~ plantuml
group issuance
   Wallet --> Issuer: request credential
   Issuer --> Wallet: return credential

group verification
   Verifier --> Wallet: request credential presentation
   Wallet --> Verifier: return credential presentation
~~~

# Normative Requirements on Direct Presentation Flow

## Selective Disclosure

A conformant implementation SHOULD identify a format for representing digital credentials that support selective disclosure of information to Verifiers during presentation.

## Issuer Binding

A conformant implementation MUST provide a mechanism for verifying that a digital credential is authenticic and was created by a particular Issuer.

## Holder Binding

A conformant implementation MUST provide a way for the Verifier to verify that the received digital credential presentation was issued to the same Wallet presenting the original credential to the Verifier.

## Non-linkability

A conformant implementation MUST provide a way for a Verifier to verify the current authenticity of a digital credential without making it possible for an attacker to learn the identity of the association between the Subject and the Verifier.

## Revocation

A conformant implementation SHOULD provide a way for an Issuer to revoke an issued digital credential in such a way that subsequent attempts by a Verifier to verify the authenticity of that credential fail.

# A Minimal Profile

TODO - write about using SD-JWT, accumulators, digital signature key-mgmt, OpenID Connect etc

# Security Considerations

One of the main security considerations of a direct presentation credential architecture is how to establish the transactional trust between both the entities (wallets, issuers and verifiers) aswell as the technical trust necessary for the cryptographic binding between the digital credentials and their associated presentation. Digital credentials are sometimes long-lived which also raises the issue of revocation with its associated security requirements.

# IANA Considerations

None

--- back

# Acknowledgments
{:numbered="false"}

* Peter Altman
* Giuseppe DeMarco
