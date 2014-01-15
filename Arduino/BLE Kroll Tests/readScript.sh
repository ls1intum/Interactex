stty -f /dev/cu.usbserial-A1012YS4 cs8 19200 ignbrk -brkint -icrnl -imaxbel -opost -onlcr -isig -icanon -iexten -echo -echoe -echok -echoctl -echoke noflsh -ixon -crtscts

c=1

while [ $c -le 40000 ]
do

#cat /dev/cu.usbserial-A1012YS4 > var

READ=`dd if=/dev/cu.usbserial-A1012YS4 count=16`
echo $READ

#while read line < /dev/cu.usbserial-A1012YS4; do
#echo $line
#done

#cat /dev/cu.usbserial-A1012YS4 > var

sleep 0.1
((c++))

echo "iterates"

done


echo "Finished"

