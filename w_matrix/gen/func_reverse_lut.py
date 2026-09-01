LUT_ADDR_BITS = 11
LUT_DATA_BITS = 18
LUT_SIZE = 1 << LUT_ADDR_BITS

with open("func_reverse_lut.hex", "w") as f:
    for i in range(LUT_SIZE):
        x_i = (2048.0 + i) / 4096.0
        val = round((1.0 / x_i) * (2**16))
        val &= (1 << LUT_DATA_BITS) - 1
        f.write(f"{val:05X}\n")

print(f"Generated func_reverse_lut.hex with {LUT_SIZE} entries")
print(f"First value (i=0, x=0.5):   {hex(1 << 17)}")
print(f"Last value (i=2047, x≈1.0): see file")
