def to_intel_hex_line(address: int, data: bytes) -> str:
    assert len(data) == 4, "Cada instrucción debe tener 4 bytes"
    record_type = 0x00  # Data record
    byte_count = len(data)

    # ¡NO multiplicamos por 4! Las direcciones avanzan de a palabras
    byte_address = address

    fields = [byte_count, (byte_address >> 8) & 0xFF, byte_address & 0xFF, record_type] + list(data)
    checksum = (-sum(fields)) & 0xFF

    line = f":{byte_count:02X}{byte_address:04X}{record_type:02X}" + data.hex().upper() + f"{checksum:02X}"
    return line

# Instrucciones RISC-V en big endian
instructions = [
    0x00000013,  # NOP
    0x00A00093,  # ADDI x1, x0, 10
    0x00D00113,  # ADDI x2, x0, 13
    0x002081B3,  # ADD x3, x1, x2
    0x3e302423, # sw x3, 1000(x0)
    0x3e802203, # lw x4, 1000(x0)
    0x000202b3,  # add x5, x4, x0
    0x3e5006a3, # sb x5, 1005(x0)
    0x3ed00303, # lb x6, 1005(x0)
    0x00030313, # addi x6, x6, 0
    0xfff00313, # addi x6, x0, -1
    0x3e601923, # sh x6, 1010(x0)
    0x3f201303, # lh x6, 1010(x0)
    0x00030393, # addi x7, x6, 0
]

with open("program_word.hex", "w") as f:
    for i, instr in enumerate(instructions):
        instr_bytes = instr.to_bytes(4, byteorder="big")  # Big endian
        line = to_intel_hex_line(i, instr_bytes)
        f.write(line + "\n")
    f.write(":00000001FF\n")  # EOF