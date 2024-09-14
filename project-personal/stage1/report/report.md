---
## Front matter
title: "Индивидуальный проект. Этап 1"
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

Установить на виртуальную машину ОС Kali Linux.

# Выполнение лабораторной работы

В задании лабораторной работы предполагается установка виртуальной машины, используя VirtualBox,
но я использую virt-manager, так как он более удобен и уже был установлен на моем хосте.
На процесс установки и выполнения дальнейших работ разница не влияет.

Сначала скачаем подготовленный диск виртуальной машины.

```bash
$ wget https://cdimage.kali.org/kali-2024.3/kali-linux-2024.3-qemu-amd64.7z
$ 7z x kali-linux-2024.3-qemu-amd64.7z
$ sudo cp kali-linux-2024.3-qemu-amd64.qcow2 /var/lib/libvirt/images/infosec-project.qcow2
```

Создать виртуальную машину можно одной командой:

```bash
$ sudo virt-install --name=infosec-project \
    --vcpus=2 \
    --memory=4096 \
    --disk /var/lib/libvirt/images/infosec-project.qcow2 \
    --osinfo detect=on,requi
```

Здесь мы создали машину `infosec-project` с 2 CPU, 4G оперативной памяти и 40G хранилища.

Запускаем графический интерфейс и логинимся как пользователь `kali` с паролем `kali`

```bash
$ virt-manager --connect qemu:///system \
    --show-domain-console infosec-project
```

```bash
$ sudo passwd
[sudo] password for kali:
New password:
Retype new password:
passwd: all authentication tokens updated sucessfully
```

# Выводы

На данном этапе проекта мы подготовили машину,
на которой будут выполняться последующие этапы.
