#! /bin/bash


# Define the colors used during the project
red="\033[31m"
green="\033[32m"
yellow="\033[33m"
blue="\033[34m"
pink="\033[35m"
cyan="\033[36m"
white="\033[37m"
reset="\033[0m"

# Function For show banner
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

# This function is responsible for checking whether curl is installed or not
checkInstallCurl(){
    which curl &> /dev/null
    if [ $? != 0 ]; then
        echo "${red} Curl is not installed on your system
        Please install curl first and run the script again"
        exit
    fi
}

# Simple Function to Set Color
setColor(){
    echo -e $1
}

# Function To Input Headers From User
inputHeaders(){
    echo -e "${yellow}Getting Headers ...${reset}"
        printf "${red}if you want add some request header separate with space\n\texample: Host:google.com Accept:text/html\n-> : ${reset}" 
		read -a headerList
        headerData=""
        for i in ${headerList[@]}
        do
            headerData+="-H $i \n"
        done
}

# Function To Input Query Strings From User
inputQueryStrings(){
        sendGetUrl+="?"
        echo -e "${yellow}Getting Query Strings ...${reset}"
        printf "${red}if you want add some Query Strings separate with space\n\texample: username=user1 password=1234\n->${reset}"
        printf "$(setColor $yellow)Enter Query Strings: $(setColor $reset)"
        read -a queryStrings
        for i in ${queryStrings[@]}
        do  
            sendGetUrl+="$i&"
        done
        # Delete & end of string (annoying)
        quryStringUrl=$(echo $sendGetUrl | sed 's/\&$//')
}


# Function To Input POST Data From User
inputPostData(){
        echo -e "${yellow}Getting POST Data ...${reset}"
        printf "${red}If Your POST Data Are More Than One,\nSeparate Them With a Space, For Example: username=user1 password=1234\n${reset}"
        printf "$(setColor $yellow)Enter POST Data: $(setColor $reset)"
        read -a postData
        data=""
        for i in ${postData[@]}
        do
            data+="$i&"
        done
        
        # Delete & end of string (annoying)
        data=$(echo $data | sed 's/\&$//')
}

newLine=$(printf '\n')

