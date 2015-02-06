#!/bin/bash
rm *.c
lex calc_4_59.l
yacc calc_4_59.y
cc y.tab.c -ly -ll -o calc_4_59
