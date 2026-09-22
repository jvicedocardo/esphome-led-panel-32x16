// =====================================================================
//  Marco para matriz LED 32x16  (2 paneles WS2812B 16x16 encadenados)
//
//  Todas las piezas en un unico archivo: elige cual generar en el
//  Customizer (Window -> Customizer). Cada pieza cabe en 240x240.
//
//  Flujo: elegir pieza -> F6 (render) -> F7 (exportar STL)
//  OJO: exportar sin pulsar F6 antes guarda la vista previa aproximada.
//
//  Unidades: mm.
// =====================================================================

/* [Que pieza generar] */
pieza = "montaje"; // [prueba_gx16:PRUEBA del taladro GX16 (imprime esto primero), rejilla_izq:Rejilla - mitad izquierda, rejilla_der:Rejilla - mitad derecha, bandeja_izq:Bandeja - mitad izquierda, bandeja_der:Bandeja - mitad derecha, bisel_izq:Bisel - mitad izquierda, bisel_der:Bisel - mitad derecha, caja_marco:Caja - marco (se atornilla a la bandeja), caja_tapa:Caja - tapa trasera, montaje:Montaje completo (solo vista F5)]

/* [Matriz LED] */
paneles      = 2;      // paneles de 16x16 encadenados en horizontal
cols_panel   = 16;     // columnas de LEDs por panel
rows         = 16;     // filas de LEDs
paso         = 10.0;   // centro a centro entre LEDs (160mm / 16)

// Separacion EXTRA entre el ultimo LED de un panel y el primero del
// siguiente. 0 = paso continuo (paneles a tope, cables por detras).
hueco_union  = 0.0;    // [0:0.1:6]

// Grosor del PANEL DE LEDS: placa + cuerpo del LED, sin contar los
// conectores JST del dorso (esos tienen su hueco, ver relieve_pads).
// NO confundir con difusor_t, que es la lamina de metacrilato.
// Define la profundidad del alojamiento, o sea que la rejilla apoye plana
// sobre los LEDs. Quedarse CORTO es lo malo: la rejilla sube y el bisel
// no cierra, porque el apilado crece. Pasarse es practicamente inocuo: un
// hueco de 0,2mm bajo una pared de 1,4mm de ancho es un canal de relacion
// 1:7 y por ahi no se cuela luz apreciable entre celdas.
// Medido 2026-08-05: el panel da 1,5-1,7mm -> se toma el extremo ALTO, asi
// el panel nunca sobresale de la repisa, la rejilla apoya siempre en ella
// y la altura del apilado depende solo de las piezas impresas.
panel_t      = 1.7;    // [1:0.1:5]

/* [Rejilla] */
pared        = 1.4;    // grosor de pared entre celdas
prof         = 7.2;    // profundidad de celda
borde        = 2.0;    // grosor del marco exterior de la rejilla
labio        = 1.0;    // rebaje del labio de entrada (en planta)
labio_h      = 1.0;    // altura del labio de entrada

/* [Bandeja] */
// 3mm para que los tornillos avellanados de la caja queden enrasados con
// el fondo del alojamiento y no levanten el panel.
suelo        = 3.0;
pared_b      = 3.3;    // grosor de pared de la bandeja
// Holguras TOTALES (se reparten a medias entre los dos lados). Sobre
// piezas de 320-330mm la contraccion del PLA ya vale varias decimas, asi
// que aqui hay que ser generoso: el desalineo maximo resultante (0,3mm
// por lado) sigue siendo despreciable frente a los 1,8mm de margen que
// deja un LED de 5mm dentro de una celda de 8,6mm.
hol_panel    = 0.6;
hol_rejilla  = 0.6;
ventilacion  = true;   // patron hexagonal de ventilacion en el fondo
venti_paso   = 25;     // [15:1:40]
venti_d      = 16;     // [8:1:30]

// Los pads y conectores JST de estos paneles estan en la CARA TRASERA y
// sobresalen ~6mm. Sin este hueco el panel no apoyaria plano y se
// aplastarian los conectores. Sirve ademas para pasar los cables al dorso.
//
// CORREGIDO 2026-08-05: la primera version puso el hueco pegado al borde
// izquierdo de cada panel, y los conectores no estan ahi. relieve_x es la
// distancia del borde izquierdo del panel al EJE del hueco.
relieve_pads = true;
relieve_x    = 35;     // [0:1:120] <-- posicion del eje del hueco
relieve_w    = 18;     // [10:1:30] ancho del hueco
relieve_m    = 20;     // [5:1:40] margen que deja arriba y abajo

/* [Bisel] */
pared_c      = 3.3;    // grosor de pared del bisel
solape       = 8.0;    // cuanto baja la falda sobre la bandeja
difusor_t    = 2.0;    // grosor del difusor (metacrilato, confirmado 2mm)
hol_difusor  = 0.4;    // [0:0.1:1.5] holgura EN FONDO del rebaje
// Holgura LATERAL: el rebaje se imprime a la medida nominal y el difusor se
// corta mas pequeño. Sin esto no entra, porque un rebaje impreso sale algo
// corto y el metacrilato dilata mas que el PLA. El echo de abajo publica la
// medida de CORTE, que es la que hace falta, no la del hueco.
hol_difusor_xy = 0.7;  // [0:0.1:2]
frente       = 2.0;    // grosor de la cara frontal visible
hol_bisel    = 0.6;    // holgura TOTAL del bisel sobre la bandeja

