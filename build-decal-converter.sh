#!/usr/bin/env bash
##########################################################
# This script will build a .deb file for decal-converter #
#   Created by Ed Houseman Jr <justme488@gmail.com>      #
##########################################################

# Create a directory in desktop named "decal-converter"
mkdir "$HOME/Desktop/decal-converter"

# Create a directory in desktop/decal-converter named "DEBIAN"
mkdir "$HOME/Desktop/decal-converter/DEBIAN"

# Create a directory in desktop/decal-converter named "usr"
mkdir "$HOME/Desktop/decal-converter/usr"

# Create a directory in desktop/decal-converter/usr named "share"
mkdir "$HOME/Desktop/decal-converter/usr/share"

# Create a directory in desktop/decal-converter/usr/share named "applications"
mkdir "$HOME/Desktop/decal-converter/usr/share/applications"

# Create a directory in desktop/decal-converter/usr/share named "decal-converter"
mkdir "$HOME/Desktop/decal-converter/usr/share/decal-converter"

# Create a directory in desktop/decal-converter/usr/share/decal-converter named "examples" (This will have some example decals)
mkdir "$HOME/Desktop/decal-converter/usr/share/decal-converter/examples"

# Now the main structure is Built

# Lets create a debian control file
touch "$HOME/Desktop/decal-converter/DEBIAN/control"
echo "Package: decal-converter" >>  "$HOME/Desktop/decal-converter/DEBIAN/control"
echo "Version: 1.0" >> "$HOME/Desktop/decal-converter/DEBIAN/control"
echo "Architecture: amd64" >> "$HOME/Desktop/decal-converter/DEBIAN/control"
echo "Installed-Size: 1400" >> "$HOME/Desktop/decal-converter/DEBIAN/control"
echo "Maintainer: justme488 <justme488@gmail.com>" >> "$HOME/Desktop/decal-converter/DEBIAN/control"
echo "Priority: optional" >> "$HOME/Desktop/decal-converter/DEBIAN/control"
echo "Depends: imagemagick,pngquant,zenity" >> "$HOME/Desktop/decal-converter/DEBIAN/control"
echo "Description: Decal-Converter" >> "$HOME/Desktop/decal-converter/DEBIAN/control"
echo " A utility to convert decal images to png, fill with black, colorize, watermark, and compress for Phoenix Treasures 5" >> "$HOME/Desktop/decal-converter/DEBIAN/control"
echo " Features include:" >> "$HOME/Desktop/decal-converter/DEBIAN/control"
echo " * Single or batch convert image to png" >> "$HOME/Desktop/decal-converter/DEBIAN/control"
echo " * Single or batch colorize, fill with black, compress, and watermark decals images to White, Black, Blue, Teal, Red, and green" >> "$HOME/Desktop/decal-converter/DEBIAN/control"
echo " * Saves colorized, black filled, and original files to folder in home directory" >> "$HOME/Desktop/decal-converter/DEBIAN/control"
echo " * Creates shortcut in Menu > Graphics > Decal Converter" >> "$HOME/Desktop/decal-converter/DEBIAN/control"
echo " * Adds watermark for Phoenix Treasures 5" >> "$HOME/Desktop/decal-converter/DEBIAN/control"

# Lets create the .desktop file

# Change directory to Desktop/decal-converter/usr/share/applications"
cd "$HOME/Desktop/decal-converter/usr/share/applications"
touch "$HOME/Desktop/decal-converter/usr/share/applications/decal-converter.desktop"
echo "[Desktop Entry]" >> "$HOME/Desktop/decal-converter/usr/share/applications/decal-converter.desktop"
echo "Type=Application" >> "$HOME/Desktop/decal-converter/usr/share/applications/decal-converter.desktop"
echo "Encoding=UTF-8" >> "$HOME/Desktop/decal-converter/usr/share/applications/decal-converter.desktop"
echo "Name=Decal Converter" >> "$HOME/Desktop/decal-converter/usr/share/applications/decal-converter.desktop"
echo "Comment=Convert decals and colorize" >> "$HOME/Desktop/decal-converter/usr/share/applications/decal-converter.desktop"
echo "Exec=/usr/share/decal-converter/Decal-Converter.sh" >> "$HOME/Desktop/decal-converter/usr/share/applications/decal-converter.desktop"
echo "Icon=/usr/share/decal-converter/decal-converter.png" >> "$HOME/Desktop/decal-converter/usr/share/applications/decal-converter.desktop"
echo "Terminal=False" >> "$HOME/Desktop/decal-converter/usr/share/applications/decal-converter.desktop"
echo "Categories=Graphics;" >> "$HOME/Desktop/decal-converter/usr/share/applications/decal-converter.desktop"

# Start downloading files to the directories

# Change directory to desktop
cd "$HOME/Desktop"

# Download zip file from github (main.zip)
wget "https://github.com/Justme488/Decal-Converter/archive/refs/heads/main.zip"

# Unzip desktop/main.zip
unzip "$HOME/Desktop/main.zip"

# If Decal-Converter-main exists on desktop, that means main.zip was extracted and can be removed
if [[ -d "$HOME/Desktop/Decal-Converter-main" ]]; then
  # Remove desktop/main,zip
  rm "$HOME/Desktop/main.zip"
fi

# Move files from desktop/Decal-Converter-main to "desktop/decal-converter/usr/share/decal-converter"
mv "$HOME/Desktop/Decal-Converter-main/Examples" "$HOME/Desktop/decal-converter/usr/share/decal-converter"
mv "$HOME/Desktop/Decal-Converter-main/decal-converter.png" "$HOME/Desktop/decal-converter/usr/share/decal-converter"
mv "$HOME/Desktop/Decal-Converter-main/Decal-Converter.sh" "$HOME/Desktop/decal-converter/usr/share/decal-converter"
mv "$HOME/Desktop/Decal-Converter-main/watermark.png" "$HOME/Desktop/decal-converter/usr/share/decal-converter"

# We need to make decal-converter executable
chmod +x "$HOME/Desktop/decal-converter/usr/share/decal-converter/Decal-Converter.sh"

# We need to change permissions on the folder, and all of it's contents
chmod 775 -R "$HOME/Desktop/decal-converter"

# That's it for the required files, now let's build the .deb package

# Change directory to "desktop/decal-converter"
cd "$HOME/Desktop/decal-converter"

# Build the decal-converter.deb file
dpkg-deb --build "$HOME/Desktop/decal-converter"

# Wait 2 seconds for .deb file to build before checking if it exists
sleep 2

# If the .deb file exists, delete the build directory
if [[ -f "$HOME/Desktop/decal-converter.deb" ]]; then
  rm -rf "$HOME/Desktop/decal-converter"
  rm -rf "$HOME/Desktop/Decal-Converter-main"
fi

$SHELL
