---
title: comparing major tee solutions
date: 2026-01-18 10:14:36
tags:
---

# Comparing Major TEE Solutions: What Is Measured, What Is Trusted, and Where Confidential Computing Actually Stops

## 1. Scope and Method

Trusted Execution Environments (TEEs) are often discussed as if they all provide the same security property. They do not.

This note compares the major server-side TEE families and one representative platform layer:

| Layer | Solutions covered here |
| --- | --- |
| Base CPU enclave TEE | Intel SGX |
| Base microVM enclave TEE | AWS Nitro Enclaves |
| Base confidential VM / realm TEE | Intel TDX, AMD SEV-SNP, Arm CCA |
| Base accelerator TEE | NVIDIA Confidential Computing |
| Open TEE framework | RISC-V Keystone |
| Platform layer built on a TEE | dstack on Intel TDX |

The comparison is organized around one practical question:

> What exactly can a remote relying party verify, and what trust assumptions still remain after attestation?

All factual claims below were cross-checked against original vendor or project documentation. When the text says **Analysis**, that sentence is a synthesis across sources rather than a vendor claim.

---

## 2. Executive Summary

- **Intel SGX** and **AWS Nitro Enclaves** are the closest mainstream TEEs to “measure the code or image I intend to trust.”
- **Intel TDX**, **AMD SEV-SNP**, and **Arm CCA** are primarily about “protect the VM or Realm from the host,” not “prove this exact application binary is running.”
- **NVIDIA Confidential Computing** extends the trust boundary into the GPU path, which matters for AI workloads where data and model state leave CPU memory.
- **Keystone** optimizes for openness and customizability rather than production maturity.
- **dstack** is not a new hardware TEE. It is a platform on top of **TDX** that adds workload-level claims such as `compose-hash`, `RTMR3`, and `report_data`.

The most important distinction is not marketing language such as “confidential” or “zero trust.” It is the difference between:

- measuring **application code or image**
- measuring **VM / Realm launch state**
- measuring **device state**
- measuring a **manifest or policy layer on top of a VM**

Those are related, but they are not the same thing.

---

## 3. The Right Comparison Questions

### 3.1 Threat model actors

In practice, confidential computing usually involves four actors:

1. **Infrastructure operator**: cloud provider, host OS, hypervisor, platform admins
2. **Workload publisher**: the team that built and shipped the application
3. **Relying party / data owner**: the user who wants cryptographic assurance
4. **Hardware vendor**: the silicon or platform root of trust provider

All mainstream TEEs reduce trust in the first actor. They differ sharply in how much trust remains in the second.

### 3.2 Comparison dimensions

The most useful dimensions are:

| Dimension | Question to ask | Why it matters |
| --- | --- | --- |
| **Isolation unit** | Process enclave, microVM, VM, Realm, or GPU? | Determines the TCB shape and developer ergonomics |
| **Native measured object** | What does the hardware or platform actually measure? | Determines what attestation can honestly prove |
| **Strongest native claim** | What is the verifier really learning? | Prevents over-claiming application identity |
| **Residual trust** | What still has to be trusted after attestation? | Clarifies the remaining attack surface |
| **Runtime model** | Rewrite, LibOS, Linux guest, or device extension? | Drives adoption cost |
| **Device coverage** | CPU only, or CPU plus GPU / I/O devices? | Critical for AI and heterogeneous compute |

### 3.3 One under-discussed constant

All of these systems ultimately depend on a hardware root of trust:

- Intel for SGX and TDX
- AMD for SEV-SNP
- Arm for CCA
- NVIDIA for GPU confidential computing
- AWS for Nitro Enclaves
- The platform designer for Keystone deployments

That dependency never goes away. Confidential computing reduces trust in operators, not in the hardware root itself.

---

## 4. The Four Families That Matter

### 4.1 Application-measurement TEEs

These TEEs natively bind attestation more directly to the application artifact:

- **Intel SGX**: enclave identity via `MRENCLAVE` and signer identity via `MRSIGNER`
- **AWS Nitro Enclaves**: enclave image identity via PCRs derived from the EIF

These are the closest to:

> “I know which measured code or image I am talking to.”

### 4.2 VM / Realm confidentiality TEEs

These TEEs primarily protect a full guest from the host:

- **Intel TDX**
- **AMD SEV-SNP**
- **Arm CCA**

These are the closest to:

> “I know a confidential VM or Realm booted with a measured launch state on real hardware.”

That is extremely valuable, but it is weaker than direct application identity.

### 4.3 Accelerator TEEs

- **NVIDIA Confidential Computing** extends the boundary to GPU-attached computation and memory.

This matters because a CPU-only TEE is not enough once model weights, prompts, activations, or gradients move into accelerator memory.

### 4.4 Platform overlays on TEEs

- **dstack on TDX** is a good example of a platform that adds workload-level claims on top of a confidential VM.

**Analysis:** this is an important pattern to watch. Many production systems will likely converge toward “confidential VM plus workload attestation layer,” because raw CVM attestation alone is often not enough for user-facing verification.

---

## 5. Intel SGX

### 5.1 Core idea

Intel SGX creates process-level enclaves inside an application address space and minimizes the trusted computing base to the CPU package, enclave contents, and a relatively small runtime boundary.

This is the classic “small trusted core” model.

### 5.2 Native measurement and attestation

SGX exposes two core identities:

- **`MRENCLAVE`**: measurement of the enclave image during build / initialization
- **`MRSIGNER`**: identity of the signing authority

