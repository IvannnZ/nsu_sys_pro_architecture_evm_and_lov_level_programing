def divu10(n):
    q = (n >> 1) + (n >> 2)  # q=n/2+n/4 = 3n/4
    q = q + (q >> 4)    # q=3n/4+(3n/4)/16 = 3n/4+3n/64 = 51n/64
    q = q + (q >> 8)    # 3 q=51n/64+(51n/64)/256 = 51n/64 + 51n/16384 = 13107n/16384 q = q + (q >> 16); // q= 13107n/16384+(13107n/16384)/65536=13107n/16348+13107n/1073741824=858993458n/1073741824
    q = q + (q >> 16)
    # note: q is now roughly 0.8n
    q = q >> 3  # q=n/8 = (about 0.1n or n/10)
    print(f"Q:{q}", end = ' ')
    r = n - (((q << 2) + q) << 1)  # rounding: r= n-2*(n/10*4+n/10)=n-2*5n/10=n-10n/10
    print(f"R:{r} ", end = '')
    return q + (r > 9)  # adjust answer by error term

print(f"absw:{divu10(165)} ")
print(f"absw:{divu10(160)} ")
print(f"absw:{divu10(1)} ")
print(f"absw:{divu10(0)} ")
print(f"absw:{divu10(1200)} ")
print(f"absw:{divu10(1665564645)} ")
