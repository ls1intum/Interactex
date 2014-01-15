stty -f /dev/cu.usbserial-A1012YS4 cs8 19200 ignbrk -brkint -icrnl -imaxbel -opost -onlcr -isig -icanon -iexten -echo -echoe -echok -echoctl -echoke noflsh -ixon -crtscts

c=1

while [ $c -le 400 ]
do

echo "AAAAAAAAAAAAAAA" > /dev/cu.usbserial-A1012YS4

sleep 0.05
((c++))

done


echo "Finished"

