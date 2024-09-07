---
## Front matter
title: "Лабораторная работа 1"
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

1. Установить на виртуальную машину ОС Rocky Linux.
2. Настроить git репозиторий для хранения отчетов

# Выполнение лабораторной работы

## Установка дистрибутива Rocky Linux на виртуальную машину

В задании лабораторной работы предполагается установка виртуальной машины, используя VirtualBox,
но я использую virt-manager, так как он более удобен и уже был установлен на моем хосте.
На процесс установки и выполнения дальнейших работ разница не влияет.

Создать виртуальную машину можно одной командой:

```bash
$ sudo virt-install --name=infosec \
    --vcpus=2 \
    --memory=4096 \
    --cdrom=./Downloads/Rocky-9.4-x86_64-minimal.iso \
    --disk size=40 \
    --os-variant=rocky9
```
Здесь мы создали машину `infosec` с 2 CPU, 4G оперативной памяти и 40G хранилища.

Дальше в графическом интерфейсе мы настраиваем установку:

1. Настраиваем язык
1. Устанавливаем пароль для пользователя root
1. Создаем пользователя gmatiukhin
1. Отключаем `kdump`
1. Устанавливаем имя хоста: `infosec.gmatiukhin.internal`
1. Выбираем необходимые программы для установки.

После установки и запуска нам необходимо узнать следующую информацию о системе:

1. Версия ядра Linux: 5.14
1. Частота процессора: 3393.6
1. Модель процессора: AMD Ryzen 5 2600
1. Объем доступной оперативной памяти: 4193768K
1. Тип гипервизора: KVM

## Настройка git репозитория

В ходе работы нам необходимо сделать следующее:

1. Создать базовую конфигурацию для работы с git
1. Создать ключ SSH
1. Создать ключ PGP
1. Настроить подписи git
1. Зарегистрироваться на Github
1. Создать локальный каталог для выполнения заданий по предмету

Но все кроме последнего шага у меня уже сделано.

Чтобы подготивить локальный каталог необходимо:

1. Создать репозиторий удаленно

```bash
$ gh repo create study_2024-2025_infosec \
    --template=yamadharma/course-directory-student-template --public
```

2. Склонировать его на компъютер

```bash
$ git clone https://github.com/gmatiukhin/study_2024-2025_infosec infosec
```

3. Запустить скрипт для генерации директорий

```bash
$ rm package.json
$ echo infosec > COURSE
$ make prepare
```

# Контрольные вопросы

1. Какую информацию содержит учётная запись пользователя?  
    Имя, список групп
2. Укажите команды терминала и приведите примеры:
    - для получения справки по команде;  
    `man`: например `man ls`
    - для перемещения по файловой системе;  
    `cd`: например `cd /tmp`
    - для просмотра содержимого каталога;  
    `ls`: например `ls /tmp`
    - для определения объёма каталога;  
    `du`: например `du -sh /tmp`
    - для создания / удаления каталогов / файлов;  
    `touch`: например `touch /tmp/file-to-be-created`  
    `rm`: например `rm /tmp/file-to-be-deleted`
    - для задания определённых прав на файл / каталог;  
    `chmod`: например `chmod o-r`
    - для просмотра истории команд.  
    `history`
3. Что такое файловая система? Приведите примеры с краткой характеристикой.  
    Порядок, определяющий способ организации, хранения и именования данных на носителях информации в компьютерах, а также в другом электронном оборудовании.
4. Как посмотреть, какие файловые системы подмонтированы в ОС?  
    Выполнить команду `lsblk`, чтобы посмотреть на дерево устройств и разделов и увидеть, где они примонтированы, или команду `mount`, чтобы увидеть все примотнированные вещи.
5. Как удалить зависший процесс?  
    `killall <name-of-the-process>` или `kill <pid>`

# Выводы

В ходе данной лабораторной работы мы подготовили машину,
на которой будут выполняться последующие лабораторные работы.
Мы также освоили систему управления версиями git,
которую будем использвать для ведения отчетов по работам.
