---
Title: dedup-simulator
ProjectGroup: Other
Repository: https://github.com/sjakthol/dedup-simulator
Summary: |
  A simulator and related scripts for measuring efficiency of an
  encrypted data deduplication solution. https://eprint.iacr.org/2015/455.pdf
Tags:
    - python
Date: 2017-09-10
---

This simulator was developed to measure the efficiency of an encrypted data
deduplication protocol for cloud storage service providers. The protocol
was developed by the Secure Systems group at the Aalto University School of
Science.

This simulator consists of various components that can be used to measure the
efficiency of the deduplication protocol. These components are:

* Dataset Collector - Collects file size and popularity data from UNIX
  systems.
* Upload Request Stream Generator - Generates a stream of upload requests
  from the collected datasets.
* Simulator - Reads the generated upload request stream and simulates the
  deduplication protocol.


This project also contains some additional tools used during the simulation
process:

* Perfect Protocol Simulator - Measures the perfect deduplication percentage
  for the generated upload request streams that provides a baseline for
  comparisons.
* Oversampler - A tool for generating larger datasets from a collected datasets.

## References and Additional Information
* Liu, Jian, N. Asokan, and Benny Pinkas. "Secure deduplication of encrypted
  data without additional independent servers." *Proceedings of the 22nd ACM
  SIGSAC Conference on Computer and Communications Security.* ACM, 2015. Available
  at https://eprint.iacr.org/2015/455.pdf
* Demo Implementation: https://git.ssg.aalto.fi/close/cloud-dedup
