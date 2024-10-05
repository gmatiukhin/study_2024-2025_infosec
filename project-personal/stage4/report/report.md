---
## Front matter
title: "Индивидуальный проект. Этап 4"
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

Использование `nikto`

# Выполнение лабораторной работы

`nikto` -- базовый сканер безопасности веб-сервера.
Он сканирует и обнаруживает уязвимости в веб-приложениях,
обычно вызванные неправильной конфигурацией на самом сервере,
файлами, установленными по умолчанию, и небезопасными файлами,
а также устаревшими серверными приложениями.

Проанализируем DVWA:

```bash
$ nikto -host localhost:4280                                                 
- Nikto v2.5.0
---------------------------------------------------------------------------
+ Target IP:          127.0.0.1
+ Target Hostname:    localhost
+ Target Port:        4280
+ Start Time:         2024-10-05 16:23:31 (GMT-4)
---------------------------------------------------------------------------
+ Server: Apache/2.4.62 (Debian)
+ /: Retrieved x-powered-by header: PHP/8.3.11.
+ /: The anti-clickjacking X-Frame-Options header is not present. See: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/X-Frame-Options
+ /: The X-Content-Type-Options header is not set. This could allow the user agent to render the content of the site in a different fashion to the MIME type. See: https://www.netsparker.com/web-vulnerability-scanner/vulnerabilities/missing-content-type-header/
+ No CGI Directories found (use '-C all' to force check all possible dirs)
+ /: Web Server returns a valid response with junk HTTP methods which may cause false positives.
+ /phpinfo.php: Output from the phpinfo() function was found.
+ /?=PHPB8B5F2A0-3C92-11d3-A3A9-4C7B08C10000: PHP reveals potentially sensitive information via certain HTTP requests that contain specific QUERY strings. See: OSVDB-12184
+ /phpinfo.php: PHP is installed, and a test script which runs phpinfo() was found. This gives a lot of system information. See: CWE-552
+ /login.php: Admin login page/section found.
+ 7851 requests: 0 error(s) and 8 item(s) reported on remote host
+ End Time:           2024-10-05 16:23:40 (GMT-4) (9 seconds)
---------------------------------------------------------------------------
+ 1 host(s) tested
```

Проанализируем более конкретный путь в DVWA:

```bash
$ nikto -host http://localhost:4280/vulnerabilities/sqli
- Nikto v2.5.0
---------------------------------------------------------------------------
+ Target IP:          127.0.0.1
+ Target Hostname:    localhost
+ Target Port:        4280
+ Start Time:         2024-10-05 16:24:12 (GMT-4)
---------------------------------------------------------------------------
+ Server: Apache/2.4.62 (Debian)
+ /vulnerabilities/sqli/: Retrieved x-powered-by header: PHP/8.3.11.
+ /vulnerabilities/sqli/: The anti-clickjacking X-Frame-Options header is not present. See: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/X-Frame-Options
+ /vulnerabilities/sqli/: The X-Content-Type-Options header is not set. This could allow the user agent to render the content of the site in a different fashion to the MIME type. See: https://www.netsparker.com/web-vulnerability-scanner/vulnerabilities/missing-content-type-header/
+ No CGI Directories found (use '-C all' to force check all possible dirs)
+ OPTIONS: Allowed HTTP Methods: POST, OPTIONS, HEAD, GET .
+ /: Web Server returns a valid response with junk HTTP methods which may cause false positives.
+ /vulnerabilities/sqli/test.php: Potential PHP MSSQL database connection string found.
+ /vulnerabilities/sqli/?=PHPB8B5F2A0-3C92-11d3-A3A9-4C7B08C10000: PHP reveals potentially sensitive information via certain HTTP requests that contain specific QUERY strings. See: OSVDB-12184
+ /vulnerabilities/sqli/test.php: This might be interesting.
+ 7851 requests: 0 error(s) and 8 item(s) reported on remote host
+ End Time:           2024-10-05 16:24:22 (GMT-4) (10 seconds)
---------------------------------------------------------------------------
+ 1 host(s) tested
```

Найденная нитересная страница:

```bash
...
/vulnerabilities/sqli/test.php: This might be interesting.
...
```

# Выводы

На данном этапе проекта я научился пользоваться `nikto` для анализа уязвимостей веб приложений.