/* [Particion para imprimir] */
diente       = 2;      // [0:1:4]  filas por escalon de costura (0 = recta)
holgura      = 0.15;   // [0:0.05:0.5]
// Desplazamiento de la costura de la BANDEJA respecto al centro. La
// bandeja no se ve, asi que se parte fuera del eje para que haga de
// puente sobre las juntas de rejilla y bisel (y ellas sobre la suya).
// 20 y no 30: con relieve_x=35 el hueco del panel 2 va de 190,6 a 208,6 y
// una costura en 194,9 lo partiria por la mitad. Con 20 la costura cae en
// 184,9 y queda 5,7mm por debajo del hueco. Sigue dentro de la huella de la
// caja (89,9-239,9), asi que la caja la sigue puenteando y atornillando.
//
// !! Las bandejas FISICAS impresas el 2026-08-05 son la revision ANTERIOR:
// costura en 194,9 (desfase 30) y huecos en el borde del panel, corregidos
// a mano. Si algun dia hay que reimprimir, hay que reimprimir LAS DOS
// MITADES: una mitad nueva no casa con una vieja, la costura no coincide.
desfase_bandeja = 20;  // [0:5:60]

/* [Caja de electronica] */
// Va atornillada al dorso de la bandeja y aloja el ESP32-S3 y la placa
// perforada (diodo D1, R 330, condensadores). La fuente LRS-100-5 queda
// FUERA, en su propia caja; aqui solo entran los 4 hilos del GX16.
// Al ir centrada, la caja puentea la costura de la bandeja y atornilla
// las dos mitades entre si.
caja_w       = 150;    // [80:5:220]
caja_h       = 70;     // [40:5:120]
caja_z       = 26;     // [18:1:40] profundidad interior (la marca el GX16)
caja_pared   = 2.4;
caja_y0      = 25;     // altura del borde inferior de la caja sobre la bandeja
caja_m       = 7;      // retranqueo de los tornillos respecto al borde
tapa_t       = 3.0;    // [2:0.2:5] grosor de la tapa trasera. 3mm porque de
                       // ella cuelgan las bocallaves y ademas hay que
                       // avellanar la cabeza del tornillo por fuera.
// Diametro de las columnas de tornillo. Al quitar el suelo dejaron de estar
// unidas por el, asi que ahora tienen que FUNDIRSE CON LAS PAREDES ellas
// solas: hace falta columna_d >= 2*(caja_m - caja_pared) o quedan sueltas
// en el aire. Ver el ECHO de aviso.
columna_d    = 12;     // [7:0.5:18]
caja_radio   = 3;      // [0:0.5:10] redondeo de las esquinas de la caja
// Labio de la tapa: encaja dentro del marco, lo centra y disimula la junta.
tapa_labio_h   = 2.5;  // [0:0.5:6] cuanto entra
tapa_labio_t   = 2.0;  // [1:0.5:4] grosor del labio
tapa_labio_hol = 0.4;  // [0:0.1:1.2] holgura TOTAL dentro del marco

// Placa ESP32-S3 del usuario (medida 2026-08-04): 63 x 23 x 5 mm.
esp_l            = 63;     // [40:1:90]
esp_w            = 23;     // [18:0.5:40]

// Va ENZOCALADA sobre la placa perforada: perforada 1,6 + tira de pines
// hembra ~8,5 = la cara inferior del ESP32 queda a ~10mm del fondo. De
// esta cota cuelga la altura de la ranura del USB.
esp_altura_montaje = 10;   // [0:0.5:14]

// Placa perforada: es ELLA la que sujeta la cuna, no el ESP32.
pcb_l            = 70;     // [30:1:130]
pcb_w            = 30;     // [20:1:60]
pcb_h            = 1.0;

/* [Anclaje a pared] */
// Bocallaves en el fondo de la caja: se cuelga sobre dos tornillos o
// alcayatas. Deja los tornillos sobresaliendo ~6mm de la pared para que
// la cabeza pase el agujero grande y quede por detras del refuerzo.
bocallaves       = true;
bocallave_sep    = 110;    // [60:5:140] separacion entre los dos anclajes
bocallave_y      = 48;     // [20:1:60] altura dentro de la caja. El tope lo
                           // marca el labio de la tapa: ver los ECHO de aviso.
bocallave_d      = 9;      // [7:0.5:14] agujero grande (cabeza)
bocallave_w      = 4.5;    // [3:0.5:7] ranura (cana del tornillo)
bocallave_l      = 12;     // [8:1:20] recorrido de la ranura
bocallave_ref    = 2;      // refuerzo interior alrededor de cada bocallave

// CALIBRADO con la pieza prueba_gx16 (2026-08-05): 15,4 entraba forzado y
// 15,8 con holgura. 15,5 en vez de 15,6 porque la caja se va a imprimir CON
// SOPORTES y el taladro saldra algo mas fiel que en la prueba, que iba sin
// ellos: 15,5 con soporte deberia quedar donde quedo 15,4 sin el.
gx16_d       = 15.5;   // [14:0.1:18]
// Altura de la cuspide sobre el circulo. Con soportes no hace falta que
// sea agresiva: 0,8mm apenas se nota a la vista y sigue evitando que el
// techo del agujero quede en voladizo puro si algun dia se imprime sin
// ellos. (Una lagrima completa subiria 11mm y ademas la tuerca no la
// taparia.)
gx16_punta   = 0.8;    // [0:0.1:6]
// El conector se sujeta con ARANDELA + TUERCA (taladro de paso libre, no
// roscado: roscar M15x1 en PLA se pasaria a las pocas desconexiones).
// El presupuesto de rosca manda sobre el grosor de pared:
//    pared + refuerzo + arandela + tuerca  <=  gx16_rosca
// El refuerzo se recorta solo para que cuadre; ver el ECHO de aviso.
gx16_rosca    = 8.5;   // [4:0.5:15] alto de rosca util
gx16_arandela = 1.0;   // [0:0.1:3]  medida 2026-08-05
gx16_tuerca   = 3.1;   // [2:0.1:8]  medida 2026-08-05
gx16_refuerzo = 1.6;   // [0:0.2:4]  deseado; se recorta si no cabe

