######################################################
#  Take one photo, wait 5 seconds, turn on WiFi      #
#  Wait 60 seconds, turn off WiFi, turn off camera   #
#             http://cam-do.com/SOBM                 #
######################################################

sleep 5
t app button shutter PR
sleep 5
t app button wifi PR
sleep 60
t app button wifi P
sleep 3
t app button wifi R
sleep 1
t app button power P
sleep 3
t app button power R
