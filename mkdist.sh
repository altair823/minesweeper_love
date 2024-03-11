#!/bin/bash

echo "Creating .love file..."
zip -r minesweeper_love.love \
*.lua \
object \
model \
game \
common \
resources \
original_resources \
fonts

echo "Creating .exe file..."
cat love.exe minesweeper_love.love > ./dist/minesweeper_love.exe
rm minesewwper_love.love

echo "Compresing .exe directory..."
zip -r ./minesweeper_love.zip ./dist