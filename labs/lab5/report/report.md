---
## Front matter
title: "Лабораторная работа 5"
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

Изучение механизмов изменения идентификаторов, применения SetUID- и Sticky-битов.
Получение практических навыков работы в консоли с дополнительными атрибутами.
Рассмотрение работы механизма смены идентификатора процессов пользователей,
а также влияние бита Sticky на запись и удаление файлов.

# Выполнение лабораторной работы

## Подготовка

Нам нужно будет скомпилировать программы на C, поэтому устновим `gcc`;

```bash
$ yum install gcc
```

Уберем пользователя `guest2` из группы `guest`.
Он бул добавлен туда в предыдущей лабораторной работе, но это помешает выполнению текущей.

## Узнаем фактический uid и gid

Напишем следующую программу.

```c
#include <sys/types.h>
#include <unistd.h>
#include <stdio.h>

int main () {
    uid_t real_uid = getuid();
    uid_t e_uid = geteuid();
    gid_t real_gid = getgid();
    gid_t e_gid = getegid() ;
    printf("e_uid=%d, e_gid=%d\n", e_uid, e_gid);
    printf("real_uid=%d, real_gid=%d\n", real_uid, real_gid);
    return 0;
}
```

Скомпилируем ее и запустим как `guest`:

```bash
$ gcc simpleid.c -o simpleid
$ ./simpleid
e_uid=1001, e_gid=1001
uid=1001, gid=1001
```

Сравним вывод с `id`.

```bash
$ id
uid=1001(guest) gid=1001(guest) groups=1001(guest) context=uncofined_u:uncofined_r:uncofined_t:s0-s0:c0.c1023
```

Как `root` изменим владельца и установим setuid:

```bash
$ chown root:guest /home/guest/simpleid
$ chmod u+s /home/guest/simpleid
```

Запустим программу опять как `guest`:

```bash
$ ./simpleid
e_uid=0, e_gid=1001
uid=1001, gid=1001
```

Видим id пользователя `root`.

## Используем SetUid для чтения файлов без полномочий

Напишем следующую программу для чтения файлов.

```c
#include <fcntl.h>
#include <stdio.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>
int main (int argc, char* argv[]) {
    unsigned char buffer[16];
    size_t bytes_read;
    int i;
    int fd = open (argv[1], O_RDONLY);
    do {
        bytes_read = read(fd, buffer, sizeof (buffer));
        for (i =0; i < bytes_read; ++i) printf("%c", buffer[i]);
    } while(bytes_read == sizeof (buffer));
    close(fd);
    return 0;
}
```

Создадим файл, который может читать только `root`.

```bash
$ echo "secret" > /home/guest/test.txt
$ chown root:root /home/guest/test.txt
$ chmod 700 /home/guest/test.txt
```

Скомпилируем программу:

```bash
$ gcc readfile.c -o readfile
```

Как `root` установим setuid аттрибут:

```bash
$ chown root:guest /home/guest/reafile
$ chmod u+s /home/guest/readfile
```

Как пользователь `guest` попробуем прочесть содержимое файла:

```bash
$ ./readfile test.txt
secret
```

Это работает, потому что программа запускается с фактическими правами `root`.

## Исследуем Sticky-бит

1. Выясните, установлен ли атрибут Sticky на директории /tmp, для чего выполните команду
```bash
$ ls -l / | grep tmp
```

2. От имени пользователя guest создайте файл file01.txt в директории /tmp
со словом test:
```bash
$ echo "test" > /tmp/file01.txt
```

3. Просмотрите атрибуты у только что созданного файла и разрешите
чтение и запись для категории пользователей "все остальные":
```bash
$ chmod o+rw /tmp/file01.txt
```
4. От пользователя guest2 (не являющегося владельцем) попробуйте прочитать файл /tmp/file01.txt:
```bash
$ cat /tmp/file01.txt
test
```

5. От пользователя guest2 попробуйте дозаписать в файл
/tmp/file01.txt слово test2 командой
```bash
$ echo "test2" > /tmp/file01.txt
```
Удалось ли вам выполнить операцию? -- Да

6. Проверьте содержимое файла командой
```bash
$ cat /tmp/file01.txt
test
test2
```

7. От пользователя guest2 попробуйте записать в файл /tmp/file01.txt
слово test3, стерев при этом всю имеющуюся в файле информацию ко мандой
```bash
$ echo "test3" > /tmp/file01.txt
```
Удалось ли вам выполнить операцию? Да

8. Проверьте содержимое файла командой
```bash
$ cat /tmp/file01.txt
test3
```

9. От пользователя guest2 попробуйте удалить файл /tmp/file01.txt ко мандой
```bash
$ rm /tmp/fileOl.txt
```
Удалось ли вам удалить файл? Нет Sticky-бит предотвращает это.

10. Повысьте свои права до суперпользователя и выполните после этого команду,
снимающую атрибут t (Sticky-бит) с директории /tmp:
```bash
$ chmod -t /tmp
```

11. Покиньте режим суперпользователя
12. От пользователя guest2 проверьте, что атрибута t у директории /tmp
нет:
```bash
$ ls -l / | grep tmp
```
13. Повторите предыдущие шаги. Какие наблюдаются изменения? Теперь мы можем удалить файл.

# Выводы

Я изучил механизмы изменения идентификаторов, применения SetUID- и Sticky-битов.
Получил практические навыки работы в консоли с дополнительными атрибутами.
Рассмотрел работу механизма смены идентификатора процессов пользователей,
а также влияние бита Sticky на запись и удаление файлов.
