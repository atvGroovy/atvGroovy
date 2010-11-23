#echo "Always clean up first!"
#echo ""

#make clean

echo "Making..."
echo ""

make

echo "Make Stage..."
echo ""

make stage

echo "Make Package"

make package

echo "Make Install..."

make install

#echo "Creating Repository"

#rm -rf Repository/deb
#rm Repository/Package.gz
#rm Repository/Package.bz2
#mkdir Repository/deb
#mv *.deb Repository/deb/
#cd Repository/
#dpkg-scanpackages . /dev/null >Packages
#cat Packages | gzip  > Packages.gz
#bzip2 Packages



