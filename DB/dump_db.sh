#!/bin/bash
# Есть проблемы с правами на последовательности (авто-инкрементные ID) в оригинальной базе, поэтому я скопировал
# только метаданные, а данные извлёк с помощью \copy другим скриптом.
pg_dump -c --schema-only -E utf-8 -F custom -n case10 -O -v -x -h 84.201.134.129 -p 5432 -U skillfactory -W skillfactory > case10.dump
