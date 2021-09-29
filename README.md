# Interrupt Latency Timer Core

An APB slave device, capable to generate an interrupt request
signal and to count clock cycles till the request is acknowledged
by an ISR and/or received by an application program

## Register Map

| Offset (hex) | Mode | Register Name                            |
|:------------:|:----:|:-----------------------------------------|
| 00           | RO   | Core ID                                  |
| 04           | RW   | Master Control and Status register       |
| 08           | RO   | Free-running timer latch (low 32 bits)   |
| 0c           | RO   | Free-running timer latch (high 32 bits)  |
| 10           | RW   | Interrupt generator delay counter        |
| 14           | RW   | RFU                                      |
| 18           | RW   | RFU                                      |
| 1c           | RW   | RFU                                      |
| 20           | RW   | Interrupt Acknowledge/Status register    |
| 24           | RO   | Interrupt counter                        |
| 28           | RO   | Missed ACK 0 counter                     |
| 2c           | RO   | Missed ACK 3 counter                     |
| 30           | RO   | ACK 0 latency latch                      |
| 34           | RO   | ACK 1 latency latch                      |
| 38           | RO   | ACK 2 latency latch                      |
| 3c           | RO   | ACK 3 latency latch                      |

## Registers Description

### Core ID

Idnetification register contains output of the `git rev-parse --short=8 HEAD`
command as unsigned 32-bit integer.

### Master Control and Status register

### Free-running timer latch (low and high) registers

### Interrupt generator delay counter

### Interrupt Acknowledge and Status register

### Interrupt counters

### Interrupt latency latches