// Plano antigiro del casquillo (entrecaras). 0 = taladro redondo.
// DESACTIVADO A PROPOSITO: medido 14,95 entrecaras frente a 15,3 sobre
// rosca = solo 0,35mm de rebaje, del orden del error del instrumento.
// Un plano tan somero no sujeta nada y en cambio arriesga que el
// conector no entre. La tuerca ya impide el giro. Si algun dia se quiere
// activar, poner aqui el entrecaras + 0,4mm.
gx16_plano    = 0;     // [0:0.1:16]
usb_w        = 13;     // ancho de la ranura de acceso al USB
usb_h        = 8;      // alto de la ranura
tornillo_d   = 3.4;    // paso libre M3
piloto_d     = 2.5;    // pretaladro para M3 autorroscante

/* [Tornillos bisel <-> bandeja] */
// M3 autorroscantes por el canto INFERIOR y los dos LATERALES; el canto
// superior queda limpio. Atraviesan la falda del bisel (3,3mm) y roscan
// en la pared de la bandeja (3,3mm): usa M3x6, que es justo lo que hay.
// Mas largos asomarian dentro del alojamiento y tropezarian con la rejilla.
tornillos_bisel = true;
tb_fx = [0.15, 0.35, 0.65, 0.85];   // posiciones en el canto inferior
tb_fy = [0.35, 0.65];               // posiciones en los laterales

/* [Vista de montaje] */
// Separacion entre capas en la vista "montaje". 0 = montado real,
// >0 = despiece para ver como encaja todo.
explosion    = 0;      // [0:5:60]

/* [Calidad] */
$fs = 0.4;
$fa = 2;

// =====================================================================
//  Derivados
// =====================================================================
cols     = paneles * cols_panel;
apertura = paso - pared;

// Borde izquierdo de la celda i / j. El floor() inserta hueco_union en
// cada frontera entre paneles.
function xcell(i) = borde + i*paso + floor(i/cols_panel)*hueco_union;
function ycell(j) = borde + j*paso;

// Eje central de la pared que precede a la celda i / j. La costura corta
// SIEMPRE por aqui, nunca por la cara de una pared: dos caras
// coplanarias hacen que CGAL devuelva un solido no-manifold.
function xmid(i) = (xcell(i-1) + apertura + xcell(i)) / 2;
function ymid(j) = (ycell(j-1) + apertura + ycell(j)) / 2;

// --- rejilla
r_int_w = xcell(cols-1) + apertura - borde;
r_int_h = ycell(rows-1) + apertura - borde;
r_w     = r_int_w + 2*borde;
r_h     = r_int_h + 2*borde;

// --- panel fisico
p_w = paneles * cols_panel * paso + (paneles-1) * hueco_union;
p_h = rows * paso;

// --- bandeja
b_cav_w = r_w + hol_rejilla;          // aloja la rejilla
b_cav_h = r_h + hol_rejilla;
b_pan_w = p_w + hol_panel;            // aloja el panel, mas estrecho
b_pan_h = p_h + hol_panel;
b_w     = b_cav_w + 2*pared_b;
b_h     = b_cav_h + 2*pared_b;
b_z     = suelo + panel_t + prof;     // la rejilla queda enrasada arriba

// --- bisel
c_cav_w = b_w + hol_bisel;            // encaja sobre la bandeja
c_cav_h = b_h + hol_bisel;
c_w     = c_cav_w + 2*pared_c;
c_h     = c_cav_h + 2*pared_c;
// El rebaje del difusor se hace algo mas profundo que el difusor. Si van
// exactamente iguales, cualquier decima que crezca el apilado (tolerancia
// del panel, del corte del metacrilato, una primera capa gorda) impide que
// el bisel se asiente sobre el reborde de la bandeja, y eso SE VE: queda
// una ranura alrededor de todo el marco.
dif_hueco = difusor_t + hol_difusor;
c_z     = solape + dif_hueco + frente;
dif_w   = b_cav_w;                    // el difusor apoya sobre la rejilla
dif_h   = b_cav_h;

// --- caja de electronica (posicion en coordenadas de la bandeja)
cj_x0 = (b_w - caja_w) / 2;
cj_y0 = caja_y0;
cj_z  = caja_z + tapa_t;              // altura total que sobresale por detras
gx_z  = caja_z/2 - 1;                 // eje del GX16 dentro del marco

// La ranura de la bocallave no debe morder el labio de la tapa, y el
// refuerzo no debe salirse del hueco del marco o la tapa no cierra.
boc_ranura_top = bocallave_y + bocallave_l + bocallave_w/2;
boc_refuer_top = bocallave_y + bocallave_l + (bocallave_w + 7)/2;
boc_lim_labio  = caja_h - caja_pared - tapa_labio_t;
boc_lim_pared  = caja_h - caja_pared - tapa_labio_hol/2;
if (bocallaves && boc_ranura_top > boc_lim_labio)
    echo(str("*** AVISO: la ranura de la bocallave llega a ", boc_ranura_top,
             " y el labio empieza en ", boc_lim_labio, ". Baja bocallave_y. ***"));
