---
## Front matter
lang: ru-RU
title: Индивидуальный проект. Этап 4
subtitle: 
author:
  - Матюхин Г.В.
institute:
  - Российский университет дружбы народов, Москва, Россия
date: 28 сентября 2024

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

Использование `nikto`

# Выполнение лабораторной работы

`nikto` -- базовый сканер безопасности веб-сервера.
Он сканирует и обнаруживает уязвимости в веб-приложениях,
обычно вызванные неправильной конфигурацией на самом сервере,
файлами, установленными по умолчанию, и небезопасными файлами,
а также устаревшими серверными приложениями.

## Проанализируем DVWA:

```bash
$ nikto -host localhost:4280                                                 
```

```bash
+ /phpinfo.php: PHP is installed, and a test script which runs phpinfo() was found. This gives a lot of system information. See: CWE-552
+ /login.php: Admin login page/section found.
```

## Проанализируем более конкретный путь в DVWA:

```bash
$ nikto -host http://localhost:4280/vulnerabilities/sqli
```

```bash
+ /vulnerabilities/sqli/test.php: This might be interesting.
```

# Выводы

На данном этапе проекта я научился пользоваться `nikto` для анализа уязвимостей веб приложений.
