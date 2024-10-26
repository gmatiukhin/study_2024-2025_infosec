---
## Front matter
lang: ru-RU
title: Лабораторная работа 8
subtitle: 
author:
  - Матюхин Г.В.
institute:
  - Российский университет дружбы народов, Москва, Россия
date: 26 октября 2024

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

Освоить на практике применение режима однократного гаммирования
на примере кодирования различных исходных текстов одним ключом.

# Выполнение лабораторной работы

# Необходимые компоненты

## Программа граммирования

```python
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

## Скрипт создания файлов 1/3

```bash
#!/bin/fish

echo -n "Goodbye, TEMPLATE" > template.txt
sed 's/TEMPLATE/world/' template.txt > clear1.txt

echo -n "super secret message" > clear2.txt
```

## Скрипт создания файлов 2/3

```bash
set -l len (string length (bat clear1.txt))
set -l len1 (string length (bat clear2.txt))
set -l len2 (string length (bat template.txt))
if test $len1 -ge $len
  set len $len1
end
if test $len2 -ge $len
  set len $len2
end
string pad -r -c '=' -w $len (bat template.txt) | tr -d '\n' > template.pad.txt
string pad -r -c '=' -w $len (bat clear1.txt) | tr -d '\n' > clear1.pad.txt
string pad -r -c '=' -w $len (bat clear2.txt) | tr -d '\n' > clear2.pad.txt
```

## Скрипт создания файлов 3/3

```bash
openssl rand -base64 $len | head -c $len > key.txt

python main.py -a clear1.pad.txt -b key.txt -O cipher1.txt
printf '\n'
python main.py -a clear2.pad.txt -b key.txt -O cipher2.txt
```

# Дешифровка текста

## Сначала подготовим все файлы:

```bash
$ ./prep.bash
A:  b'Goodbye, world======'
B:  b'jpJAcztyrVvK75Nl5lCr'
O:  b'-\x1f%%\x01\x03\x11UR!\x199[QsQ\x08Q~O'

A:  b'super secret message'
B:  b'jpJAcztyrVvK75Nl5lCr'
O:  b'\x19\x05:$\x11Z\x07\x1c\x11$\x13?\x17X+\x1fF\r$\x17'
```

## Создадим комбинированный шифротекст.

```bash
$ python main.py -a cipher1.txt -b cipher2.txt -O mix.txt
A:  b'-\x1f%%\x01\x03\x11UR!\x199[QsQ\x08Q~O'
B:  b'\x19\x05:$\x11Z\x07\x1c\x11$\x13?\x17X+\x1fF\r$\x17'
O:  b'4\x1a\x1f\x01\x10Y\x16IC\x05\n\x06L\tXNN\\ZX'
```

## Скомбинируем его с известным нам шаблоном:

```bash
$ python main.py -a mix.txt -b template.pad.txt -O clear2.guess1.txt
A:  b'4\x1a\x1f\x01\x10Y\x16IC\x05\n\x06L\tXNN\\ZX'
B:  b'Goodbye, TEMPLATE==='
O:  b'super secQOK\x1cE\x19\x1a\x0bage
```

## Угадаем слово

```
s  u  p  e  r     s  e  c  Q  O  K  .  E  .  .  .  a  g  e
73 75 70 65 72 20 73 65 63 51 4F 4B 1C 45 19 1A 0B 61 67 65
```

```
s  u  p  e  r     s  e  c  r  e  t  .  E  .  .  .  a  g  e
73 75 70 65 72 20 73 65 63 72 65 74 1C 45 19 1A 0B 61 67 65
```

## Получим частично дешифрованное первое сообщение

```bash
$ python main.py -a mix.txt -b clear2.guess1.txt -O clear1.guess1.txt
A:  b'4\x1a\x1f\x01\x10Y\x16IC\x05\n\x06L\tXNN\\ZX'
B:  b'super secret\x1cE\x19\x1a\x0bage'
O:  b'Goodbye, worPLATE==='
```

## Повторим 1/2

```bash
hexedit clear1.guess1.txt
$ python main.py -a mix.txt -b clear1.guess1.txt -O clear2.guess2.txt
A:  b'4\x1a\x1f\x01\x10Y\x16IC\x05\n\x06L\tXNN\\ZX'
B:  b'Goodbye, wordLATE==='
O:  b'super secret(E\x19\x1a\x0bage'
$ hexedit clear2.guess2.txt 
```

## Повторим 2/2

```bash
$ python main.py -a mix.txt -b clear2.guess2.txt -O clear1.guess2.txt
A:  b'4\x1a\x1f\x01\x10Y\x16IC\x05\n\x06L\tXNN\\ZX'
B:  b'super secret massage'
O:  b'Goodbye, world9====='
$ hexedit clear1.guess2.txt 
$ python main.py -a mix.txt -b clear1.guess2.txt -O clear2.guess3.txt
A:  b'4\x1a\x1f\x01\x10Y\x16IC\x05\n\x06L\tXNN\\ZX'
B:  b'Goodbye, world======'
O:  b'super secret message'
```

# Выводы

В ходе данной лабораторной работы я освоил
на практике применение режима однократного гаммирования
на примере кодирования различных исходных текстов одним ключом.
