Лекция 1
1. установил VBox
2. установил Vagrant взяв установщик с git https://github.com/hashicorp/vagrant-installers/releases/tag/v2.2.19.dev%2Bmain
3. подготовил cmd
4. vagrant init сделано
vagrant up не выполняется без vpn (что очень неприятно, т.к. не все смогут выполнить задание и вероятно стоит пересмотреть курс в текущие ситуации)
vagrant suspend сделано
5. оперативной памяти - 1024Гб (по умолчанию), процессор - 2, видеопамять - 4Мб, носитель - 64Гб, сеть - NAT (по умолчанию), общая папка.
6. v.memory = ??? v.cpus = ???
7. выполнено
8. HISTFILESIZE 1104 строка
ignoreboth - не записывает команду, которая начинается с пробела, либо дублирующая предыдущую
9. в 1541 строке, для указания массива параметров
10. touch f{1..100000}, больше 137867 не получится создать из-за проверки на максимальное кол-во параметров
11. проверяет на существование каталога, вернет 0 (истину) так как каталог "/tmp" существует
12. mkdir /tmp/newDir
cp /bin/bash /tmp/newDir/bash
export PATH="/tmp/newDir/:$PATH"
13. batch является псевдонимом 'at -b'
14. vagrant halt только для остановки
или vagrant destroy для остановки и удаления

Лекция 2
1. cd is a shell builtin
2. grep <some_string> <some_file> -c
3. systemd
4. ls /tmp 2 > /dev/pts/2
5. cat < 1.txt > 2.txt
6. Получится через перенаправление на эмулятор терминала ctrl+alt+f1...f6
7. создаст дескриптор fd/5 и перенаправит в stdout
выведет netology на экран, т.к. вывод echo перенаправлен в fd/5, который перенаправлен в stdout
8. ll ./ 55>&2 2>&1 1>&55
9. выведет переменные окружения. При помощи env.
10. /proc/<PID>/cmdline
  содержит полную командную строку запуска процесса
/proc/<PID>/exe
  символьная ссылка, содержащая фактическое полное имя выполняемого файла
11. sse4_2
12. ssh -t localhost 'tty'
13. reptyr -T <PID>
14. tee читает из input в output и файл. Работает потому что запущена из под рут и 

Лекция 3
1. chdir("/tmp")
2. openat(AT_FDCWD, "/usr/share/misc/magic.mgc", O_RDONLY) = 3
3. echo '' > /proc/<PID>/fd/3
4. нет, остается только запись в таблице процессов
5.vagrant@vagrant:~$ sudo /usr/sbin/opensnoop-bpfcc
PID    COMM               FD ERR PATH
856    vminfo              6   0 /var/run/utmp
621    dbus-daemon        -1   2 /usr/local/share/dbus-1/system-services
621    dbus-daemon        20   0 /usr/share/dbus-1/system-services
621    dbus-daemon        -1   2 /lib/dbus-1/system-services
621    dbus-daemon        20   0 /var/lib/snapd/dbus-1/system-services/
629    irqbalance          6   0 /proc/interrupts
629    irqbalance          6   0 /proc/stat
629    irqbalance          6   0 /proc/irq/20/smp_affinity
629    irqbalance          6   0 /proc/irq/0/smp_affinity
629    irqbalance          6   0 /proc/irq/1/smp_affinity
629    irqbalance          6   0 /proc/irq/8/smp_affinity
629    irqbalance          6   0 /proc/irq/12/smp_affinity
629    irqbalance          6   0 /proc/irq/14/smp_affinity
629    irqbalance          6   0 /proc/irq/15/smp_affinity
6. Part of the utsname information is also accessible via /proc/sys/kernel/{ostype, hostname, osrelease, version, domainname}.
7. при ; команды будут запущены последовательно в любом случае. При && команды будут запущены последовательно, только при успешном выполнении предыдущей команды.
8. set -euxo pipefail
-e - прекращает выполнение скрипта если команда завершилась ошибкой, выводит в stderr строку с ошибкой
-u - прекращает выполнение скрипта, если встретилась несуществующая переменная
-x - выводит выполняемые команды в stdout перед выполненинем
-o pipefail - прекращает выполнение скрипта, даже если одна из частей пайпа завершилась ошибкой
Хорошо использовать потому что происходит автоматическая обработка ошибок.
9. Ss - процесс, ожидающий завершения
R+ - процесс выполняется
