#!/usr/bin/env python3
"""Simula una escena del panel 32x16 y la exporta como GIF ampliado.

La razon de existir de esto: afinar el ritmo de una animacion recompilando el
firmware es insufrible (dos minutos por intento). Aqui se ve el resultado al
instante, y solo se pasa a la cabecera cuando la escena ya convence. Las dos
escenas de este proyecto necesitaron cuatro pasadas cada una.

NECESITA un `sprites.json` en el directorio actual, con los sprites que vayas
a usar. Lo genera extraer_sprites.py con la opcion --json:

    python3 extraer_sprites.py pliego.png HEROE_A 11 35 --json
    python3 extraer_sprites.py pliego.png HEROE_B 11 52 --json
    ...

Esta escena de ejemplo espera HEROE_A/B, BICHO_A/B y ATAQUE1-4. Cambiala a
gusto: es un guion, no una biblioteca.
"""
import json
from PIL import Image

W, H = 32, 16
S = json.load(open('sprites.json'))

# --------- parametros de la escena (los que se tocan al afinar) ---------
MS      = 55   # milisegundos por pixel de avance
SEP     = 17   # cuanto va el heroe por detras del bicho
PAUSA   = 10   # pasos en negro entre las dos partes
PARADA  = 0    # X donde Link se planta a dar el mandoble
ESTOCADA = ['ATAQUE1','ATAQUE1','ATAQUE2','ATAQUE2','ATAQUE2','ATAQUE2','ATAQUE2','ATAQUE2',
            'ATAQUE3','ATAQUE3','ATAQUE4','ATAQUE4','ATAQUE1','ATAQUE1']
EMPUJE   = [    1,     1,     5,     4,     3,     2,     1,     1,
                1,     1,     1,     1,     1,     1]   # retroceso del golpe

HEROE_PAL   = {'V':(128,208,16),'O':(200,76,12),'P':(252,152,56),
              'B':(255,255,255),'R':(216,40,0),'p':(252,216,168)}
BICHO_NORMAL = {'R':(216,40,0),'P':(252,152,56),'B':(252,252,252)}
BICHO_DANIO  = [{'R':(0,0,168),'P':(92,148,252),'B':(252,252,252)},
              {'R':(0,0,0),'P':(0,128,136),'B':(216,40,0)},
              {'R':(0,168,0),'P':(252,216,168),'B':(32,56,236)},
              {'R':(128,208,16),'P':(252,152,56),'B':(200,76,12)}]

def nuevo(): return [[(0,0,0)] * W for _ in range(H)]
def pinta(b, arte, px, pal, espejo=False):
    an = len(arte[0])
    for r, f in enumerate(arte):
        for c, ch in enumerate(f):
            if ch == '.': continue
            x = px + (an - 1 - c if espejo else c)
            if 0 <= x < W: b[r][x] = pal[ch]
mob = lambda n: S['BICHO_A'] if (n // 4) % 2 == 0 else S['BICHO_B']
lnk = lambda n: S['HEROE_A']   if (n // 4) % 2 == 0 else S['HEROE_B']

frames = []
for t in range(49):                                    # el bicho huye a la izquierda
    b = nuevo(); pinta(b, mob(t), 32 - t, BICHO_NORMAL, True); frames.append(b)
for _ in range(PAUSA): frames.append(nuevo())
mx, lx, tm, tl = -16, -16 - SEP, 0, 0
while lx < PARADA:                                     # vuelve perseguido
    b = nuevo(); pinta(b, mob(tm), mx, BICHO_NORMAL); pinta(b, lnk(tl), lx, HEROE_PAL)
    frames.append(b); mx += 1; lx += 1; tm += 1; tl += 1
g = 0
for nombre, av in zip(ESTOCADA, EMPUJE):               # el ataque
    b = nuevo()
    if mx < W:
        pal = BICHO_NORMAL
        if nombre == 'ATAQUE2':
            pal = BICHO_DANIO[g % 4] if g < 5 else BICHO_NORMAL; g += 1
        pinta(b, mob(tm), mx, pal)
    pinta(b, S[nombre], PARADA, HEROE_PAL)
    frames.append(b); mx += av; tm += 1
lx = PARADA
while lx < W:                                          # el heroe sale por la derecha
    b = nuevo(); pinta(b, lnk(tl), lx, HEROE_PAL); frames.append(b); lx += 1; tl += 1

print(f"{len(frames)} fotogramas · {len(frames)*MS/1000:.1f} s a {MS} ms/px")
ims = []
for b in frames:
    im = Image.new('RGB', (W, H)); im.putdata([p for f in b for p in f])
    ims.append(im.resize((W * 10, H * 10), Image.NEAREST))
ims[0].save('escena.gif', save_all=True, append_images=ims[1:], duration=MS, loop=0)
print("-> escena.gif")
