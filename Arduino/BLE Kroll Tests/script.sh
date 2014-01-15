exec 3<> /dev/tty.usbserial-A1012YS4
sleep 1

c=1
while [ $c -le 100 ]
do

echo "ABCDEFGHIJKLMNOP" >&3

sleep 1
((c++))

done

exec 3>&-

echo "Finished"