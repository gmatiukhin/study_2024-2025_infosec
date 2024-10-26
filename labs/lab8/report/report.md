---
## Front matter
title: "Лабораторная работа 8"
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

Освоить на практике применение режима однократного гаммирования
на примере кодирования различных исходных текстов одним ключом.

# Выполнение лабораторной работы

## Необходимые компоненты

Для выполнения работы воспользуемся программой граммирования,
разработанной в ходе предыдущей лабораторной работы.

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

Программа принимает на вход три имени файла,
читает информацию из первых двух, XOR-ит их,
и записывает в третий файл.

Также воспользуемся скриптом, который подготовит
исходные открытые тексты, шифротексты и ключ.

```bash
#!/bin/fish

echo -n "Goodbye, TEMPLATE" > template.txt
sed 's/TEMPLATE/world/' template.txt > clear1.txt

echo -n "super secret message" > clear2.txt

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

openssl rand -base64 $len | head -c $len > key.txt

python main.py -a clear1.pad.txt -b key.txt -O cipher1.txt
printf '\n'
python main.py -a clear2.pad.txt -b key.txt -O cipher2.txt
```

Сначала этот скрипт создает:
  - файл шаболона для первого сообщения
  - открытый текст первого сообщения по шаблону
  - открытый текст второго сообщения в свободном формате

Потом приводит все эти три файла к одинаковой длинне,
добавляя знак "=" в конец коротких файлов.

Далее создается ключ такой же длинны как и файлы.

Сообщения шифруются ключем.

Итого имеем:
  - Шаблон
    - template.txt
    - template.pad.txt
  - Открытый текст 1
    - clear1.txt
    - clear1.pad.txt
  - Открытый текст 2
    - clear2.txt
    - clear2.pad.txt
  - Ключ
    - key.txt
  - Шифротекст 1
    - cipher1.txt
  - Шифротекст 2
    - cipher2.txt

Также нам понадобится хексовый редактор для работы с бинарными данными.
Я использовал `hexedit`, но подойдет любой.

## Дешифровка текста

Сначала подготовим все файлы:

```bash
$ ./prep.bash
A:  b'Goodbye, world======'
B:  b'jpJAcztyrVvK75Nl5lCr'
O:  b'-\x1f%%\x01\x03\x11UR!\x199[QsQ\x08Q~O'

A:  b'super secret message'
B:  b'jpJAcztyrVvK75Nl5lCr'
O:  b'\x19\x05:$\x11Z\x07\x1c\x11$\x13?\x17X+\x1fF\r$\x17'
```

Далее создадим комбинированный шифротекст.
Его свойства таковы, что он равен XOR-у двух открытых текстов.
Это и поможет нам дешифровать их.

```bash
$ python main.py -a cipher1.txt -b cipher2.txt -O mix.txt
A:  b'-\x1f%%\x01\x03\x11UR!\x199[QsQ\x08Q~O'
B:  b'\x19\x05:$\x11Z\x07\x1c\x11$\x13?\x17X+\x1fF\r$\x17'
O:  b'4\x1a\x1f\x01\x10Y\x16IC\x05\n\x06L\tXNN\\ZX'
```

И скомбинируем его с известным нам шаблоном:

```bash
$ python main.py -a mix.txt -b template.pad.txt -O clear2.guess1.txt
A:  b'4\x1a\x1f\x01\x10Y\x16IC\x05\n\x06L\tXNN\\ZX'
B:  b'Goodbye, TEMPLATE==='
O:  b'super secQOK\x1cE\x19\x1a\x0bage
```

Можно заметить, что мы отгадали кусочек второго сообщения.
Это потому что мы знали часть первого сообщения, так как нам был известен шаблон.

Посмотрим на его хексовое представление:

```
s  u  p  e  r     s  e  c  Q  O  K  .  E  .  .  .  a  g  e
73 75 70 65 72 20 73 65 63 51 4F 4B 1C 45 19 1A 0B 61 67 65
```

Нам известно первое слово и часть второго и третьего слов,
попробуем их угадать.

> В реальном мире мы бы использовали статистические инструменты
> чтобы узнать свойства текста, как, например,
> "frequency analysis".
> Но в целях демонстрации можем просто попробовать угадать слова.

Предположим "secret":

```
s  u  p  e  r     s  e  c  r  e  t  .  E  .  .  .  a  g  e
73 75 70 65 72 20 73 65 63 72 65 74 1C 45 19 1A 0B 61 67 65
```

Теперь это сообщение можно использовать,
чтобы узнасть информацию о втором первом сообщении.
Здесь важно, чтобы в этот файл был более верным чем шаблон,
иначе мы просто получим его обратно.

```bash
$ python main.py -a mix.txt -b clear2.guess1.txt -O clear1.guess1.txt
A:  b'4\x1a\x1f\x01\x10Y\x16IC\x05\n\x06L\tXNN\\ZX'
B:  b'super secret\x1cE\x19\x1a\x0bage'
O:  b'Goodbye, worPLATE==='
```

Тепрь мы знаем начало значения в поле `TEMPLATE`.
Повторим угадывание слова и снова повторим операцию.

Далее я покажу только результаты комбинаций,
чтобы сократить длинну текста, но логика остается такой-же.
На каждом шаге мы пытаемся получить болше информации из частичто дешифрованного файла,
чтобы потом получить еще больще информации из другого файла.
Рано или поздно мы прийдем к открытым файлам.

```bash
hexedit clear1.guess1.txt
$ python main.py -a mix.txt -b clear1.guess1.txt -O clear2.guess2.txt
A:  b'4\x1a\x1f\x01\x10Y\x16IC\x05\n\x06L\tXNN\\ZX'
B:  b'Goodbye, wordLATE==='
O:  b'super secret(E\x19\x1a\x0bage'
$ hexedit clear2.guess2.txt 
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

Вот мы получили исходное содержимое сообщений.
Можно заметить, что нами была допущенна ошибка при дешифроке.
Мы предположили "super secret massage", но мы смогли это заметить,
когда получили символ "9" в первом открытом тексте.

# Выводы

В ходе данной лабораторной работы я освоил
на практике применение режима однократного гаммирования
на примере кодирования различных исходных текстов одним ключом.
