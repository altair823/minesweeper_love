#!/bin/bash

echo "Creating .exe file..."
cat love.exe minesweeper_love.love > ./dist/minesweeper_love.exe

echo "Compresing .exe directory..."
zip -r ./minesweeper_love.zip ./dist