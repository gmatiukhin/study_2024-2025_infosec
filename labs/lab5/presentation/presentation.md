---
## Front matter
lang: ru-RU
title: Лабораторная работа 4
subtitle: 
author:
  - Матюхин Г.В.
institute:
  - Российский университет дружбы народов, Москва, Россия
date: 5 октября 2024

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

Изучение механизмов изменения идентификаторов, применения SetUID- и Sticky-битов.
Получение практических навыков работы в консоли с дополнительными атрибутами.
Рассмотрение работы механизма смены идентификатора процессов пользователей,
а также влияние бита Sticky на запись и удаление файлов.

# Выполнение лабораторной работы

# Подготовка

Нам нужно будет скомпилировать программы на C, поэтому устновим `gcc`;

```bash
$ yum install gcc
```

Уберем пользователя `guest2` из группы `guest`.
Он бул добавлен туда в предыдущей лабораторной работе, но это помешает выполнению текущей.

# Узнаем фактический uid и gid

Напишем следующую программу.

```c
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

## Скомпилируем ее и запустим как `guest`:

```bash
$ gcc simpleid.c -o simpleid
$ ./simpleid
e_uid=1001, e_gid=1001
uid=1001, gid=1001
```

## Сравним вывод с `id`.

```bash
$ id
uid=1001(guest) gid=1001(guest) groups=1001(guest) context=uncofined_u:uncofined_r:uncofined_t:s0-s0:c0.c1023
```

## Как `root` изменим владельца и установим setuid:

```bash
$ chown root:guest /home/guest/simpleid
$ chmod u+s /home/guest/simpleid
```

## Запустим программу опять как `guest`:

```bash
$ ./simpleid
e_uid=0, e_gid=1001
uid=1001, gid=1001
```

# Используем SetUid для чтения файлов без полномочий

## Напишем следующую программу для чтения файлов.

```c
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

## Создадим файл, который может читать только `root`.

```bash
$ echo "secret" > /home/guest/test.txt
$ chown root:root /home/guest/test.txt
$ chmod 700 /home/guest/test.txt
```

## Скомпилируем программу:

```bash
$ gcc readfile.c -o readfile
```

## Как `root` установим setuid аттрибут:

```bash
$ chown root:guest /home/guest/reafile
$ chmod u+s /home/guest/readfile
```

## Как пользователь `guest` попробуем прочесть содержимое файла:

```bash
$ ./readfile test.txt
secret
```

## Исследуем Sticky-бит

## От имени пользователя guest создайте файл file01.txt в директории /tmp
со словом test:
```bash
$ echo "test" > /tmp/file01.txt
$ chmod o+rw /tmp/file01.txt
```

## От пользователя guest2 (не являющегося владельцем) попробуйте прочитать файл /tmp/file01.txt:
```bash
$ cat /tmp/file01.txt
test
```

## Изменения файла

```bash
$ echo "test2" > /tmp/file01.txt
$ cat /tmp/file01.txt
test
test2
$ echo "test3" > /tmp/file01.txt
$ cat /tmp/file01.txt
test3
```

## Удаление файла
```bash
$ rm /tmp/fileOl.txt
```

## Уберем sticky-бит

```bash
$ chmod -t /tmp
```
Теперь мы можем удалить файл.

# Выводы

Я изучил механизмы изменения идентификаторов, применения SetUID- и Sticky-битов.
Получил практические навыки работы в консоли с дополнительными атрибутами.
Рассмотрел работу механизма смены идентификатора процессов пользователей,
а также влияние бита Sticky на запись и удаление файлов.
