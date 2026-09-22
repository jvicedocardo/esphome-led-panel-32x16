# Panel LED informativo 32×16

*[English](README.md) · **Español***

Panel de pared de **512 LEDs WS2812B** que muestra la hora, el tiempo y la presencia
de las personas de la casa en pixel-art, gobernado por un **ESP32-S3 con ESPHome** e
integrado con **Home Assistant**.

Todo se ajusta desde Home Assistant —brillo, horarios, colores, ritmos, umbrales—
**sin volver a compilar**.

---

## Qué hace

| Pantalla | Contenido |
|---|---|
| **Reloj** | Cuatro dígitos a toda pantalla, dos puntos parpadeando y barra de segundos |
| **Tiempo** | Icono del cielo, temperatura grande, y un hueco que rota entre nueve datos meteorológicos **según lo que merezca la pena contar** |
| **Presencia** | Un icono por persona indicando dónde está: la forma dice el tipo de sitio y el color dice cuál |
| **Animaciones** | Escenas de pixel-art que se disparan a mano o desde una automatización |

Además: avisos al cambiar alguien de ubicación, modo noche con horario configurable,
rotación automática de páginas y apagado.

## Especificaciones

| | |
|---|---|
| Resolución | 32 × 16 = 512 LEDs · paso 10 mm |
| Medidas | 337 × 177 × ~30 mm |
| Cerebro | ESP32-S3 (ESPHome) |
| Alimentación | 5 V / 18 A, fuente externa al marco |
| Consumo típico | 5-6 A (30 W) |
| Coste aproximado | 90-110 € sin contar herramientas ni filamento |

## Por dónde empezar

👉 **[Guía de construcción completa](docs/GUIA.md)** — lista de materiales con
enlaces, piezas a imprimir, cableado, montaje, calibración y resolución de problemas.

📐 **[Diagrama de cableado](https://jvicedocardo.github.io/esphome-led-panel-32x16/docs/cableado.html)** — esquema completo, lista de materiales y orden de montaje.
Se ve a través de GitHub Pages; el archivo es `docs/cableado.html` y funciona sin conexión una vez clonado.

## Qué hay aquí

```
docs/GUIA.md              la guía de construcción, de principio a fin
docs/cableado.html        diagrama visual del cableado (HTML sin conexión)
firmware/                 el YAML de ESPHome y las cabeceras de dibujos
homeassistant/            automatizaciones y panel de control
impresion3d/              modelo paramétrico en OpenSCAD y los STL
herramientas/             extractor de sprites y simulador de escenas
```

## Sobre las animaciones

Las dos escenas incluidas vienen con **sprites de relleno**, dibujos genéricos
hechos para este repositorio. Funcionan y demuestran el mecanismo, pero son
deliberadamente sencillos.

Las originales usaban sprites de juegos de NES, que **no se distribuyen aquí** por
estar protegidos por derechos de autor — el copyright de una obra de 1985 sigue
vigente durante décadas, y las marcas no caducan mientras se usen.

Si quieres usar los tuyos, en `herramientas/` está el extractor: descargas un pliego
de [The Spriters Resource](https://www.spriters-resource.com/), lo conviertes y
sustituyes los bloques de `firmware/panel_led_sprites.h`. El proceso está explicado
en la cabecera de ese archivo y en la guía.

> **Y no iteres recompilando.** En `herramientas/simular_escena.py` tienes un
> simulador que monta la escena y la exporta como GIF. Un ciclo de compilación y
> subida son dos minutos; ver el GIF es instantáneo. Las escenas de este proyecto
> necesitaron cuatro pasadas cada una.

## Lo que hace falta

- **Home Assistant** funcionando, con el complemento de ESPHome.
- **Impresora 3D** con cama de al menos 240 × 240 mm.
- Soldadura básica y estar cómodo cableando 230 V. La fuente es de bornes abiertos.
- **AEMET OpenData** para los datos meteorológicos, que **solo cubre España**. La guía
  explica qué hace falta para sustituirlo por otro proveedor.

## Decisiones de diseño que quizá te interesen

- **La fuente va fuera del marco.** Eso quita el calor y los 230 V de la pieza que
  cuelga de la pared, permite imprimirlo todo en PLA, y baja el fondo de ~50 mm a 15-20.
- **Dos pares de cable independientes**, uno por panel. La inyección separada hacía
  falta igual, así que llevar dos pares sale gratis y reparte la corriente: cada uno
  mueve 3 A en vez de 6.
- **El brillo tiene un tope por construcción.** El deslizador se mueve dentro de un
  `color_correct` del 45 %, así que ni el fogonazo del arranque puede pasarse del
  presupuesto de la fuente. El límite no vive en ningún control que se pueda mover.
- **El hueco del tiempo rota por relevancia, no en carrusel fijo.** La mayoría de esos
  datos valen 0 casi todo el año; un carrusel fijo se pasaría medio año enseñando
  ceros por turnos.
- **Las animaciones no se guardan como fotogramas** sino como un sprite más una regla
  de movimiento, lo que desacopla la fluidez del avance de la cadencia de las poses.

## Licencia

| Material | Licencia |
|---|---|
| Código (`firmware/`, `homeassistant/`, `herramientas/`) | **MIT** |
| Documentación (`docs/`, este README) | **CC BY-SA 4.0** |
| Modelo 3D (`impresion3d/`) | **CC BY-SA 4.0** |

Forks y mejoras, adelante: solo reconoce de dónde viene.

El marco está **inspirado** en un modelo de [DBMaking](https://makerworld.com/en/models/156388),
del que se tomaron medidas de celda. Está reescrito desde cero como código paramétrico,
es de 32×16 en vez de 16×16 y añade piezas que el original no tiene. El razonamiento
completo está en [LICENSE](LICENSE).

## Créditos

- Geometría del marco derivada de
  [*Frame Led Matrix 16x16 sound reactive*](https://makerworld.com/en/models/156388)
  de **DBMaking**.
- Caja de la fuente:
  [*Meanwell LRS-100-5 Case*](https://www.printables.com/model/183280-meanwell-lrs-100-5-case)
  de **bloodpack**.
