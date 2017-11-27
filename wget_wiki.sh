#!/bin/bash

WIKI_URL="https://www.xxx.yyy.br/wiki/"  # with trailing slash
WIKI_USERNAME="user.name"
WIKI_PASSWORD="password"
WIKI_DOMAIN="xxx.yyy.br"
WIKI_DUMP_DIR="$1" # param or a name that will be used as path
WIKI_DUMP_DIR_LOGIN=${WIKI_DUMP_DIR}/login
WIKI_LOGIN_PAGE="index.php?title=Especial:Autenticar-se" # Language dependent page
WIKI_COOKIES="${WIKI_DUMP_DIR}/cookies.txt"
LIST_OF_URLS="${WIKI_DUMP_DIR}.txt" # an url in each line of this file, as start pages

mkdir -p ${WIKI_DUMP_DIR}
mkdir -p ${WIKI_DUMP_DIR_LOGIN}

# get login page
wget 	--keep-session-cookies \
	--save-cookies ${WIKI_COOKIES} \
	--directory-prefix=${WIKI_DUMP_DIR} \
	"${WIKI_URL}${WIKI_LOGIN_PAGE}" \
	-O ${WIKI_DUMP_DIR_LOGIN}/login_page.html

# extract login token form login page
WIKI_LOGIN_TOKEN=$(grep -Eo '[a-z0-9]{32}' ${WIKI_DUMP_DIR_LOGIN}/login_page.html)
POST_DATA="wpName=${WIKI_USERNAME}&wpPassword=${WIKI_PASSWORD}&wpDomain=${WIKI_DOMAIN}&wpRemember=1&wpLoginattempt=Entrar&wpLoginToken=${WIKI_LOGIN_TOKEN}"

echo
echo "WIKI_LOGIN_TOKEN = \"${WIKI_LOGIN_TOKEN}\""
echo "POST DATA = ${POST_DATA}"
echo
sleep 2


# post login
wget 	--keep-session-cookies \
	--load-cookies ${WIKI_COOKIES} \
	--save-cookies ${WIKI_COOKIES} \
	--post-data "${POST_DATA}" \
	--directory-prefix=${WIKI_DUMP_DIR_LOGIN} \
	"${WIKI_URL}${WIKI_LOGIN_PAGE}&action=submitlogin&type=login"


# DUMP ALL
# you may replace -i for a single URL
wget \
  --keep-session-cookies \
  --load-cookies ${WIKI_COOKIES} \
  --save-cookies ${WIKI_COOKIES} \
  --page-requisites \
  --convert-links \
  --no-clobber \
  --continue \
  --adjust-extension \
  --restrict-file-names=nocontrol \
  --content-disposition \
  --remote-encoding=utf-8 \
  --quiet --show-progress \
  --user-agent=firefox \
  --directory-prefix=${WIKI_DUMP_DIR} \
  -i ${LIST_OF_URLS}

# Other useful options

#  --wait=1 \
# --recursive \
#  --level=1 \


#  --exclude-directories "/index.php/Especial*" \
#  --reject "*oldid=*","*action=edit*","*action=history*","*diff=*","*limit=*","*[/=]User:*","*[/=]User_talk:*","Categoria/","*[^p]/Especial:*","*=Especial:[^R]*","*.php/Especial:[^LUA][^onl][^nul]*","*MediaWiki:*","*Search:*","*Help:*’","*[/=]Участник:*","*[^p]/${SPECIAL_ENCODED}:*","*=${SPECIAL_ENCODED}:[^R]*","*.php/${SPECIAL_ENCODED}:[^LUA][^onl][^nul]*"  \
#   -e robots=off \
# --mirror # equivalent to: -r -N -l inf --no-remove-listing
#  --recursive \
#  -l 2 \
#  --limit-rate 200K \


#wget --mirror \
#  --limit-rate=20K \
#  --wait=20
#  --recursive \
#  -e robots=off \
#	--page-requisites \
#	--convert-links \
#  --no-clobber \
#  --adjust-extension \
#	--keep-session-cookies \
#  --restrict-file-names=nocontrol \
#  --remote-encoding=utf-8 \
#	--load-cookies cookies.txt \
#  -q --show-progress \
#  --user-agent=firefox \
#	--directory-prefix=${WIKI_DUMP_DIR} \
#  ${WIKI_URL}${WIKI_START_PAGE}

 # --reject "*action=*","*oldid=*","*diff=*","*index.php*" \
 # --exclude-directories "/index.php/Oficial*" \
  
#--no-parent
#--no-host-directories \
#--adjust-extension
#--html-extension (OBSOLETE)
#--reject "*oldid=*","*action=edit*","*action=history*","*diff=*","*limit=*","*[/=]User:*","*[/=]User_talk:*","*[^p]/Special:*","*=Special:[^R]*","*.php/Special:[^LUA][^onl][^nul]*","*MediaWiki:*","*Search:*","*Help:*’","*[/=]Участник:*","*[/=]Обсуждение:*","*[^p]/${SPECIAL_ENCODED}:*","*=${SPECIAL_ENCODED}:[^R]*","*.php/${SPECIAL_ENCODED}:[^LUA][^onl][^nul]*","*Поиск:*","*Помощь:*" \
#--reject-regex "Служебная|Поиск|Помощь|Участник|index\.php|action=|diff=|limit=|" \
#--reject-regex
#--no-clobber \ prevents download twice
#--cut-dirs=2 \


# rawurlencode "${WIKI_TEST_ARTICLE}";
# wget --no-parent --page-requisites --convert-links --no-host-directories --cut-dirs=2 --load-cookies cookies.txt --directory-prefix=. ${WIKI_URL}index.php/${REPLY}

# SPECIAL_ENCODED=$( rawurlencode "Portal:Informações_complementares" )

# rawurlencode() {
#   local string="${1}"
#   local strlen=${#string}
#   local encoded=""
#   local pos c o
# 
#   for (( pos=0 ; pos<strlen ; pos++ )); do
#      c=${string:$pos:1}
#      case "$c" in
#         [-_.~a-zA-Z0-9] ) o="${c}" ;;
#         * )               printf -v o '%%%02x' "'$c"
#      esac
#      encoded+="${o}"
#   done
#   echo "${encoded}"    # You can either set a return variable (FASTER) 
#   REPLY="${encoded}"   #+or echo the result (EASIER)... or both... :p
# }
