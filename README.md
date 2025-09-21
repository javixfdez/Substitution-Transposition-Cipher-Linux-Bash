# Substitution-Transposition-Cipher-Linux-Bash

Bash script that combines two classical ciphers: Caesar (substitution) and Columnar Transposition — perfect for learning cryptography and bash scripting.

## Purpose

This script demonstrates how to implement two classical cryptographic techniques in Linux Bash:

1. **Substitution Cipher (Caesar Cipher)**  
   Each alphabetic character is shifted by a fixed number of positions in the alphabet (e.g., A → D with shift=3).

2. **Transposition Cipher (Columnar)**  
   The substituted text is written into a grid row-wise and then read column-wise in an order defined by a numeric key (e.g., key "213" means read column 2 first, then 1, then 3).

### Environment

- Linux, macOS, or WSL (Windows Subsystem for Linux)
- Bash shell (v4.0+ recommended)
- Basic terminal knowledge

### Examples
1. When executing ./cipher2.sh "HELLO" 3 "213" -->
Original: HELLO
Substituted: KHOOR
Transposed: HOOKR
Final Cipher: HOOKR

2. ./cipher2.sh "SECRET"
Original: SECRET
Substituted: VHFUHW
Transposed: VHF UHW
Final Cipher: VHF UHW
