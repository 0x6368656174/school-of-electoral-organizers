#!/bin/bash
rm -r dist
mkdir -p dist

echo 'build book.epub'
rm -r build
mkdir -p build
find src -iname "*.md" -exec cp {} build \;
find src -iname "*.png" -exec cp {} build \;
find src -iname "*.svg" -exec cp {} build \;
cp README.md build/0.md
cp title.txt build

cd build
PNG=`find . -iname "*.png"`
for f in $PNG
do
    optipng $f
done

SVG=`find . -iname "*.svg"`
cd ..
for f in $SVG
do
    filename=$(basename "$f")
    filename="${filename%.*}"
    node_modules/.bin/svgexport build/$f build/$filename.png 640:
done

cd build

find . -type f -name '*.md' -exec sed -i -r 's/\.svg\w*\)/\.png\)/g' {} \;

FILES=`find . -iname "*.md" | sort`

pandoc -f markdown+header_attributes+smart -t epub3 --epub-chapter-level=4 --toc-dept=4 -o ../dist/book.epub title.txt $FILES




cd ..
echo 'build book-svg.epub'
rm -rf build-svg
mkdir -p build-svg
find src -iname "*.md" -exec cp {} build-svg \;
find src -iname "*.png" -exec cp {} build-svg \;
find src -iname "*.svg" -exec cp {} build-svg \;
cp README.md build-svg/0.md
cp title.txt build-svg

#node_modules/.bin/svgo -f build-svg

cd build-svg

PNG=`find . -iname "*.png"`
for f in $PNG
do
    optipng $f
done

FILES=`find . -iname "*.md" | sort`

pandoc -f markdown+header_attributes+smart -t epub3 --epub-chapter-level=4 --toc-dept=4 -o ../dist/book-svg.epub title.txt $FILES
