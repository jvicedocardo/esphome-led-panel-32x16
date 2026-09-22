#!/usr/bin/env python3
"""Extrae sprites 1:1 de un pliego de The Spriters Resource al formato de
caracteres que usa panel_led_arte.h.

Estos pliegos tienen dos colores planos de fondo: uno para la hoja y otro
detras de cada celda de sprite. El truco que hace esto fiable es enmascarar
el de la HOJA y quedarse con lo que sobra: salen las celdas exactas, de 16x16
con 1 px de separacion. Buscar el fondo de celda no vale, porque el propio
sprite lo tapa y una celda se fragmenta en tres o cuatro tramos.

El fondo de hoja se detecta solo (es el color mas frecuente), asi que sirve
igual con fondos verdes que azul oscuro, que son los dos habituales.

  python3 extraer_sprites.py <pliego.png>              -> lista filas y celdas
  python3 extraer_sprites.py <pliego.png> NOMBRE y x   -> vuelca esa celda
  python3 extraer_sprites.py <pliego.png> NOMBRE y x A -> celda de A de ancho

Anade --json al final para acumular el sprite en sprites.json en vez de
imprimir el array de C: es lo que lee simular_escena.py.
"""
import sys
from collections import Counter

import numpy as np
from PIL import Image

# Caracteres ya en uso en panel_led_arte.h. Manten la coherencia entre escenas.
MAPA = {
    (128, 208, 16): 'V',   # verde claro
    (200, 76, 12):  'O',   # marron
    (252, 152, 56): 'P',   # piel / naranja
    (216, 40, 0):   'R',   # rojo   (intercambiable por paleta)
    (252, 252, 252): 'B',  # blanco (intercambiable por paleta)
    (255, 255, 255): 'B',
    (252, 216, 168): 'p',
    (181, 49, 32):  'M',   # rojo del personaje 2
    (234, 158, 34): 'C',   # piel del personaje 2
    (107, 109, 0):  'D',   # oscuro del personaje 2
    (0, 168, 0):    'G',   # verdes de escenario
    (0, 68, 0):     'd',
}
VIS = {'.': '·', 'V': '█', 'O': '▓', 'P': '▒', 'B': '░',
       'R': 'R', 'p': '+', 'M': '█', 'C': '▒', 'D': '▓',
       'G': '█', 'g': '▒', 'd': '▓'}


def fondo_hoja(im):
    """El color mas frecuente del pliego es el fondo de la hoja."""
    return Counter(map(tuple, im.reshape(-1, 3))).most_common(1)[0][0]


def bandas(v, minimo=2):
    out, ini = [], None
    for i, x in enumerate(v):
        if x and ini is None:
            ini = i
        elif not x and ini is not None:
            if i - ini >= minimo:
                out.append((ini, i - 1))
            ini = None
    if ini is not None:
        out.append((ini, len(v) - 1))
    return out


def fondo_celda(im, hoja, alto=16):
    """El segundo color plano: el que hay DETRAS de cada sprite, dentro de su
    celda. No se puede suponer (lo he visto gris y lila), asi que se
    prueban los colores mas frecuentes y gana el que produzca mas bandas
    horizontales de exactamente `alto` pixeles: eso son filas de sprites.

    Hace falta para pliegos con paneles de seccion, que los hay:
    ahi el fondo de hoja no sirve para encontrar las filas, porque el panel
    ocupa cientos de filas seguidas y se traga la hoja entera de una vez."""
    mejor, mejor_n = None, 0
    for col, _ in Counter(map(tuple, im.reshape(-1, 3))).most_common(8):
        if col == hoja:
            continue
        m = np.all(im == list(col), axis=2)
        n = sum(1 for a, z in bandas(m.any(axis=1)) if z - a + 1 == alto)
        if n > mejor_n:
            mejor, mejor_n = col, n
    return mejor, mejor_n


def celdas(im, hoja, alto=16, ancho=16, zona=None):
    """Filas de sprites por el fondo de celda; columnas por el fondo de hoja."""
    celda, _ = fondo_celda(im, hoja, alto)
    mc = np.all(im == list(celda), axis=2) if celda is not None else None
    no = ~np.all(im == list(hoja), axis=2)
    filas = bandas(mc.any(axis=1)) if mc is not None else bandas(no.any(axis=1))
    for y0, y1 in filas:
        if y1 - y0 + 1 != alto:
            continue
        if zona and not (zona[0] <= y0 <= zona[1]):
            continue
        xs = [a for a, z in bandas(no[y0:y1 + 1].any(axis=0)) if z - a + 1 == ancho]
        if xs:
            yield y0, xs


def arte(im, fondos, y0, x0, ancho=16, alto=16):
    """Devuelve la celda como lista de cadenas. Todo lo que no reconozca lo
    marca con '?' y lo reporta: es la senal de que hay un color nuevo que
    anadir a MAPA, no de que el sprite este mal."""
    out, raros = [], Counter()
    for r in range(y0, y0 + alto):
        fila = ''
        for c in range(x0, x0 + ancho):
            t = tuple(im[r, c])
            if t in fondos:          # fondo de hoja Y fondo de celda: transparente
                fila += '.'
                continue
            ch = MAPA.get(t)
            if ch is None:
                raros[t] += 1
                ch = '?'
            fila += ch
        out.append(fila)
    return out, raros


if __name__ == '__main__':
    if len(sys.argv) < 2:
        print(__doc__)
        sys.exit(1)
    im = np.array(Image.open(sys.argv[1]).convert('RGB')).astype(int)
    fondo = fondo_hoja(im)
    print(f"fondo de hoja detectado: {fondo}")

    if len(sys.argv) == 2:
        celda, n = fondo_celda(im, fondo)
        print(f"fondo de celda detectado: {celda}  ({n} filas de sprites)")
        hubo = False
        for y0, xs in celdas(im, fondo):
            print(f"  fila y={y0}: celdas de 16 en x = {xs}")
            hubo = True
        if not hubo:
            print("  ninguna celda de 16x16. Mira las dos detecciones de arriba:")
            print("  si el fondo de celda sale raro, el pliego no sigue el patron")
            print("  habitual y hay que acotar la zona a mano.")
        sys.exit()

    nombre, y0, x0 = sys.argv[2], int(sys.argv[3]), int(sys.argv[4])
    ancho = int(sys.argv[5]) if len(sys.argv) > 5 else 16
    celda, _ = fondo_celda(im, fondo)
    fondos = {fondo} | ({celda} if celda else set())
    a, raros = arte(im, fondos, y0, x0, ancho)
    for f in a:
        print("  " + "".join(VIS.get(c, '?') for c in f))
    if raros:
        print("\n  COLORES SIN MAPEAR (anadelos a MAPA con su letra):")
        for col, n in raros.most_common():
            print(f"    {col}  x{n}")
    if '--json' in sys.argv:
        import json, os
        d = json.load(open('sprites.json')) if os.path.exists('sprites.json') else {}
        d[nombre] = a
        json.dump(d, open('sprites.json', 'w'), indent=1)
        print(f"\n  {nombre} guardado en sprites.json ({len(d)} sprites)")
    else:
        print()
        print('static const char* %s[16] = {' % nombre)
        print(",\n".join('  "%s"' % f for f in a))
        print('};')
