# ============================================================
# Gerador do microprograma Mic-1 (Tanenbaum) -> microcode.mif e MIFtest.mif
# Uso:  powershell -ExecutionPolicy Bypass -File gen_microcode.ps1
#
# Formato do MIR (36 bits):
#   [35..27] NEXT_ADDRESS
#   [26..24] JAM    (JMPC, JAMN, JAMZ)
#   [23..16] ALU    (SLL8, SRA1, F0, F1, ENA, ENB, INVA, INC)
#   [15..7]  C      (H, OPC, TOS, CPP, LV, SP, PC, MDR, MAR)
#   [6..4]   MEM    (WRITE, READ, FETCH)
#   [3..0]   B      (0 MDR, 1 PC, 2 MBR, 3 MBRU, 4 SP, 5 LV, 6 CPP, 7 TOS, 8 OPC)
# ============================================================

$rom = New-Object 'uint64[]' 512
$cmt = New-Object 'string[]' 512

function W($addr, [string]$hex, $comment) {
    $rom[$addr] = [Convert]::ToUInt64($hex, 16)
    $cmt[$addr] = $comment
}

# ---------------- NOP (0x00) & Main1 (0x02) ----------------
W 0x000 '010000000' 'nop1: goto Main1'
W 0x002 '004350211' 'Main1: PC = PC + 1; fetch; goto (MBR)'

# ---------------- BIPUSH (0x10..0x12) ----------------
W 0x010 '088350484' 'bipush1: SP = MAR = SP + 1'
W 0x011 '090350211' 'bipush2: PC = PC + 1; fetch'
W 0x012 '010142142' 'bipush3: MDR = TOS = MBR; wr; goto Main1'

# ---------------- LDC_W (0x13..0x14, 0x1A..0x1B) ----------------
W 0x013 '0A0350211' 'ldc_w1: PC = PC + 1; fetch'
W 0x014 '0D0948003' 'ldc_w2: H = MBRU << 8'
W 0x01A '0D81C8003' 'ldc_w3: H = MBRU OR H'
W 0x01B '0B83C00A6' 'ldc_w4: MAR = H + CPP; rd; goto iload3'

# ---------------- ILOAD (0x15..0x19) ----------------
W 0x015 '0B0148005' 'iload1: H = LV'
W 0x016 '0B83C00A3' 'iload2: MAR = MBRU + H; rd'
W 0x017 '0C0350484' 'iload3: MAR = SP = SP + 1'
W 0x018 '0C8350251' 'iload4: PC = PC + 1; fetch; wr'
W 0x019 '010142000' 'iload5: TOS = MDR; goto Main1'

# ---------------- ISTORE (0x36..0x3B) ----------------
W 0x036 '1B8148005' 'istore1: H = LV'
W 0x037 '1C03C0083' 'istore2: MAR = MBRU + H'
W 0x038 '1C8140147' 'istore3: MDR = TOS; wr'
W 0x039 '1D03604A4' 'istore4: SP = MAR = SP - 1; rd'
W 0x03A '1D8350211' 'istore5: PC = PC + 1; fetch'
W 0x03B '010142000' 'istore6: TOS = MDR; goto Main1'

# ---------------- POP (0x57..0x58, 0x5B) / DUP (0x59..0x5A) / SWAP (0x5F, 0x5C..0x5E, 0x68..0x69) ----------------
W 0x057 '2C03604A4' 'pop1: MAR = SP = SP - 1; rd'
W 0x058 '2D8140000' 'pop2: (espera leitura)'
W 0x05B '010142000' 'pop3: TOS = MDR; goto Main1'
W 0x059 '2D0350484' 'dup1: MAR = SP = SP + 1'
W 0x05A '010140147' 'dup2: MDR = TOS; wr; goto Main1'

# ---------------- IADD (0x60..0x62) ----------------
W 0x060 '3083604A4' 'iadd1: MAR = SP = SP - 1; rd'
W 0x061 '310148007' 'iadd2: H = TOS'
W 0x062 '0103C2140' 'iadd3: MDR = TOS = MDR + H; wr; goto Main1'

# ---------------- ISUB (0x64..0x66) ----------------
W 0x064 '3283604A4' 'isub1: MAR = SP = SP - 1; rd'
W 0x065 '330148007' 'isub2: H = TOS'
W 0x066 '0103F2140' 'isub3: MDR = TOS = MDR - H; wr; goto Main1'

# ---------------- IAND (0x7E..0x7F, 0x7D) / IOR (0x80..0x82) ----------------
W 0x07E '3F83604A4' 'iand1: MAR = SP = SP - 1; rd'
W 0x07F '3E8148007' 'iand2: H = TOS'
W 0x07D '0100C2140' 'iand3: MDR = TOS = MDR AND H; wr; goto Main1'
W 0x080 '4083604A4' 'ior1: MAR = SP = SP - 1; rd'
W 0x081 '410148007' 'ior2: H = TOS'
W 0x082 '0101C2140' 'ior3: MDR = TOS = MDR OR H; wr; goto Main1'