Modern data-center attestation centers on **DCAP / ECDSA** and Intel provisioning collateral.

### 5.3 What SGX proves well

SGX is strongest when the relying party wants to verify:

- that a specific enclave measurement loaded
- that it was signed by an expected authority
- that the platform has valid attestation collateral

This is still one of the strongest native application-identity models among mainstream server TEEs.

### 5.4 What SGX does not solve by itself

- It does not automatically make a large Linux application easy to trust.
- It does not eliminate the need to audit enclave code.
- It has a long history of side-channel and microarchitectural research pressure, which means operational hardening matters a lot in practice.

### 5.5 Practical strengths

- Smallest trust boundary among mainstream server TEEs
- Precise enclave identity model
- Good fit for key custody, signing, MPC, and compact trusted kernels
- Strong attestation story for small, audited components

### 5.6 Practical limits

- Hardest developer model of the mainstream options
- Poor fit for large general-purpose Linux workloads
- Performance can degrade sharply when enclave memory pressure becomes significant
- Intel’s current product positioning is server-centric: the active SGX processor list is centered on Xeon families, while 12th Gen Intel Core documentation lists SGX as deprecated on that client line

### 5.7 Best fit

Choose SGX when the trusted component is small, high value, and worth treating almost like a cryptographic appliance.

### 5.8 Primary sources