# Function To Send GET Request
sendGet(){
    read -p "$(setColor $yellow)Enter Hostname OR IP Address: $(setColor $reset)" sendGetUrl
    sleep 0.3
    read -p "$(setColor $pink)[?]$(printf '\t')Do You want to Send any Header $(printf '\t\t')[$(setColor $red)N$(setColor $reset)/$(setColor $green)y$(setColor $reset)$(setColor $pink)]$(setColor $reset)? " sendGetHeaderQuestion
    sleep 0.3
    read -p "$(setColor $pink)[?]$(printf '\t')Do You Want to Send Query String $(printf '\t')[$(setColor $red)N$(setColor $reset)/$(setColor $green)y$(setColor $reset)$(setColor $pink)]$(setColor $reset)? " sendGetQueryStringQuestion
    sleep 0.3
    read -p "$(setColor $pink)[?]$(printf '\t')Do You want to Follow Redirect $(printf '\t\t')[$(setColor $red)N$(setColor $reset)/$(setColor $green)y$(setColor $reset)$(setColor $pink)]$(setColor $reset)? " sendGetFollowRedirectQuestion
    # Condition For Header True , Query String True , Follow Redirect True (T,T,T)
    if [[ $sendGetHeaderQuestion == "Y" || $sendGetHeaderQuestion == "y" ]] && [[ $sendGetQueryStringQuestion == "Y" || $sendGetQueryStringQuestion == "y" ]] && [[ $sendGetFollowRedirectQuestion == "Y" || $sendGetFollowRedirectQuestion == "y" ]]; then
        # Getting Query Strings From User
        inputQueryStrings
        # Getting Headers From User
        inputHeaders
        curl -X GET -L $quryStringUrl $(echo -e $headerData)
        selectOption
    # Condition For Header False , Query String False , Follow Redirect False (F,F,F)
    elif [[ $sendGetHeaderQuestion == "N" || $sendGetHeaderQuestion == "n" || $sendGetHeaderQuestion == $newLine ]] && [[ $sendGetQueryStringQuestion == "N" || $sendGetQueryStringQuestion == "n" || $sendGetQueryStringQuestion == $newLine ]] && [[ $sendGetFollowRedirectQuestion == "N" || $sendGetFollowRedirectQuestion == "n" || $sendGetFollowRedirectQuestion == $newLine ]]; then
        curl -X GET $sendGetUrl
        selectOption
    # Condition For Header True , Query String False , Follow Redirect False (T,F,F)
    elif [[ $sendGetHeaderQuestion == "Y" || $sendGetHeaderQuestion == "y" ]] && [[ $sendGetQueryStringQuestion == "n" || $sendGetQueryStringQuestion == "N" || $sendGetQueryStringQuestion == $newLine ]] && [[ $sendGetFollowRedirectQuestion == "n" || $sendGetFollowRedirectQuestion == "N" || $sendGetFollowRedirectQuestion == $newLine ]]; then
        # Getting Headers From User
        inputHeaders
        curl -X GET $sendGetUrl $(echo -e $headerData)
        selectOption
    # Condition For Header True , Query String True , Follow Redirect False (T,T,F)
    elif [[ $sendGetHeaderQuestion == "Y" || $sendGetHeaderQuestion == "y" ]] && [[ $sendGetQueryStringQuestion == "Y" || $sendGetQueryStringQuestion == "y" ]] && [[ $sendGetFollowRedirectQuestion == "n" || $sendGetFollowRedirectQuestion == "N" || $sendGetFollowRedirectQuestion == $newLine ]]; then
        # Getting Query Strings From User
        inputQueryStrings
        # Getting Headers From User
        inputHeaders
        curl -X GET $quryStringUrl $(echo -e $headerData)
        selectOption
    # Condition For Header True , Query String False , Follow Redirect True (T,F,T)
    elif [[ $sendGetHeaderQuestion == "Y" || $sendGetHeaderQuestion == "y" ]] && [[ $sendGetQueryStringQuestion == "n" || $sendGetQueryStringQuestion == "N" || $sendGetQueryStringQuestion == $newLine ]] && [[ $sendGetFollowRedirectQuestion == "Y" || $sendGetFollowRedirectQuestion == "y" ]]; then
        # Getting Headers From User
        inputHeaders
        curl -X GET -L $sendGetUrl $(echo -e $headerData)
        selectOption
    # Condition For Header False , Query String True , Follow Redirect True (F,T,T)
    elif [[ $sendGetHeaderQuestion == "N" || $sendGetHeaderQuestion == "n" || $sendGetHeaderQuestion == $newLine ]] && [[ $sendGetQueryStringQuestion == "Y" || $sendGetQueryStringQuestion == "y" ]] && [[ $sendGetFollowRedirectQuestion == "Y" || $sendGetFollowRedirectQuestion == "y" ]]; then
        # Getting Query Strings From User
        inputQueryStrings
        curl -X GET -L $quryStringUrl
        selectOption
    # Condition For Header False , Query String False , Follow Redirect True (F,F,T)
    elif [[ $sendGetHeaderQuestion == "N" || $sendGetHeaderQuestion == "n" || $sendGetHeaderQuestion == $newLine ]] && [[ $sendGetQueryStringQuestion == "N" || $sendGetQueryStringQuestion == "n" || $sendGetQueryStringQuestion == $newLine ]] && [[ $sendGetFollowRedirectQuestion == "Y" || $sendGetFollowRedirectQuestion == "y" ]]; then
        curl -X GET -L $sendGetUrl
        selectOption
    # Condition For Header False , Query String True , Follow Redirect False (F,T,F)
    elif [[ $sendGetHeaderQuestion == "N" || $sendGetHeaderQuestion == "n" || $sendGetHeaderQuestion == $newLine ]] && [[ $sendGetQueryStringQuestion == "Y" || $sendGetQueryStringQuestion == "y" ]] && [[ $sendGetFollowRedirectQuestion == "Y" || $sendGetFollowRedirectQuestion == "y" || $sendGetFollowRedirectQuestion == $newLine ]]; then
        # Getting Query Strings From User 
        inputQueryStrings
        curl -X GET $quryStringUrl
        selectOption
    else
        echo -e "${red}Wrong Answer To Question ...${reset}"
        read -p "$(setColor $yellow)Do You Want To Continue [Y/n]? $(setColor $reset)" wrongAnswerQuestion
        case $wrongAnswerQuestion in
            Y|y|yes)
                selectOption
            ;;
            N|n|no)
                exit
        esac
    fi
}

