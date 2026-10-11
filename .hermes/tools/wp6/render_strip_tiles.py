#!/usr/bin/env python3
"""Render the 8 tiles covered by the four $A7xx strips ($88E0/$89E0/$8CE0/$8DE0)."""
from PIL import Image

data = open('gfx/overworld/overworld.2bpp', 'rb').read()
tiles = [0x8E, 0x8F, 0x9E, 0x9F, 0xCE, 0xCF, 0xDE, 0xDF]
S = 8  # scale
img = Image.new('RGB', (len(tiles) * 8 * S, 8 * S), (255, 255, 255))
px = img.load()
for i, t in enumerate(tiles):
    off = t * 16
    for y in range(8):
        b0 = data[off + y * 2]
        b1 = data[off + y * 2 + 1]
        for x in range(8):
            bit = 7 - x
            c = ((b0 >> bit) & 1) | (((b1 >> bit) & 1) << 1)
            shade = [255, 170, 85, 0][c]
            for dx in range(S):
                for dy in range(S):
                    px[i * 64 + x * S + dx, y * S + dy] = (shade, shade, shade)
img.save('/home/pmill/.hermes/cache/scratch/wp6/strip_tiles.png')
print('wrote strip_tiles.png; tiles:', [hex(t) for t in tiles])
