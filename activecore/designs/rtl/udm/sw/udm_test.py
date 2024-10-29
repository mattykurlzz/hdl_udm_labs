# -*- coding:utf-8 -*-
from __future__ import division

import struct
import udm
from ctypes import c_int32
from udm import *

udm = udm('COM11', 9600)
print("")

CSR_LED_ADDR    = 0x00000000
CSR_SW_ADDR     = 0x00000004
FLOAT1_ADDR     = 0x00000008
FLOAT2_ADDR     = 0x0000000C 
RES_ADDR     = 0x00000010 
TESTMEM_ADDR    = 0x80000000

a = 1.56
b = 35.0
s = struct.pack('>f', a)
''.join('%2.2x' % c for c in s)
ia = struct.unpack('>i', s)[0]
print(hex(ia))


s = struct.pack('>f', b)
''.join('%2.2x' % c for c in s)
ib = struct.unpack('>i', s)[0]
print(hex(ib))


udm.wr32(FLOAT1_ADDR, ia)
udm.wr32(FLOAT2_ADDR, ib)
ians = udm.rd32(RES_ADDR)
print(hex(ians))
s = struct.pack('>i', ians)
''.join('%2.2x' % c for c in s)
ans = struct.unpack('>f', s)[0]
print("{} + {} = {}".format(a, b, ans))
udm.disconnect()
