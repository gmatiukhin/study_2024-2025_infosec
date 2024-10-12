---
## Front matter
lang: ru-RU
title: Лабораторная работа 7
subtitle: 
author:
  - Матюхин Г.В.
institute:
  - Российский университет дружбы народов, Москва, Россия
date: 12 октября 2024

## i18n babel
babel-lang: russian
babel-otherlangs: english

## Formatting pdf
toc: false
toc-title: Содержание
slide_level: 2
aspectratio: 169
section-titles: true
theme: metropolis
header-includes:
 - \metroset{progressbar=frametitle,sectionpage=progressbar,numbering=fraction}
---

# Цель работы

Освоить на практике применение режима однократного гаммирования.

# Выполнение лабораторной работы

## Требования

Требуется разработать приложение,
позволяющее шифровать и дешифровать данные в режиме однократного гаммирования.

Приложение должно:
1. Определить вид шифротекста при известном ключе и известном открытом тексте.
2. Определить ключ, с помощью которого шифротекст может быть преобразован в некоторый фрагмент текста,
представляющий собой один из возможных вариантов прочтения открытого текста.

# Код приложения

## Обработка аргументов

```python
import argparse

parser = argparse.ArgumentParser(prog="Cipher")
parser.add_argument("--bytefile_a", "-a", required=True)
parser.add_argument("--bytefile_b", "-b", required=True)
parser.add_argument("--out", "-O", required=True)


args = parser.parse_args()
```

## Граммирование

```python
def read_file_bytes(fname):
    with open(fname, "rb") as f:
        return f.read()
a = read_file_bytes(args.bytefile_a)
b = read_file_bytes(args.bytefile_b)
if len(a) != len(b):
    exit(1)
a_int = int.from_bytes(a)
b_int = int.from_bytes(b)
o_int = a_int ^ b_int
o = o_int.to_bytes(len(a))
with open(args.out, "wb") as f:
    f.write(o)
```

# Тестирование

## Шифрование данных

```bash
$ echo -n "hello world" > clear.txt
$ echo -n "asfsafasfsa" > key.txt
$ python main.py -a clear.txt -b key.txt -O cipher.txt
A:  b'hello world'
B:  b'asfsafasfsa'
O:  b'\t\x16\n\x1f\x0eF\x16\x1c\x14\x1f\x05'
```

## Дешифорование данных

```bash
$ python main.py -a cipher.txt -b key.txt -O clear1.txt
A:  b'\t\x16\n\x1f\x0eF\x16\x1c\x14\x1f\x05'
B:  b'asfsafasfsa'
O:  b'hello world'
```

## Определение ключа, для декодирования в другой открытый текст

```bash
$ echo -n "byeee world" > clear.txt
$ python main.py -a cipher.txt -b wrong-clear.txt -O wrong-key.txt
A:  b'\t\x16\n\x1f\x0eF\x16\x1c\x14\x1f\x05'
B:  b'byeee world'
O:  b'koozkfasfsa'
```

# Выводы

В ходе данной лабораторной работы я освоил на практике применение режима однократного гаммирования.
