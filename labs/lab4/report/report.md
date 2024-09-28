---
## Front matter
title: "Лабораторная работа 4"
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

Получение практических навыков работы в консоли с расширенными атрибутами файлов.

# Выполнение лабораторной работы

1. От имени пользователя guest определите расширенные атрибуты файла
`/home/guest/dir1/file1` командой
```bash
lsattr /home/guest/dir1/file1
```

В ответ получаем:
```bash
$ lsattr file1
---------------------- file1
```

2. Установите командой
```bash
chmod 600 file1
```
на файл `file1` права, разрешающие чтение и запись для владельца файла.

```bash
$ ls -l file1
-rw-------. 1 guest guest 4 Sep 28 21:24 file1
```

3. Попробуйте установить на файл `/home/guest/dir1/file1` расширенный атрибут a от имени пользователя guest:
```bash
chattr +a /home/guest/dir1/file1
```
Этого сделать мы не можем: `chattr: Operation not permitted while setting flags on file1`
Нужно пробовать как `root`.

4. Зайдите на третью консоль с правами администратора либо повысьте
свои права с помощью команды `su`. Попробуйте установить
расширенный атрибут a на файл `/home/guest/dir1/file1` от имени суперпользователя:
```bash
chattr +a /home/guest/dir1/file1
```
Теперь это получается.

5. От пользователя guest проверьте правильность установления атрибута:
```bash
lsattr /home/guest/dir1/file1
```
Да, атрибут установлен верно.
```bash
$ lsattr file1
-----a---------------- file1
```

6. Выполните дозапись в файл `file1` слова "test" командой
```bash
echo "test" >> /home/guest/dir1/file1
```
После этого выполните чтение файла `file1` командой
```bash
cat /home/guest/dir1/file1
```
Убедитесь, что слово "test" было успешно записано в `file1`.

Да, параметр `a` позволяет дозаписывать в файлы.
```bash
$ cat file1
test
```

7. Попробуйте удалить файл `file1` либо стереть имеющуюся в нём информацию командой
```bash
echo "abcd" > /home/guest/dirl/file1
```
Попробуйте переименовать файл.

Этого мы не можем сделать. `-bash: file1: Operation not permitted`

8. Попробуйте с помощью команды
```bash
chmod 000 file1
```
установить на файл `file1` права, например, запрещающие чтение и запись для владельца файла.

Это тоже нельзя.

9. Снимите расширенный атрибут a с файла `/home/guest/dirl/file1` от
имени суперпользователя командой
```bash
chattr -a /home/guest/dir1/file1
```
Повторите операции, которые вам ранее не удавалось выполнить.

Теперь мы можем перезаписывать файл, переименовывать файл,
и устанавливать на нем права, потому что атрибут `a` больше не мешает нам.

10. Повторите ваши действия по шагам, заменив атрибут `a` атрибутом `i`.

С установленным атрибутом `i` мы не можем ничего сделать с файлом кроме чтения.
Этот атрибут делает файл немутабельным (immutable), что запрещает всякие изменения.

# Выводы

В ходе данной лабораторной работы я получил практические навыки работы в консоли с расширенными атрибутами файлов.
