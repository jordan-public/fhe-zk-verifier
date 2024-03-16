# ZVER - FHE ZK Verifier

## Abstract

We create and demonstrate a proving system that can run inside FHEnix, an EVM blockchain that is capable of Fully Homomorphic Encryption (FHE). As the FHE acts on the two operations, addition ("+") and multiplication ("*") allowing calculations of both operations on encrypted data, the inverse operations are quite expensive in terms of computational resources (Gas). Exponentiations is quite unreasonable and calculation of a Bilinear Pairing Function is prohibitive. To make reasonable compromise, we
arithmetize general computations into polynomial evaluation and execute them on-chain. This allows for small "proofs" to execute and
"show" the results instead of proving them by checking commitments
and calculations on a pre-calculated quasi-random point using Bilinear Pairing functions.

## Introduction

Imagine the following:
- Generate a ZK proof.
- Verify the proof. Keep the result a secret (usually the verification, especially on-chain one is public).
- Based on the result of the verification, run further calculations,
without revealing the verification result or the further calculations.

In FHE this is doable, but better written with the cost of each FHE
operation in mind.

## Anatomy of a ZK Proof

![Anatomy of ZK Prof](./docs/anatomy.png)

## How is ZVER made

## Demo

## Future Work

