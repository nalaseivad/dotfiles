# -*-sh-*-

thisfile='.bash_profile'
wd=`pwd`
echo ">> $wd/$thisfile"

if [ -f ~/.bashrc ]; then
  echo "sourcing ~/.bashrc ..."
  source ~/.bashrc
  echo "                   ... done"
fi

echo ""
echo "Welcome to `uname -s` `uname -r` on node `uname -n`"
echo ""
echo "<< $wd/$thisfile"

