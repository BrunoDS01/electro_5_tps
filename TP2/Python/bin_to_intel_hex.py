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
0x00200293,
0x01e00313,
0x00000f13,
0x00200393,
0x00100e13,
0x00000e93,
0x00000f93,
0x007f8863,
0x007e8eb3,
0x001f8f93,
0xff5ff0ef,
0x03d2c663,
0x00028213,
0x00724663,
0x40720233,
0xff9ff0ef,
0x00020863,
0x00138393,
0xfc53c6e3,
0x00c000ef,
0x00000e13,
0x004000ef,
0x000e0463,
0x001f0f13,
0x00128293,
0xfa5354e3,
0x000f0e13,
0x000000ef

  ]

with open("program_word.hex", "w") as f:
    for i, instr in enumerate(instructions):
        instr_bytes = instr.to_bytes(4, byteorder="big")  # Big endian
        line = to_intel_hex_line(i, instr_bytes)
        f.write(line + "\n")
    f.write(":00000001FF\n")  # EOF


"""
Código prueba SUMA, STORE y LOAD
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

ADDI
    0x00000013,  # NOP
    0x03800093, # addi x1, x0, 56
    0x1c808113, # addi x2, x1, 456
    0xf9c10193, # addi x3, x2, -100

SLTI/SLTIU
    0x00000013,  # NOP
    0x0c800093, # addi x1, x0, 200
    0x0c90a113, # slti x2, x1, 201
    0x0c70a193, # slti x3, x1, 199
    0xf380a193, # slti x3, x1, -200

    0xed400093, # addi x1, x0, -300
    0x0c90a113, # slti x2, x1, 201
    0xf380a193, # slti x3, x1, -200
    0xed30a193, # slti x3, x1, -301
    0xed50a193, # slti x3, x1, -299

    0x0c800093, # addi x1, x0, 200
    0x0c70b193, # sltiu x3, x1, 199
    0x0c90b193, # sltiu x3, x1, 201
    0x0c80b193, # sltiu x3, x1, 200

XORI/ORI/ANDI
    0x00000013,  # NOP
    0x0ff00093, # addi x1, x0, 0xff (0000 1111 1111)
    0x7110c113, # xori x2, x1, 0b 0111 0001 0001   (deberia dar 0111 1110 1110 - 7EE)
    0x7110e113, # ori x2, x1, 0b 0111 0001 0001 (deberia dar 0111 1111 1111 - 7FF)
    0x7110f113, # andi x2, x1, 0b 0111 0001 0001 (deberia dar 0000 0001 0001 - 011)


SLLI/SRLI/SRAI
    0x00000013,  # NOP
    0x0ff00093, # addi x1, x0, 0xff (0000 1111 1111)
    0x00309113, # slli x2, x1, 3
    0x0040d113, # srli x2, x1, 4
    0x4040d113, # srai x2, x1, 4
    0xf9c00093, # addi x1, x0, -100
    0x4020d113, # srai x2, x1, 2 (-25)
    0x0020d113, # srli x2, x1, 2 (tiene que ser -25, pero con 2 ceros al principio)
    0x00109113, # slli x2, x1, 1 (-200)
    
ADD/SUB
    0x00000013,  # NOP
    0x02d00093, # addi x1, x0, 45
    0x06400113, # addi x2, x0, 100
    0x001101b3, # add x3, x2, x1
    0xfff00093, # addi x1, x0, -1
    0x001101b3, # add x3, x2, x1
    0x01900093, # addi x1, x0, 25
    0x401101b3, # sub x3, x2, x1
    0x402081b3, # sub x3, x1, x2
    
SLL/SRL/SRA
    0x00000013, # NOP
    0xff600093, # addi x1, x0, -10
    0x00300113, # addi x2, x0, 3
    0x002091b3, # sll x3, x1, x2
    0x0020d1b3, # srl x3, x1, x2
    0x4020d1b3, # sra x3, x1, x2

SLT/SLTU
    0x00000013, # NOP
    0x0c800093, # addi x1, x0, 200
    0x0c700113, # addi x2, x0, 199
    0x0020a1b3, # slt x3, x1, x2 (0)
    0x001121b3, # slt x3, x2, x1
    
    0xff600093, # addi x1, x0, -10
    0xff500113, # addi x2, x0, -11
    0x0020a1b3, # slt x3, x1, x2 (0)
    0x001121b3, # slt x3, x2, x1
    0x0c800093, # addi x1, x0, 200
    0x0020a1b3, # slt x3, x1, x2 (0)
    0x001121b3, # slt x3, x2, x1

    0x00a00093, # addi x1, x0, 10
    0x00900113, # addi x2, x0, 9
    0x0020b1b3, # sltu x3, x1, x2
    0x001131b3, # sltu x3, x2, x1

XOR/OR/AND
    0x00000013, # NOP
    0x07700093, # addi x1, x0, 0x77 (0111 0111)
    0x0aa00093, # addi x1, x0, 0xAA (1010 1010)
    0x001141b3, # xor x3, x2, x1 (1101 1101)
    0x001161b3, # or x3, x2, x1 (1111 1111)
    0x001171b3, # and x3, x2, x1 (0010 0010)

LOAD STORE:
    0x00000013, # NOP
    0xfe200113, # addi x2, x0, -30
    0xff600093, # addi x1, x0, -10
    0x20208423, # sb x2, 520(x1)
    0x20808183, # lb x3, 520(x1)
    0x00018193, # addi x3, x3, 0

    0x20209923, # sh x2, 530(x1)
    0x21209183, # lh x3, 530(x1)
    0x00018193, # addi x3, x3, 0

    0x2420ac23, # sw x2, 600(x1)
    0x2580a183, # lw x3, 600(x1)
    0x00018193, # addi x3, x3, 0

    0x2080c183, # lbu x3, 520(x1)
    0x00018193, # addi x3, x3, 0

    0x2120d183, # lhu x3, 530(x1)
    0x00018193, # addi x3, x3, 0

JAL y Predictor de saltos
    0x00000013, # NOP
    0x01c000ef, # jal x1, 28
    0x00000013, # NOP (4)
    0x00000013, # NOP (8)
    0x00000013, # NOP (12)
    0x00000013, # NOP (16)
    0x00000013, # NOP (20)
    0x00000013, # NOP (24)
    0xfe1ff0ef, # jal x1, -32 (28 saltaría a 0)
    0x00000013, # NOP
    0x00000013, # NOP
    0x00000013, # NOP
    0x00000013, # NOP
    0x00000013, # NOP
    0x00000013, # NOP
    0x00000013, # NOP

JAL y JALR
    0x00000013, # NOP
    0x00018193, # addi x3, x3, 0
    0x01c000ef, # jal x1, 28
    0x00000013, # NOP
    0x00000013, # NOP
    0x00000013, # NOP
    0x00000013, # NOP
    0x00000013, # NOP
    0x00000013, # NOP
    0x00008093, # addi x1, x1, 0
    0x00a00113, # addi x2, x0, 10
    0xff6101e7, # jalr x3, -10(x2)

Branches


    BEQ/BNE
    0x00000013, # NOP
    0xff500093, # addi x1, x0, -11
    0xf3800113, # addi x2, x0, -200
    0x00208e63, # beq x1, x2, 28 (va a la linea 11)
    0x02209263, # bne x1, x2, 36 (va a la linea 14)
    0x00000013, # NOP
    0x00000013, # NOP
    0x00000013, # NOP
    0x00000013, # NOP
    0x00000013, # NOP
    0xff400093, # addi x1, x0, -12
    0xfc209ce3, # bne x1, x2, -40 (salta a la linea 2)
    0x00000013, # NOP
    0xf3800093, # addi x1, x0, -200
    0xfc208ae3, # beq x1, x2, -44 (va a la linea 4)
    0x00000013, # NOP
    0x00000013, # NOP
    0x00000013, # NOP

    BLT/BGE
    0x00000013, # NOP
    0xff500093, # addi x1, x0, -11
    0xf3800113, # addi x2, x0, -200
    0x0020ce63, # blt x1, x2, 28 (va a la linea 11)
    0x0220d263, # bge x1, x2, 36 (va a la linea 14)
    0x00000013, # NOP
    0x00000013, # NOP
    0x00000013, # NOP
    0x00000013, # NOP
    0x00000013, # NOP
    0xff400093, # addi x1, x0, -12
    0xfc20dce3, # bge x1, x2, -40 (salta a la linea 2)
    0x00000013, # NOP
    0xf3700093, # addi x1, x0, -201
    0xfc20cae3, # blt x1, x2, -44 (va a la linea 4)
    0x00000013, # NOP
    0x00000013, # NOP
    0x00000013, # NOP

    BLTU/BGEU
    0x00000013, # NOP
    0xff500093, # addi x1, x0, -11
    0x0c800113, # addi x2, x0, 200
    0x00116e63, # bltu x2, x1, 28 (va a la linea 11)
    0x02117263, # bgeu x2, x1, 36 (va a la linea 14)
    0x00000013, # NOP
    0x00000013, # NOP
    0x00000013, # NOP
    0x00000013, # NOP
    0x00000013, # NOP
    0xff400093, # addi x1, x0, -12
    0xfc117ce3, # bgeu x2, x1, -40 (salta a la linea 2)
    0x00000013, # NOP
    0x0c900093, # addi x1, x0, s201
    0xfc116ae3, # bltu x2, x1, -44 (va a la linea 4)
    0x00000013, # NOP
    0x00000013, # NOP
    0x00000013, # NOP

AUIPC/LUI
    0x00000013, # NOP
    0x0ff000b7, # lui x1, 0xFF00
    0x00008093, # addi x1, x1, 0
    0x0ff00117, # auipc x2, 65280
    0x00010113, # addi x2, x2, 0

FIBONACCI

   /*Fiboncacci*/
   addi x1, x0, 0
   addi x2, x0, 1
   addi x4, x0, 10       /*x4 = 10 repeticiones*/

loop:
 	add x3, x1, x2     /*x3=x1+x2*/
   	addi x1, x2, 0 		/*x1=x2*/
   	addi x2, x3, 0		/*x2=x3*/
   	addi x4, x4, -1
   	bne	x4, x0, loop
    
    addi x28, x3, 0

fin:
	jal x0, fin


    00000093
    00100113
    00a00213
    002081b3
    00010093
    00018113
    fff20213
    fe0218e3
    00018e13

    

# numeros primos hasta 30

    addi t0, x0, 2      # i = 2, primer número a chequear si es primo
    addi t1, x0, 30     # N = 30, límite superior
    addi t5, x0, 0      # contador de primos encontrados = 0

outer_loop:
    addi t2, x0, 2      # divisor = 2, empezamos a probar divisores
    addi t3, x0, 1      # es_primo = 1, asumimos que i es primo

inner_loop:
    # Calculamos divisor * divisor usando sumas repetidas
    addi t4, x0, 0      # t4 = 0, acumulador de multiplicación
    addi t6, x0, 0      # t6 = 0, contador de sumas realizadas

mul_loop:
    beq t6, t2, mul_end # si t6 == divisor, termina multiplicación
    add t4, t4, t2      # t4 += divisor
    addi t6, t6, 1      # t6 += 1
    jal mul_loop        # salto para repetir multiplicación

mul_end:
    blt t0, t4, check_prime  # si i < divisor*divisor, no hay más divisores que probar

    # Calculamos i % divisor usando restas sucesivas
    addi x4, t0, 0      # x4 = i, valor que iremos restando divisor

mod_loop:
    blt x4, t2, mod_end # si resto < divisor, termina el cálculo del módulo
    sub x4, x4, t2      # resto -= divisor
    jal mod_loop        # repetir hasta que resto < divisor

mod_end:
    beq x4, x0, not_prime # si resto == 0, i es divisible por divisor → no es primo

    addi t2, t2, 1      # divisor += 1, probamos siguiente divisor
    blt t2, t0, inner_loop  # mientras divisor < i seguimos probando
    jal check_prime     # sino, vamos a checkear si es primo

not_prime:
    addi t3, x0, 0      # es_primo = 0, marcamos que no es primo
    jal check_prime     # saltamos a la verificación final

check_prime:
    beq t3, x0, skip_count # si no es primo, saltamos el conteo
    addi t5, t5, 1      # contador_primos += 1

skip_count:
    addi t0, t0, 1      # i += 1, probamos el siguiente número
    ble t0, t1, outer_loop  # mientras i <= N, seguimos con outer_loop

    addi x28, t5, 0
end:
    jal end             # bucle infinito para detener ejecución (resultado en t5)

    
    0x00200293,
0x01e00313,
0x00000f13,
0x00200393,
0x00100e13,
0x00000e93,
0x00000f93,
0x007f8863,
0x007e8eb3,
0x001f8f93,
0xff5ff0ef,
0x03d2c663,
0x00028213,
0x00724663,
0x40720233,
0xff9ff0ef,
0x00020863,
0x00138393,
0xfc53c6e3,
0x00c000ef,
0x00000e13,
0x004000ef,
0x000e0463,
0x001f0f13,
0x00128293,
0xfa5354e3,
0x000f0e13,
0x000000ef

"""