if (bocallaves && boc_refuer_top > boc_lim_pared)
    echo(str("*** AVISO: el refuerzo de la bocallave llega a ", boc_refuer_top,
             " y la pared del marco empieza en ", boc_lim_pared,
             ". La tapa no cerrara. Baja bocallave_y. ***"));

columna_min = 2 * (caja_m - caja_pared) + 2;   // +2 = 1mm de solape por lado
if (columna_d < columna_min)
    echo(str("*** AVISO: columna_d=", columna_d, " es menor que ", columna_min,
             ". Las columnas de tornillo quedarian sueltas, sin tocar la ",
             "pared. Subela o baja caja_m. ***"));

// Los 4 tornillos que unen caja y bandeja, en coordenadas de la bandeja.
tornillos = [ for (sx = [0,1], sy = [0,1])
                [ cj_x0 + (sx ? caja_w - caja_m : caja_m),
                  cj_y0 + (sy ? caja_h - caja_m : caja_m) ] ];

// --- presupuesto de rosca del GX16
// El refuerzo se recorta solo para que arandela y tuerca quepan.
gx16_pared_max = gx16_rosca - gx16_arandela - gx16_tuerca;
gx16_ref = max(0, min(gx16_refuerzo, gx16_pared_max - caja_pared));

echo(str("GX16: pared ", caja_pared, " + refuerzo ", gx16_ref,
         " + arandela ", gx16_arandela, " + tuerca ", gx16_tuerca,
         " = ", caja_pared + gx16_ref + gx16_arandela + gx16_tuerca,
         " / rosca ", gx16_rosca));
if (gx16_pared_max < caja_pared)
    echo("*** AVISO GX16: ni la pared sola cabe en la rosca. Baja "
       , "caja_pared o comprueba gx16_rosca / tuerca / arandela ***");

// --- tornillos bisel <-> bandeja
off_cx = (c_w - b_w) / 2;             // el bisel va centrado sobre la bandeja
off_cy = (c_h - b_h) / 2;
z_tor_bisel   = frente + dif_hueco + solape/2;
z_tor_bandeja = b_z - solape/2;

nb = (diente > 0) ? floor(rows/diente) : 1;

x_corte_r = xmid(cols_panel);         // costura rejilla y bisel (centro)
x_corte_b = b_w/2 + desfase_bandeja;  // costura bandeja (desplazada)

echo(str("Rejilla  : ", r_w, " x ", r_h, " x ", prof));
echo(str("Bandeja  : ", b_w, " x ", b_h, " x ", b_z));
echo(str("Bisel    : ", c_w, " x ", c_h, " x ", c_z));
echo(str("Difusor  : CORTAR a ", dif_w - hol_difusor_xy, " x ",
         dif_h - hol_difusor_xy, " x ", difusor_t,
         "   (hueco ", dif_w, " x ", dif_h, ", NO cortar a esa medida)"));
echo(str("           solape del labio sobre el difusor: ",
         (dif_w - hol_difusor_xy - r_int_w)/2, " mm por lado"));
echo(str("Caja     : marco ", caja_w, " x ", caja_h, " x ", caja_z,
         " + tapa ", tapa_t, "  = ", cj_z, " de fondo total"));
echo(str("--- envolventes de impresion (cama 240x240) ---"));
echo(str("  rejilla_izq : ", (diente>0 ? xmid(cols_panel+1) : x_corte_r), " x ", r_h));
echo(str("  rejilla_der : ", r_w - x_corte_r, " x ", r_h));
echo(str("  bandeja_izq : ", x_corte_b, " x ", b_h));
echo(str("  bandeja_der : ", b_w - x_corte_b, " x ", b_h));
echo(str("  bisel_izq   : ", c_w/2, " x ", c_h));
echo(str("  bisel_der   : ", c_w/2, " x ", c_h));

// =====================================================================
//  Utilidad: partir una pieza por un plano X
// =====================================================================
module corte(x, lado) {
    if (lado == "izq")
        intersection() {
            children();
            translate([-500, -500, -500]) cube([500 + x - holgura/2, 1000, 1000]);
        }
    else
        difference() {
            children();
            translate([-500, -500, -500]) cube([500 + x + holgura/2, 1000, 1000]);
        }
}

// =====================================================================
//  REJILLA
// =====================================================================
module rejilla() {
    union() {
        // Marco exterior con labio de entrada de 1x1mm en la base.
        difference() {
            union() {
                translate([0, 0, labio_h]) cube([r_w, r_h, prof - labio_h]);
                translate([labio, labio, 0])
                    cube([r_w - 2*labio, r_h - 2*labio, labio_h]);
            }
            translate([borde, borde, -1]) cube([r_int_w, r_int_h, prof + 2]);
        }
        // Paredes verticales interiores
        for (i = [1 : cols-1])
            translate([xcell(i-1) + apertura, borde, 0])
                cube([xcell(i) - xcell(i-1) - apertura, r_int_h, prof]);
        // Paredes horizontales interiores
        for (j = [1 : rows-1])
            translate([borde, ycell(j-1) + apertura, 0])
                cube([r_int_w, ycell(j) - ycell(j-1) - apertura, prof]);
    }
}

