#! /bin/bash



# Colors
red="\033[31m"
green="\033[32m"
yellow="\033[33m"
blue="\033[34m"
pink="\033[35m"
cyan="\033[36m"
white="\033[37m"
reset="\033[0m"


banner(){
    echo -e "
 .d888                            d8b          888              .d8888b.  888     888 8888888b.  888      
d88P\"                             Y8P          888             d88P  Y88b 888     888 888   Y88b 888      
888                                            888             888    888 888     888 888    888 888      
888888 .d8888b   .d88b.   .d8888b 888  .d88b.  888888 888  888 888        888     888 888   d88P 888      
888    88K      d88\"\"88b d88P\"    888 d8P  Y8b 888    888  888 888        888     888 8888888P\"  888      
888    \"Y8888b. 888  888 888      888 88888888 888    888  888 888    888 888     888 888 T88b   888      
888         X88 Y88..88P Y88b.    888 Y8b.     Y88b.  Y88b 888 Y88b  d88P Y88b. .d88P 888  T88b  888      
888     88888P'  \"Y88P\"   \"Y8888P 888  \"Y8888   \"Y888  \"Y88888  \"Y8888P\"   \"Y88888P\"  888   T88b 88888888 
                                                           888                                            
                                                      Y8b d88P                                            
                                                       \"Y88P\"     

    ${red} A Simple Script To Use ${yellow}CURL                                        
    "    
}


checkInstallCurl(){
    which curl &> /dev/null
    if [ $? != 0 ]; then
        echo "${red} Curl is not installed on your system
        Please install curl first and run the script again"
        exit
    fi
}

selectOption(){
    echo -e "${pink}[1]${reset}\tSend ${red}GET${reset}    Request"
    echo -e "${pink}[2]${reset}\tSend ${red}POST${reset}   Request"
    echo -e "${pink}[3]${reset}\tSend ${red}Header${reset} Request"
    echo -e "${pink}[4]${reset}\tGET  ${red}Header${reset} Response"
    echo -e "${green}Select Option: ${reset}"
    read -r selectOption
}


main(){
    banner              
    checkInstallCurl
    selectOption
}


main