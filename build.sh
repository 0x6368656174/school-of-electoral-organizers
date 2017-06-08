rm -r dist
rm -r build
mkdir -p dist
mkdir -p build
find . -iname "*.md" -exec cp {} build \;
find . -iname "*.png" -exec cp {} build \;
find . -iname "*.svg" -exec cp {} build \;
cp title.txt build
cp styles/epub.css build
cd build

FILES=`find . -iname "*.md" | sort`

pandoc -f markdown+header_attributes -t epub3 -S --normalize --epub-chapter-level=3 --epub-stylesheet=epub.css -o ../dist/book.epub title.txt $FILES

ls $TRAVIS_BUILD_DIR