// Costura escalonada: el corte salta una celda cada `diente` filas,
// siempre sobre paredes que ya existen -> opticamente invisible, y las
// dos mitades se traban contra el desplazamiento lateral. Todo el perfil
// es prismatico en Z: se imprime plano y sin soportes.
// La region desborda 10mm por izquierda/arriba/abajo para que el offset
// de holgura solo muerda en la costura, no en el perimetro exterior.
m = 10;

module region_izq_2d() {
    if (diente <= 0) {
        translate([-m, -m]) square([xmid(cols_panel) + m, r_h + 2*m]);
    } else {
        for (b = [0 : nb-1]) {
            i  = (b % 2 == 0) ? cols_panel : cols_panel + 1;
            ya = (b == 0)     ? -m        : ymid(b * diente);
            yb = (b == nb-1)  ? r_h + m   : ymid((b+1) * diente);
            translate([-m, ya]) square([xmid(i) + m, yb - ya]);
        }
    }
}

module rejilla_izq() {
    intersection() {
        rejilla();
        translate([0, 0, -1])
            linear_extrude(prof + 2) offset(delta = -holgura/2) region_izq_2d();
    }
}

module rejilla_der() {
    difference() {
        rejilla();
        translate([0, 0, -1])
            linear_extrude(prof + 2) offset(delta = holgura/2) region_izq_2d();
    }
}

// =====================================================================
//  BANDEJA
// =====================================================================
module hex(d, h) {
    rotate([0, 0, 30]) cylinder(h = h, d = d / cos(30), $fn = 6);
}

// Distancia del punto (px,py) al tornillo mas cercano. Se usa para no
// dejar un hexagono de ventilacion pisando la cabeza de un tornillo.
function d_tornillo(px, py) =
    min([ for (t = tornillos) norm([px - t[0], py - t[1]]) ]);

// True si un hexagono en px se comeria el borde de un relieve de pads.
function en_relieve(px) = relieve_pads &&
    len([ for (p = [0 : paneles-1])
          let (cx = (b_w - b_pan_w)/2 + p*(cols_panel*paso + hueco_union)
                    + relieve_x)
          if (abs(px - cx) < relieve_w/2 + venti_d/2 + 4)
              1 ]) > 0;

module patron_ventilacion() {
    nx = floor((b_pan_w - venti_d) / venti_paso);
    ny = floor((b_pan_h - venti_d) / venti_paso);
    ox = (b_w - (nx-1) * venti_paso) / 2;
    oy = (b_h - (ny-1) * venti_paso) / 2;
    for (i = [0 : nx-1], j = [0 : ny-1]) {
        px = ox + i*venti_paso;
        py = oy + j*venti_paso;
        if (d_tornillo(px, py) > venti_d/2 + 6 && !en_relieve(px))
            translate([px, py, -1]) hex(venti_d, suelo + 2);
    }
}

module bandeja() {
    difference() {
        cube([b_w, b_h, b_z]);
        // Alojamiento de la rejilla (parte alta)
        translate([pared_b, pared_b, suelo + panel_t])
            cube([b_cav_w, b_cav_h, prof + 1]);
        // Alojamiento del panel (mas estrecho: deja una repisa de apoyo)
        translate([(b_w - b_pan_w)/2, (b_h - b_pan_h)/2, suelo])
            cube([b_pan_w, b_pan_h, panel_t + 0.01]);
        // Ventilacion + aligerado del fondo
        if (ventilacion) patron_ventilacion();
        // Tornillos de la caja: avellanados por dentro para que la cabeza
        // quede enrasada y no levante el panel.
        for (t = tornillos) {
            translate([t[0], t[1], -1]) cylinder(d = tornillo_d, h = suelo + 2);
            translate([t[0], t[1], suelo - 1.8])
                cylinder(d1 = tornillo_d, d2 = tornillo_d + 3, h = 1.81);
        }
        // Paso de cables desde la caja al alojamiento del panel
        hull() for (s = [-1, 1])
            translate([b_w/2 + s*20, cj_y0 + caja_h/2, -1])
                cylinder(d = 10, h = suelo + 2);
        // Relieve para los pads / conectores JST del dorso de cada panel
        if (relieve_pads)
            for (p = [0 : paneles-1]) {
                xp = (b_w - b_pan_w)/2
                     + p * (cols_panel*paso + hueco_union);
                py0 = (b_h - b_pan_h)/2;
                hull() for (s = [0, 1])
                    translate([xp + relieve_x,
                               py0 + (s ? b_pan_h - relieve_m : relieve_m),
                               -1])
                        cylinder(d = relieve_w, h = suelo + 2);
            }
        // Pretaladros de los tornillos del bisel. Solo la pared: el
        // tornillo no debe asomar al alojamiento de la rejilla.
        if (tornillos_bisel) {
            for (fx = tb_fx)
                translate([c_w*fx - off_cx, -1, z_tor_bandeja])
                    rotate([-90, 0, 0])
                        cylinder(d = piloto_d, h = pared_b + 1);
            for (fy = tb_fy, s = [0, 1])
                translate([s ? b_w + 1 : -1, c_h*fy - off_cy, z_tor_bandeja])
                    rotate([0, s ? -90 : 90, 0])
                        cylinder(d = piloto_d, h = pared_b + 1);
        }
    }
}

module bandeja_izq() { corte(x_corte_b, "izq") bandeja(); }
module bandeja_der() { corte(x_corte_b, "der") bandeja(); }

