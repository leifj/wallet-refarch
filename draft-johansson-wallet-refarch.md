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
  PathToSSI:
    title: The Path to Self-Sovereign Identiy
    author:
      -
        ins: C. Allen
        name: Chrisopher Allen
    target: http://www.lifewithalacrity.com/2016/04/the-path-to-self-soverereign-identity.html
  ARF:
    title: The European Digital identity Wallet architecture and Reference framework
    author:
      -
        ins: COM
        name: The European Commission
    target: https://digital-strategy.ec.europa.eu/en/library/european-digital-identity-wallet-architecture-and-reference-framework
normative:
  RFC2119:
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
        ins: K. Yatsuda
        name: Kristina Yatsuda
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
        ins: K. Yatsuda
        name: Kristina Yatsuda
      -
        ins: T. Looker
        name: Tobias Looker
    target: https://openid.net/specs/openid-4-verifiable-credential-issuance-1_0.html

--- abstract

This document provides a general reference architecture for direct presentation credential flows, often called "digital identity wallets".

--- middle

# Introduction

The term "digital wallet" or "digital identity wallet" is often used to denote a container for digital objects representing information about a subject. Such objects are often called "digital credentials". The use of the word "wallet" is both historic, stemming from the origin of some types of wallet in the "crypto" or digital asset community, aswell as meant to make the user think of a physical wallet where digital credentials correspond to things like credit cards, currency, loyalty cards, identity cards etc. The wallet concept is a powerful conceptual tool and this document does not claim to define or constrain all aspects of the use of the term "digital wallet". Instead this document is attempting to define a reference architecture for a type of digital identity architectures where a form of digital wallet is used to facilitate the flow of digital _identity_ credentials. Specifically, this document does not concern itself with digital currency schemes or "crypto" wallets.

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in RFC 2119, BCP 14 {{RFC2119}}.

# A Note on History

The origins of the notion of digital identity goes back to the mid 1990s. Historically, Internet protocols were designed to deal with authentication and (sometimes) authorization, i.e. the question of what entity is accessing the protocol and what they are allowed to do. Digital identity can be thought of as a generalization of the concept of a user identifier in a protocol. Today we typically use the term data subject (abbreviated as 'subject' when there is no risk of confusion) to denote the actor whoese data is beeing acted upon by the protocol. Most internet protocols represent the data subject as a "user" identified by a single unique identifier. Identifier in use by Internet protocols were typically never designed to be unified - each security protocol typically designed a separate structure of identifiers.

Identifier schemes such as kerberos principal names or X.509 distinguished names are often assumed to be unique across multiple protocol endpoints. This introduces linkability across multiple protocol endpoints. Historically this was never seen as an issue.

When web applications were build that required some form of user authentication the notion of externalized or _federated_ user authentication was established as a way to offload the work involved in user management from each web application to some form of centralized service. This is sometimes called "single sign on" - a term used to describe the (sometimes, but not alwasy desirable) property of authentication flows that a user can login in (sign on) once and have the "logged in" state recognized across multiple applications. State replication across multiple web application carries with it a separate set of concerns which is not discussed here.

In the late 1990s multiple protocols for "web single sign-on" were developed. Soon the need to connect multiple "SSO-systems" across different administrative and technical realms was recognized. Bridging administrative realms is often called "federating" those realms and the term "federated identity" owes its origin to this practice. The development of standard protocols for federating identity such as the Security Assertion Markup Language {{SAML}} and Open ID Connect {{OPENIDC}} were initially created in the early to mid 2000s. These protocols are widely deployed today.

The notion of digital identity evolved as a generalization of the "single sign-on" concept because modern federation protocols (OIDC, SAML etc) are able to transport not only shared state about the sign-in status of a user (eg in the form of a login-cookie) but can also be used to share information about the subject (user) accessing the service. In some cases identity federation protocols made it possible to fully externalize identity management from the application into an "identity provider"; a centralized service responsible for maintaining information about users and _releasing_ such information in the form of _attributes_ to trusted services (aka relying parties).

Federated identity can be thought of as an architecture for digital identity where information about data subjects is maintained by identity providers and shared with relying parties (sometimes called service providers) as needed to allow subjects to be authenticated and associated with appropriate authorization at the relying party.

Here is an illustration of how most federation protocols work. In this example the Subject is requesting some resource at the RP that requires authentication. The RP issues an authentication requests which is sent to the IdP. The IdP prompts the user to present login credentials (username/password or some other authentication token) and after successfully verifying that the Subject matches the login credentials in the IdPs database the IdP returns an authentication response to the RP.

