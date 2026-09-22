#pragma once
// =====================================================================
//  panel_led_sprites.h — SPRITES DE RELLENO
//
//  Estos son dibujos genéricos hechos para este repositorio, para que el
//  firmware compile y las animaciones se puedan ver funcionando nada más
//  clonarlo. Son deliberadamente sencillos: su trabajo es demostrar el
//  mecanismo, no ser bonitos.
//
//  Las animaciones originales usaban sprites de juegos de NES, que NO se
//  distribuyen aquí por estar protegidos por derechos de autor. Si quieres
//  usar los tuyos:
//
//    1. Descarga un pliego de https://www.spriters-resource.com/
//       Coge SIEMPRE el PNG a escala 1:1, nunca una versión escalada o en
//       WebP: los rips tienen paletas de 14-42 colores y se convierten
//       directamente.
//    2. Extráelos con herramientas/extraer_sprites.py
//    3. Sustituye los bloques de este archivo manteniendo los nombres y
//       las medidas (16 filas; los ATAQUE van a 16, 27, 23 y 19 de ancho).
//
//  Letras de color: V/O/P = héroe · R/B = bicho (intercambiables por
//  paleta, ver MOB_PAL) · M/C/D = personaje 2 · G/g/d = verdes del tubo.
// =====================================================================

#include <cstdint>

static const char* HEROE_A[16] = {
  "......PPPP......",
  "......PPPP......",
  ".....PPPPPP.....",
  ".....PP..PP.....",
  ".....PPPPPP.....",
  "......PPPP......",
  "....VVVVVVVV....",
  "...VVVVVVVVVV...",
  "...VV.VVVV.VV...",
  "...VV.VVVV.VV...",
  "......VVVV......",
  "......VVVV......",
  ".....OO..OO.....",
  ".....OO..OO.....",
  "....OOO..OOO....",
  "................" };

static const char* HEROE_B[16] = {
  "................",
  "......PPPP......",
  ".....PPPPPP.....",
  ".....PP..PP.....",
  ".....PPPPPP.....",
  "......PPPP......",
  "....VVVVVVVV....",
  "...VVVVVVVVVV...",
  "...VV.VVVV.VV...",
  "...VV.VVVV.VV...",
  "......VVVV......",
  "....OOO..OOO....",
  "...OOO....OOO...",
  "...OO......OO...",
  "..OOO......OOO..",
  "................" };

static const char* BICHO_A[16] = {
  "................",
  "................",
  "....RRRRRRRR....",
  "...RRRRRRRRRR...",
  "..RRBBRRRRBBRR..",
  "..RRBBRRRRBBRR..",
  "..RRRRRRRRRRRR..",
  "..RRRRRRRRRRRR..",
  "..RRRRRRRRRRRR..",
  "..RRRRRRRRRRRR..",
  "...RRRRRRRRRR...",
  "....RRRRRRRR....",
  "....RR....RR....",
  "....RR....RR....",
  "...RRR....RRR...",
  "................" };

static const char* BICHO_B[16] = {
  "................",
  "....RRRRRRRR....",
  "...RRRRRRRRRR...",
  "..RRBBRRRRBBRR..",
  "..RRBBRRRRBBRR..",
  "..RRRRRRRRRRRR..",
  "..RRRRRRRRRRRR..",
  "..RRRRRRRRRRRR..",
  "..RRRRRRRRRRRR..",
  "...RRRRRRRRRR...",
  "....RRRRRRRR....",
  "...RRR....RRR...",
  "...RR......RR...",
  "..RRR......RRR..",
  "..RR........RR..",
  "................" };

static const char* ATAQUE1[16] = {
  "......PPPP......",
  "......PPPP......",
  ".....PPPPPP.....",
  ".....PP..PP.....",
  ".....PPPPPP.....",
  "......PPPP......",
  "....VVVVVVVV....",
  "...VVVVVVVVVV...",
  "...VV.VVVV.VV...",
  "...VV.VVVV.VV...",
  "......VVVV......",
  "......VVVV......",
  ".....OO..OO.....",
  ".....OO..OO.....",
  "....OOO..OOO....",
  "................" };

static const char* ATAQUE2[16] = {
  "......PPPP.................",
  "......PPPP.................",
  ".....PPPPPP................",
  ".....PP..PP................",
  ".....PPPPPP................",
  "......PPPP.................",
  "....VVVVVVVV...............",
  "...VVVVVVVVVV..............",
  "...VV.VVVV.VV...OOOOOOOOOOO",
  "...VV.VVVV.VV...OOOOOOOOOOO",
  "......VVVV.................",
  "......VVVV.................",
  ".....OO..OO................",
  ".....OO..OO................",
  "....OOO..OOO...............",
  "..........................." };

