### 1.  
> Опишите своими словами основные преимущества применения на практике IaaC паттернов.  

Быстро и удобно разворачивается. 
> Какой из принципов IaaC является основополагающим?  

Идентичность разворачиваемой инфраструктуры.  

### 2.  
> Чем Ansible выгодно отличается от других систем управление конфигурациями?  

Низкий порог вхождения, не требуется устанавливать агента.
> Какой, на ваш взгляд, метод работы систем конфигурации более надёжный push или pull?  

Более надежный pull, т.к. сразу проверяется доступность удаленной машины при подключении к клиенту.   
  
### 3.  
Установить на личный компьютер:  
> VirtualBox  

user@ubuntu:~$ vboxmanage --version  
6.1.32_Ubuntur149290  
> Vagrant  

user@ubuntu:~$ vagrant --version  
Vagrant 2.2.19  
> Ansible  

user@ubuntu:~$ ansible --version  
ansible 2.10.8  
  config file = None  
  configured module search path = ['/home/user/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']  
  ansible python module location = /usr/lib/python3/dist-packages/ansible  
  executable location = /usr/bin/ansible  
  python version = 3.10.4 (main, Apr  2 2022, 09:04:19) [GCC 11.2.0]  
  
