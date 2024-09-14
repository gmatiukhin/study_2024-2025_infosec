---
## Front matter
lang: ru-RU
title: Лабораторная работа 2
subtitle: 
author:
  - Матюхин Г.В.
institute:
  - Российский университет дружбы народов, Москва, Россия
date: 14 сентября 2024

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

Получение практических навыков работы в консоли с атрибутами файлов,
закрепление теоретических основ дискреционного разграничения доступа
в современных системах с открытым кодом на базе ОС Linux1.

# Выполнение лабораторной работы

# Доступ к файлам пользователя

## Создаем пользователя `guest`

```bash
$ useradd guest
$ passwd guest
```

## Узнаем информацию о `guest`

```bash
$ pwd
/home/guest
$ whoami
guest
$ id
uid=1001(guest) gid=1001(guest) groups=1001(guest) context=uncofined_u:uncofined_r:uncofined_t:s0-s0:c0.c1023
$ groups
guest
```

## Проверяем ту же информацию в `/etc/passwd`

```bash
$ cat /etc/passwd | grep guest
guest:x:1001:1001::/home/guest:/bin/bash
```

## Разрешения директорий

```bash
$ ls -l /home
drwx------. 2 gmatiukhin gmatiukhin 62 sep 7 22:51 gmatiukhin
drwx------. 2 guest      guest      62 sep 7 22:51 guest
```

## Исследования прав директорий и файлов

```bash
$ mkdir dir1
$ ls -l
drwxr-x-r-x. 2 guest guest 6 sep 14 22:55 dir1
$ chmod 000 dir1
$ ls -l
d----------. 2 guest guest 6 sep 14 22:55 dir1
$ echo "test" > dir1/file1
-bash: dir1/file1: Permission denied
```

# Таблицы прав файлов

Основным заданием данной лабораторной работы было изучение атрибутов файлов.
Как продукт, было необходимо заполнить две таблицы,
показывающие как права доступа к директории и файлу определяют допустимые операции над ними.

## Минимальные права для совершения операций

| Операция               | Минимальные права на директорию | Минимальные права на файл |
|------------------------|---------------------------------|---------------------------|
| Создание файла         | d-wx------                      | ----------                |
| Удаление файла         | d-wx------                      | ----------                |
| Чтение файла           | d--x------                      | -r--------                |
| Запись в файл          | d--x------                      | --w-------                |
| Переименование файла   | d-wx------                      | ----------                |
| Создание поддиректории | d-wx------                      | ----------                |
| Удаление поддиректории | d-wx------                      | ----------                |

# Выводы

В ходе данной лабораторно работы я получил практические навыки работы в консоли с атрибутами файлов,
закрепил теоретические основ дискреционного разграничения доступа
в современных системах с открытым кодом на базе ОС Linux1.