# Function To Send POST Request
sendPost(){
    read -p "$(setColor $yellow)Enter Hostname OR IP Address: $(setColor $reset)" sendPostUrl
    sleep 0.3
    read -p "$(setColor $pink)[?]$(printf '\t')Do You want to Send any Header $(printf '\t\t')[$(setColor $red)N$(setColor $reset)/$(setColor $green)y$(setColor $reset)$(setColor $pink)]$(setColor $reset)? " sendPostHeaderQuestion
    sleep 0.3
    read -p "$(setColor $pink)[?]$(printf '\t')Do You Want to Send POST Data $(printf '\t\t')[$(setColor $red)N$(setColor $reset)/$(setColor $green)y$(setColor $reset)$(setColor $pink)]$(setColor $reset)? " sendPostDataQuestion
    sleep 0.3
    read -p "$(setColor $pink)[?]$(printf '\t')Do You want to Follow Redirect $(printf '\t\t')[$(setColor $red)N$(setColor $reset)/$(setColor $green)y$(setColor $reset)$(setColor $pink)]$(setColor $reset)? " sendPostFollowRedirectQuestion
    # Condition For Header True , Send Data True , Follow Redirect True (T,T,T)
    if [[ $sendPostHeaderQuestion == "Y" || $sendPostHeaderQuestion == "y" ]] && [[ $sendPostDataQuestion == "Y" || $sendPostDataQuestion == "y" ]] && [[ $sendPostFollowRedirectQuestion == "Y" || $sendPostFollowRedirectQuestion == "y" ]]; then
        # Getting PostData From User
        inputPostData
        # Getting Headers From User
        inputHeaders
        curl -X POST -L $sendPostUrl -d "$data" $(echo -e $headerData)
        selectOption
    # Condition For Header False , Send Data False , Follow Redirect False (F,F,F)
    elif [[ $sendPostHeaderQuestion == "N" || $sendPostHeaderQuestion == "n" || $sendPostHeaderQuestion == $newLine ]] && [[ $sendPostDataQuestion == "N" || $sendPostDataQuestion == "n" || $sendPostDataQuestion == $newLine ]] && [[ $sendPostFollowRedirectQuestion == "N" || $sendPostFollowRedirectQuestion == "n" || $sendPostFollowRedirectQuestion == $newLine ]]; then
        curl -X POST $sendPostUrl
        selectOption
    # Condition For Header True , Send Data False , Follow Redirect False (T,F,F)
    elif [[ $sendPostHeaderQuestion == "Y" || $sendPostHeaderQuestion == "y" ]] && [[ $sendPostDataQuestion == "n" || $sendPostDataQuestion == "N" || $$sendPostDataQuestion == $newLine ]] && [[ $sendPostFollowRedirectQuestion == "n" || $sendPostFollowRedirectQuestion == "N" || $sendPostFollowRedirectQuestion == $newLine ]]; then
        # Getting Headers From User
        inputHeaders
        curl -X POST $sendPostUrl $(echo -e $headerData)
        selectOption
    # Condition For Header True , Send Data True , Follow Redirect False (T,T,F)
    elif [[ $sendPostHeaderQuestion == "Y" || $sendPostHeaderQuestion == "y" ]] && [[ $sendPostDataQuestion == "Y" || $sendPostDataQuestion == "y" ]] && [[ $sendPostFollowRedirectQuestion == "n" || $sendPostFollowRedirectQuestion == "N" || $sendPostFollowRedirectQuestion == $newLine ]]; then
        # Getting PostData From User
        inputPostData
        # Getting Headers From User
        inputHeaders
        curl -X POST $sendPostUrl -d "$data" $(echo -e $headerData)
        selectOption
    # Condition For Header True , Send Data False , Follow Redirect True (T,F,T)
    elif [[ $sendPostHeaderQuestion == "Y" || $sendPostHeaderQuestion == "y" ]] && [[ $sendPostDataQuestion == "n" || $sendPostDataQuestion == "N" || $sendPostDataQuestion == $newLine ]] && [[ $sendPostFollowRedirectQuestion == "Y" || $sendPostFollowRedirectQuestion == "y" ]]; then
        # Getting Headers From User
        inputHeaders
        curl -X POST -L $sendPostUrl $(echo -e $headerData)
        selectOption
    # Condition For Header False , Send Data True , Follow Redirect True (F,T,T)
    elif [[ $sendPostHeaderQuestion == "N" || $sendPostHeaderQuestion == "n" || $sendPostHeaderQuestion == $newLine ]] && [[ $sendPostDataQuestion == "Y" || $sendPostDataQuestion == "y" ]] && [[ $sendPostFollowRedirectQuestion == "Y" || $sendPostFollowRedirectQuestion == "y" ]]; then
        # Getting PostData From User
        inputPostData 
        curl -X POST -L $sendPostUrl -d "$data"
        selectOption
    # Condition For Header False , Send Data False , Follow Redirect True (F,F,T)
    elif [[ $sendPostHeaderQuestion == "N" || $sendPostHeaderQuestion == "n" || $sendPostHeaderQuestion == $newLine ]] && [[ $sendPostDataQuestion == "N" || $sendPostDataQuestion == "n" || $sendPostDataQuestion == $newLine ]] && [[ $sendPostFollowRedirectQuestion == "Y" || $sendPostFollowRedirectQuestion == "y" ]]; then
        curl -X POST -L $sendPostUrl
        selectOption
    # Condition For Header False , Send Data True , Follow Redirect False (F,T,F)
    elif [[ $sendPostHeaderQuestion == "N" || $sendPostHeaderQuestion == "n" || $sendPostHeaderQuestion == $newLine ]] && [[ $sendPostDataQuestion == "Y" || $sendPostDataQuestion == "y" ]] && [[ $sendPostFollowRedirectQuestion == "Y" || $sendPostFollowRedirectQuestion == "y" || $sendPostFollowRedirectQuestion == $newLine ]]; then
        # Getting PostData From User 
        inputPostData 
        curl -X POST $sendPostUrl -d "$data"
        selectOption
    else
        echo -e "${red}Wrong Answer To Question ...${reset}"
        read -p "$(setColor $yellow)Do You Want To Continue [Y/n]? $(setColor $reset)" wrongAnswerQuestion
        case $wrongAnswerQuestion in
            Y|y|yes)
                selectOption
            ;;
            N|n|no)
                exit
        esac
    fi
}

