echo "------- Build all started -------"
echo ""

./data.make
./contracts.make
./core.make
./images.make
./view.make

echo ""
echo "------ Build all completed ------"
