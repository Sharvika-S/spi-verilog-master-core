# 🔄 SPI Master Core in Verilog



## 📌 Overview

This project implements a fully functional **Serial Peripheral Interface (SPI) Master Core** using Verilog HDL. It simulates and verifies SPI communication between master and slave modules, including clock generation, shift registers, and Wishbone protocol support.

---

## 🔧 Features

- Full-duplex synchronous data transfer
- Supports variable-length word transfer (up to 128 bits)
- MSB/LSB-first transmission modes
- Rx/Tx on rising or falling edges of SCLK
- Wishbone-compliant interface
- Up to 8 slave select lines
- Fully synthesizable Verilog HDL
- Simulated using ModelSim; synthesis-ready for Quartus

---

## 📁 Folder Structure
spi-verilog-master-core/
-├── src/ # Verilog HDL modules
-│ ├── spi_clockgen.v
│ ├── spi_shift_register.v
│ ├── spi_slave.v
│ ├── wishbone_master.v
│ ├── spi_topmodule.v
│ └── spi_define.v
│
├── testbench/ # Testbenches for simulation
│ ├── spi_clockgen_tb.v
│ ├── spi_shift_register_tb.v
│ └── spi_slave_tb.v
│
├── docs/ # Diagrams, waveforms, project report
│ ├── architecture_diagram.png
│ ├── waveform_results.png
│ └── SPI_Project_Report.pdf



---

## 📦 Key Modules

| File                     | Description                                |
|--------------------------|--------------------------------------------|
| `spi_clockgen.v`         | Generates SPI serial clock and CPOL flags  |
| `spi_shift_register.v`   | Handles serial-to-parallel & parallel-to-serial conversion |
| `spi_slave.v`            | Responds to SPI master as per protocol     |
| `wishbone_master.v`      | Integrates Wishbone bus for communication  |
| `spi_topmodule.v`        | Combines all modules into one core         |
| `spi_define.v`           | Global parameter definitions               |

---

## 🧪 Testbenches

- `spi_clockgen_tb.v`
- `spi_shift_register_tb.v`
- `spi_slave_tb.v`

Simulated using ModelSim with clock waveforms, edge-triggered transmission, and valid SPI transfers.

---

## 🛠️ Tools Used

- **Verilog HDL**
- **ModelSim** – Functional simulation and debugging
- **Intel Quartus Prime** – Synthesis and resource analysis

---

## 📊 Documentation

- 📄 `SPI_Project_Report.pdf` in `docs/`
- 📸 Diagrams and simulation results in `docs/`
