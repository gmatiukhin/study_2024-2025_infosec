---
## Front matter
lang: ru-RU
title: Лабораторная работа 1
subtitle: 
author:
  - Матюхин Г.В.
institute:
  - Российский университет дружбы народов, Москва, Россия
date: 07 сентября 2024

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

1. Установить на виртуальную машину ОС Rocky Linux.
2. Настроить git репозиторий для хранения отчетов

# Установка дистрибутива Rocky Linux на виртуальную машину

Создать виртуальную машину можно одной командой:

```bash
$ sudo virt-install --name=infosec \
    --vcpus=2 \
    --memory=4096 \
    --cdrom=./Downloads/Rocky-9.4-x86_64-minimal.iso \
    --disk size=40 \
    --os-variant=rocky9
```

## Настройка пармаметров виртуальной машины

1. Настраиваем язык
1. Устанавливаем пароль для пользователя root
1. Создаем пользователя gmatiukhin
1. Отключаем `kdump`
1. Устанавливаем имя хоста: `infosec.gmatiukhin.internal`
1. Выбираем необходимые программы для установки.


## Информация о системе:

1. Версия ядра Linux: 5.14
1. Частота процессора: 3393.6
1. Модель процессора: AMD Ryzen 5 2600
1. Объем доступной оперативной памяти: 4193768K
1. Тип гипервизора: KVM

# Настройка git репозитория

## Что нужно

1. Создать базовую конфигурацию для работы с git
1. Создать ключ SSH
1. Создать ключ PGP
1. Настроить подписи git
1. Зарегистрироваться на Github
1. Создать локальный каталог для выполнения заданий по предмету

## Что есть

1. ~~Создать базовую конфигурацию для работы с git~~
1. ~~Создать ключ SSH~~
1. ~~Создать ключ PGP~~
1. ~~Настроить подписи git~~
1. ~~Зарегистрироваться на Github~~
1. Создать локальный каталог для выполнения заданий по предмету

## Подготовка локального каталогоа

```bash
$ gh repo create study_2024-2025_infosec \
    --template=yamadharma/course-directory-student-template --public
$ git clone https://github.com/gmatiukhin/study_2024-2025_infosec infosec
$ rm package.json
$ echo infosec > COURSE
$ make prepare
```

# Выводы

В ходе данной лабораторной работы мы подготовили машину,
на которой будут выполняться последующие лабораторные работы.
Мы также освоили систему управления версиями git,
которую будем использвать для ведения отчетов по работам.