A brief illustration of the typical federation flow is useful. For the purpose of this illustration we are not considering the precise way in which protocol messages are transported between IdP and RP, nor do we consider how the Subject is represented in the interaction between the IdP and RP (eg if a user-agent is involved).

~~~~ plantuml
Subject -> RP: Initiate authentication flow
RP -> IdP: Authentication request
IdP --> Subject: Prompt for login credentials
Subject --> IdP: Presents login credentials
RP <-- IdP: Authentication response
Subject <-- RP: Success!
~~~~

Note that

* The Subject only presents login credentials to the IdP
* The IdP learns which RP the subject is requesting access to
* The RP trusts the IdP to accurately represent information about the Subject

The limitation of this type of architecture and the need to evolve the architecture into direct presentation flow is primarily the second point: the IdP has information about every RP the Subject has ever used. Together with the use of linkable attributes at the RP this becomes a major privacy leak and a signifficant drawback of this type of architecture.

The notion of "Self Sovreign Identity" (SSI) was first introduced in the blogpost [PathToSSI] by Christopher Allen. The concept initially relied heavily on the assumed dependency on blockchain technology. Recently there has been work to abstract the concepts of SSI away from a dependency on specificy technical solutions and desribe the key concepts of SSI independently of the use of blockchain.

The purpose of this document is to create a reference architecture for some of the concepts involved in SSI in such a way that different implementations can be contrasted and compared. This document attempts to define a set of core normative requirement and also introduce the notion of direct presentation flow to denote the practice of using a digital wallet to allow the data subject control over the digital credential sharing flow.

Direct presentation flow should be seen as a generalization of the Self-Sovereign Identity concept in the sense that unlike SSI, direct presentation make no assumptions or value judgements about the relative merits of third party data ownership and control. The basic architecture of direct presentation does empower the user with more control than the federated model does but in the SSI architecture the user always has full control over every aspect of data sharing with the RP. This is not necessarily true (eg for legal reasons) in all cases which is why there is a need to desribe the technical underpinnings of direct presentation flows in such a way that the full SSI model can be a special case of a direct presentation architecture.

# Actors and Entities

## Subject and Wallet

The subject (aka data subject) is typically a natural person but can be thought of as the entity associated with a set of data. The subject controls a digital identity wallet (abbreviated as 'wallet' in this document). The wallet is used by the subject to communicate with issuers and verifiers and acts as a container for digital credentials and presentation proofs. The nature of the control the user has over the wallet varies but minimally the user must be able to initiate the receipt of credentials from an issuer and the transmission of digital credentials to a verifier.

## Credentials and Presentation Proofs

A digital identity credential (abbreviated as 'credential' in this document) is an object representing a set of data associated with a subject. The credential MAY contain data that uniquely identify a single subject. A digital identity credential is typically cryptographically bound both to the issuer and to the wallet where it is stored. A presentation proof (abbreviated as 'presentation' in this document) is a proof that a particular issuer has provided a particular set of credentials to the wallet. A presentation can be verified by at least one verifier. A presentation proof can be based on data present in a single credential or in multiple or even on the result of computations based on a set of credentials. A common example is a presentation proof that a subject is legally permitted to take driving lessons. This is a binary attribute the result of a computation involving knowledge of both the biological age of the subject aswell as legal restrictions that apply to the juristiction where the verifier is operating.

## Issuer and Verifier

An issuer is a set of protcol endpoints that allow a wallet to receive a credential. Credentials issued by the issuer are cryptographically bound to that issuer and to the receiving wallet.

A verfier is a set of protocol endpoints that allow a wallet to send a presentation to a verifier. A verifier is typically a component used to provide an application with data about the subject - for instance in the context of an authentication process.

# Direct Presentation Flow

The basic direct presentation flows looks like this:

~~~ plantuml
group issuance
   Subject --> Wallet: <<initiate credential request>>
   activate Wallet
   Issuer <-- Wallet: request credential
   activate Issuer
   Issuer --> Issuer: <<generate credential>>
   return credential
   deactivate Issuer
   deactivate Wallet
end

group verification
   Verifier --> Wallet: request presentation
   activate Wallet
   Wallet --> Subject: <<prompt to select credential(s)>>
   activate Subject
   Wallet <-- Subject: <<pick credential(s)>>
   deactivate Subject
   Wallet --> Wallet: <<generate presentation from credential(s)>>
   return presentation
   deactivate Wallet
end
~~~

