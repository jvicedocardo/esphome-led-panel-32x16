# Panel LED informativo 32×16

Guía de construcción de un panel de pared que muestra la hora, el tiempo y dónde
está cada persona de la casa, en pixel-art, sobre una matriz de 512 LEDs.
Controlado desde Home Assistant.

> **Qué hace**
> Cuatro pantallas rotatorias: un reloj a toda pantalla, el tiempo con icono,
> temperatura y un dato meteorológico que cambia según lo que merezca la pena
> contar, la presencia de las personas con un icono por lugar, y animaciones de
> pixel-art que se disparan a mano o solas.
> Todo —brillo, horarios, colores, ritmos— se ajusta desde Home Assistant sin
> volver a compilar.

---

## Índice

1. [Especificaciones](#1-especificaciones)
2. [Qué necesitas saber antes de empezar](#2-qué-necesitas-saber-antes-de-empezar)
3. [Lista de materiales](#3-lista-de-materiales)
4. [Herramientas](#4-herramientas)
5. [Las piezas impresas](#5-las-piezas-impresas)
6. [ESPHome: instalación y primer flasheo](#6-esphome-instalación-y-primer-flasheo)
7. [Electrónica y cableado](#7-electrónica-y-cableado)
8. [Montaje físico](#8-montaje-físico)
9. [Puesta en marcha y calibración](#9-puesta-en-marcha-y-calibración)
10. [El firmware por dentro](#10-el-firmware-por-dentro)
11. [Home Assistant](#11-home-assistant)
12. [Personalizarlo](#12-personalizarlo)
13. [Cuando algo falla](#13-cuando-algo-falla)
14. [Créditos y referencias](#14-créditos-y-referencias)

---

## 1. Especificaciones

| | |
|---|---|
| Resolución | 32 × 16 = **512 LEDs** |
| Paneles | 2 × matriz WS2812B de 16×16, encadenados por datos |
| Paso entre LEDs | 10,0 mm exactos (160 mm / 16) |
| Medidas exteriores | 337 × 177 × ~30 mm |
| Cerebro | ESP32-S3 con ESPHome |
| Alimentación | 5 V / 18 A, fuente **fuera** del marco |
| Consumo típico | 5-6 A (30 W) con contenido pixel-art |
| Conexión | WiFi, integración nativa con Home Assistant |

**Por qué 32×16 y no otra cosa.** Dos paneles de 16×16 a tope dan una retícula
continua porque el margen de borde de cada panel es 2,5 mm, justo medio paso. Al
juntarlos, el paso sigue siendo de 10 mm de un panel al otro y la rejilla no tiene
ninguna junta visible. Si usas paneles con otro margen, esto no se cumple y habrás
de ajustar `hueco_union` en el modelo 3D.

---

## 2. Qué necesitas saber antes de empezar

**Lo que se da por hecho:**

- **Home Assistant funcionando.** Da igual cómo esté instalado (HAOS, contenedor,
  supervisado) mientras puedas añadir complementos o levantar ESPHome aparte.
- **Una impresora 3D** con cama de al menos **240 × 240 mm**. Todas las piezas
  grandes van partidas en dos para caber ahí.
- **Soldadura básica.** Hay que soldar un conector de aviación de 4 pines y unos
  cuantos cables a una placa perforada. Nada fino.
- **Cableado de 230 V.** La fuente es de bornes abiertos y hay que conectarle la
  230 V. Si esto te da respeto, que te lo haga alguien con manos — el respeto está
  bien puesto, y no es sitio para aprender.

**Lo que NO hace falta:**

- Saber programar. El firmware está escrito; se copia y se ajustan cuatro valores.
- Saber OpenSCAD. Los STL están exportados y listos. El `.scad` está por si quieres
  cambiar medidas.

**Tiempo aproximado:** un fin de semana largo de trabajo repartido, más unas 30-40
horas de impresora que corren en paralelo.

---

## 3. Lista de materiales

### Lo esencial

| Componente | Qué buscar | Notas |
|---|---|---|
| **2 × matriz LED** | `WS2812B 16x16 LED Matrix Panel` — 160×160 mm, paso 10 mm | Las hay rígidas y flexibles; sirven las dos. En AliExpress las encuentras por ese nombre. Unos 10-15 € cada una |
| **ESP32-S3** | `ESP32-S3-N16R8 DevKit` (16 MB flash, 8 MB PSRAM) | Vale casi cualquier ESP32, pero el S3 va sobrado y el driver RMT es el mejor para WS2812B |
| **Fuente 5 V** | **Mean Well LRS-100-5** (5 V / 18 A / 90 W) | [Diotronic, 22,69 €](https://diotronic.com/de-5v/7186-fuente-5v-100w-16a). Sin ventilador y con tensión ajustable, que es justo lo que hace falta |
| **Cable 1 mm²** | H05V-K flexible, rojo y negro, 3 m de cada | [rojo](https://diotronic.com/de-1mm2/2510-cable-1x1-rojo) · [negro](https://diotronic.com/de-1mm2/2515-cable-1x1-negro). 2,50 mm de diámetro exterior: **ese dato importa**, ver el GX16 |
| **2 × WAGO 221-415** | Conector de palanca de 5 vías | [Diotronic](https://diotronic.com/regletas-conectores/970-221-415-conector-wago-5-vias). Una regleta de clemas hace lo mismo |
| **Portafusible + fusible** | Portafusible aéreo de cuchilla + **fusible de 10 A** | [portafusible](https://diotronic.com/fusibles-portafusibles/1543-portafusible-aereo-para-coche) · [fusibles](https://diotronic.com/fusibles-portafusibles/1534-fusible-coche-de-15a) (pide de 10 A, no de 15 — ver más abajo) |
| **Malla trenzada** | `Malla trenzada expansible 6 mm` | Convierte los cuatro hilos en un cable redondo único |
| **Difusor** | Metacrilato **blanco opal de 2 mm**, cortado a 323,2 × 163,2 mm | Es lo que convierte 512 puntos en pixel-art. Cualquier tienda de plásticos te lo corta |
| **Cable de alimentación 230 V** | El cable de corriente de un ordenador de sobremesa viejo | Tiene que ser **IEC C13 con tierra** — los C7 de figura de ocho solo llevan dos hilos. La sección viene impresa en la funda: `3G0.75` va de sobra para los 0,4 A que consume esto |

### Del cajón de componentes

| | |
|---|---|
| Resistencia de **330 Ω** | En serie con la línea de datos |
| **1 × condensador 1000 µF / 10 V por panel** | En la entrada de cada panel, entre +5 V y GND. Si no lo encuentras, **2 × 100 µF en paralelo** por panel hacen el apaño — en paralelo suman, así que dan 200 µF. **En paralelo, no en serie**: en serie darían 50 y sería peor que uno solo |
| Placa perforada ~70 × 30 mm | Para el ESP32 |
| Tira de pines hembra | Para enzocalar el ESP32 y poder cambiarlo |
| Tornillos **M3×6 autorroscantes** | 8 para el bisel. **M3×6, no más largos**: asoman al alojamiento y tropiezan con la rejilla |
| Termorretráctil | Varios diámetros |
| Filamento PLA | Ver la sección de impresión |

### ⚠️ Sobre el fusible

El fusible protege **el cable**, no la fuente. El cable de 1 mm² aguanta unos
13,5 A, y la regla es que el fusible no pase del 80 % de eso: **10 A**.

Con uno de 15 A, ante un cortocircuito la fuente entregaría unos 20 A antes de
entrar en protección y el fusible no saltaría a tiempo de proteger el hilo. Es un
error fácil de cometer porque 15 A "parece" razonable al lado de una fuente de 18 A
— pero la fuente no es lo que hay que proteger.

### Lo que NO hace falta comprar

- **Level shifter (74AHCT125).** Comprobado: la matriz funciona con los 3,3 V del
  ESP32 directos, con la resistencia de 330 Ω y el cable de datos corto. Como el
  ESP32 va dentro del mismo marco, el cable son centímetros. Si alargas mucho esa
  línea y aparecen píxeles aleatorios, entonces sí lo necesitarás.
- **Diodo de protección del USB.** El diseño original llevaba un 1N5819 entre el
  raíl de 5 V y el ESP32 para que al enchufar el USB no hubiera dos fuentes
  peleándose. Se acabó quitando (ver la sección de montaje). Si lo pones, mejor;
  si no, hay una regla que cumplir.
- **Conector GX16.** Es la unión desmontable entre la caja y el marco, y está bien
  tenerla — pero **es un componente relativamente difícil de encontrar** y solo hace
  falta si quieres poder separar las dos piezas. Si vas a dejar el cable fijo, o la
  fuente va detrás del propio panel o empotrada en la pared, **suéldalo todo directo
  y te lo ahorras**. El marco tiene el taladro de todas formas; puedes dejarlo tapado
  o pasar el cable por él.
- **Pasahilos o prensaestopas.** Se pusieron para evitar tirones en la entrada de
  230 V, pero **la caja impresa de la fuente ya trae una ranura para bridar** el cable
  de alimentación y el mallado. Una brida apretada sobre la funda exterior hace el
  mismo trabajo y no cuesta nada.

---

## 4. Herramientas

| | Por qué |
|---|---|
| **Crimpadora de punteras** con trinquete | Los extremos estañados **no deben ir en borne de tornillo**: el estaño fluye bajo la presión constante, el apriete se afloja con los meses, sube la resistencia y calienta. Es el fallo clásico en un borne de 230 V |
| Soldador | GX16, placa perforada, condensadores |
| **Multímetro** | No es opcional: hay que ajustar la tensión y verificar polaridades antes de conectar los paneles |
| Impresora 3D, cama ≥ 240×240 | |
| Destornilladores finos | Los bornes de la fuente son M3 |

**Punteras necesarias:** de **0,75 mm²** para los tres hilos de 230 V y de **1 mm²**
para el lado de continua. Si el surtido no trae de 0,75, las de 1 mm² valen — el
casquillo deforma de sobra al crimpar.

> **Calibra la crimpadora antes de tocar el cable de alimentación.** Estas herramientas
> traen un tornillo de ajuste y vienen desreguladas de fábrica a menudo. Haz dos o
> tres crimpados de prueba en un recorte: el casquillo debe quedar cuadrado, con
> las indentaciones marcadas, sin grietas, y al tirar fuerte el hilo no sale.

---

## 5. Las piezas impresas

El marco son **cinco piezas** más una de prueba. Todo sale de un único archivo
parametrizado, `impresion3d/marco.scad`, donde eliges qué generar desde el
Customizer de OpenSCAD. Los STL ya exportados están en esa misma carpeta.

La geometría de la rejilla está derivada por ingeniería inversa del modelo
[*Frame Led Matrix 16x16 sound reactive* de DBMaking](https://makerworld.com/en/models/156388),
adaptada a dos paneles y rehecha como código paramétrico.

### Qué imprimir y en qué orden

| # | Pieza | Medidas | Notas |
|---|---|---|---|
| 0 | **Prueba del GX16** | pequeña | **Imprímela primero.** Cuatro taladros escalonados (15,4 / 15,8 / 16,2 / 16,6) para calibrar el tuyo antes de lanzar la caja |
| 1 | **Rejilla** (2 mitades) | 322,6 × 162,6 × 7,2 | Una celda por LED. Es lo que separa los píxeles |
| 2 | **Bandeja** (2 mitades) | 329,8 × 169,8 × 11,2 | Aloja los paneles. Lleva ventilación hexagonal en el fondo |
| 3 | **Bisel** (2 mitades) | 337 × 177 × 12 | La cara vista. Sujeta el difusor |
| 4 | **Caja - marco** | 150 × 70 × 26 | La electrónica, se atornilla al dorso de la bandeja |
| 5 | **Caja - tapa** | 3 mm de grosor | Cierra la caja por detrás |

**El difusor no se imprime**: es la lámina de metacrilato, cortada aparte a
323,2 × 163,2 mm.

### Filamentos

| Pieza | Filamento | Por qué |
|---|---|---|
| **Rejilla** | PLA **blanco** (vale un blanco efecto mármol) | Rebota la luz dentro de cada celda. Las motas del mármol no se ven tras el difusor |
| **Bisel** | PLA **silk** del color que quieras | Es la cara visible |
| **Bandeja y caja** | El que sobre | No se ven |

**PETG descartado a propósito** para el marco: la fuente va fuera, así que no hay
calor que justifique el cambio, y las paredes de 1,4 mm de la rejilla delaminan con
facilidad si el PETG no está bien puesto a punto.

### Trampas de impresión

**El bisel se imprime boca abajo**, así que la textura de la cama queda en la cara
vista. Si tienes una lámina PEI texturizada, **imprime las dos mitades en la misma
orientación** — si no, el destello cambia de dirección en la costura y la delata.

**Las costuras van desplazadas entre capas.** La de la bandeja no cae en el centro
(`desfase_bandeja = 20`), mientras que rejilla y bisel sí parten por el mitad. Es a
propósito: así cada capa hace de puente sobre la junta de las otras. El bisel es la
cara visible, y una junta descentrada ahí cantaría.

**Calibra el taladro del GX16.** Imprime primero la pieza de prueba y mira cuál de
los cuatro agujeros acepta tu conector. En el diseño quedó en **15,5 mm** — con
15,4 entraba forzado y con 15,8 bailaba. Si imprimes la caja **con soportes**, el
taladro sale más fiel que en la prueba, que va sin ellos; tenlo en cuenta al elegir.

### La caja de la fuente

Los 230 V van en una caja **aparte**, junto al enchufe. Necesitas dos cosas:

- **Una tapa de bornes** para la LRS-100-5. Sin esto, la regleta de siete bornes
  queda al aire y no deberías enchufarla. Busca en Printables o Thingiverse
  `Meanwell LRS-100 terminal cover`; hay varias y **toda la serie LRS-100 comparte
  la misma carcasa**, así que una hecha para la de 24 V vale igual.
- **Una caja** para meter la fuente entera. La usada aquí es
  [*Meanwell LRS-100-5 Case* de bloodpack](https://www.printables.com/model/183280-meanwell-lrs-100-5-case),
  que necesita **5 insertos roscados M3**. Imprímela en **PETG**: es lo único que va
  pegado a algo que se calienta. Alternativa sin imprimir: una caja de derivación de
  ferretería, 3-4 € y ya homologada.

---

## 6. ESPHome: instalación y primer flasheo

### Instalar el complemento

1. En Home Assistant: **Ajustes → Complementos → Tienda de complementos**.
2. Busca **ESPHome Device Builder** e instálalo.
3. Arráncalo y marca **"Mostrar en la barra lateral"**.

Si tu Home Assistant no admite complementos (instalación en contenedor), puedes
correr ESPHome como contenedor aparte — la
[documentación oficial](https://esphome.io/guides/installing_esphome.html) lo cubre.

### Crear el dispositivo

1. Dentro de ESPHome: **+ Nuevo dispositivo**, nómbralo `panel-led`.
2. Elige **ESP32-S3** como plataforma.
3. **Apunta la clave de cifrado que te genera.** Es la llave del dispositivo.
4. Te crea un YAML mínimo. Lo sustituirás entero más adelante.

### El primer flasheo va por cable

Solo el primero; a partir de ahí todo es por WiFi.

1. En el dispositivo, **Instalar → Conectar a este ordenador**. Se abre WebSerial,
   que **necesita un navegador basado en Chromium** (Chrome, Edge, Opera…).
2. **El ESP32-S3 casi siempre hay que ponerlo en modo bootloader a mano**: mantén
   pulsado **BOOT**, pulsa y suelta **RESET**, y luego suelta BOOT. Sin esto se queda
   en *Connecting…* para siempre.
3. Si HA corre en una máquina virtual o un contenedor, **el USB no estará ahí**:
   flashea desde el ordenador donde tengas el cable, con la opción de "conectar a
   este mismo ordenador".

> **En Linux**, si el puerto no aparece: añade tu usuario al grupo `uucp` (o
> `dialout` según la distribución) y **cierra la sesión gráfica entera**. Cerrar solo
> el navegador no basta: la sesión hereda los grupos viejos.

El chip USB de estas placas suele ser un **CH343**, que aparece como
`/dev/ttyACM0`.

---

## 7. Electrónica y cableado

> 📐 **[Diagrama visual del cableado](cableado.html)** — esquema completo con los tres
> dominios, la lista de materiales con precios y el orden de montaje. Es una página HTML
> suelta: se abre en cualquier navegador, sin conexión, y se imprime bien.

Hay **tres dominios eléctricos separados** y conviene no mezclarlos mentalmente:
los 230 V que solo existen dentro de la caja de la fuente, los 5 V de potencia, y
los datos de 3,3 V que solo existen dentro del marco.

### 230 V — solo en la caja

| Hilo | Borne |
|---|---|
| Marrón (fase) | `AC/L` |
| Azul (neutro) | `AC/N` |
| Amarillo/verde (tierra) | `⏚` / FG |

Los siete bornes van en fila: `AC/L · AC/N · ⏚ · −V · −V · +V · +V`. Comprueba la
serigrafía de tu unidad.

- **Punteras crimpadas** en los tres hilos. Nunca estañados.
- **Deja la tierra 1-2 cm más larga** que fase y neutro. Si el cable recibe un tirón
  y se sueltan los bornes, la tierra es la última en irse.
- **Antitirón**: pasa una brida por la ranura de la caja —o por una rejilla del propio
  chasis de la fuente— y apriétala sobre la **funda exterior**, antes de que se separen
  los hilos. El tirón lo debe aguantar la funda, nunca los tornillos de los bornes.
- **Corta el extremo C13** del cable reciclado y quédate con el del enchufe. Antes de
  pelar, comprueba que asoman **tres** hilos.

### 5 V — de la caja al marco

```
  LRS-100-5
 ┌──────────────────────────────────┐
 │ AC/L  AC/N   ⏚   −V   −V   +V  +V│
 └────────────────────┬─────────┬───┘
                      │         │   (el 2º −V y el 2º +V se quedan sin usar)
                   negro       rojo
                      │         │
                      │    ═╡ FUSIBLE 10 A ╞═
                      │         │
                ┌─────┴───┐ ┌───┴─────┐
                │ WAGO GND│ │ WAGO +5V│
                └─┬─────┬─┘ └─┬─────┬─┘
                  │     │     │     │
                negro negro  rojo  rojo
                  └──── al GX16 ────┘
                     (panel 1 y panel 2)
```

**Usa un solo `+V` y un solo `−V`.** Los bornes están duplicados porque la fuente
puede dar 18 A y a esa corriente un solo tornillo se queda corto. Tú vas a mover 6 A.
Y hay una razón de seguridad: **toda la corriente debe pasar por el fusible**, y eso
solo se garantiza con un único camino.

**Cada panel con su propio par.** Nunca en cadena. Los paneles traen un par de cables
pelados justo para esto, aparte de los conectores de datos. Como la inyección
independiente hacía falta igual, llevar dos pares desde la caja sale gratis y
**reparte la corriente**: cada par mueve ~3 A en vez de ~6, y la caída se queda en la
mitad. A 1 metro son 0,10 V, despreciables.

### El umbilical

> Esta sección describe el montaje **con** conector GX16. Si decides soldar el cable
> directo —perfectamente válido, ver *Lo que NO hace falta comprar*—, sáltate lo del
> prensacable y el pinout: te queda simplemente pasar los cuatro hilos por la ranura de
> la caja y soldarlos en su sitio. La malla y el marcado de pares siguen mereciendo la
> pena igual.


Si usas el GX16, su prensacable mide **6,5 mm**, y una manguera de cuatro conductores
de 1 mm² mide 8,6: no pasa. La solución son **cuatro hilos sueltos** de 1 mm² (2,50 mm cada uno),
que juntos dan un círculo envolvente de 6,04 mm y entran con holgura, metidos por
fuera en **malla trenzada** para que quede un cable redondo único.

⚠️ **La malla termina justo antes del conector**, rematada con un anillo de
termorretráctil que hace tope contra la tuerca. El último centímetro entran los
cuatro hilos pelados: el haz ya va justo en los 6,5 mm y la malla no cabe.

⚠️ **Marca el par 1** con un anillo de termorretráctil de color **en los dos
extremos, antes de meter los hilos en la malla**. Dentro todos los rojos son
idénticos, y al soldar el segundo conector necesitas saber cuál es cuál.

**Pinout usado** (el tuyo puede ser otro, pero apúntalo):

| Pin | Señal |
|---|---|
| 1 | +5 V panel 1 |
| 2 | GND panel 1 |
| 3 | GND panel 2 |
| 4 | +5 V panel 2 |

⚠️ **Suelda por el número grabado junto a cada copa, nunca por la posición.** Las
dos mitades del conector son imágenes especulares: si te guías por dónde cae el pin
visualmente, lo inviertes. **Los WS2812B no sobreviven a la polaridad invertida** —
no parpadean, se mueren los 512 en el acto.

### Datos — dentro del marco

```
ESP32 GPIO 4 ──[ 330 Ω ]──> DIN panel 1
panel 1 DOUT ────────────> DIN panel 2
```

- La resistencia, cerca del panel.
- **Trenza el hilo de datos con un hilo de masa.** No lo lleves suelto por el aire.
- **Masa común, no negociable**: fuente, ESP32 y los dos paneles comparten GND.

⚠️ **Los paneles tienen tres grupos de pads** en la cara trasera, y dos de ellos
llevan un conector idéntico de 3 pines:

| Grupo | Pads |
|---|---|
| Arriba | `5V · GND · DOUT` ← **salida** |
| Medio | `5V · GND` (cables pelados, la inyección) |
| Abajo | `5V · GND · DIN` ← **entrada** |

Si metes el cable del ESP32 en el conector de arriba en vez del de abajo, **no se
enciende absolutamente nada** y todo lo demás parece correcto. Mira la serigrafía.

Ojo también con los colores: en el mismo panel conviven dos códigos. El par pelado
de inyección va en **rojo y negro**, y el latiguillo de datos en **rojo, blanco/gris
y verde/cian**.

---

## 8. Montaje físico

**El orden importa.** Estos pasos están en este orden porque hacerlo de otra manera
obliga a deshacer.

1. **Atornilla la caja de electrónica a la bandeja.** Primero de todo: esos tornillos
   quedan **debajo de los paneles LED**, así que si colocas los paneles antes, hay
   que sacarlos.
2. **Coloca los paneles** en su alojamiento. Comprueba que los huecos de alivio de
   los pads coinciden con los conectores del dorso: los pads y conectores sobresalen
   unos 6 mm y sin ese hueco se aplastan.
3. **Rejilla, difusor y bisel**, en ese orden. El bisel se sujeta con **M3×6
   autorroscantes**, 4 por mitad: dos en el canto inferior y dos en el lateral. El
   canto superior queda limpio.
4. **Cablea por el hueco trasero**, que aún está abierto.
5. **Cierra con la tapa.**

⚠️ **Deja unos 80 mm de lazo de servicio** en los cables que van a los paneles. La
cuna de la electrónica va en la tapa, así que **al quitar la tapa sale la electrónica
con ella**. Sin ese lazo, abrir la caja significa desconectar a ciegas.

### Sobre el USB del ESP32

El diseño original llevaba un diodo Schottky (1N5819) entre el raíl de 5 V y el pin
de alimentación del ESP32: con él, el pin queda a ~4,6 V, los 5,0 V del USB ganan, y
no circula corriente hacia atrás por el puerto del ordenador.

En este montaje **se acabó quitando**, porque era una soldadura más en una placa que
queda encastrada y estaba dando falsos contactos. Si tú lo pones, mejor. Si no:

> ⚠️ **Nunca enchufes el USB con la fuente encendida.** Sin el diodo hay dos caminos
> abiertos: la fuente empujaría 5 V hacia el puerto del ordenador, y el USB intentaría
> alimentar 512 LEDs (que consumen 0,5 A solo en reposo). Para flashear o leer
> registros por USB, **desconecta antes el GX16**.

Pon una etiqueta en la tapa. Dentro de seis meses no te acordarás.

---

## 9. Puesta en marcha y calibración

**Hazlo por partes.** Si algo falla, así sabes dónde mirar.

### 1. Ajuste en vacío

Con la tapa de bornes puesta y **nada conectado a la salida**, enchufa y mide entre
`+V` y `−V`. Ajusta el potenciómetro `V-ADJ` hasta **5,05-5,10 V**. Desenchufa.

### 2. Verifica la polaridad antes de conectar los paneles

Este paso salva 512 LEDs:

- **Con la fuente desenchufada**, acopla el GX16 y pita continuidad de cada hilo
  hasta su puerto del WAGO. Y comprueba que **no hay continuidad entre rojo y negro**.
- **Enchufa con los paneles todavía sin conectar** y mide tensión en el extremo libre
  de cada par, punta roja en el hilo rojo. Tienes que leer **+5,1 V**. Si lees
  −5,1 V, está invertido.

### 3. Con los paneles conectados

Mide en la entrada de **cada** panel: debe leer ~5,1 V y no bajar. Los 512 LEDs
apagados consumen igualmente ~0,5 A de reposo, así que verás unas centésimas de
caída. Lo que no es normal es bajar de 4,8 V.

### 4. Ajuste final

Con todo montado y el panel mostrando el caso más caro (un icono de nube, que
enciende unos 90 píxeles casi blancos), mide **en la entrada de un panel**, no en la
fuente. Si baja de 4,8 V, sube el `V-ADJ` hasta que el panel lea ~5,0 V.

**Nunca pases de 5,3 V medidos en vacío**, que es el límite cómodo de los WS2812B.

### 5. El brillo

El firmware arranca con `color_correct: 45%`, y el deslizador de brillo de Home
Assistant se mueve **dentro** de ese tope. El 100 % del deslizador ya es el 45 % real.

⚠️ **Ese 45 % no es arbitrario y no conviene subirlo.** Al arrancar, el firmware
enciende los 512 LEDs en blanco pleno durante un segundo (es el mejor diagnóstico que
tiene el montaje). Eso son 512 × 60 mA = **30,7 A a escala completa**, escalados por
`color_correct`:

| `color_correct` | Pico del arranque |
|---|---|
| 45 % | 13,8 A ✅ |
| 60 % | 18,4 A ❌ **por encima de los 18 A de la fuente** |

En régimen normal el contenido pixel-art tira 5-6 A y da igual. El límite lo impone
solo ese segundo del arranque.

---

## 10. El firmware por dentro

Son **dos archivos**, los dos en `/config/esphome/`:

| Archivo | Qué lleva |
|---|---|
| `panel-led.yaml` | Configuración, entidades, lógica y las páginas |
| `panel_led_arte.h` | Iconos, fuentes y los guiones de las escenas |
| `panel_led_sprites.h` | Los dibujos de las animaciones |

**Sube siempre primero las cabeceras.** El YAML referencia símbolos que deben existir
ya, o la compilación falla con `No such file or directory`.

> **Por qué dos archivos.** Los arrays `static` declarados dentro de un *lambda* no
> son visibles desde otro. Con los dibujos dentro del YAML, la fuente de dígitos
> grandes acabó duplicada en dos páginas — y eso no es incomodidad, es una trampa: el
> día que retoques un dígito lo cambias en un sitio y no en el otro, y la hora y la
> temperatura acaban con dibujos distintos.

### Lo que tienes que cambiar

Busca las marcas `⚠️` en el YAML. Son cuatro cosas:

| Qué | Dónde |
|---|---|
| **La IP del panel** | `use_address:`. Imprescindible si HA corre en VM o contenedor: desde ahí el mDNS no llega y el dispositivo aparece como desconectado aunque funcione |
| **Tus entidades de persona** | `person.persona_1` y `person.persona_2` |
| **Tus zonas** | En la página de presencia, las cadenas `"Zona A"`, `"Zona B"`, `"Trabajo"`, `"Universidad"`. **Se comparan literalmente**: si renombras una zona en HA, hay que tocar aquí |
| **Los secretos** | Copia `secrets.yaml.ejemplo` como `secrets.yaml` y rellénalo |

### Las cuatro páginas

| Página | Contenido |
|---|---|
| **Reloj** | Cuatro dígitos de 6×11 a lo ancho, dos puntos parpadeando en los segundos pares y una barra de segundos abajo |
| **Tiempo** | Icono 16×16 a la izquierda, temperatura grande a la derecha, y abajo un hueco que rota entre nueve datos según lo que merezca la pena contar |
| **Presencia** | Un icono de 16×16 por persona. **La forma dice el tipo de sitio y el color dice cuál**: tres de las zonas son casas, y a 16 píxeles tres casas distintas no se distinguen, pero tres colores sí |
| **Animación** | No está en el selector: se dispara con un botón y se reproduce sola |

### El hueco rotatorio del tiempo

Rota **por relevancia, no en carrusel fijo**. La mayoría de estos datos valen 0 casi
todo el año, y un carrusel fijo se pasaría medio año enseñando ceros por turnos. La
lista se construye por prioridad y solo entran los primeros hasta el tope:

| # | Dato | Entra si | Símbolo |
|---|---|---|---|
| 1 | Prob. tormenta | > 0 % | rayo |
| 2 | Lluvia próxima hora | > 0 % | rayas diagonales |
| 3 | Lluvia hoy | > 0 % | rayas + barra |
| 4 | Prob. nieve | > 0 % | copo |
| 5 | Viento | racha ≥ umbral | tres rachas |
| 6 | Sensación térmica | difiere ≥ umbral | `≈` |
| 7 | Humedad | siempre | gota |
| 8 | Máxima de hoy | siempre | triángulo arriba |
| 9 | Mínima de hoy | siempre | triángulo abajo |

Un día tranquilo: humedad → máxima → mínima. Un día de tormenta: rayo → lluvia →
lluvia hoy → viento, **y la humedad desaparece**. Con una tormenta encima, la humedad
no es noticia.

Los símbolos están en `tiempo_simbolos.png`, dibujados a tamaño real.

---

## 11. Home Assistant

### El proveedor del tiempo

Este panel usa **AEMET OpenData**, que **solo cubre España**. Se instala desde
Ajustes → Dispositivos y servicios, con una clave gratuita que se pide en
[la web de AEMET](https://opendata.aemet.es/centrodedescargas/altaUsuario).

⚠️ **Los sensores `hourly forecast` vienen deshabilitados.** Hay que activarlos en
la página del dispositivo, bajo "+N entidades no mostradas". Habilitar entidades **no
añade peticiones a la API**: la integración se descarga todo el paquete en la misma
llamada y solo decide qué publica.

⚠️ **AEMET limita las peticiones con mano dura.** Si ves el error `Too many API
requests`, desactiva el sondeo automático en las opciones de la integración y
contrólalo tú con una automatización cada 15 minutos. En esta instalación estuvo
mes y medio caído sin que nadie se enterara.

**Si estás fuera de España**, sustituye la sección de sensores del YAML por los de tu
proveedor (Met.no, OpenWeatherMap, AccuWeather…). Necesitas: condición actual,
temperatura, humedad, probabilidades de lluvia/nieve/tormenta, viento medio y racha,
sensación térmica y máxima/mínima del día. Los que no tengas, quítalos de la lista de
prioridad y ya está.

### Automatizaciones

En `homeassistant/automatizaciones.yaml`. Dos cosas:

- **Aviso al cambiar de ubicación**: el panel salta a la página de presencia y
  parpadea a esa persona unos segundos. La condición de plantilla normaliza
  `not_home` y `unknown` al mismo valor, **para que los rebotes de GPS no disparen
  nada**.
- **Animación al llegar a casa** (opcional). Es el evento con más garantía de
  público: una animación que nadie ve no ha ocurrido.

### El panel de control

En `homeassistant/dashboard.yaml`. Dos pestañas: uso diario y ajustes finos.

⚠️ **Comprueba los `entity_id` antes de pegarlo.** Si asignaste el dispositivo a un
área y aceptaste el renombrado que ofrece HA, **te habrá antepuesto el área a todo**:
`switch.salon_panel_led_pantalla` en vez de `switch.panel_led_pantalla`. Es cómodo
mientras solo uses la interfaz, y una trampa en cuanto escribes algo a mano.

> **Las tarjetas van sueltas al nivel de la vista, nunca todas dentro de un
> `vertical-stack`.** Metidas en un stack se apilan en una columna sin importar el
> ancho de la pantalla; sueltas, HA las reparte solo en columnas.

---

## 12. Personalizarlo

### Cambiar un icono del tiempo

Están en `panel_led_arte.h` como matrices de 16 cadenas de 16 caracteres, una letra
por color. Editas caracteres y reinstalas. **Mantén 16 filas de 16 caracteres
exactos**: un descuadre **no da error de compilación**, simplemente dibuja mal.

### Añadir una zona a la página de presencia

Dibuja el icono en la cabecera, añade su color, y añade la rama correspondiente en el
`resolver` de la página de presencia. La cadena debe coincidir **exactamente** con el
nombre de la zona en Home Assistant.

### Animaciones nuevas

Una animación **no se guarda como fotogramas de pantalla completa** — eso almacena el
mismo personaje N veces en sitios distintos. Se guarda el **ciclo de andar** (2-3
sprites de 16×16) y una **regla de movimiento**. Así desacoplas el avance de la pose:
puedes moverte 1 píxel cada 40 ms (fluido) mientras cambias de pose cada 4 píxeles
(la estética de pocos fotogramas), y la otra dirección sale gratis espejando.

**Y no itères recompilando.** Un ciclo de compilación y subida son dos minutos; una
previsualización en GIF es instantánea. Las dos animaciones de este panel necesitaron
cuatro pasadas cada una para quedar bien.

### Sustituir los sprites de relleno

Las dos escenas vienen con dibujos genéricos, hechos para este repositorio. Para poner
los tuyos:

1. Descarga un pliego de [The Spriters Resource](https://www.spriters-resource.com/).
   **Coge siempre el PNG a escala 1:1**, nunca una versión escalada o en WebP: los rips
   tienen paletas de 14-42 colores y se convierten directamente, mientras que una
   versión comprimida con pérdida puede tener 30.000 y hay que reconstruir la rejilla
   a mano.
2. Pásalo por `herramientas/extraer_sprites.py`. Sin argumentos te lista las celdas que
   encuentra; con un nombre y coordenadas te vuelca una en el formato de la cabecera.
3. Sustituye los bloques de `firmware/panel_led_sprites.h` **manteniendo los nombres y
   las medidas**: 16 filas siempre, y los `ATAQUE` a 16, 27, 23 y 19 de ancho.

⚠️ Ten en cuenta de dónde sacas los dibujos. Los sprites de juegos comerciales siguen
protegidos por derechos de autor mucho después de que el juego desaparezca de las
tiendas, y las marcas no caducan mientras se usen. Para tu panel en tu casa es una cosa;
publicarlos es otra.

### Diseñar símbolos propios

Dos hallazgos de este proyecto, por si dibujas los tuyos en los huecos pequeños:

- **A 5 filas de alto no sobrevive nada con estructura interna.** Un termómetro (tubo
  más bulbo) se lee como un enchufe, una nube con gotas como un marciano de Space
  Invaders, un paraguas como un martillo. Usa siluetas planas o macizas.
- **Los triángulos macizos ganan a las flechas.** Una flecha necesita más alto del que
  hay para que la punta domine sobre el mástil; por debajo se lee como un signo `+`.

De nueve símbolos, cuatro fallaron en la primera pasada. Cuenta con tres iteraciones y
hazlas todas dibujando, no compilando.

---

## 13. Cuando algo falla

### El panel no enciende nada

**Primero, mira el arranque.** El firmware enciende los 512 LEDs en blanco durante un
segundo antes de que el display tome el control. **Ese fogonazo es el test decisivo**:

- **Aparece** → el camino de datos funciona. El problema es de contenido o de brillo.
- **No aparece** → o los datos no llegan (revisa `DIN` contra `DOUT`, y la resistencia)
  o el ESP32 no llega a arrancar.

### Se ven los monigotes pero no la hora ni la temperatura

El panel funciona; lo que falla es la conexión con Home Assistant. La hora viene de
HA, y los dibujos de presencia se pintan siempre haya datos o no.

### El LED del ESP32 parpadea al mover la placa

**Soldadura fría.** Resuelda antes de buscar nada más. Todas las medidas estáticas
pueden dar correctas y aun así fallar: el defecto solo aparece con movimiento.

### El dispositivo sale como no disponible en HA aunque funcione

Falta `use_address:` con la IP numérica. Si HA corre en una VM, el mDNS no llega hasta
ahí.

### Errores de compilación (ESPHome 2026.9)

| Error | Solución |
|---|---|
| `Select ... has no member named 'state'` | `Select` ya no expone `.state`. Resuelve el valor en su `set_action` y guárdalo en un *global*; el lambda lee el global. `number`, `switch`, `sensor` y `text_sensor` sí lo conservan |
| `update() is protected` | No se puede llamar desde un lambda. Usa la acción de YAML `- component.update: matriz_display` |
| `'rgb_order' is deprecated` | Cámbialo por `channel_colors` |
| Aviso sobre cifrado del OTA | Añade un `encryption:` vacío bajo `ota:`; hereda la clave de `api:` |

### Un lambda de display no dibuja nada, sin ningún error

⚠️ **Nunca uses `x` ni `y` como nombre de variable dentro de un lambda de display.**
Chocan con los parámetros que ESPHome genera para el `pixel_mapper`, y el resultado es
que **no se dibuja absolutamente nada, sin ningún error ni aviso en los registros**.
Usa `col`, `fila`, `px`, `dx`. Costó más de una hora de depuración a ciegas.

### La imagen sale girada

El `pixel_mapper` de este firmware **deshace un giro de 90°**, porque los paneles
quedaron montados girados. Si los tuyos van derechos, sustitúyelo por el mapeo simple:

```cpp
if (x % 2 == 0) { return (x * 16) + y; }
return (x * 16) + (15 - y);
```

Y si sale de cualquier otra manera, usa el test de píxel andante: hay un número
`Indice de pixel` en Home Assistant pensado justo para eso — enciendes el LED 0, el 1,
el 2… y ves dónde caen.

---

## 14. Créditos y referencias

**Geometría del marco** derivada de
[*Frame Led Matrix 16x16 sound reactive*](https://makerworld.com/en/models/156388) de
**DBMaking**. De ahí salieron las **medidas de celda** —apertura 8,6 mm, pared 1,4 mm,
profundidad 7,2 mm, borde 2,0 mm y labio de 1×1—, obtenidas midiendo el modelo
publicado. El marco de este proyecto está reescrito desde cero como código paramétrico,
es de 32×16 y añade bandeja, bisel y caja que el original no tiene.

**Sprites de las animaciones.** Los que trae este repositorio son **de relleno y
originales**. El montaje del que salió esta guía usaba sprites de juegos de NES
obtenidos en [The Spriters Resource](https://www.spriters-resource.com/), que no se
distribuyen aquí por estar protegidos por derechos de autor — el copyright de una obra
de los años ochenta sigue vigente durante décadas, y las marcas no caducan mientras se
usen. Si los usas para tu panel, ten presente que una cosa es un cacharro en tu salón y
otra publicarlos.

**Documentación de referencia:**

- [ESPHome](https://esphome.io/) — [`esp32_rmt_led_strip`](https://esphome.io/components/light/esp32_rmt_led_strip.html) · [`addressable_light` display](https://esphome.io/components/display/addressable_light.html)
- [AEMET OpenData en Home Assistant](https://www.home-assistant.io/integrations/aemet/)
- [OpenSCAD](https://openscad.org/) para editar el modelo del marco

---

## Contenido de esta carpeta

```
README.md                       presentación del proyecto
LICENSE                         MIT para el código, CC BY-SA para lo demás
docs/
  GUIA.md                       este documento
  cableado.html                 diagrama visual del cableado, se abre sin conexión
  tiempo_simbolos.png           los nueve símbolos del tiempo a tamaño real
firmware/
  panel-led.yaml                el firmware
  panel_led_arte.h              iconos, fuentes y guiones de escena
  panel_led_sprites.h           dibujos de animación (de relleno, sustituibles)
  secrets.yaml.ejemplo          plantilla de secretos
homeassistant/
  automatizaciones.yaml         avisos de ubicación y animación al llegar
  dashboard.yaml                panel de control de dos pestañas
impresion3d/
  marco.scad                    modelo paramétrico, todas las piezas
  *.stl                         piezas ya exportadas y partidas
herramientas/
  extraer_sprites.py            saca sprites de un pliego al formato de la cabecera
  simular_escena.py             monta una escena y la exporta como GIF
```