- [Intel SGX sealing: `MRENCLAVE` and `MRSIGNER`](https://www.intel.com/content/www/us/en/developer/articles/technical/introduction-to-intel-sgx-sealing.html)
- [Intel SGX DCAP ECDSA orientation](https://download.01.org/intel-sgx/sgx-dcap/dcap-1.0.1/docs/Intel_SGX_DCAP_ECDSA_Orientation.pdf)
- [Intel SGX processor support page](https://www.intel.com/content/www/us/en/architecture-and-technology/software-guard-extensions-processors.html)
- [12th Gen Intel Core deprecated technologies](https://edc.intel.com/content/www/tw/zh/design/ipla/software-development-platforms/client/platforms/alder-lake-desktop/12th-generation-intel-core-processors-datasheet-volume-1-of-2/011/deprecated-technologies/https%3A%25252F%25252Fedc.intel.com%25252Fcontent%25252Fwww%25252Fjp%25252Fja%25252Fdesign%25252Fipla%25252Fsoftware-development-platforms%25252Fclient%25252Fplatforms%25252Falder-lake-desktop%25252F12th-generation-intel-core-processors-datasheet-volume-1-of-2%25252F011%25252Fdeprecated-technologies%25252F/)

---

## 6. AWS Nitro Enclaves

### 6.1 Core idea

AWS Nitro Enclaves creates a hardened microVM carved out of a parent EC2 instance.

The enclave has:

- dedicated vCPU and memory
- no persistent storage
- no interactive access
- no external networking
- `vsock` as the main communication path to the parent

This is not a process enclave. It is an isolated microVM with a narrow operational surface.

### 6.2 Native measurement and attestation

AWS documents Nitro attestation around PCRs exposed from the EIF build and parent context:

| PCR | Meaning |
| --- | --- |
| `PCR0` | Enclave image file |
| `PCR1` | Linux kernel and bootstrap |
| `PCR2` | Application |
| `PCR3` | Parent instance IAM role |
| `PCR4` | Parent instance ID |
| `PCR8` | EIF signing certificate |

The attestation document is generated by the **Nitro Hypervisor**, encoded as CBOR, COSE-signed, and chained to the **AWS Nitro Attestation PKI**. Optional fields such as `public_key`, `user_data`, and `nonce` let a verifier build stronger challenge-binding or secret-release protocols.

### 6.3 What Nitro proves well

Nitro is strong when the relying party wants to verify:

- a specific EIF-derived measured image
- a specific parent context if PCR3 / PCR4 are enforced
- a challenge or recipient key bound into the attestation flow

Combined with **AWS KMS** condition keys, Nitro enables a very practical pattern:

> release secrets only to an enclave with the expected PCRs

### 6.4 What Nitro does not solve by itself

- Nitro measures the starting image, not every future dynamic behavior inside it.
- If the measured image contains an interpreter, plugin loader, or mutable data dependencies, those need their own trust story.
- Nitro is AWS-specific.

### 6.5 Practical strengths

- Strong native image identity
- Much easier Linux environment than SGX
- Excellent fit for secure services, signing gateways, KMS clients, and policy-gated secret handling
- Very strong operational pattern through KMS-conditioned decryption

### 6.6 Practical limits

- Larger TCB than SGX
- Not a general confidential VM for arbitrary lift-and-shift workloads
- Networking and storage constraints force architectural adaptation

### 6.7 Best fit

Choose Nitro Enclaves when you want strong measured-image identity in an AWS-native service boundary and can accept the parent/enclave split model.

### 6.8 Nitro as a solution landscape

One practical difference between Nitro Enclaves and some other TEE discussions is that “choosing Nitro” is often only the first decision.

**Analysis:** in real deployments, teams usually choose both:

- **Nitro as the base enclave primitive**
- a **higher-level Nitro operating model** on top of it

That is a direct consequence of Nitro’s constraints:

- no external networking by default
- no persistent storage inside the enclave
- parent / enclave split
- `vsock`-centric communication model

So the next architectural question is usually:

> Which layer of the Nitro problem do we want to own ourselves, and which layer do we want abstracted?

Examples of distinct Nitro operating models include the following, as of **March 27, 2026**:

| Nitro stack type | Representative examples | What it adds above raw Nitro | Best fit |
| --- | --- | --- | --- |
| Raw AWS-native path | AWS Nitro Enclaves itself | Cleanest trust boundary, maximum control | Teams willing to own enclave packaging, networking, and operations |
| Open-source toolkit | Enclaver | Build / run abstraction, networking helpers, attestation tooling | Teams that want help with Nitro mechanics without giving up control |
| Managed developer platform | Evervault Enclaves | Docker-centric deployment, managed ingress / egress, SDK-driven attestation UX | Teams optimizing for developer velocity |
| Enterprise runtime / platform | Anjuna on Nitro | Higher-level runtime, EKS integration, secrets / policy helpers | Larger enterprises migrating or operating broader workloads |
| Networked public-verifiability path | Marlin Oyster | A public / decentralized enclave deployment model rather than only a local runtime | Web3 or public-verifiability use cases |
| Kubernetes substrate | AWS EKS + Nitro Enclaves device plugin | Better orchestration and scheduling of enclaves in clusters | Teams already standardized on Kubernetes |

These are not one-for-one substitutes.

They solve different jobs:

- low-level control
- toolkit convenience
- managed platform ergonomics
- enterprise operating model
- decentralized verifiable deployment
- cluster orchestration

That distinction is useful because it prevents a common category error:

> Nitro Enclaves is the TEE primitive. Many “Nitro solutions” are really platform choices above that primitive.

### 6.9 Primary sources

- [What is Nitro Enclaves?](https://docs.aws.amazon.com/enclaves/latest/user/nitro-enclave.html)
- [Nitro Enclaves concepts](https://docs.aws.amazon.com/enclaves/latest/user/nitro-enclave-concepts.html)
- [Cryptographic attestation and PCR definitions](https://docs.aws.amazon.com/enclaves/latest/user/set-up-attestation.html)
- [Verifying the Nitro root of trust](https://docs.aws.amazon.com/enclaves/latest/user/verify-root.html)
- [Require attestation to use an AWS KMS key](https://docs.aws.amazon.com/prescriptive-guidance/latest/privacy-reference-architecture/require-attestation-for-kms-key.html)
- [Using Nitro Enclaves with Amazon EKS](https://docs.aws.amazon.com/enclaves/latest/user/kubernetes.html)
- [Enclaver](https://enclaver.io/)
- [Evervault Enclaves](https://docs.evervault.com/enclaves)
- [Anjuna on AWS Nitro Enclaves](https://www.anjuna.io/partners/aws)
- [Marlin Oyster Nitro-based networking docs](https://docs.marlin.org/oyster/core-concepts/networking)

---

## 7. Intel TDX

### 7.1 Core idea

Intel TDX protects a full confidential VM, called a **Trust Domain (TD)**, from the host VMM, hypervisor, and non-TD software.

Its core value proposition is not “shrink the application TCB to a tiny enclave.” It is:

> run a conventional VM while excluding the host from the VM’s trust boundary

### 7.2 Native measurement and attestation

TDX attestation exposes measured TD state through claims such as:

- **`MRTD`**: initial TD measurement
- **`RTMR0-RTMR3`**: extendable measurement registers
- **`report_data`**: caller-supplied data bound into the quote

Intel Trust Authority documents the RTMR roles as:

- `RTMR0`: TD virtual firmware configuration
- `RTMR1`: TD OS loader and kernel
- `RTMR2`: OS application
- `RTMR3`: reserved for special usage

That “special usage” point is exactly why higher-level platforms can extend TDX with workload claims.

### 7.3 What TDX proves well

TDX is strong when the relying party wants to verify:

- that a real TDX-enabled platform booted a confidential VM
- that the TD launch state matches expected measurements
- that a nonce, key, or runtime binding is reflected in `report_data`

### 7.4 What TDX does not prove by default

By itself, TDX does **not** natively answer:

> “Is this exact application binary running now?”

It proves a measured confidential VM launch, not the full semantic identity of everything inside the guest.

### 7.5 Practical strengths

- Strong infrastructure isolation for conventional VM workloads
- Very good lift-and-shift story for Linux applications
- Better fit than SGX or Nitro for larger services, data systems, and CPU-side AI runtimes
- Extensible measurement model that platform layers can build on

### 7.6 Practical limits

- Larger TCB than enclave-centric TEEs
- Application identity is indirect unless an additional workload attestation layer is added
- Verification often still assumes trust in the workload publisher

### 7.7 Best fit

Choose TDX when the main goal is to make the infrastructure blind while keeping the developer model close to a normal VM.

### 7.8 Primary sources

- [Intel TDX overview](https://www.intel.com/content/www/us/en/developer/tools/trust-domain-extensions/overview.html)
- [Intel Trust Authority: TDX overview](https://docs.trustauthority.intel.com/main/articles/articles/ita/tee-tdx.html)
- [Intel Trust Authority: attestation tokens and TDX claims](https://docs.trustauthority.intel.com/main/articles/articles/ita/concept-attestation-tokens.html)

---

## 8. AMD SEV-SNP

### 8.1 Core idea

AMD SEV-SNP belongs to the same broad family as TDX: a VM-based TEE that protects the guest from the hypervisor and host operator.

AMD’s own developer material frames SEV as a VM-based confidential computing solution that requires **no code changes** and evolves generation by generation:

- **SEV**: encrypted memory
- **SEV-ES**: encrypted CPU state
- **SEV-SNP**: integrity protection and guest attestation
- **Trusted I/O / TDISP on EPYC 9005**: extending the TEE boundary toward devices

### 8.2 Key architectural mechanisms

The most important technical mechanisms are:

- **AMD Secure Processor**: manages keys and security operations
- **RMP (Reverse Map Table)**: enforces page ownership and integrity constraints
- **VMPL**: privilege separation inside the guest
- **GHCB**: standardized guest-hypervisor communication block

### 8.3 Native measurement and attestation

SEV-SNP attestation centers on guest launch state, guest policy, and platform TCB.

AMD’s SNP documentation makes the endorsement model explicit:

- the attestation signing key is the **VCEK**
- the VCEK is derived from chip-unique secrets and TCB version
- AMD KDS publishes the certificate material used to validate it

This is a very strong platform and launch attestation model, but it is still not a native “exact app binary” model.

### 8.4 What SEV-SNP proves well

SEV-SNP is strong when the relying party wants to verify:

- that a genuine AMD-backed confidential VM launched
- that the guest policy and platform TCB are acceptable
- that memory integrity protections such as SNP are actually in effect

### 8.5 What SEV-SNP does not prove by default

Like TDX, it does not natively prove the exact application binary inside the guest unless a higher-level measurement layer is added.

### 8.6 Practical strengths

- Strong VM-level confidentiality and integrity model
- Very good compatibility with existing workloads
- Broad ecosystem and cloud availability documented by AMD
- Clear evolutionary path toward trusted devices through Trusted I/O

### 8.7 Practical limits

- Application identity is indirect by default
- TCB is much larger than a small enclave model
- The secure processor firmware remains a significant trust dependency

### 8.8 Best fit

Choose SEV-SNP when you want confidential VM semantics similar to TDX, often with strong ecosystem availability on AMD-backed clouds and platforms.

### 8.9 Primary sources

- [AMD Infinity Guard: SEV, SNP, and Trusted I/O overview](https://www.amd.com/en/products/processors/server/epyc/infinity-guard.html)
- [AMD published technical details for SEV cloud offerings](https://www.amd.com/en/newsroom/press-releases/2023-8-30-amd-shares-the-technical-details-of-technology-pow.html)
- [AMD SEV-SNP Firmware ABI specification](https://www.amd.com/content/dam/amd/en/documents/epyc-technical-docs/specifications/56860.pdf)
- [AMD SEV-TIO Firmware Interface specification](https://www.amd.com/content/dam/amd/en/documents/epyc-technical-docs/specifications/58271.pdf)
- [AMD GHCB standardization](https://docs.amd.com/api/khub/documents/oJly8EPzLO1Bt7ncrkCytw/content)

---

## 9. Arm Confidential Compute Architecture (CCA)

### 9.1 Core idea

Arm CCA brings confidential computing to Armv9-A through the **Realm Management Extension (RME)** and the concept of **Realms**.

Arm positions Realms as an execution environment isolated not only from the normal-world hypervisor, but also from other Realms and from devices that are not trusted by the Realm.

### 9.2 Core architecture

The key software components are:

- **RMM**: Realm Management Monitor
- **RMI**: host-facing Realm Management Interface
- **RSI**: Realm-facing service interface
- **TF-A at EL3**: root firmware layer used by the reference implementation

TrustedFirmware’s documentation makes an important boundary explicit:

- the normal-world hypervisor still makes resource-management and policy decisions
- the RMM enforces Realm execution and provides services including attestation

### 9.3 Native measurement and attestation

Arm’s attestation flow combines:

- a **Realm token**
- a **CCA Platform token**

TrustedFirmware documentation and Arm attestation material describe the Realm token as carrying Realm measurements plus a relying-party challenge, while the platform token carries platform claims and firmware state.

### 9.4 What CCA proves well

CCA is strong when the relying party wants to verify:

- that a genuine Realm launched on a CCA platform
- that the Realm initial state matches expected measurements
- that platform and firmware state are reflected in the attestation chain

### 9.5 What CCA does not prove by default

Like TDX and SEV-SNP, CCA’s native proof is closer to “measured confidential VM / Realm state” than “exact application binary identity.”

### 9.6 Practical strengths

- Clean architecture for confidential VM-style isolation on Arm
- Open-source reference implementation for RMM and TF-A
- Clear path toward device assignment and memory encryption contexts
- Strong relevance for cloud-on-Arm, edge, and mobile-adjacent deployments

### 9.7 Practical limits

- Ecosystem maturity is still earlier than the established x86 CVM stacks
- Availability depends on Armv9-A plus platform support for RME
- Native application identity remains indirect

### 9.8 Best fit

Choose Arm CCA when your roadmap includes Arm-based cloud, edge, or accelerator-rich systems and you value an open management-layer implementation.

### 9.9 Primary sources

- [Arm: Unlocking the power of data with Arm CCA](https://developer.arm.com/community/arm-community-blogs/b/architectures-and-processors-blog/posts/unlocking-the-power-of-data-with-arm-cca)
- [Arm: Arm and confidential computing](https://developer.arm.com/community/arm-community-blogs/b/architectures-and-processors-blog/posts/arm-and-confidential-computing)
- [TF-RMM readme](https://rmm.docs.trustedfirmware.org/en/latest/readme.html)
- [TrustedFirmware attestation and measured boot](https://www.trustedfirmware.org/docs/Attestation_and_Measured_Boot.pdf)

---

## 10. NVIDIA Confidential Computing

### 10.1 Core idea

NVIDIA Confidential Computing addresses the part that CPU TEEs do not cover: data and code that execute on the GPU.

NVIDIA’s H100 material describes Hopper as the first GPU with native confidential computing support, anchored in an on-die hardware root of trust.

### 10.2 Native measurement and attestation

NVIDIA documents attestation through the **NVIDIA Attestation Suite**, which includes:

- **NRAS**: NVIDIA Remote Attestation Service
- local verifier flows
- SDK and CLI tooling for collecting and validating evidence

Current NVIDIA attestation docs describe the typical deployment precondition as:

> a confidential virtual machine with an H100-or-later GPU that supports confidential computing

That is the key architectural point: in practice, GPU confidential computing composes with a CPU-side TEE.

### 10.3 What NVIDIA CC proves well

NVIDIA CC is strong when the relying party wants to verify:

- that a genuine NVIDIA GPU is present
- that its firmware / mode / attestation evidence are acceptable
- that the GPU is operating in confidential-computing mode before sensitive workloads run

### 10.4 What NVIDIA CC does not replace

- It does not replace the need for CPU-side isolation.
- It does not by itself provide a full-system trust story for the application unless the CPU-side environment is also attested.

### 10.5 Practical strengths

- Extends the boundary into the GPU path, which is essential for confidential AI
- Strong vendor-provided attestation tooling
- Enables end-to-end reasoning about CPU-plus-GPU trusted execution instead of CPU-only confidentiality

### 10.6 Practical limits

- NVIDIA-specific trust root and tooling
- Must usually be composed with a confidential VM
- The full trust base now includes GPU firmware and driver state in addition to the CPU-side stack

### 10.7 Best fit

Choose NVIDIA Confidential Computing when sensitive data or model state enters the GPU and CPU-only confidential computing is therefore incomplete.

### 10.8 Primary sources

- [Confidential Computing on NVIDIA H100 GPUs](https://developer.nvidia.com/blog/confidential-computing-on-h100-gpus-for-secure-and-trustworthy-ai/)
- [NVIDIA Hopper architecture in depth](https://developer.nvidia.com/blog/nvidia-hopper-architecture-in-depth/)
- [NVIDIA Attestation overview](https://docs.nvidia.com/attestation/index.html)
- [NVIDIA Attestation Suite introduction](https://docs.nvidia.com/attestation/overview-attestation-suite/latest/introduction.html)
- [GPU attestation guide](https://docs.nvidia.com/attestation/attestation-client-tools-sdk/latest/gpu_and_switch_attestation.html)

---

## 11. RISC-V Keystone

### 11.1 Core idea

Keystone is an open-source framework for building TEEs on RISC-V. Its goal is very different from Intel, AMD, AWS, Arm, or NVIDIA product stacks:

> maximize openness and customizability, even if that means accepting lower product maturity

### 11.2 Core architecture

Keystone builds around:

- a **Security Monitor** running in machine mode
- **PMP** for memory isolation
- untrusted host software
- enclave runtimes on top of the monitor

The project documentation is explicit that full security depends on platform support for:

- measured boot
- secure on-chip key storage
- a hardware root of trust

It can still run on platforms without a real hardware root of trust for development, but that is not the same as a fully anchored production trust chain.

### 11.3 What Keystone proves well

Keystone is strong when the goal is to study or build:

- a customizable open TEE stack
- inspectable security monitor logic
- remote attestation and measurement flows without a closed vendor architecture

### 11.4 What Keystone does not optimize for

- turnkey cloud deployment
- mature commercial attestation infrastructure
- broad production compatibility

### 11.5 Practical strengths

- Fully open software stack
- Strong research value
- Good fit for experimentation, formal methods, and custom threat models

### 11.6 Practical limits

- Research and incubation maturity
- Much weaker ecosystem support than mainstream commercial TEEs
- Security strength depends heavily on the chosen RISC-V platform and its root-of-trust story

### 11.7 Best fit

Choose Keystone when openness, inspectability, and TEE experimentation matter more than commercial deployment maturity.

### 11.8 Primary sources

- [Keystone GitHub repository](https://github.com/keystone-enclave/keystone)
- [Keystone Security Monitor documentation](https://docs.keystone-enclave.org/en/latest/Security-Monitor/)
- [Keystone RISC-V background and PMP](https://docs.keystone-enclave.org/en/latest/Getting-Started/How-Keystone-Works/RISC-V-Background.html)

---

## 12. dstack on Intel TDX

### 12.1 What it is

dstack is best understood as a **platform layer on top of Intel TDX**, not as a separate hardware TEE.

Its job is to strengthen workload-level verification for TDX-based deployments.

### 12.2 What it adds

Phala’s dstack / attestation documentation exposes workload-facing claims such as:

- **`compose-hash`**
- **`RTMR3`**
- **`report_data`**
- event-log replay and higher-level verification tooling

The official docs frame this as a way to verify:

- that a specific deployment configuration was booted
- that the quote came from genuine TDX hardware
- that the application-level measurement chain matches the quoted value

### 12.3 The key measurement nuance

Phala’s docs define `compose-hash` as the SHA-256 hash of **`app-compose.json`**, which contains the Docker Compose configuration plus metadata.

That is important because it means the measured application identity is **manifest-centric**, not equivalent to SGX-style page measurement or Nitro-style EIF measurement.

**Analysis:** dstack materially strengthens raw TDX, but its strongest workload claim is still:

> “this attested deployment manifest and related event chain booted in the CVM”

not:

> “the CPU hardware directly measured this application binary page by page”

The docs themselves also stress that full verification requires:

- digest-pinned container images
- RTMR3 replay
- quote validation
- source provenance or reproducible build linkage

That is exactly the right mental model: dstack adds a serious verification layer, but the verifier must actually perform it.

### 12.4 Practical strengths

- Much stronger workload story than raw TDX
- Docker-centric developer experience
- External verification flows are explicitly documented
- Good bridge between “confidential infrastructure” and “verifiable deployment”

### 12.5 Practical limits

- Still inherits TDX as the underlying hardware TEE
- Workload identity is only as strong as the full verification procedure actually performed
- Manifest measurement is not identical to direct binary measurement

### 12.6 Best fit

Choose dstack when you want TDX’s full-VM convenience but also need a meaningful workload-verification layer for users, auditors, or downstream services.

### 12.7 Primary sources

- [Phala attestation fields reference](https://docs.phala.com/phala-cloud/attestation/attestation-fields)
- [Verify your application](https://docs.phala.com/phala-cloud/attestation/verify-your-application)
- [Verify the platform](https://docs.phala.com/phala-cloud/attestation/verify-the-platform)
- [Trust Center verification](https://docs.phala.com/phala-cloud/attestation/trust-center-verification)
- [dstack audit PDF](https://docs.phala.com/images/audits/dstack-audit.pdf)

---

## 13. Attestation Protocol Patterns and Verification Appendix

The earlier sections focus on trust meaning. This appendix focuses on attestation mechanics.

**Analysis:** the main reason attestation sections matter is not because every verifier needs to memorize the wire format, but because each attestation design reveals what the platform considers its primary object of trust.

### 13.1 Intel SGX DCAP

- **Evidence shape**: a quote over enclave claims such as `MRENCLAVE`, `MRSIGNER`, attributes, and user-bound data
- **Root of trust**: Intel provisioning collateral
- **Typical verifier question**: “Does this enclave measurement and signer match the release policy I trust?”
- **What it is uniquely good at**: direct enclave-identity verification

### 13.2 AWS Nitro attestation

- **Evidence shape**: a Nitro attestation document signed in the AWS Nitro attestation PKI
- **Core claims**: PCRs, certificate chain, and optional `nonce`, `user_data`, `public_key`
- **Typical verifier question**: “Does this enclave image and parent context match the policy I allow?”
- **What it is uniquely good at**: secret release and session setup bound to a measured enclave image

### 13.3 Intel TDX quote

- **Evidence shape**: a TD quote exposing claims such as `MRTD`, `RTMR0-RTMR3`, and `report_data`
- **Root of trust**: Intel TDX attestation infrastructure and collateral
- **Typical verifier question**: “Did a TD with this measured launch state boot on a genuine TDX platform?”
- **What it is uniquely good at**: platform-grade confidential-VM attestation with room for higher-layer measurement extensions

### 13.4 AMD SEV-SNP report

- **Evidence shape**: an attestation report signed using AMD’s SNP endorsement chain
- **Root of trust**: AMD certificate hierarchy, including VCEK-backed verification
- **Typical verifier question**: “Did this SNP guest launch with the expected policy and acceptable TCB?”
- **What it is uniquely good at**: strong launch and policy attestation tied to AMD’s per-platform trust model

### 13.5 Arm CCA Realm attestation

- **Evidence shape**: Realm token plus platform token
- **Root of trust**: Arm CCA attestation architecture and platform attestation keys
- **Typical verifier question**: “Did this Realm launch with the expected initial state on a valid CCA platform?”
- **What it is uniquely good at**: clean separation between Realm state and platform state

### 13.6 NVIDIA attestation

- **Evidence shape**: GPU evidence validated via the NVIDIA Attestation Suite
- **Root of trust**: NVIDIA GPU identity and attestation chain
- **Typical verifier question**: “Is this GPU genuine, in confidential mode, and correctly configured before the workload runs?”
- **What it is uniquely good at**: extending the attestation story to accelerator state

### 13.7 dstack-style composed attestation

- **Evidence shape**: TDX quote plus workload-facing claims such as `RTMR3`, `compose-hash`, and `report_data`
- **Root of trust**: Intel TDX hardware plus dstack’s workload measurement flow
- **Typical verifier question**: “Did this expected deployment manifest, bound to my challenge or key, boot inside genuine TDX hardware?”
- **What it is uniquely good at**: pushing a CVM toward workload-verifiable deployment

### 13.8 Verification takeaway

Across all these systems, the relying party should ask the same sequence of questions:

1. Is the evidence genuine and chained to a valid root of trust?
2. Is the measured object the one I actually care about?
3. Are the measurements pinned to a release, manifest, policy, or signer I trust?
4. Is my key, nonce, or session binding reflected in the evidence?
5. What trusted software still sits between this evidence and the real application behavior?

That last question is the one most likely to be skipped, and it is exactly where many overclaims about TEEs begin.

---

## 14. Measurement Depth: The Difference That Changes Everything

One of the biggest sources of confusion in TEE comparisons is measurement depth.

| Measurement depth | Representative systems | What is natively measured |
| --- | --- | --- |
| **Direct enclave code / page measurement** | Intel SGX | Enclave image as it is built / initialized |
| **Direct measured image measurement** | AWS Nitro Enclaves | EIF-derived image components through PCRs |
| **Launch-state measurement for a confidential guest** | Intel TDX, AMD SEV-SNP, Arm CCA | VM / Realm launch state, policy, firmware / boot chain |
| **Device-state measurement** | NVIDIA CC | GPU mode, device identity, firmware / evidence |
| **Manifest-layer measurement on top of a CVM** | dstack on TDX | Deployment manifest and workload event chain |

This is why statements like “all TEEs prove the running code” are too imprecise to be useful.

They do not all prove the same thing.

---

## 15. Comparison Matrix

| Solution | Isolation unit | Strongest native thing a verifier can learn | What still usually has to be trusted | Best mental model |
| --- | --- | --- | --- | --- |
| **Intel SGX** | Process enclave | A specific enclave measurement and signer identity | Enclave author intent, enclave-side side-channel hardening | Small trusted core |
| **AWS Nitro Enclaves** | Isolated microVM | A specific measured EIF plus parent-context claims | What the measured image may load or depend on at runtime | Measured secure service boundary |
| **Intel TDX** | Confidential VM | A measured TD booted on genuine TDX hardware | Workload publisher for exact guest contents | Confidential infrastructure |
| **AMD SEV-SNP** | Confidential VM | A measured SNP guest with platform-backed policy / TCB | Workload publisher for exact guest contents | Confidential infrastructure |
| **Arm CCA** | Realm VM | A measured Realm booted with valid platform claims | Workload publisher for exact guest contents | Confidential infrastructure on Arm |
| **NVIDIA CC** | GPU device + mode | A GPU is genuine and running in confidential mode | CPU-side environment unless attested too | Confidential accelerator |
| **Keystone** | Enclave framework | Open, monitor-based enclave measurements on a chosen RISC-V platform | Platform root-of-trust design and deployment quality | Open TEE framework |
| **dstack on TDX** | Platform layer in a CVM | A measured deployment manifest and RTMR3 chain on top of TDX | Full verification flow, digest pinning, image provenance | TDX plus workload attestation |

---

## 16. Three Claims That Are Often Confused

### 16.1 “The host cannot read my VM”

This is what **TDX**, **SEV-SNP**, and **CCA** are designed to do well.

### 16.2 “I can verify the code or image I intended to trust”

This is where **SGX** and **Nitro Enclaves** are naturally stronger.

### 16.3 “My AI workload is protected end to end”

This usually requires more than a CPU TEE. Once the workload moves into GPU memory and execution state, **NVIDIA Confidential Computing** or an equivalent accelerator trust story becomes necessary.

---

## 17. Selection Guidance by Use Case

### 17.1 Small, auditable trusted core

Choose **Intel SGX**.

Typical fit:

- signing engines
- wallets
- MPC
- compact policy kernels

### 17.2 AWS-native secure service boundary

Choose **AWS Nitro Enclaves**.

Typical fit:

- KMS-gated decryption
- HSM-adjacent service patterns
- secure API middle tiers
- secret handling inside an enclave-specific service

### 17.3 Large lift-and-shift confidential workloads

Choose **Intel TDX** or **AMD SEV-SNP**.

Typical fit:

- existing Linux services
- confidential databases
- data-processing pipelines
- CPU-side confidential AI runtimes

### 17.4 Arm-first confidential compute roadmap

Choose **Arm CCA** when the platform supports it and the roadmap matters more than short-term ecosystem depth.

### 17.5 GPU-resident confidential AI

Choose **CPU TEE + NVIDIA Confidential Computing**.

Typical fit:

- protected model weights
- private inference prompts
- confidential fine-tuning or training

### 17.6 Open and customizable TEE research

Choose **Keystone**.

### 17.7 TDX plus stronger user-visible workload verification

Choose **dstack on TDX**.

This is often the right compromise when you want:

- a normal VM-like runtime
- Docker-centric deployment
- workload-level claims stronger than raw CVM attestation

---

## 18. SGX vs Nitro Enclaves: Which One Is “Stronger”?

This comparison comes up often because SGX and Nitro are the two mainstream options that get closest to native application identity. But they optimize for different kinds of strength.

### 18.1 Why SGX can be stronger in theory

In the narrow minimal-TCB sense, SGX is often the stronger construction:

- the trust boundary is smaller
- enclave identity is more direct
- the model is explicitly built around a compact trusted computation

If the question is only:

> Which model minimizes trusted surface most aggressively?

SGX often wins.

### 18.2 Why Nitro can be stronger in practice for many teams

In production, however, many teams care about a different question:

> Which model gives us a strong enough trust story with fewer operational traps?

Nitro often looks stronger on that axis because it offers:

- a conventional Linux environment
- simpler packaging and debugging than SGX
- a clean measured-image story
- powerful AWS KMS policy integration
- a service-boundary model that many teams can actually operate correctly

**Analysis:** this is the practical split:

- **SGX** optimizes for smallest theoretical trust base
- **Nitro** optimizes for a stronger balance of verifiability and deployability

### 18.3 The most useful conclusion

The best answer is usually not “SGX is better” or “Nitro is better.”

It is:

- choose **SGX** when a tiny, audited, high-value trusted core is worth the complexity
- choose **Nitro** when you want strong measured-image identity in a production-friendly isolated service model

---

## 19. Final Takeaway

The main fault line in the TEE landscape is not “which vendor says their security is stronger.”

It is:

- **what is actually measured**
- **what the attestation can honestly prove**
- **what residual trust remains**

That gives a much cleaner map of the current landscape:

- **SGX**: verify a small enclave
- **Nitro Enclaves**: verify a measured service image
- **TDX / SEV-SNP / CCA**: protect a confidential guest from the host
- **NVIDIA CC**: extend that trust boundary into the GPU
- **Keystone**: keep the TEE stack open and customizable
- **dstack**: add workload verification on top of a confidential VM

If a document does not clearly distinguish those categories, it will almost always overstate what at least one of the TEEs is proving.

---

## 20. Original-Source Index

### 20.1 Common confidential computing background

- [CCC: Common Terminology for Confidential Computing](https://confidentialcomputing.io/wp-content/uploads/sites/10/2023/03/Common-Terminology-for-Confidential-Computing.pdf)
- [CCC: Why is Attestation Required for Confidential Computing?](https://confidentialcomputing.io/2023/04/06/why-is-attestation-required-for-confidential-computing/)

### 20.2 Intel SGX

- [Intel SGX sealing](https://www.intel.com/content/www/us/en/developer/articles/technical/introduction-to-intel-sgx-sealing.html)
- [Intel SGX DCAP ECDSA orientation](https://download.01.org/intel-sgx/sgx-dcap/dcap-1.0.1/docs/Intel_SGX_DCAP_ECDSA_Orientation.pdf)
- [Intel SGX processor support](https://www.intel.com/content/www/us/en/architecture-and-technology/software-guard-extensions-processors.html)

### 20.3 AWS Nitro Enclaves

- [What is Nitro Enclaves?](https://docs.aws.amazon.com/enclaves/latest/user/nitro-enclave.html)
- [Nitro attestation](https://docs.aws.amazon.com/enclaves/latest/user/set-up-attestation.html)
- [Nitro root of trust verification](https://docs.aws.amazon.com/enclaves/latest/user/verify-root.html)
- [KMS attestation policy example](https://docs.aws.amazon.com/prescriptive-guidance/latest/privacy-reference-architecture/require-attestation-for-kms-key.html)
- [Using Nitro Enclaves with Amazon EKS](https://docs.aws.amazon.com/enclaves/latest/user/kubernetes.html)
- [Enclaver](https://enclaver.io/)
- [Evervault Enclaves](https://docs.evervault.com/enclaves)
- [Anjuna on AWS Nitro Enclaves](https://www.anjuna.io/partners/aws)
- [Marlin Oyster docs](https://docs.marlin.org/oyster/introduction-to-marlin/trusted-execution-environments)

### 20.4 Intel TDX

- [Intel TDX overview](https://www.intel.com/content/www/us/en/developer/tools/trust-domain-extensions/overview.html)
- [Intel Trust Authority: TDX](https://docs.trustauthority.intel.com/main/articles/articles/ita/tee-tdx.html)
- [Intel Trust Authority: attestation claims](https://docs.trustauthority.intel.com/main/articles/articles/ita/concept-attestation-tokens.html)

### 20.5 AMD SEV-SNP

- [AMD Infinity Guard](https://www.amd.com/en/products/processors/server/epyc/infinity-guard.html)
- [AMD press release on technical details and source publication](https://www.amd.com/en/newsroom/press-releases/2023-8-30-amd-shares-the-technical-details-of-technology-pow.html)
- [AMD SEV-SNP Firmware ABI](https://www.amd.com/content/dam/amd/en/documents/epyc-technical-docs/specifications/56860.pdf)
- [AMD SEV-TIO Firmware Interface specification](https://www.amd.com/content/dam/amd/en/documents/epyc-technical-docs/specifications/58271.pdf)
- [AMD GHCB standard](https://docs.amd.com/api/khub/documents/oJly8EPzLO1Bt7ncrkCytw/content)

### 20.6 Arm CCA

- [Arm: Unlocking the power of data with Arm CCA](https://developer.arm.com/community/arm-community-blogs/b/architectures-and-processors-blog/posts/unlocking-the-power-of-data-with-arm-cca)
- [Arm: Arm and confidential computing](https://developer.arm.com/community/arm-community-blogs/b/architectures-and-processors-blog/posts/arm-and-confidential-computing)
- [TF-RMM documentation](https://rmm.docs.trustedfirmware.org/en/latest/readme.html)
- [TrustedFirmware attestation and measured boot](https://www.trustedfirmware.org/docs/Attestation_and_Measured_Boot.pdf)

### 20.7 NVIDIA Confidential Computing

- [Confidential Computing on NVIDIA H100 GPUs](https://developer.nvidia.com/blog/confidential-computing-on-h100-gpus-for-secure-and-trustworthy-ai/)
- [NVIDIA Hopper architecture in depth](https://developer.nvidia.com/blog/nvidia-hopper-architecture-in-depth/)
- [NVIDIA Attestation documentation](https://docs.nvidia.com/attestation/index.html)
- [NVIDIA Attestation Suite](https://docs.nvidia.com/attestation/overview-attestation-suite/latest/introduction.html)

### 20.8 Keystone

- [Keystone GitHub](https://github.com/keystone-enclave/keystone)
- [Keystone Security Monitor docs](https://docs.keystone-enclave.org/en/latest/Security-Monitor/)
- [Keystone PMP / RISC-V background docs](https://docs.keystone-enclave.org/en/latest/Getting-Started/How-Keystone-Works/RISC-V-Background.html)

### 20.9 dstack / Phala

- [Attestation fields reference](https://docs.phala.com/phala-cloud/attestation/attestation-fields)
- [Verify your application](https://docs.phala.com/phala-cloud/attestation/verify-your-application)
- [Verify the platform](https://docs.phala.com/phala-cloud/attestation/verify-the-platform)
- [Trust Center verification](https://docs.phala.com/phala-cloud/attestation/trust-center-verification)
- [dstack audit PDF](https://docs.phala.com/images/audits/dstack-audit.pdf)