// =====================================================================
//  CAJA DE ELECTRONICA
// =====================================================================
// Se imprime con la boca hacia ARRIBA (la pared del fondo contra la
// cama). Sin soportes.
//
// Coordenadas locales: 0..caja_w en X, 0..caja_h en Y (la pared y=0 es
// la de abajo, la que lleva el GX16), 0..cj_z en Z (z=0 = fondo, la cara
// que queda contra la pared; la boca abierta mira a la bandeja).

// Agujero horizontal imprimible sin soporte: circulo con cuspide a 45
// grados arriba, TRUNCADA a `punta` mm para que la tuerca del conector
// siga tapando todo el hueco. El techo plano que queda es estrecho y la
// impresora lo puentea sin problema.
module lagrima_y(d, largo, punta = 2, plano = 0) {
    translate([0, largo, 0]) rotate([90, 0, 0])
        linear_extrude(largo)
            intersection() {
                union() {
                    circle(d = d, $fn = 64);
                    rotate([0, 0, 45]) square([d/2, d/2]);
                }
                // trunca la cuspide
                translate([-d, -d]) square([2*d, d + d/2 + punta]);
                // plano antigiro, abajo (asi no estorba a la impresion)
                if (plano > 0)
                    translate([-d, -(plano - d/2)]) square([2*d, 3*d]);
            }
}

// La caja va en DOS piezas por una razon de orden de montaje: los tornillos
// que la unen a la bandeja quedan debajo de los paneles LED, asi que hay que
// apretarlos ANTES de colocar los paneles. Con una caja cerrada eso deja la
// electronica inaccesible para siempre. Partida en marco + tapa:
//
//   1. Se atornilla el MARCO a las dos mitades de bandeja (4 M3 desde dentro
//      de la bandeja, avellanados). Esto ademas une las dos mitades.
//   2. Se montan paneles, rejilla, difusor y bisel. El marco sigue abierto
//      por detras.
//   3. Se cablea y suelda con via libre por ese hueco.
//   4. Se cierra con la TAPA (4 M3 a las mismas columnas, por el otro lado).
//
// Para mantenimiento basta quitar la tapa: no hay que desmontar el panel.
//
// Coordenadas locales del marco: z=0 es el lado de la TAPA (el que queda
// contra la pared) y z=caja_z el lado de la BANDEJA. Se imprime con z=0
// contra la cama, que es lo que deja la lagrima del GX16 con la cuspide
// hacia arriba.

// Perfil rectangular con esquinas redondeadas.
module rect_r(w, h, r) {
    if (r > 0) translate([r, r]) offset(r = r) square([w - 2*r, h - 2*r]);
    else square([w, h]);
}

module caja_marco() {
    ri = max(caja_radio - caja_pared, 0);       // radio interior
    difference() {
        // El recorte contra la envolvente no es cosmetico: el refuerzo del
        // GX16 (Ø24,5 centrado a gx_z) asomaria por la cara de la tapa e
        // impediria que asentase plana.
        intersection() {
            linear_extrude(caja_z) rect_r(caja_w, caja_h, caja_radio);
            union() {
                // Paredes, abiertas por los dos extremos
                linear_extrude(caja_z)
                    difference() {
                        rect_r(caja_w, caja_h, caja_radio);
                        translate([caja_pared, caja_pared])
                            rect_r(caja_w - 2*caja_pared, caja_h - 2*caja_pared, ri);
                    }
                // Columnas de esquina. Sirven a la vez para los tornillos de
                // la bandeja (por z=caja_z) y para los de la tapa (por z=0):
                // 9mm de rosca por extremo y 8mm macizos en medio. Su
                // diametro esta calculado para que se fundan con las dos
                // paredes del rincon: sin suelo, es lo unico que las sujeta.
                for (t = tornillos)
                    translate([t[0] - cj_x0, t[1] - cj_y0, 0])
                        cylinder(d = columna_d, h = caja_z);
                // Refuerzo alrededor del GX16: ahi tira el cable cada vez
                // que se conecta y desconecta.
                translate([caja_w/2, caja_pared, gx_z]) rotate([-90, 0, 0])
                    cylinder(d = gx16_d + 9, h = gx16_ref);
            }
        }
        // Pretaladros hacia la BANDEJA
        for (t = tornillos)
            translate([t[0] - cj_x0, t[1] - cj_y0, caja_z - 9])
                cylinder(d = piloto_d, h = 10);
        // Pretaladros hacia la TAPA
        for (t = tornillos)
            translate([t[0] - cj_x0, t[1] - cj_y0, -1])
                cylinder(d = piloto_d, h = 10);
        // Conector GX16 en la pared inferior, apuntando hacia abajo
        translate([caja_w/2, -1, gx_z])
            lagrima_y(gx16_d, caja_pared + gx16_ref + 2, gx16_punta, gx16_plano);
        // Acceso al USB. La cota se mide desde la cara interior de la tapa,
        // que es donde apoya la placa perforada.
        translate([-1, caja_h/2 - usb_w/2, esp_altura_montaje + 0.5])
            cube([caja_pared + 2, usb_w, usb_h]);
        // Entrada de cables por el reborde del lado bandeja, en los dos
        // laterales. Los hilos del panel 1 salen por un hexagono del fondo
        // de la bandeja, recorren su dorso y entran por aqui.
        for (s = [0, 1])
            translate([s ? caja_w - caja_pared - 1 : -1, caja_h/2 - 6,
                       caja_z - 7])
                cube([caja_pared + 2, 12, 8]);
        // Ventilacion en la pared SUPERIOR: la tapa queda contra la pared y
        // ahi no circula aire.
        for (i = [-4 : 4])
            translate([caja_w/2 + i*15 - 2.5, caja_h - caja_pared - 1, 4])
                cube([5, caja_pared + 2, caja_z - 10]);
    }
}

