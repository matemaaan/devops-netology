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
10. /sbin/init 
11. sse4_2
12. ssh -t localhost 'tty'
13. reptyr -T <PID>
14. tee читает из input в output и файл. Работает потому что запущена из под рут и 