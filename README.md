# Single-Stage Pipeline Register (Valid/Ready Handshake)

## Overview
This repository implements a **single-stage pipeline register** in **SystemVerilog** using a standard **valid/ready handshake protocol**.

The module sits between an input and output interface, storing one data item and correctly handling **flow control and backpressure** without data loss or duplication.

The design is fully synthesizable and resets to a clean empty state.

This exercise demonstrates practical RTL skills required in real hardware pipelines such as CPUs, interconnects, accelerators, and DMA engines.

---

## Task Requirements Addressed
The design satisfies the following requirements:

- Accept data only when `in_valid && in_ready`
- Present stored data using `out_valid`
- Transfer data only when `out_valid && out_ready`
- Handle output backpressure correctly
- Prevent data loss and duplication
- Apply proper upstream backpressure
- Reset to empty pipeline state
- Fully synthesizable RTL
- Clean sequential coding style

---

## Handshake Protocol

### Input Interface
| Signal | Description |
|---------|------------|
| `in_valid` | Input data valid |
| `in_ready` | Stage ready to accept data |
| `in_data`  | Input data |

Data transfer occurs when:
in_valid && in_ready


---

### Output Interface
| Signal | Description |
|---------|------------|
| `out_valid` | Output data valid |
| `out_ready` | Downstream ready |
| `out_data`  | Output data |

Data transfer occurs when:
out_valid && out_ready


---

## Pipeline Behavior

The stage contains:

- One data register
- One valid register

### Operation
1. Accept data when stage is empty or output consumes data.
2. Hold data if output stalls.
3. Apply backpressure upstream when full.
4. Replace data immediately when output consumes and new data arrives.

---

## Flow Control Logic

The ready signal is computed as:
in_ready = !valid_reg || out_ready


Meaning:
- Accept input if stage empty.
- Accept new data when output consumes current data.

---

## Reset Behavior
On reset:

- Pipeline becomes empty
- `out_valid` is cleared
- Stored data cleared
- No garbage data propagates

---

## RTL Design Characteristics

✔ Fully synthesizable  
✔ Uses `always_ff`  
✔ Non-blocking assignments  
✔ No latches  
✔ No delays or unsynthesizable constructs  
✔ Minimal hardware resources  
✔ Clean and readable coding style  

---


---

## Testbench Features

The provided testbench verifies:

- Correct reset behavior
- Normal data flow
- Output backpressure handling
- Continuous traffic operation
- No data loss or duplication

Simulation prints accepted and transmitted data.

---

## Simulation

Example simulator output:
INPUT accepted: 000000a1
OUTPUT sent: 000000a1



demonstrates correct handshake transfer.

---

## Applications

This pipeline structure appears in:

- CPU pipelines
- Memory subsystems
- NoC routers
- DMA engines
- AI accelerators
- Streaming interfaces
- Hardware FIFOs

---

## Possible Extensions

Future improvements may include:

- Multi-stage pipelines
- FIFO buffers
- Skid buffers
- Assertion-based verification
- Randomized testing
- UVM testbench integration

---

## Author
RTL implementation developed as part of a pipeline flow-control exercise demonstrating synthesizable RTL design and handshake correctness.