// Labio de registro de la tapa. Es un anillo que entra en el hueco del
// marco, menos las cosas del marco que invaden ese hueco: las columnas de
// tornillo y el refuerzo del GX16. Restarlas explicitamente en vez de
// dibujar tramos a mano hace que siga encajando si se cambian esas cotas.
module tapa_labio() {
    ri = max(caja_radio - caja_pared, 0);
    difference() {
        linear_extrude(tapa_labio_h)
            difference() {
                offset(delta = -tapa_labio_hol/2)
                    translate([caja_pared, caja_pared])
                        rect_r(caja_w - 2*caja_pared, caja_h - 2*caja_pared, ri);
                translate([caja_pared + tapa_labio_t, caja_pared + tapa_labio_t])
                    rect_r(caja_w - 2*(caja_pared + tapa_labio_t),
                           caja_h - 2*(caja_pared + tapa_labio_t),
                           max(ri - tapa_labio_t, 0));
            }
        for (t = tornillos)
            translate([t[0] - cj_x0, t[1] - cj_y0, -1])
                cylinder(d = columna_d + 0.8, h = tapa_labio_h + 2);
        translate([caja_w/2, caja_pared - 1, gx_z]) rotate([-90, 0, 0])
            cylinder(d = gx16_d + 9 + 0.8, h = gx16_ref + 2);
    }
}

// Todo lo que sobresale de la tapa hacia el marco, con origen en z=0.
module tapa_relieve() {
    if (tapa_labio_h > 0) tapa_labio();
    // Cuna de la placa perforada: cuatro topes en sus esquinas.
    for (sx = [0,1], sy = [0,1])
        translate([caja_w/2 + (sx ? pcb_l/2 : -pcb_l/2),
                   caja_h/2 + (sy ? pcb_w/2 : -pcb_w/2), 0])
            cylinder(d = 5, h = pcb_h + 4);
    // Refuerzo interior de las bocallaves: de ahi cuelga todo el conjunto.
    if (bocallaves)
        for (s = [-1, 1])
            translate([caja_w/2 + s*bocallave_sep/2, bocallave_y, 0])
                hull() {
                    cylinder(d = bocallave_d + 7, h = bocallave_ref);
                    translate([0, bocallave_l, 0])
                        cylinder(d = bocallave_w + 7, h = bocallave_ref);
                }
}

// La tapa lleva la cuna de la placa perforada y las bocallaves. Al quitarla
// sale con ella toda la electronica, asi que hay que dejar lazo de servicio
// en los cables que van a los paneles (unos 80mm sobran).
// Se imprime plana, con la cara exterior contra la cama.
module caja_tapa() {
    h_rel = max(tapa_labio_h, pcb_h + 4, bocallave_ref) + 1;
    difference() {
        union() {
            linear_extrude(tapa_t) rect_r(caja_w, caja_h, caja_radio);
            // TODO lo que sobresale se recorta al hueco del marco. Sin este
            // recorte el refuerzo de las bocallaves invade la pared del
            // marco y la tapa no llega a cerrar: en la caja de una pieza no
            // se notaba porque pared y refuerzo eran el mismo solido.
            translate([0, 0, tapa_t])
                intersection() {
                    linear_extrude(h_rel)
                        offset(delta = -tapa_labio_hol/2)
                            translate([caja_pared, caja_pared])
                                rect_r(caja_w - 2*caja_pared,
                                       caja_h - 2*caja_pared,
                                       max(caja_radio - caja_pared, 0));
                    tapa_relieve();
                }
        }
        // Bocallaves: agujero grande abajo y ranura hacia ARRIBA. Se cuelga
        // metiendo la cabeza por el circulo y dejando caer el marco.
        if (bocallaves)
            for (s = [-1, 1])
                translate([caja_w/2 + s*bocallave_sep/2, bocallave_y, -1])
                    linear_extrude(tapa_t + bocallave_ref + 2)
                        union() {
                            circle(d = bocallave_d, $fn = 48);
                            hull() {
                                circle(d = bocallave_w, $fn = 32);
                                translate([0, bocallave_l])
                                    circle(d = bocallave_w, $fn = 32);
                            }
                        }
        // Tornillos a las columnas del marco, avellanados por FUERA: esa
        // cara apoya contra la pared y tiene que quedar lisa.
        for (t = tornillos) {
            translate([t[0] - cj_x0, t[1] - cj_y0, -1])
                cylinder(d = tornillo_d, h = tapa_t + tapa_labio_h + 2);
            translate([t[0] - cj_x0, t[1] - cj_y0, -0.01])
                cylinder(d1 = tornillo_d + 3, d2 = tornillo_d, h = 1.81);
        }
    }
}

