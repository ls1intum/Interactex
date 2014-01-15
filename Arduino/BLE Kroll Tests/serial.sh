
#exec 3<> /dev/tty.usbmodemfa1331
exec 3<> /dev/cu.usbserial-A1012YS4

sleep 1

echo -e "Hello" > /dev/cu.usbserial-A1012YS4

c=1
while [ $c -le 200 ]
do

echo "Before"

while read line < /dev/cu.usbserial-A1012YS4; do
#echo -e $i > /dev/tty.usbserial-A1012YS4
echo $line
done

echo "After"

#echo -e $c >&3
#cat <&3

sleep 0.1
((c++))

done

exec 3>&-

echo "Finished"