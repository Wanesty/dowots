#!/bin/bash
#
#                   ▄
#                  █▀█
#                 ▄▀           █▀
#                 █      ▄▄▄▄ ▄▀
#                █           ██▄     ▄
#         ▄▄█▄  █     ▄▄     █  ▀▀   ▀█
#        ▄▀  ▀ ▄█   ▄▀▀▀█   ▀▄       ▄█▀█
#        █     ▀█  ▄▀   █    █     ▄▀▀   █
#        ▀▄  ▄▄▀▀▄ ▀█▄▄▀      █▄      ▄  █▀
#          ▀▀    ▀              ▀▀    ▀▀▀▀
#
#------------------------------------------------------------

if (( $EUID != 0 )); then
    echo -e "\e[31;1m wait ! you must run it as root ! x3\e[0m"
    exit 1
fi

dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
print_help() {
	echo -e "\e[34;1mUsage: $0 [OPTIONS]\e[0m"
	echo
	echo -e "\e[34;1m	-i,  --install\e[0m"
	echo -e "\e[34;1m	-un, --uninstall\e[0m"
}

install() {
	echo ᓚᘏᗢ 
	echo -e "\e[34;1m linking DefaultSyntax script to sublime-text configs \e[0m"
		ln -sv "${dir}"/DefaultSyntaxToGenericConfig-Subl.py /home/"${SUDO_USER}"/.config/sublime-text/Packages/User/DefaultSyntaxToGenericConfig-Subl.py
	
	echo -e "\e[34;1m linking systemd automount files \e[0m"
		ln -sv "${dir}"/permnt-data.mount /etc/systemd/system/permnt-data.mount
		ln -sv "${dir}"/permnt-data.automount /etc/systemd/system/permnt-data.automount
	echo -e "\e[34;1m making mount directories :3 \e[0m"
		mkdir -p /permnt/data/
	echo -e "\e[34;1m starting mount services uwu \e[0m"
		systemctl enable permnt-data.mount
		systemctl enable permnt-data.automount


	echo -e "\e[34;1m font x3 \e[0m"

		if [ "$(sha256sum font.zip | awk '{ print $1 }')" == "b10c834c67ef0a954381084f3bc9f57b818cbc66e2a64701ccf84e07df40adf9" ]; then
			echo -e "\e[34;1m file alredy exist \o/ \e[0m"
		else
			echo -e "\e[34;1m dowonloading the font ! \e[0m"
			curl https://en.bestfonts.pro/fonts_files/600c045b6a101229c67525c5/font.zip -O "${dir}"/
		fi
	echo -e "\e[34;1m extracting CartographCF \e[0m"
		mkdir /usr/local/share/fonts/c
		bsdtar -C /usr/local/share/fonts/c/ -xf "${dir}"/font.zip "*.ttf"
}

uninstall() {
	echo ᓚᘏᗢ
	echo -e "\e[34;1m Remeowing DefaultSyntax\e[0m"
		rm /home/"${SUDO_USER}"/.config/sublime-text/Packages/User/DefaultSyntaxToGenericConfig-Subl.py

	echo -e "\e[34;1m Stopping systemd automount \e[0m"
		systemctl disable permnt-data.mount
		systemctl disable permnt-data.automount

	echo -e "\e[34;1m Remeowing systemd automount files\e[0m"
		rm /etc/systemd/system/permnt-data*

	echo -e "\e[34;1m Remeowing CartographCF\e[0m"
		rm /usr/local/share/fonts/c/CartographCF*
}


if [[ "$1" == "-i" || "$1" == "--install" || "$1" == "install" ]]; then
    install
    exit


elif [[ "$1" == "-un" || "$1" == "--uninstall" || "$1" == "uninstall" ]]; then
    uninstall
    exit

else
	print_help
	exit
fi