// =====================================================================
//  PIEZA DE PRUEBA DEL GX16
// =====================================================================
// Cuatro taladros escalonados en un trozo de pared del MISMO grosor y en
// la MISMA orientacion de impresion que la caja (pared vertical, agujero
// horizontal). Eso importa: un agujero horizontal sale mas estrecho que
// uno vertical, asi que probarlo tumbado no valdria.
// Se imprime en 10 minutos: pruebas cual pasa la rosca y ese numero lo
// pones en gx16_d antes de lanzar la caja.
// Las muescas de la base cuentan de izquierda a derecha: 1, 2, 3, 4.
module prueba_gx16() {
    ds     = [gx16_d - 0.4, gx16_d, gx16_d + 0.4, gx16_d + 0.8];
    paso_p = gx16_d + 7;
    ancho  = len(ds) * paso_p + 10;
    fondo  = 22;
    base_h = 3;
    r_max  = max(ds) / 2;
    alto   = base_h + 3 + 2*r_max + gx16_punta + 4;

    echo(str("PRUEBA GX16 -> diametros: ", ds));
    difference() {
        union() {
            cube([ancho, fondo, base_h]);
            translate([0, fondo - caja_pared, 0])
                cube([ancho, caja_pared, alto]);
        }
        for (i = [0 : len(ds)-1]) {
            cx = 5 + paso_p * (i + 0.5);
            translate([cx, fondo - caja_pared - 1, base_h + 3 + ds[i]/2])
                lagrima_y(ds[i], caja_pared + 2, gx16_punta, gx16_plano);
            // Muescas identificativas: tantas como el numero de taladro
            for (k = [0 : i])
                translate([cx - (i*3)/2 + k*3 - 0.75, 3, base_h - 1])
                    cube([1.5, 5, 2]);
        }
    }
}

// =====================================================================
//  BISEL
// =====================================================================
// Impreso boca abajo (cara frontal contra la cama): cada escalon es mas
// ancho que el anterior segun sube, asi que no hay un solo voladizo.
module bisel() {
    difference() {
        cube([c_w, c_h, c_z]);
        // Ventana frontal (deja ver el interior de todas las celdas)
        translate([(c_w - r_int_w)/2, (c_h - r_int_h)/2, -1])
            cube([r_int_w, r_int_h, frente + 1]);
        // Rebaje del difusor (algo mas profundo que el difusor, ver dif_hueco)
        translate([(c_w - dif_w)/2, (c_h - dif_h)/2, frente])
            cube([dif_w, dif_h, dif_hueco]);
        // Falda que encaja sobre la bandeja
        translate([(c_w - c_cav_w)/2, (c_h - c_cav_h)/2, frente + dif_hueco])
            cube([c_cav_w, c_cav_h, solape + 1]);
        // Taladros de paso de los tornillos
        if (tornillos_bisel) {
            for (fx = tb_fx)
                translate([c_w*fx, -1, z_tor_bisel]) rotate([-90, 0, 0])
                    cylinder(d = tornillo_d, h = pared_c + 2);
            for (fy = tb_fy, s = [0, 1])
                translate([s ? c_w + 1 : -1, c_h*fy, z_tor_bisel])
                    rotate([0, s ? -90 : 90, 0])
                        cylinder(d = tornillo_d, h = pared_c + 2);
        }
    }
}

module bisel_izq() { corte(c_w/2, "izq") bisel(); }
module bisel_der() { corte(c_w/2, "der") bisel(); }

// =====================================================================
//  Vista de montaje (solo F5 - el render CGAL completo es lento)
// =====================================================================
module montaje() {
    e = explosion;
    // Bandeja
    color("DimGray") bandeja();
    // Panel LED (bloque representativo)
    color("ForestGreen")
        translate([(b_w - p_w)/2, (b_h - p_h)/2, suelo + e])
            cube([p_w, p_h, panel_t]);
    // Rejilla
    color("WhiteSmoke")
        translate([(b_w - r_w)/2, (b_h - r_h)/2, suelo + panel_t + 2*e]) rejilla();
    // Difusor
    color("LightSkyBlue", 0.45)
        translate([(b_w - dif_w)/2, (b_h - dif_h)/2, b_z + 3*e])
            cube([dif_w, dif_h, difusor_t]);
    // Bisel, invertido y encajado por arriba
    color("#303030")
        translate([(b_w - c_w)/2, (b_h - c_h)/2, b_z + dif_hueco + frente + 4*e])
            rotate([180, 0, 0]) translate([0, -c_h, 0]) bisel();
    // Caja de electronica: marco atornillado al dorso, y tapa detras
    color("SteelBlue")
        translate([cj_x0, cj_y0, -e])
            rotate([180, 0, 0]) translate([0, -caja_h, -caja_z]) caja_marco();
    color("LightSteelBlue")
        translate([cj_x0, cj_y0, -caja_z - 2*e])
            rotate([180, 0, 0]) translate([0, -caja_h, -tapa_t]) caja_tapa();
}

// =====================================================================
//  Salida
// =====================================================================
if      (pieza == "rejilla_izq") rejilla_izq();
else if (pieza == "rejilla_der") translate([-(x_corte_r + holgura/2), 0, 0]) rejilla_der();
else if (pieza == "bandeja_izq") bandeja_izq();
else if (pieza == "bandeja_der") translate([-(x_corte_b + holgura/2), 0, 0]) bandeja_der();
else if (pieza == "bisel_izq")   bisel_izq();
else if (pieza == "bisel_der")   translate([-(c_w/2 + holgura/2), 0, 0]) bisel_der();
else if (pieza == "caja_marco")  caja_marco();
else if (pieza == "caja_tapa")   caja_tapa();
else if (pieza == "prueba_gx16") prueba_gx16();
else                             montaje();
