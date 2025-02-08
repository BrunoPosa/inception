# Inception
hive school project

## Introduction

This project enhances system administration skills using Docker. Multiple Docker images will be virtualized within a VM.

### Guidelines

* The project must be completed in a Virtual Machine.
* All configuration files should be placed in srcs/.
* A Makefile must set up the application via docker-compose.yml.

### Required Services

1. NGINX (TLSv1.2/1.3 only).
2. WordPress + PHP-FPM (configured, no NGINX).
3. MariaDB (without NGINX).
4. Volumes for WordPress database and files.
5. Docker Network to link services.

### Constraints

* Containers must auto-restart on failure.
* network: host, --link, and links: cannot be used.
* Infinite loops (tail -f, bash, sleep infinity) must be avoided.
* The WordPress admin username must not contain admin or administrator.
* Volumes must be stored in /home/<login>/data/.
* The domain <login>.42.fr must point to the local IP.
* NGINX must be the sole entry point via port 443, using TLSv1.2/1.3.

## Instructions step-by-step

### Virtual machine

#### Instalation of virtual machine

1. Instalation of VirtualBox: https://www.virtualbox.org/. It is needed for instalinsling the operating system we want to use.

2. Download Alpine Linux: https://dl-cdn.alpinelinux.org/alpine/v3.20/releases/x86_64/. Download alpine-virt-3.20.4-x86_64.iso file.

After insallation do:
* Open Virtual Box. 
* Click at New. Change name to be Inception. Change folder to be goinfre or your usb. ISO Image is the Alpine we downloaded. Type is Linux. Verion is Other Linux (64-bit). Then click on Next button.
* Hardware: Base Memory is 2048MB, Processors is 1 CPU. Then click on Next button.
* Virtual Hard disk: Disk Size is 30GB. Then click on Next button.
* Summary: click Finish.
* Click on Settings. Click on Storage. Choose alpine. Click blue disk next to Optical Drive and check if its alpine. Then click start.
* When it opens go to view and choose scaled so you can change size of your window.

#### Setting it up

* Now when you installed it and started your virtual machine, we need to set it up:
    * when it open the screen it will ask for the local host login where you initially have to put root (if your mouse disapear, click control button under shift to unfreeze it)
    * now type setup-alpine command to configure Alpine Linux after installation It will first ask for keyboard layout. Choose us and then again us.
    * Hostname: tmenkovi.42.fr. After that Interface will show and click enter and then again enter, then type "n".
    * Now write your password twice (and remember it :D)
    * Pick your timezone: Europe/. Then Helsinki.
    * Proxy: type none. Then enter 2 times.
    * User: tmenkovi. Tanja Menkovic. Then new password 2 times. Then click enter 2 times.
    * Disk & Install: sda. sys. y.
    * Go to VB. Settings. Storage. Press alipne. then blue disk. Then remove disk and click OK.
    * Now go back to VM and type reboot.
    * Now login with root and root password.
    * Now lets install sudo: vi /etc/apk/repositories. When it opens type i and then delete "#" infront of last line. Now click esc, then ":wq" to save and exit.
    * Now type "su -", "apk update", "apk add sudo", "sudo visude".
    * When it opens click "i" and uncomment (delete "#" infront of) %sudo ALL=(ALL:ALL) ALL. Then exit.
    * After this check if group sudo exist with the command: getent group sudo. If no output is given it means that not. So we have to create the group and after add our user in the group: "addgroup sudo", "adduser tmenkovi sudo". Where tmenkovi is my username and sudo is the groupt. Now you are good to go to exercise sudo writes with your user.
* Installation and Configuration of SSH:
    * type: "sudo apk update", "sudo apk add nano", "sudo nano /etc/ssh/sshd_config".
    * now when it opens uncomment Port and change it into 4241 and in PermitRootLogin change the rest of the line to no. To save it do CTRL+O and enter. To exit nano do STRL+X.
    * Now type: "sudo vi /etc/ssh/ssh_config". Then uncomment the Post and change it into 4241. Now save and exit.
    * Now type "sudo rc-service sshd restart"
    * To check if it is listening from 4241 we can see with this command: "netstat -tuln | grep 4241"
    * Now go back to VM. Settings. Network. Advanced. Port Forwarding. Click green + and in both ports type "4241". Click OK 2 times.
    * Open normal terminal to check if it works. type: "ssh localhost -p 4241", "yes" and then password. Now we can continue in terminal.
    * type: "sudo apk add xorg-server xfce4 xfce4-terminal lightdm lightdm-gtk-greeter xf86-input-libinput elogind", "sudo setup-devd udev", "sudo rc-update add elogind", "sudo rc-update add lightdm", "sudo reboot"
    * now go back to VM and it will show a little window for log in with your name :D Log in there and you will see a nice background with a little blue mouse in the middle :D Now if you close it and start again in VB, it will show this again.

    ### Docker

    #### Installation

    * First connect using ssh at terminal: ssh localhost -p 4241
    * Update Alpine: "sudo apk update && sudo apk upgrade"
    * then type: "sudo vi /etc/apk/repositories" and uncomment first line and save and close.
    * Install Docker and Docker Compose: "sudo apk add docker docker-compose"
    * run: "sudo apk add --update docker openrc"
    * To start the Docker daemon at boot, run: "sudo rc-update add docker boot", execute: "service docker status" to ensure the status is running. If it is stoped type: "sudo service docker start" and check again: "service docker status"
    * Connecting to the Docker daemon through its socket requires you to add yourself to the docker group: "sudo addgroup tmenkovi docker"
    * Installing Docker Compose: "sudo apk add docker-cli-compose"