The wallet (acting on behalf of the subject) requests a credential from the issuer. The way this flow is initiated is implementation dependent and in some cases (notably in {{OIDC4VCI}}) the flow often starts with the subject visiting a web page at the issuer where the subject is first authenticated and then presented with means to launch a credential issuance request using their wallet. These details are left out from the diagram above.

The credential is somehow generated by the issuer. This is implementation dependent. The claims in the credential typically comes from some source with which the issuer has a trust relationship. The term "authentic source" is sometimes used when there is a need to distinguish the source of the claims in a credential from the source of the credential which by definition is the issuer.

The wallet receives a credential from the issuer. The credential is typically bound both to the wallet instance and to the issuer in such a way that presentation proofs generated from the credential can be used to verify said bindings.

At some later point, the subject wants to use the credentials in their wallet to provide identity data to an application. The application has a verifier (a specific software component responsible for verifying presentation proofs) associated with it. The wallet - often after involving the user in some form of interaction to choose which credential(s) to use and what parts of the credential(s) to include - generates a presentation proof and sends it to the verifier. The precise way this flow is initiated is again implementation dependent and in some cases (notably {{OIDC4VP}}) the flow starts with the subject visiting the application and hitting a "login" button which directs the users device to launch the wallet instance to complete the flow. These details are left out of the diagram above.

Upon receipt of the presentation the verifier verifies the issuer and wallet binding (aka holder binding) of the proof and - if the implementation supports revocation - the current validity of the underlying credential(s). If successful the data in the proof is made available to the application.

# Normative Requirements

## Subject control

The wallet SHOULD provide the subject with the means to control which data from a credential is used in a presentation proof.

## Selective Disclosure

A conformant implementation SHOULD identify a format for representing digital credentials that make it possible for the subject to select a subset of the data present in the credential for inclusion in a presentation proof.

## Issuer Binding

A verifier MUST be able to verifiy the identity of the issuer of the credential from the presentation proof.

## Holder Binding

The verifier MUST be able to verify that the wallet sending the presentation proof is the same wallet that received the credential from which the presentation proof was derived.

## Non-linkability and data minimization

The verifier MUST NOT be able to infer information about data or subjects not present in the presentation. This includes any association between the wallet or subject and other issuers and verifiers not associated with the presentation. In particular, colluding verifiers MUST NOT be able to infer data not present in presentation proofs.

## Revocation

A conformant implementation SHOULD provide a way for an issuer to revoke an issued digital credential in such a way that subsequent attempts by a verifier to verify the authenticity of proofs based on that credential fail.

# Profiles

Several profiles of this reference architecture exist. We present two below.

## A Minimal Profile

A minimal profile of the direct presentation credential architecture is as follows:

  1. Digital credentials are represented as SD-JWT objects {{SDJWT}}
  2. An issuer implements the OP side of {{OIDC4VCI}}
  3. A verifier implements RP side of {{OIDC4VP}}
  4. A wallet implements the RP side of {{OIDC4VCI}} and the OP side of {{OIDC4VP}}

A wallet conforming to this profile is essentially an openid connect store-and-proove proxy with a user interface allowing the subject control over selective disclosure.

This minimal profile fulfills several of the requirements in the previous section:

  * Selective disclosure is provided by the use of SD-JWT objects to represent credential and presentation objects.
  * Issuer binding is provided by a combination of digital signatures on SD-JWTs and OpenID connect authentication between the wallet and issuer.
  * Non-linkability is provided by not reusing SD-JWTs from the issuer for multiple presentations. The wallet MAY obtain multiple copies of the same SD-JWT credentials from the wallet at the same time. These can then be used to generate separate presentation objects, never reusing the same SD-JWT credential for separate verifiers.

  This profile does not provide any solution for revocation and it leaves the question of how OpenID connect entities (issuers, verifiers and wallets) trust each other. There are also real scalability issues involved in how the digital signature keys are managed but as a minimal profile it illustrates the components necessary to make a direct presentation architecture work.

## The EU Digital Identity Wallet

The EU digital identity wallet (EUID wallet) as defined by the architecture reference framework {{ARF}} is an evolving profile for a direct presentation architecture that includes several aspects of the minimal profile above. Note that the EUID wallet specification is in flux and subect to signifficant change.

# Security Considerations

One of the main security considerations of a direct presentation credential architecture is how to establish the transactional trust between both the entities (wallets, issuers and verifiers) aswell as the technical trust necessary for the cryptographic binding between the digital credentials and their associated presentation. Digital credentials are sometimes long-lived which also raises the issue of revocation with its associated security requirements.

# IANA Considerations

None

--- back

# Acknowledgments
{:numbered="false"}

* Peter Altman
* Giuseppe DeMarco
