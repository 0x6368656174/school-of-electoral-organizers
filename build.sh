#!/bin/bash

echo 'build book.epub'
rm -r dist
rm -r build
mkdir -p dist
mkdir -p build
find src -iname "*.md" -exec cp {} build \;
find src -iname "*.png" -exec cp {} build \;
find src -iname "*.svg" -exec cp {} build \;
cp title.txt build

cd build
SVG=`find . -iname "*.svg"`
cd ..
for f in $SVG
do
    filename=$(basename "$f")
    filename="${filename%.*}"
    node_modules/.bin/svgexport build/$f build/$filename.png 640:
    optipng build/$filename.png
done

cd build

PNG=`find . -iname "*.png"`
for f in $PNG
do
    optipng $f
done

find . -type f -name '*.md' -exec sed -i -r 's/\.svg\w*\)/\.png\)/g' {} \;

FILES=`find . -iname "*.md" | sort`

pandoc -f markdown+header_attributes -t epub2 -S --normalize --epub-chapter-level=3 -o ../dist/book.epub title.txt $FILES




cd ..
echo 'build book-svg.epub'
rm -r dist-svg
rm -r build-svg
mkdir -p dist-svg
mkdir -p build-svg
find src -iname "*.md" -exec cp {} build-svg \;
find src -iname "*.png" -exec cp {} build-svg \;
find src -iname "*.svg" -exec cp {} build-svg \;
cp title.txt build-svg

node_modules/.bin/svgo -f build-svg

cd build-svg

FILES=`find . -iname "*.md" | sort`

pandoc -f markdown+header_attributes -t epub2 -S --normalize --epub-chapter-level=3 -o ../dist/book-svg.epub title.txt $FILES