sendHead(){
    read -p "$(setColor $yellow)Enter Host Or Domain Name: $(setColor $reset)$(printf '\n')" sendHeadUrl
    read -p "$(setColor $pink)[?]$(setColor $reset)$(printf '\t')do you want to Send Any Data $(setColor $pink)[$(setColor $red)N$(setColor $reset)/$(setColor $green)y$(setColor $reset)$(setColor $pink)]? $(setColor $reset)" sendHeadDataQuestion
    if [[ $sendHeadDataQuestion == "Y" ]] || [[ $sendHeadDataQuestion == "y" ]]; then
        printf "${red}if you want add some request header separate with space\n\texample: Host:google.com Accept:text/html\n-> : ${reset}" 
		read -a headerList
        headerData=""
        for i in ${headerList[@]}
        do
            headerData+="-H $i \n"
        done
        curl -IL $sendHeadUrl $(echo -e $headerData)
        # selectOption
    elif [[ $sendHeadDataQuestion == "n" ]] || [[ $sendHeadDataQuestion == "N" ]] || [[ $sendHeadDataQuestion == $newLine ]]; then
        curl -IL $sendHeadUrl
        selectOption
    else
        echo -p "${red}Wrong Selection ! , EXIT${reset}"
    fi
}

getHead(){
    read -p "$(setColor $yellow)Enter Hostname OR IP Address: $(setColor $reset)" sendHeadUrl
	read -p "$(setColor $yellow)do you want to follow moved(301) address (default:n): [y,n]: $(setColor $reset)" followLocation
	case ${followLocation} in 
		y|Y)
			curl -L --head ${sendHeadUrl};;
		n|N)
			curl --head ${sendHeadUrl};;
		*)
			curl --head ${sendHeadUrl};;
	esac
	selectOption
}



selectOption(){
	echo	
	echo -e "${pink}[1]${reset}\tSend ${red}GET${reset}    Request"
    sleep 0.2
    echo -e "${pink}[2]${reset}\tSend ${red}POST${reset}   Request"
    sleep 0.2
    echo -e "${pink}[3]${reset}\tSend ${red}Header${reset} Request"
    sleep 0.2
    echo -e "${pink}[4]${reset}\tGET  ${red}Header${reset} Response"
    sleep 0.2
    echo -e "${pink}[5]${reset}\t${red}###### EXIT ########${reset}"
    read -p  "$(setColor $green)Select Option: $(setColor $reset)" selectOption
    case $selectOption in
        1)
        sendGet
        ;;
        2)
        sendPost
        ;;
        3)
        sendHead
        ;;
        4)
        getHead
        ;;
        5)
        exit
    esac
}


main(){
	banner
    checkInstallCurl
    selectOption
}


main
