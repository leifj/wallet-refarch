---
title: A reference architecture for direct presentation credential flows
abbrev: wallet-refarch
docname: draft-johansson-wallet-refarch-latest
category: info
stream: IETF

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

--- abstract

This document provides a general reference architecture for direct presentation credential flows, often called "digital identity wallets".

--- middle

# Introduction

The term "digital wallet" or "digital identity wallet" is often used to denote a container for digital objects representing information about a subject. Such objects are often called "digital credentials". The use of the word "wallet" is both historic, stemming from the origin of some types of wallet in the "crypto" or digital asset community, aswell as meant to make the user think of a physical wallet where digital credentials correspond to things like credit cards, currency, loyalty cards, identity cards etc. The wallet concept is a powerful conceptual tool and this document does not claim to define or constrain all aspects of the use of the term "digital wallet". Instead this document is attempting to define a reference architecture for a type of digital identity architectures where a form of digital wallet is used to facilitate the flow of digital _identity_ credentials. Specifically, this document does not concern itself with digital currency schemes or "crypto" wallets.

# Terminology

Digital Credential
: TODO

Digital Credential Presentation
: TODO

Issuer
: TODO

Verifier
: TODO

Digital Identity Wallet
: A holder of Digital Credential(s)

# Actors and Entities

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

# Security Considerations

One of the main security considerations of a direct presentation credential architecture is how to establish the transactional trust between both the entities (wallets, issuers and verifiers) aswell as the technical trust necessary for the cryptographic binding between the digital credentials and their associated presentation. Digital credentials are sometimes long-lived which also raises the issue of revocation with its associated security requirements.

# IANA Considerations

None

--- back

# Acknowledgments
{:numbered="false"}

* Peter Altman
* Giuseppe DeMarco
