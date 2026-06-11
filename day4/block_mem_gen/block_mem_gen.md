Block Memory Generator

About:
This project implements a Block Memory Generator in Verilog HDL. The memory stores 8-bit data and supports separate read and write addresses. Write operations occur when the write enable signal is asserted, while read operations return the contents of the selected memory location. An active-low asynchronous reset clears all memory locations.

Files:
[Design File](design/block_mem_gen.v)
[Testbench File](tb/block_mem_gen_tb.v)

Simulation Output:
![Block Memory Generator Waveform](block_memory_generator_waveform.png)

Features:
* 8 memory locations
* 8-bit data width
* Separate read and write addresses
* Write enable controlled operation
* Active-low asynchronous reset
* Memory initialization during reset

Test Cases Performed:
1. Wrote `AB` to address `01`
2. Wrote `CD` to address `02`
3. Wrote `EF` to address `03`
4. Read back all three locations and verified the stored values
5. Wrote `55` to address `04`
6. Applied reset and verified that memory contents were cleared
7. Read address `04` after reset and confirmed the output was `00`

Notes:
The design was verified using the provided testbench. Read and write operations behaved as expected, and the asynchronous reset successfully cleared all memory locations.
