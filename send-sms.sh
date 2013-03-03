# Description:
#   Sends a link to a Corgi photo from Tumblr to a given number
#
# Variables:
#   GV_EMAIL=Google Voice Username
#   GV_PW=Google Voice Password
#   NUM=Comma delimited list of numbers to send to
# 
# Author: nb

#Requires pygvoice to be in your $PATH
# > 0 */3 * * * $HOME/corgi-sms.sh >> $HOME/corgi-log.txt
gvoice -e $GV_EMAIL --password=$GV_PW --batch send_sms $num `curl -s http://cuture.herokuapp.com/random`
echo "Sent something at `date '+%H:%M:%S - %m/%d/%y'`"
