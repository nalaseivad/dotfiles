# -*-sh-*-

thisfile='.bash_profile'
wd=`pwd`
echo ">> $wd/$thisfile"

if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi

echo "<< $wd/$thisfile"
