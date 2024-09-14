---
## Front matter
lang: ru-RU
title: Индивидуальный проект. Этап 1
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
slide_level: 3
aspectratio: 169
section-titles: true
theme: metropolis
header-includes:
 - \metroset{progressbar=frametitle,sectionpage=progressbar,numbering=fraction}
---

# Цель работы

Установить на виртуальную машину ОС Kali Linux.

# Выполнение лабораторной работы

## Сначала скачаем подготовленный диск виртуальной машины.

```bash
$ wget https://cdimage.kali.org/kali-2024.3/kali-linux-2024.3-qemu-amd64.7z
$ 7z x kali-linux-2024.3-qemu-amd64.7z
$ sudo cp kali-linux-2024.3-qemu-amd64.qcow2 /var/lib/libvirt/images/infosec-project.qcow2
```

## Создать виртуальную машину можно одной командой:

```bash
$ sudo virt-install --name=infosec-project \
    --vcpus=2 \
    --memory=4096 \
    --disk /var/lib/libvirt/images/infosec-project.qcow2 \
    --osinfo detect=on,requi
$ virt-manager --connect qemu:///system \
    --show-domain-console infosec-project
```

## Ставим пароль для `root`

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
