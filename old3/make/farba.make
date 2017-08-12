echo "------- Build all started -------"
echo ""

./shared.make
./core.make
./images.make
./view.make
./engine.make

echo ""
echo "------ Build all completed ------"