# ---------------- IINC (0x84..0x89) ----------------
W 0x084 '428148005' 'iinc1: H = LV'
W 0x085 '4303C00A3' 'iinc2: MAR = MBRU + H; rd'
W 0x086 '438350211' 'iinc3: PC = PC + 1; fetch'
W 0x087 '440148000' 'iinc4: H = MDR'
W 0x088 '448350211' 'iinc5: PC = PC + 1; fetch'
W 0x089 '0103C0142' 'iinc6: MDR = MBR + H; wr; goto Main1'

# ---------------- F (0x8D..0x8F) & T (0x18D) ----------------
W 0x08D '470350201' 'F: PC = PC + 1'
W 0x08E '478350211' 'F2: PC = PC + 1; fetch'
W 0x08F '010000000' 'F3: goto Main1'
W 0x18D '540364001' 'T: OPC = PC - 1; goto goto2'

# ---------------- IFEQ (0x99..0x9A, 0xA5..0xA6) ----------------
W 0x099 '4D03604A4' 'ifeq1: MAR = SP = SP - 1; rd'
W 0x09A '528144007' 'ifeq2: OPC = TOS; goto ifeq3'
W 0x0A5 '530142000' 'ifeq3: TOS = MDR'
W 0x0A6 '469140008' 'ifeq4: Z = OPC; if (Z) goto T; else goto F'

# ---------------- IFLT (0x9B..0x9E) ----------------
W 0x09B '4E03604A4' 'iflt1: MAR = SP = SP - 1; rd'
W 0x09C '4E8144007' 'iflt2: OPC = TOS'
W 0x09D '4F0142000' 'iflt3: TOS = MDR'
W 0x09E '46A140008' 'iflt4: N = OPC; if (N) goto T; else goto F'

# ---------------- IF_ICMPEQ (0x9F..0xA4) ----------------
W 0x09F '5003604A4' 'if_icmpeq1: MAR = SP = SP - 1; rd'
W 0x0A0 '508360484' 'if_icmpeq2: MAR = SP = SP - 1'
W 0x0A1 '510148020' 'if_icmpeq3: H = MDR; rd'
W 0x0A2 '518144007' 'if_icmpeq4: OPC = TOS'
W 0x0A3 '520142000' 'if_icmpeq5: TOS = MDR'
W 0x0A4 '4693F0008' 'if_icmpeq6: Z = OPC - H; if (Z) goto T; else goto F'

# ---------------- GOTO (0xA7..0xAC) ----------------
W 0x0A7 '540364001' 'goto1: OPC = PC - 1'
W 0x0A8 '548350211' 'goto2: PC = PC + 1; fetch'
W 0x0A9 '550948002' 'goto3: H = MBR << 8'
W 0x0AA '5581C8003' 'goto4: H = MBRU OR H'
W 0x0AB '5603C0218' 'goto5: PC = OPC + H; fetch'
W 0x0AC '010000000' 'goto6: goto Main1'

# ---------------- WIDE (0xC4..0xC5) ----------------
W 0x0C4 '628350211' 'wide1: PC = PC + 1; fetch'
W 0x0C5 '804000000' 'wide2: goto (MBR OR 0x100)'

# ---------------- WIDE ILOAD (0x115..0x118) ----------------
W 0x115 '8B0350211' 'wide_iload1: PC = PC + 1; fetch'
W 0x116 '8B8948003' 'wide_iload2: H = MBRU << 8'
W 0x117 '8C01C8003' 'wide_iload3: H = MBRU OR H'
W 0x118 '0B83C00A5' 'wide_iload4: MAR = LV + H; rd; goto iload3'

# ---------------- WIDE ISTORE (0x136..0x139) ----------------
W 0x136 '9B8350211' 'wide_istore1: PC = PC + 1; fetch'
W 0x137 '9C0948003' 'wide_istore2: H = MBRU << 8'
W 0x138 '9C81C8003' 'wide_istore3: H = MBRU OR H'
W 0x139 '1C03C0085' 'wide_istore4: MAR = LV + H; goto istore3'

# ---------------- Opcodes nao usados mas presentes como lixo no barramento PROG_MEM_IN dos VWFs ----------------
W 0x02A '010000000' 'nop: goto Main1'
W 0x06C '010000000' 'nop: goto Main1'
W 0x0FF '010000000' 'nop: goto Main1'

$out = New-Object System.Collections.Generic.List[string]
$out.Add('-- Microprograma Mic-1 (IJVM) - gerado por gen_microcode.ps1.')
$out.Add('WIDTH=36;'); $out.Add('DEPTH=512;'); $out.Add('')
$out.Add('ADDRESS_RADIX=HEX;'); $out.Add('DATA_RADIX=HEX;'); $out.Add('')
$out.Add('CONTENT BEGIN')
for ($a = 0; $a -lt 512; $a++) {
    $line = "`t{0:X3} : {1:X9};" -f $a, $rom[$a]
    if ($cmt[$a]) { $line += "`t-- " + $cmt[$a] }
    $out.Add($line)
}
$out.Add('END;')
$path = Join-Path $PSScriptRoot 'MIFtest.mif'
[System.IO.File]::WriteAllLines($path, $out)
$path2 = Join-Path $PSScriptRoot 'microcode.mif'
[System.IO.File]::WriteAllLines($path2, $out)
Write-Host ("Gerados {0} e {1}" -f $path, $path2)