static const char* ATAQUE3[16] = {
  "......PPPP.............",
  "......PPPP.............",
  ".....PPPPPP............",
  ".....PP..PP............",
  ".....PPPPPP............",
  "......PPPP.............",
  "....VVVVVVVV...........",
  "...VVVVVVVVVV..........",
  "...VV.VVVV.VV...OOOOOOO",
  "...VV.VVVV.VV...OOOOOOO",
  "......VVVV.............",
  "......VVVV.............",
  ".....OO..OO............",
  ".....OO..OO............",
  "....OOO..OOO...........",
  "......................." };

static const char* ATAQUE4[16] = {
  "......PPPP.........",
  "......PPPP.........",
  ".....PPPPPP........",
  ".....PP..PP........",
  ".....PPPPPP........",
  "......PPPP.........",
  "....VVVVVVVV.......",
  "...VVVVVVVVVV......",
  "...VV.VVVV.VV...OOO",
  "...VV.VVVV.VV...OOO",
  "......VVVV.........",
  "......VVVV.........",
  ".....OO..OO........",
  ".....OO..OO........",
  "....OOO..OOO.......",
  "..................." };

static const char* QUIETO[16] = {
  "................",
  "......MMMM......",
  ".....MMMMMM.....",
  ".....MM..MM.....",
  ".....MMMMMM.....",
  "......CCCC......",
  "....CCCCCCCC....",
  "...CCCCCCCCCC...",
  "...CC.CCCC.CC...",
  "...CC.CCCC.CC...",
  "......CCCC......",
  "......CCCC......",
  ".....DD..DD.....",
  ".....DD..DD.....",
  "....DDD..DDD....",
  "................" };

static const char* PASO_A[16] = {
  "................",
  "......MMMM......",
  ".....MMMMMM.....",
  ".....MM..MM.....",
  ".....MMMMMM.....",
  "......CCCC......",
  "....CCCCCCCC....",
  "...CCCCCCCCCC...",
  "...CC.CCCC.CC...",
  "...CC.CCCC.CC...",
  "......CCCC......",
  "......CCCC......",
  ".....DD..DD.....",
  ".....DD..DD.....",
  "....DDD..DDD....",
  "................" };

static const char* PASO_B[16] = {
  "................",
  "......MMMM......",
  ".....MMMMMM.....",
  ".....MM..MM.....",
  ".....MMMMMM.....",
  "......CCCC......",
  "....CCCCCCCC....",
  "...CCCCCCCCCC...",
  "...CC.CCCC.CC...",
  "...CC.CCCC.CC...",
  "......CCCC......",
  "....DDD..DDD....",
  "...DDD....DDD...",
  "...DD......DD...",
  "..DDD......DDD..",
  "................" };

static const char* PASO_C[16] = {
  "................",
  "......MMMM......",
  ".....MMMMMM.....",
  ".....MM..MM.....",
  ".....MMMMMM.....",
  "......CCCC......",
  "....CCCCCCCC....",
  "...CCCCCCCCCC...",
  "...CC.CCCC.CC...",
  "...CC.CCCC.CC...",
  "......CCCC......",
  "...DDD....DDD...",
  "..DDD......DDD..",
  "..DD........DD..",
  ".DDD........DDD.",
  "................" };

static const char* TUBO[16] = {
  "dddddddddddddddd",
  "dgggggggggggggd.",
  "dgggggggggggggd.",
  "dGGGGGGGGGGGGGd.",
  "dgggggggggggggd.",
  "dgggggggggggggd.",
  "dGGGGGGGGGGGGGd.",
  "dgggggggggggggd.",
  "dgggggggggggggd.",
  "dGGGGGGGGGGGGGd.",
  "dGGGGGGGGGGGGGd.",
  "dGGGGGGGGGGGGGd.",
  "dGgGgGgGgGgGgGd.",
  "dGgGgGgGgGgGgGd.",
  "dgggggggggggggd.",
  "dddddddddddddddd" };

static const char* const* ATAQUE[4]   = { ATAQUE1, ATAQUE2, ATAQUE3, ATAQUE4 };
static const uint8_t      ATAQUE_AN[4] = { 16, 27, 23, 19 };
static const char* const* PASOS[3]     = { PASO_A, PASO_B, PASO_C };

// Paleta del bicho: la normal y cuatro destellos para el golpe. Orden R, P, B.
static const uint8_t MOB_PAL[5][3][3] = {
  {{216, 40,  0},{252,152, 56},{252,252,252}},   // normal
  {{  0,  0,168},{ 92,148,252},{252,252,252}},
  {{  0,  0,  0},{  0,128,136},{216, 40,  0}},   // el negro hace que parpadee a trozos
  {{  0,168,  0},{252,216,168},{ 32, 56,236}},
  {{128,208, 16},{252,152, 56},{200, 76, 12}},
};
