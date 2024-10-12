---
## Front matter
title: "Лабораторная работа 7"
subtitle: ""
author: "Матюхин Григорий Васильевич"

## Generic otions
lang: ru-RU
toc-title: "Содержание"

## Bibliography
bibliography: bib/cite.bib
csl: pandoc/csl/gost-r-7-0-5-2008-numeric.csl

## Pdf output format
toc: true # Table of contents
toc-depth: 2
lof: true # List of figures
lot: true # List of tables
fontsize: 12pt
linestretch: 1.5
papersize: a4
documentclass: scrreprt
## I18n polyglossia
polyglossia-lang:
  name: russian
  options:
	- spelling=modern
	- babelshorthands=true
polyglossia-otherlangs:
  name: english
## I18n babel
babel-lang: russian
babel-otherlangs: english
## Fonts
mainfont: IBM Plex Serif
romanfont: IBM Plex Serif
sansfont: IBM Plex Sans
monofont: IBM Plex Mono
mathfont: STIX Two Math
mainfontoptions: Ligatures=Common,Ligatures=TeX,Scale=0.94
romanfontoptions: Ligatures=Common,Ligatures=TeX,Scale=0.94
sansfontoptions: Ligatures=Common,Ligatures=TeX,Scale=MatchLowercase,Scale=0.94
monofontoptions: Scale=MatchLowercase,Scale=0.94,FakeStretch=0.9
mathfontoptions:
## Biblatex
biblatex: true
biblio-style: "gost-numeric"
biblatexoptions:
  - parentracker=true
  - backend=biber
  - hyperref=auto
  - language=auto
  - autolang=other*
  - citestyle=gost-numeric
## Pandoc-crossref LaTeX customization
figureTitle: "Рис."
tableTitle: "Таблица"
listingTitle: "Листинг"
lofTitle: "Список иллюстраций"
lotTitle: "Список таблиц"
lolTitle: "Листинги"
## Misc options
indent: true
header-includes:
  - \usepackage{indentfirst}
  - \usepackage{float} # keep figures where there are in the text
  - \floatplacement{figure}{H} # keep figures where there are in the text
---

# Цель работы

Освоить на практике применение режима однократного гаммирования.

# Выполнение лабораторной работы

Требуется разработать приложение,
позволяющее шифровать и дешифровать данные в режиме однократного гаммирования.

Приложение должно:
1. Определить вид шифротекста при известном ключе и известном открытом тексте.
2. Определить ключ, с помощью которого шифротекст может быть преобразован в некоторый фрагмент текста,
представляющий собой один из возможных вариантов прочтения открытого текста.

## Код приложения

```python
import argparse

parser = argparse.ArgumentParser(prog="Cipher")
parser.add_argument("--bytefile_a", "-a", required=True)
parser.add_argument("--bytefile_b", "-b", required=True)
parser.add_argument("--out", "-O", required=True)


args = parser.parse_args()


def read_file_bytes(fname):
    with open(fname, "rb") as f:
        return f.read()


a = read_file_bytes(args.bytefile_a)
b = read_file_bytes(args.bytefile_b)

if len(a) != len(b):
    print(f"Lengths of A ({len(a)}) and B ({len(b)}) are not the same.")
    exit(1)

print("A: ", a)
print("B: ", b)

a_int = int.from_bytes(a)
b_int = int.from_bytes(b)

o_int = a_int ^ b_int

o = o_int.to_bytes(len(a))

print("O: ", o)

with open(args.out, "wb") as f:
    f.write(o)
```

В нем мы читаем байты данных из файлов и пишем в файлы,
потому что вводить байты в консоли не удобно.

## Тестирование

### Шифрование и дешифорование данных

```bash
$ echo -n "hello world" > clear.txt
$ echo -n "asfsafasfsa" > key.txt
$ python main.py -a clear.txt -b key.txt -O cipher.txt
A:  b'hello world'
B:  b'asfsafasfsa'
O:  b'\t\x16\n\x1f\x0eF\x16\x1c\x14\x1f\x05'
```

```bash
$ python main.py -a cipher.txt -b key.txt -O clear1.txt
A:  b'\t\x16\n\x1f\x0eF\x16\x1c\x14\x1f\x05'
B:  b'asfsafasfsa'
O:  b'hello world'
```

### Определение ключа, для декодирования в другой открытый текст

```bash
$ echo -n "byeee world" > wrong-clear.txt
$ python main.py -a cipher.txt -b wrong-clear.txt -O wrong-key.txt
A:  b'\t\x16\n\x1f\x0eF\x16\x1c\x14\x1f\x05'
B:  b'byeee world'
O:  b'koozkfasfsa'
```

# Выводы

В ходе данной лабораторной работы я освоил на практике применение режима однократного гаммирования.
