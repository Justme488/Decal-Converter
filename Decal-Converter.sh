#!/usr/bin/env bash
#########################################################################################################################################
# Decal converter by Ed Houseman jr - Created 10/27/22 - Revised 1/19/25                                                                #
#########################################################################################################################################
# This script relies on Imagemagick, Potrace, Pngquant, and Zenity installed on a Unix system - Tested on Linux Mint 22 Cinnamon        #
#########################################################################################################################################
# Options include: Remove background, Fill visible color with black, Convert to GIF, Colorize, Decal on white background, Tablet images #
#########################################################################################################################################
# Colors are:            #
# *White - #ffffff       #
# *Black - #000000       #
# *Blue - #1791d8        #
# *Teal - #29bbc8        #
# *Red - #a01922         #
# *Green - #008c35       #
# *Silver - #928F98      #
# *Pink - #FFADE5        #
# *Purple = #1a0e67      #
# *Dark-Blue = #003478   #
# *Orange = #d56f31      #
# *Yellow = #f3e11f      #
# *Neon-Green = ##39FF14 #
##########################
######################
# Define directories #
######################
# Main decal directory
decals="${HOME}/Decals"

# Original Decal backup directory
original_dir="${HOME}/Decals/Original"

# Colorized directory
colorized_dir="${HOME}/Decals/Colorized"

# Black fill directory
black_fill_dir="${HOME}/Decals/Black-Fill"

# White background directory
white_background_dir="${HOME}/Decals/White-Background"

# GIF directory
gif_dir="${HOME}/Decals/GIF"

# Tablet images for slideshow directory
tablet_dir="${HOME}/Decals/Tablet"

# Resized-Transparent directory
resized_transparent="${HOME}/Decals/Resized-Transparent"

# Temp directory
temp_dir="${decals}/.tmp"
######################
# Create directories #
######################
# Check if "Original" directory exists (Create if it doesn't)
if [[ ! -d "$original_dir" ]]; then
  # Create Original directory
  mkdir "$original_dir"
fi

# Check if "Resized-Transparent" directory exists (Create if it doesn't)
if [[ ! -d "$resized_transparent" ]]; then
  # Create resized transparent directory
  mkdir "$resized_transparent"
fi

# Check if "Black-Fill" directory exists (Create if it doesn't)
if [[ ! -d "$black_fill_dir" ]]; then
  # Create black_fill directory
  mkdir "$black_fill_dir"
fi

# Check if "White-Background" directory exists (Create if it doesn't)
if [[ ! -d "$white_background_dir" ]]; then
  # Create White background directory
  mkdir "$white_background_dir"
fi

# Check if "Colorized" directory exists (Create if it doesn't)
if [[ ! -d "$colorized_dir" ]]; then
  # Create Colorized directory
  mkdir "$colorized_dir"
fi

# Check if "GIF" directory exists (Create if it doesn't)
if [[ ! -d "$gif_dir" ]]; then
  # Create GIF directory
  mkdir "$gif_dir"
fi

# Check if "Tablet" directory exists (Create if it doesn't)
if [[ ! -d "$tablet_dir" ]]; then
  # Create tablet directory
  mkdir "$tablet_dir"
fi

# Create temp directory
if [[ ! -d "$temp_dir" ]]; then
  # Create temp directory
  mkdir "$temp_dir"
fi
##################
# Define options #
##################
# AIO - Perform all tasks
opt1="Perform All Tasks"

# AIO - Perform all tasks (Single file - Mirrored)
opt2="Perform All Tasks - Single File (Mirrored)"

# Remove background and resize
opt3="Remove Background And Resize"

# Fill all visible color in decal to black
opt4="Fill All Visible Color With black"

# Put decal on white background
opt5="Put Decal On White Background"

# Colorize decal
opt6="Colorize Decals"

# Convert decal to GIF
opt7="Convert To GIF"

# Create tablet images
opt8="Create Tablet Images"

# Clean decal directories - delete files from within directories
opt9="Clean Decal Directories"

# Help - Options, Usage, Info
opt10="Help - Options / Usage / Info"

# Single conversion
opt11="Single Conversion"

# Multiple conversion
opt12="Multiple Conversion"
#############
# Functions #
#############
########################################################
# Create function all_tasks_single - Perform all tasks #
########################################################
all_tasks_single () {
# Get number to increment progress bar by (45 actions / 99)
increment="2.357142857"

# Set initial percentage
percentage="0"

# Select the single decal file to be converted to png format
input_file=$(zenity --file-selection --filename="${HOME}/Desktop/" --title="Select the source decal")

# If the user selects the "cancel" button, close the script
if [[ "$?" == "1" ]]; then
  # Remove temp directory
  rm -rf "$temp_dir"
  exit
fi

# Remove path from "$input_file"
input_file_no_path=$(basename "${input_file}")

# Get new percentage (task 1 - backup original decal)
percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

# Create new percentage without decimal
percentage_new="${percentage%%.*}"

# If percentage is empty, make it "0"
if [[ "$percentage_new" == "" ]]; then
  percentage_new="0"
fi

# Echo percentage to zenity progress
echo "$percentage_new" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: Creating backup\n\nCopying: ${input_file} to \"Original\" directory\n\n${percentage_new}%" ; sleep 0.2

# Copy input file to "original" directory (create backup)
cp "$input_file" "$original_dir"

# Remove path and extension from input directory
input_file_no_path_or_ext="$(basename "${input_file%.*}")"

# Convert to jpg,bmp,svg,png to remove background(task 2 - remove background)
# Get new percentage
percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

# Create new percentage without decimal
percentage_new="${percentage%%.*}"

# If percentage is empty, make it "0"
if [[ "$percentage_new" == "" ]]; then
  percentage_new="0"
fi

# Echo percentage to zenity progress
echo "$percentage_new" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: Remove background\n\nRemoving background from: ${input_file_no_path}\n\n${percentage_new}%" ; sleep 0.2

# Get new percentage
echo percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

# Create new percentage without decimal
percentage_new="${percentage%%.*}"

# If percentage is empty, make it "0"
if [[ "$percentage_new" == "" ]]; then
  percentage_new="0"
fi

# Echo percentage to zenity progress
echo "$percentage_new" ; sleep 0.2

# Check if image is transparent
transparency_check=$(identify -format %A "$input_file")

# If the file contains transparency
if [[ "$transparency_check" == "True" ]]; then
  # Convert decal to jpg
  convert "$input_file" -sharpen 0x -background white -alpha remove -alpha off "${temp_dir}/${input_file_no_path_or_ext}.jpg"
else
  # Convert decal tp jpg
  convert "$input_file" -sharpen 0x "${temp_dir}/${input_file_no_path_or_ext}.jpg"
fi

# Convert decal to pgm"
convert "${temp_dir}/${input_file_no_path_or_ext}.jpg" "${temp_dir}/${input_file_no_path_or_ext}.pgm"

# Convert bmp to svg
potrace --svg "${temp_dir}/${input_file_no_path_or_ext}.pgm" -o "${temp_dir}/${input_file_no_path_or_ext}.svg"

# Convert svg to png
mogrify -background none -density 500 -format png "${temp_dir}/${input_file_no_path_or_ext}.svg"

# Get input image width
input_file_width="$(identify -format "%w" "${temp_dir}/${input_file_no_path_or_ext}.png")"

# Get input image height
input_file_height="$(identify -format "%h" "${temp_dir}/${input_file_no_path_or_ext}.png")"

# Resize larger image dimension to 750px, and then paste onto 800x800 transparent background in temp directory
# Get new percentage (task 3 - resize)
percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

# Create new percentage without decimal
percentage_new="${percentage%%.*}"

# If percentage is empty, make it "0"
if [[ "$percentage_new" == "" ]]; then
  percentage_new="0"
fi

# Echo percentage to zenity progress
echo "$percentage_new" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: Resizing Decal\n\Resizing: ${input_file_no_path_or_ext}.png\n\n${percentage_new}%" ; sleep 0.2

# Resize based on larger dimension
if [[ "$input_file_width" -ge "$input_file_height" ]]; then
  convert "${temp_dir}/${input_file_no_path_or_ext}.png" -resize 750x -background transparent -gravity center -extent 800x800 "${temp_dir}/${input_file_no_path_or_ext}_resized.png"
else
  convert "${temp_dir}/${input_file_no_path_or_ext}.png" -resize x750 -background transparent -gravity center -extent 800x800 "${temp_dir}/${input_file_no_path_or_ext}_resized.png"
fi

# Move resized-transparent file from temp directory to resized-transparent directory
cp "${temp_dir}/${input_file_no_path_or_ext}_resized.png" "${resized_transparent}/${input_file_no_path_or_ext}.png"

# Fill visible color with black
# Reassign input_file_new variable to "${resized_transparent}/${input_file_no_path_or_ext}.png"
input_file_new="${resized_transparent}/${input_file_no_path_or_ext}.png"

# Reassign basename of input_file with no extension
input_file_no_path_or_ext="$(basename "${input_file_new%.*}")"

# Get new percentage (task 4 - black fill)
percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

# Create new percentage without decimal
percentage_new="${percentage%%.*}"

# If percentage is empty, make it "0"
if [[ "$percentage_new" == "" ]]; then
  percentage_new="0"
fi

# Echo percentage to zenity progress
echo "$percentage_new" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: Fill all visible color with black\n\nConverting: ${input_file_no_path_or_ext}.png\n\n${percentage_new}%" ; sleep 0.2

# Fill png with black, and add to Black-Fill directory
convert "$input_file_new" -fill "#000000" -colorize "100" "${black_fill_dir}/${input_file_no_path_or_ext}.png" 2>/dev/null

# White background
# Reassign input_file_new variable to "${black_fill_dir}/${input_file_no_path_or_ext}.png"
input_file_new="${black_fill_dir}/${input_file_no_path_or_ext}.png"

# Reassign basename of input_file with no extension
input_file_no_path_or_ext="$(basename "${input_file_new%.*}")"

# Get new percentage (task 5 - white background)
percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

# Create new percentage without decimal
percentage_new="${percentage%%.*}"

# If percentage is empty, make it "0"
if [[ "$percentage_new" == "" ]]; then
  percentage_new="0"
fi

# Echo percentage to zenity progress
echo "$percentage_new" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: White Background\n\nConverting: ${input_file_no_path_or_ext}.png\n\n${percentage_new}%" ; sleep 0.2

# Convert decal to white background
convert "$input_file_new" -background white -alpha remove -alpha off "${white_background_dir}/${input_file_no_path_or_ext}.png"

# Colorize
# Reassign input_file_new variable to "${black_fill_dir}/${input_file_no_path_or_ext}.png"
input_file_new="${black_fill_dir}/${input_file_no_path_or_ext}.png"

# Reassign basename of input_file with no extension
input_file_no_path_or_ext="$(basename "${input_file_new%.*}")"

# Create directory with decal name in colorized
mkdir "${colorized_dir}/${input_file_no_path_or_ext}"

# Create and compress white image
# Get new percentage (task 6 - colorize white)
percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

# Create new percentage without decimal
percentage_new="${percentage%%.*}"

# If percentage is empty, make it "0"
if [[ "$percentage_new" == "" ]]; then
  percentage_new="0"
fi

# Echo percentage to zenity progress
echo "$percentage_new" ; sleep 0.2

#Echo text to zenity progress
echo "# Task: Colorize\n\nCreating: ${input_file_no_path_or_ext}-White.png\n\n${percentage_new}%" ; sleep 0.2

# Convert decal to white
convert "$input_file_new" -fill "#ffffff" -colorize "100" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-White.png"

# Get new percentage (task 7 - compress white image)
percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

# Create new percentage without decimal
percentage_new="${percentage%%.*}"

# If percentage is empty, make it "0"
if [[ "$percentage_new" == "" ]]; then
  percentage_new="0"
fi

# Echo percentage to zenity progress
echo "$percentage_new" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: Colorize\n\nCompressing: ${input_file_no_path_or_ext}-White.png\n\n${percentage_new}%" ; sleep 0.2

# Compress white decal
pngquant --force --quality=60-100 --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-White.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-White.png"

# Create and compress black image
# Get new percentage (task 8 - colorize black)
percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

# Create new percentage without decimal
percentage_new="${percentage%%.*}"

# If percentage is empty, make it "0"
if [[ "$percentage_new" == "" ]]; then
  percentage_new="0"
fi

# Echo percentage to zenity progress
echo "$percentage_new" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: Colorize\n\nCreating: ${input_file_no_path_or_ext}-Black.png\n\n${percentage_new}%" ; sleep 0.2

# Convert decal to black
convert "$input_file_new" -fill "#000000" -colorize "100" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Black.png"

# Get new percentage (task 9 - compress black)
percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

# Create new percentage without decimal
percentage_new="${percentage%%.*}"

# If percentage is empty, make it "0"
if [[ "$percentage_new" == "" ]]; then
  percentage_new="0"
fi

# Echo percentage to zenity progress
echo "$percentage_new" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: Colorize\n\nCompressing: ${input_file_no_path_or_ext}-Black.png\n\n${percentage_new}%" ; sleep 0.2

# Compress black decal
pngquant --force --quality=60-100 --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Black.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Black.png"

# Create and compress Blue image
# Get new percentage (task 10 - colorize blue)
percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

# Create new percentage without decimal
percentage_new="${percentage%%.*}"

# If percentage is empty, make it "0"
if [[ "$percentage_new" == "" ]]; then
  percentage_new="0"
fi

# Echo percentage to zenity progress
echo "$percentage_new" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: Colorize\n\nCreating: ${input_file_no_path_or_ext}-Blue.png\n\n${percentage_new}%" ; sleep 0.2

# Convert decal to blue
convert "$input_file_new" -fill "#1791d8" -colorize "100" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Blue.png"

# Get new percentage (task 11 - compress blue)
percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

# Create new percentage without decimal
percentage_new="${percentage%%.*}"

# If percentage is empty, make it "0"
if [[ "$percentage_new" == "" ]]; then
  percentage_new="0"
fi

# Echo percentage to zenity progress
echo "$percentage_new" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: Colorize\n\nCompressing: ${input_file_no_path_or_ext}-Blue.png\n\n${percentage_new}%" ; sleep 0.2

# Compress blue decal
pngquant --force --quality=60-100 --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Blue.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Blue.png"

# Create and compress Teal image
# Get new percentage (task 12 - colorize teal)
percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

# Create new percentage without decimal
percentage_new="${percentage%%.*}"

# If percentage is empty, make it "0"
if [[ "$percentage_new" == "" ]]; then
  percentage_new="0"
fi

# Echo percentage to zenity progress
echo "$percentage_new" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: Colorize\n\nCreating: ${input_file_no_path_or_ext}-Teal.png\n\n${percentage_new}%" ; sleep 0.2

# Convert decal to teal
convert "$input_file_new" -fill "#29bbc8" -colorize "100" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Teal.png"

# Get new percentage (task 13 - compress teal)
percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

# Echo percentage to zenity progress
echo "$percentage_new" ; sleep 0.2

# Create percentage without decimal
percentage_new="${percentage%%.*}"

# Echo text to zenity progress
echo "# Task: Colorize\n\nCompressing: ${input_file_no_path_or_ext}-Teal.png\n\n${percentage_new}%" ; sleep 0.2

# Compress teal decal
pngquant --force --quality=60-100 --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Teal.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Teal.png"

# Create and compress Red image
# Get new percentage (task 14 - colorize red)
percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

# Create new percentage without decimal
percentage_new="${percentage%%.*}"

# If percentage is empty, make it "0"
if [[ "$percentage_new" == "" ]]; then
  percentage_new="0"
fi

# Echo percentage to zenity progress
echo "$percentage_new" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: Colorize\n\nCreating: ${input_file_no_path_or_ext}-Red.png\n\n${percentage_new}%" ; sleep 0.2

# Convert decal to red
convert "$input_file_new" -fill "#a01922" -colorize "100" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Red.png"

# Get new percentage (task 15 - compress red)
percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

# Create new percentage without decimal
percentage_new="${percentage%%.*}"

# If percentage is empty, make it "0"
if [[ "$percentage_new" == "" ]]; then
  percentage_new="0"
fi

# Echo percentage to zenity progress
echo "$percentage_new" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: Colorize\n\nCompressing: ${input_file_no_path_or_ext}-Red.png\n\n${percentage_new}%" ; sleep 0.2

# Compress red decal
pngquant --force --quality=60-100 --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Red.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Red.png"

# Create and compress Green image
# Get new percentage (task 16 - colorize green)
percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

# Create new percentage without decimal
percentage_new="${percentage%%.*}"

# If percentage is empty, make it "0"
if [[ "$percentage_new" == "" ]]; then
  percentage_new="0"
fi

# Echo percentage to zenity progress
echo "$percentage_new" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: Colorize\n\nCreating: ${input_file_no_path_or_ext}-Green.png\n\n${percentage_new}%" ; sleep 0.2

# Convert decal to green
convert "$input_file_new" -fill "#008c35" -colorize "100" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Green.png"

# Get new percentage (task 17 - compress green)
percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

# Create new percentage without decimal
percentage_new="${percentage%%.*}"

# If percentage is empty, make it "0"
if [[ "$percentage_new" == "" ]]; then
  percentage_new="0"
fi

# Echo percentage to zenity progress
echo "$percentage_new" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: Colorize\n\nCompressing: ${input_file_no_path_or_ext}-Green.png\n\n${percentage_new}%" ; sleep 0.2

# Compress green decal
pngquant --force --quality=60-100 --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Green.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Green.png"

# Create and compress Silver image
# Get new percentage (task 18 - colorize silver)
percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

# Create new percentage without decimal
percentage_new="${percentage%%.*}"

# If percentage is empty, make it "0"
if [[ "$percentage_new" == "" ]]; then
  percentage_new="0"
fi

# Echo percentage to zenity progress
echo "$percentage_new" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: Colorize\n\nCreating: ${input_file_no_path_or_ext}-Silver.png\n\n${percentage_new}%" ; sleep 0.2

# Convert decal to silver
convert "$input_file_new" -fill "#928F98" -colorize "100" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Silver.png"

# Get new percentage (task 19 - compress silver)
percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

# Create new percentage without decimal
percentage_new="${percentage%%.*}"

# If percentage is empty, make it "0"
if [[ "$percentage_new" == "" ]]; then
  percentage_new="0"
fi

# Echo percentage to zenity progress
echo "$percentage_new" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: Colorize\n\nCompressing: ${input_file_no_path_or_ext}-Silver.png\n\n${percentage_new}%" ; sleep 0.2

# Compress silver decal
pngquant --force --quality=60-100 --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Silver.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Silver.png"

# Create and compress Pink image
# Get new percentage (task 20 - colorize pink)
percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

# Create new percentage without decimal
percentage_new="${percentage%%.*}"

# If percentage is empty, make it "0"
if [[ "$percentage_new" == "" ]]; then
  percentage_new="0"
fi

# Echo percentage to zenity progress
echo "$percentage_new" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: Colorize\n\nCreating: ${input_file_no_path_or_ext}-Pink.png\n\n${percentage_new}%" ; sleep 0.2

# Convert decal to pink
convert "$input_file_new" -fill "#FFADE5" -colorize "100" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Pink.png"

# Get new percentage (task 21 - compress pink)
percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

# Create new percentage without decimal
percentage_new="${percentage%%.*}"

# If percentage is empty, make it "0"
if [[ "$percentage_new" == "" ]]; then
  percentage_new="0"
fi

# Echo percentage to zenity progress
echo "$percentage_new" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: Colorize\n\nCompressing: ${input_file_no_path_or_ext}-Pink.png\n\n${percentage_new}%" ; sleep 0.2

# Compress pink decal
pngquant --force --quality=60-100 --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Pink.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Pink.png"

# Create and compress purple image
# Get new percentage (task 22 - colorize purple)
percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

# Create new percentage without decimal
percentage_new="${percentage%%.*}"

# If percentage is empty, make it "0"
if [[ "$percentage_new" == "" ]]; then
  percentage_new="0"
fi

# Echo percentage to zenity progress
echo "$percentage_new" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: Colorize\n\nCreating: ${input_file_no_path_or_ext}-Purple.png\n\n${percentage_new}%" ; sleep 0.2

# Convert decal to purple
convert "$input_file_new" -fill "#452167" -colorize "100" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Purple.png"

# Get new percentage (task 23 - compress purple)
percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

# Create new percentage without decimal
percentage_new="${percentage%%.*}"

# If percentage is empty, make it "0"
if [[ "$percentage_new" == "" ]]; then
  percentage_new="0"
fi

# Echo percentage to zenity progress
echo "$percentage_new" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: Colorize\n\nCompressing: ${input_file_no_path_or_ext}-Purple.png\n\n${percentage_new}%" ; sleep 0.2

# Compress purple decal
pngquant --force --quality=60-100 --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Purple.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Purple.png"

# Create and compress Dark-Blue image
# Get new percentage (task 24 - colorize dark blue)
percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

# Create new percentage without decimal
percentage_new="${percentage%%.*}"

# If percentage is empty, make it "0"
if [[ "$percentage_new" == "" ]]; then
  percentage_new="0"
fi

# Echo percentage to zenity progress
echo "$percentage_new" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: Colorize\n\nCreating: ${input_file_no_path_or_ext}-Dark-Blue.png\n\n${percentage_new}%" ; sleep 0.2

# Convert decal to dark-blue
convert "$input_file_new" -fill "#003478" -colorize "100" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Dark-Blue.png"

# Get new percentage (task 25 - compress dark blue)
percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

# Create new percentage without decimal
percentage_new="${percentage%%.*}"

# If percentage is empty, make it "0"
if [[ "$percentage_new" == "" ]]; then
  percentage_new="0"
fi

# Echo percentage to zenity progress
echo "$percentage_new" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: Colorize\n\nCompressing: ${input_file_no_path_or_ext}-Dark-Blue\n\n${percentage_new}%" ; sleep 0.2

# Compress dark-blue decal
pngquant --force --quality=60-100 --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Dark-Blue.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Dark-Blue.png"

# Create and compress Orange image
# Get percentage (task 26 - colorize orange)
percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

# Create new percentage without decimal
percentage_new="${percentage%%.*}"

# If percentage is empty, make it "0"
if [[ "$percentage_new" == "" ]]; then
  percentage_new="0"
fi

# Echo percentage to zenity progress
echo "$percentage_new" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: Colorize\n\nCreating: ${input_file_no_path_or_ext}-Orange.png\n\n${percentage_new}%" ; sleep 0.2

# Convert decal to orange
convert "$input_file_new" -fill "#d56f31" -colorize "100" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Orange.png"

# Get new percentage (task 27 - compress orange)
percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

# Create new percentage without decimal
percentage_new="${percentage%%.*}"

# If percentage is empty, make it "0"
if [[ "$percentage_new" == "" ]]; then
  percentage_new="0"
fi

# Echo percentage to zenity progress
echo "$percentage_new" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: Colorize\n\nCompressing: ${input_file_no_path_or_ext}-Orange.png\n\n${percentage_new}%" ; sleep 0.2

# Compress orange decal
pngquant --force --quality=60-100 --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Orange.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Orange.png"

# Create and compress Yellow image
# Get new percentage (task 28 - colorize yellow)
percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

# Create new percentage without decimal
percentage_new="${percentage%%.*}"

# If percentage is empty, make it "0"
if [[ "$percentage_new" == "" ]]; then
  percentage_new="0"
fi

# Echo percentage to zenity progress
echo "$percentage_new" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: Colorize\n\nCreating: ${input_file_no_path_or_ext}-Yellow.png\n\n${percentage_new}%" ; sleep 0.2

# Convert decal to yellow
convert "$input_file_new" -fill "#f3e11f" -colorize "100" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Yellow.png"

# Get new percentage (task 29 - compress yellow)
percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

# Create new percentage without decimal
percentage_new="${percentage%%.*}"

# If percentage is empty, make it "0"
if [[ "$percentage_new" == "" ]]; then
  percentage_new="0"
fi

# Echo percentage to zenity progress
echo "$percentage_new" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: Colorize\n\nCompressing: ${input_file_no_path_or_ext}-Yellow.png\n\n${percentage_new}%" ; sleep 0.2

# Compress yellow decal
pngquant --force --quality=60-100 --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Yellow.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Yellow.png"

# Create and compress Neon-Green image
# Get new percentage (task 30 - colorize neon green)
percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

# Create new percentage without decimal
percentage_new="${percentage%%.*}"

# If percentage is empty, make it "0"
if [[ "$percentage_new" == "" ]]; then
  percentage_new="0"
fi

# Echo percentage to zenity progress
echo "$percentage_new" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: Colorize\n\nCreating: ${input_file_no_path_or_ext}-Neon-Green.png\n\n${percentage_new}%" ; sleep 0.2

# Convert decal to neon-green
convert "$input_file_new" -fill "#39FF14" -colorize "100" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Neon-Green.png"

# Get new percentage (task 31 - compress neon-green)
percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

# Create new percentage without decimal
percentage_new="${percentage%%.*}"

# If percentage is empty, make it "0"
if [[ "$percentage_new" == "" ]]; then
  percentage_new="0"
fi

# Echo percentage to zenity progress
echo "$percentage_new" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: Colorize\n\nCompressing: ${input_file_no_path_or_ext}-Neon-Green.png\n\n${percentage_new}%" ; sleep 0.2

# Compress neon-green decal
pngquant --force --quality=60-100 --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Neon-Green.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Neon-Green.png"

# GIF
# Assign input_dir variable to "${colorized_dir}/${input_file_no_path_or_ext}"
input_dir="${colorized_dir}/${input_file_no_path_or_ext}"

# Get new percentage (task 32 - gif)
percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

# Create new percentage without decimal
percentage_new="${percentage%%.*}"

# If percentage is empty, make it "0"
if [[ "$percentage_new" == "" ]]; then
  percentage_new="0"
fi

# Echo percentage to zenity progress
echo "$percentage_new" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: Creating GIF\n\nCreating: ${input_file_no_path_or_ext}.gif\n\n${percentage_new}%" ; sleep 0.2

# Convert decal to GIF
convert -dispose previous -delay 100 -loop 0 "${input_dir}/*.png" "${gif_dir}/${input_file_no_path_or_ext}.gif"

# Tablet (add 13 tasks - 45 total)
for decal in "${colorized_dir}/${input_file_no_path_or_ext}"/*.png ; do

  # Get decal basename
  decal_basename="$(basename "${decal}")"

  # Get new percentage
  percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

  # Create new percentage without decimal
  percentage_new="${percentage%%.*}"

  # If percentage is empty, make it "0"
  if [[ "$percentage_new" == "" ]]; then
    percentage_new="0"
  fi

  # Echo percentage to zenity progress
  echo "$percentage_new" ; sleep 0.2

  # Echo text to zenity progress
  echo "# Task: Creating tablet image\n\nCreating: ${decal_basename}\n\n${percentage_new}%" ; sleep 0.2

  # Create tablet images
  composite "$decal" "/usr/share/decal-converter/bg-tablet.png" -gravity Center -quality 95 "${tablet_dir}/${decal_basename}"
done

# Echo percentage to zenity progress
echo "100" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: All tasks finished\n\n100%" ; sleep 2
}
#################################################################
# Create function all_tasks_single_mirrored - Perform all tasks #
#################################################################
all_tasks_single_mirrored () {
# Get number to increment progress bar by (45 actions / 99)
increment="2.357142857"

# Set initial percentage
percentage="0"

# Select the single decal file to be converted to png format
input_file=$(zenity --file-selection --filename="${HOME}/Desktop/" --title="Select the source decal")

# If the user selects the "cancel" button, close the script
if [[ "$?" == "1" ]]; then
  # Remove temp directory
  rm -rf "$temp_dir"
  exit
fi

# Remove path from "$input_file"
input_file_no_path=$(basename "${input_file}")

# Get new percentage (task 1 - backup original decal)
percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

# Create new percentage without decimal
percentage_new="${percentage%%.*}"

# If percentage is empty, make it "0"
if [[ "$percentage_new" == "" ]]; then
  percentage_new="0"
fi

# Echo percentage to zenity progress
echo "$percentage_new" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: Creating backup\n\nCopying: ${input_file} to \"Original\" directory\n\n${percentage_new}%" ; sleep 0.2

# Copy input file to "original" directory (create backup)
cp "$input_file" "$original_dir"

# Remove path and extension from input directory
input_file_no_path_or_ext="$(basename "${input_file%.*}")"

# Convert to jpg,bmp,svg,png to remove background(task 2 - remove background)
# Get new percentage
percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

# Create new percentage without decimal
percentage_new="${percentage%%.*}"

# If percentage is empty, make it "0"
if [[ "$percentage_new" == "" ]]; then
  percentage_new="0"
fi

# Echo percentage to zenity progress
echo "$percentage_new" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: Remove background\n\nRemoving background from: ${input_file_no_path}\n\n${percentage_new}%" ; sleep 0.2

# Get new percentage
echo percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

# Create new percentage without decimal
percentage_new="${percentage%%.*}"

# If percentage is empty, make it "0"
if [[ "$percentage_new" == "" ]]; then
  percentage_new="0"
fi

# Echo percentage to zenity progress
echo "$percentage_new" ; sleep 0.2

# Check if image is transparent
transparency_check=$(identify -format %A "$input_file")

# If the file contains transparency
if [[ "$transparency_check" == "True" ]]; then
  # Convert decal to jpg
  convert "$input_file" -sharpen 0x -background white -alpha remove -alpha off -flop "${temp_dir}/${input_file_no_path_or_ext}.jpg"
else
  # Convert decal tp jpg
  convert "$input_file" -sharpen 0x -flop "${temp_dir}/${input_file_no_path_or_ext}.jpg"
fi

# Convert decal to pgm"
convert "${temp_dir}/${input_file_no_path_or_ext}.jpg" "${temp_dir}/${input_file_no_path_or_ext}.pgm"

# Convert bmp to svg
potrace --svg "${temp_dir}/${input_file_no_path_or_ext}.pgm" -o "${temp_dir}/${input_file_no_path_or_ext}.svg"

# Convert svg to png
mogrify -background none -density 500 -format png "${temp_dir}/${input_file_no_path_or_ext}.svg"

# Get input image width
input_file_width="$(identify -format "%w" "${temp_dir}/${input_file_no_path_or_ext}.png")"

# Get input image height
input_file_height="$(identify -format "%h" "${temp_dir}/${input_file_no_path_or_ext}.png")"

# Resize larger image dimension to 750px, and then paste onto 800x800 transparent background in temp directory
# Get new percentage (task 3 - resize)
percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

# Create new percentage without decimal
percentage_new="${percentage%%.*}"

# If percentage is empty, make it "0"
if [[ "$percentage_new" == "" ]]; then
  percentage_new="0"
fi

# Echo percentage to zenity progress
echo "$percentage_new" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: Resizing Decal\n\Resizing: ${input_file_no_path_or_ext}.png\n\n${percentage_new}%" ; sleep 0.2

# Resize based on larger dimension
if [[ "$input_file_width" -ge "$input_file_height" ]]; then
  convert "${temp_dir}/${input_file_no_path_or_ext}.png" -resize 750x -background transparent -gravity center -extent 800x800 "${temp_dir}/${input_file_no_path_or_ext}_resized.png"
else
  convert "${temp_dir}/${input_file_no_path_or_ext}.png" -resize x750 -background transparent -gravity center -extent 800x800 "${temp_dir}/${input_file_no_path_or_ext}_resized.png"
fi

# Move resized-transparent file from temp directory to resized-transparent directory
cp "${temp_dir}/${input_file_no_path_or_ext}_resized.png" "${resized_transparent}/${input_file_no_path_or_ext}-Mirrored.png"

# Fill visible color with black
# Reassign input_file_new variable to "${resized_transparent}/${input_file_no_path_or_ext}.png"
input_file_new="${resized_transparent}/${input_file_no_path_or_ext}-Mirrored.png"

# Reassign basename of input_file with no extension
input_file_no_path_or_ext="$(basename "${input_file_new%.*}")"

# Get new percentage (task 4 - black fill)
percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

# Create new percentage without decimal
percentage_new="${percentage%%.*}"

# If percentage is empty, make it "0"
if [[ "$percentage_new" == "" ]]; then
  percentage_new="0"
fi

# Echo percentage to zenity progress
echo "$percentage_new" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: Fill all visible color with black\n\nConverting: ${input_file_no_path_or_ext}.png\n\n${percentage_new}%" ; sleep 0.2

# Fill png with black, and add to Black-Fill directory
convert "$input_file_new" -fill "#000000" -colorize "100" "${black_fill_dir}/${input_file_no_path_or_ext}.png" 2>/dev/null

# White background
# Reassign input_file_new variable to "${black_fill_dir}/${input_file_no_path_or_ext}.png"
input_file_new="${black_fill_dir}/${input_file_no_path_or_ext}.png"

# Reassign basename of input_file with no extension
input_file_no_path_or_ext="$(basename "${input_file_new%.*}")"

# Get new percentage (task 5 - white background)
percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

# Create new percentage without decimal
percentage_new="${percentage%%.*}"

# If percentage is empty, make it "0"
if [[ "$percentage_new" == "" ]]; then
  percentage_new="0"
fi

# Echo percentage to zenity progress
echo "$percentage_new" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: White Background\n\nConverting: ${input_file_no_path_or_ext}.png\n\n${percentage_new}%" ; sleep 0.2

# Convert decal to white background
convert "$input_file_new" -background white -alpha remove -alpha off "${white_background_dir}/${input_file_no_path_or_ext}.png"

# Colorize
# Reassign input_file_new variable to "${black_fill_dir}/${input_file_no_path_or_ext}.png"
input_file_new="${black_fill_dir}/${input_file_no_path_or_ext}.png"

# Reassign basename of input_file with no extension
input_file_no_path_or_ext="$(basename "${input_file_new%.*}")"

# Create directory with decal name in colorized
mkdir "${colorized_dir}/${input_file_no_path_or_ext}"

# Create and compress white image
# Get new percentage (task 6 - colorize white)
percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

# Create new percentage without decimal
percentage_new="${percentage%%.*}"

# If percentage is empty, make it "0"
if [[ "$percentage_new" == "" ]]; then
  percentage_new="0"
fi

# Echo percentage to zenity progress
echo "$percentage_new" ; sleep 0.2

#Echo text to zenity progress
echo "# Task: Colorize\n\nCreating: ${input_file_no_path_or_ext}-White.png\n\n${percentage_new}%" ; sleep 0.2

# Convert decal to white
convert "$input_file_new" -fill "#ffffff" -colorize "100" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-White.png"

# Get new percentage (task 7 - compress white image)
percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

# Create new percentage without decimal
percentage_new="${percentage%%.*}"

# If percentage is empty, make it "0"
if [[ "$percentage_new" == "" ]]; then
  percentage_new="0"
fi

# Echo percentage to zenity progress
echo "$percentage_new" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: Colorize\n\nCompressing: ${input_file_no_path_or_ext}-White.png\n\n${percentage_new}%" ; sleep 0.2

# Compress white decal
pngquant --force --quality=60-100 --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-White.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-White.png"

# Create and compress black image
# Get new percentage (task 8 - colorize black)
percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

# Create new percentage without decimal
percentage_new="${percentage%%.*}"

# If percentage is empty, make it "0"
if [[ "$percentage_new" == "" ]]; then
  percentage_new="0"
fi

# Echo percentage to zenity progress
echo "$percentage_new" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: Colorize\n\nCreating: ${input_file_no_path_or_ext}-Black.png\n\n${percentage_new}%" ; sleep 0.2

# Convert decal to black
convert "$input_file_new" -fill "#000000" -colorize "100" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Black.png"

# Get new percentage (task 9 - compress black)
percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

# Create new percentage without decimal
percentage_new="${percentage%%.*}"

# If percentage is empty, make it "0"
if [[ "$percentage_new" == "" ]]; then
  percentage_new="0"
fi

# Echo percentage to zenity progress
echo "$percentage_new" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: Colorize\n\nCompressing: ${input_file_no_path_or_ext}-Black.png\n\n${percentage_new}%" ; sleep 0.2

# Compress black decal
pngquant --force --quality=60-100 --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Black.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Black.png"

# Create and compress Blue image
# Get new percentage (task 10 - colorize blue)
percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

# Create new percentage without decimal
percentage_new="${percentage%%.*}"

# If percentage is empty, make it "0"
if [[ "$percentage_new" == "" ]]; then
  percentage_new="0"
fi

# Echo percentage to zenity progress
echo "$percentage_new" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: Colorize\n\nCreating: ${input_file_no_path_or_ext}-Blue.png\n\n${percentage_new}%" ; sleep 0.2

# Convert decal to blue
convert "$input_file_new" -fill "#1791d8" -colorize "100" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Blue.png"

# Get new percentage (task 11 - compress blue)
percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

# Create new percentage without decimal
percentage_new="${percentage%%.*}"

# If percentage is empty, make it "0"
if [[ "$percentage_new" == "" ]]; then
  percentage_new="0"
fi

# Echo percentage to zenity progress
echo "$percentage_new" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: Colorize\n\nCompressing: ${input_file_no_path_or_ext}-Blue.png\n\n${percentage_new}%" ; sleep 0.2

# Compress blue decal
pngquant --force --quality=60-100 --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Blue.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Blue.png"

# Create and compress Teal image
# Get new percentage (task 12 - colorize teal)
percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

# Create new percentage without decimal
percentage_new="${percentage%%.*}"

# If percentage is empty, make it "0"
if [[ "$percentage_new" == "" ]]; then
  percentage_new="0"
fi

# Echo percentage to zenity progress
echo "$percentage_new" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: Colorize\n\nCreating: ${input_file_no_path_or_ext}-Teal.png\n\n${percentage_new}%" ; sleep 0.2

# Convert decal to teal
convert "$input_file_new" -fill "#29bbc8" -colorize "100" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Teal.png"

# Get new percentage (task 13 - compress teal)
percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

# Echo percentage to zenity progress
echo "$percentage_new" ; sleep 0.2

# Create percentage without decimal
percentage_new="${percentage%%.*}"

# Echo text to zenity progress
echo "# Task: Colorize\n\nCompressing: ${input_file_no_path_or_ext}-Teal.png\n\n${percentage_new}%" ; sleep 0.2

# Compress teal decal
pngquant --force --quality=60-100 --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Teal.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Teal.png"

# Create and compress Red image
# Get new percentage (task 14 - colorize red)
percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

# Create new percentage without decimal
percentage_new="${percentage%%.*}"

# If percentage is empty, make it "0"
if [[ "$percentage_new" == "" ]]; then
  percentage_new="0"
fi

# Echo percentage to zenity progress
echo "$percentage_new" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: Colorize\n\nCreating: ${input_file_no_path_or_ext}-Red.png\n\n${percentage_new}%" ; sleep 0.2

# Convert decal to red
convert "$input_file_new" -fill "#a01922" -colorize "100" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Red.png"

# Get new percentage (task 15 - compress red)
percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

# Create new percentage without decimal
percentage_new="${percentage%%.*}"

# If percentage is empty, make it "0"
if [[ "$percentage_new" == "" ]]; then
  percentage_new="0"
fi

# Echo percentage to zenity progress
echo "$percentage_new" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: Colorize\n\nCompressing: ${input_file_no_path_or_ext}-Red.png\n\n${percentage_new}%" ; sleep 0.2

# Compress red decal
pngquant --force --quality=60-100 --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Red.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Red.png"

# Create and compress Green image
# Get new percentage (task 16 - colorize green)
percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

# Create new percentage without decimal
percentage_new="${percentage%%.*}"

# If percentage is empty, make it "0"
if [[ "$percentage_new" == "" ]]; then
  percentage_new="0"
fi

# Echo percentage to zenity progress
echo "$percentage_new" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: Colorize\n\nCreating: ${input_file_no_path_or_ext}-Green.png\n\n${percentage_new}%" ; sleep 0.2

# Convert decal to green
convert "$input_file_new" -fill "#008c35" -colorize "100" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Green.png"

# Get new percentage (task 17 - compress green)
percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

# Create new percentage without decimal
percentage_new="${percentage%%.*}"

# If percentage is empty, make it "0"
if [[ "$percentage_new" == "" ]]; then
  percentage_new="0"
fi

# Echo percentage to zenity progress
echo "$percentage_new" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: Colorize\n\nCompressing: ${input_file_no_path_or_ext}-Green.png\n\n${percentage_new}%" ; sleep 0.2

# Compress green decal
pngquant --force --quality=60-100 --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Green.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Green.png"

# Create and compress Silver image
# Get new percentage (task 18 - colorize silver)
percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

# Create new percentage without decimal
percentage_new="${percentage%%.*}"

# If percentage is empty, make it "0"
if [[ "$percentage_new" == "" ]]; then
  percentage_new="0"
fi

# Echo percentage to zenity progress
echo "$percentage_new" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: Colorize\n\nCreating: ${input_file_no_path_or_ext}-Silver.png\n\n${percentage_new}%" ; sleep 0.2

# Convert decal to silver
convert "$input_file_new" -fill "#928F98" -colorize "100" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Silver.png"

# Get new percentage (task 19 - compress silver)
percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

# Create new percentage without decimal
percentage_new="${percentage%%.*}"

# If percentage is empty, make it "0"
if [[ "$percentage_new" == "" ]]; then
  percentage_new="0"
fi

# Echo percentage to zenity progress
echo "$percentage_new" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: Colorize\n\nCompressing: ${input_file_no_path_or_ext}-Silver.png\n\n${percentage_new}%" ; sleep 0.2

# Compress silver decal
pngquant --force --quality=60-100 --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Silver.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Silver.png"

# Create and compress Pink image
# Get new percentage (task 20 - colorize pink)
percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

# Create new percentage without decimal
percentage_new="${percentage%%.*}"

# If percentage is empty, make it "0"
if [[ "$percentage_new" == "" ]]; then
  percentage_new="0"
fi

# Echo percentage to zenity progress
echo "$percentage_new" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: Colorize\n\nCreating: ${input_file_no_path_or_ext}-Pink.png\n\n${percentage_new}%" ; sleep 0.2

# Convert decal to pink
convert "$input_file_new" -fill "#FFADE5" -colorize "100" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Pink.png"

# Get new percentage (task 21 - compress pink)
percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

# Create new percentage without decimal
percentage_new="${percentage%%.*}"

# If percentage is empty, make it "0"
if [[ "$percentage_new" == "" ]]; then
  percentage_new="0"
fi

# Echo percentage to zenity progress
echo "$percentage_new" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: Colorize\n\nCompressing: ${input_file_no_path_or_ext}-Pink.png\n\n${percentage_new}%" ; sleep 0.2

# Compress pink decal
pngquant --force --quality=60-100 --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Pink.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Pink.png"

# Create and compress purple image
# Get new percentage (task 22 - colorize purple)
percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

# Create new percentage without decimal
percentage_new="${percentage%%.*}"

# If percentage is empty, make it "0"
if [[ "$percentage_new" == "" ]]; then
  percentage_new="0"
fi

# Echo percentage to zenity progress
echo "$percentage_new" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: Colorize\n\nCreating: ${input_file_no_path_or_ext}-Purple.png\n\n${percentage_new}%" ; sleep 0.2

# Convert decal to purple
convert "$input_file_new" -fill "#452167" -colorize "100" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Purple.png"

# Get new percentage (task 23 - compress purple)
percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

# Create new percentage without decimal
percentage_new="${percentage%%.*}"

# If percentage is empty, make it "0"
if [[ "$percentage_new" == "" ]]; then
  percentage_new="0"
fi

# Echo percentage to zenity progress
echo "$percentage_new" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: Colorize\n\nCompressing: ${input_file_no_path_or_ext}-Purple.png\n\n${percentage_new}%" ; sleep 0.2

# Compress purple decal
pngquant --force --quality=60-100 --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Purple.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Purple.png"

# Create and compress Dark-Blue image
# Get new percentage (task 24 - colorize dark blue)
percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

# Create new percentage without decimal
percentage_new="${percentage%%.*}"

# If percentage is empty, make it "0"
if [[ "$percentage_new" == "" ]]; then
  percentage_new="0"
fi

# Echo percentage to zenity progress
echo "$percentage_new" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: Colorize\n\nCreating: ${input_file_no_path_or_ext}-Dark-Blue.png\n\n${percentage_new}%" ; sleep 0.2

# Convert decal to dark-blue
convert "$input_file_new" -fill "#003478" -colorize "100" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Dark-Blue.png"

# Get new percentage (task 25 - compress dark blue)
percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

# Create new percentage without decimal
percentage_new="${percentage%%.*}"

# If percentage is empty, make it "0"
if [[ "$percentage_new" == "" ]]; then
  percentage_new="0"
fi

# Echo percentage to zenity progress
echo "$percentage_new" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: Colorize\n\nCompressing: ${input_file_no_path_or_ext}-Dark-Blue\n\n${percentage_new}%" ; sleep 0.2

# Compress dark-blue decal
pngquant --force --quality=60-100 --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Dark-Blue.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Dark-Blue.png"

# Create and compress Orange image
# Get percentage (task 26 - colorize orange)
percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

# Create new percentage without decimal
percentage_new="${percentage%%.*}"

# If percentage is empty, make it "0"
if [[ "$percentage_new" == "" ]]; then
  percentage_new="0"
fi

# Echo percentage to zenity progress
echo "$percentage_new" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: Colorize\n\nCreating: ${input_file_no_path_or_ext}-Orange.png\n\n${percentage_new}%" ; sleep 0.2

# Convert decal to orange
convert "$input_file_new" -fill "#d56f31" -colorize "100" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Orange.png"

# Get new percentage (task 27 - compress orange)
percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

# Create new percentage without decimal
percentage_new="${percentage%%.*}"

# If percentage is empty, make it "0"
if [[ "$percentage_new" == "" ]]; then
  percentage_new="0"
fi

# Echo percentage to zenity progress
echo "$percentage_new" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: Colorize\n\nCompressing: ${input_file_no_path_or_ext}-Orange.png\n\n${percentage_new}%" ; sleep 0.2

# Compress orange decal
pngquant --force --quality=60-100 --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Orange.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Orange.png"

# Create and compress Yellow image
# Get new percentage (task 28 - colorize yellow)
percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

# Create new percentage without decimal
percentage_new="${percentage%%.*}"

# If percentage is empty, make it "0"
if [[ "$percentage_new" == "" ]]; then
  percentage_new="0"
fi

# Echo percentage to zenity progress
echo "$percentage_new" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: Colorize\n\nCreating: ${input_file_no_path_or_ext}-Yellow.png\n\n${percentage_new}%" ; sleep 0.2

# Convert decal to yellow
convert "$input_file_new" -fill "#f3e11f" -colorize "100" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Yellow.png"

# Get new percentage (task 29 - compress yellow)
percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

# Create new percentage without decimal
percentage_new="${percentage%%.*}"

# If percentage is empty, make it "0"
if [[ "$percentage_new" == "" ]]; then
  percentage_new="0"
fi

# Echo percentage to zenity progress
echo "$percentage_new" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: Colorize\n\nCompressing: ${input_file_no_path_or_ext}-Yellow.png\n\n${percentage_new}%" ; sleep 0.2

# Compress yellow decal
pngquant --force --quality=60-100 --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Yellow.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Yellow.png"

# Create and compress Neon-Green image
# Get new percentage (task 30 - colorize neon green)
percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

# Create new percentage without decimal
percentage_new="${percentage%%.*}"

# If percentage is empty, make it "0"
if [[ "$percentage_new" == "" ]]; then
  percentage_new="0"
fi

# Echo percentage to zenity progress
echo "$percentage_new" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: Colorize\n\nCreating: ${input_file_no_path_or_ext}-Neon-Green.png\n\n${percentage_new}%" ; sleep 0.2

# Convert decal to neon-green
convert "$input_file_new" -fill "#39FF14" -colorize "100" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Neon-Green.png"

# Get new percentage (task 31 - compress neon-green)
percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

# Create new percentage without decimal
percentage_new="${percentage%%.*}"

# If percentage is empty, make it "0"
if [[ "$percentage_new" == "" ]]; then
  percentage_new="0"
fi

# Echo percentage to zenity progress
echo "$percentage_new" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: Colorize\n\nCompressing: ${input_file_no_path_or_ext}-Neon-Green.png\n\n${percentage_new}%" ; sleep 0.2

# Compress neon-green decal
pngquant --force --quality=60-100 --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Neon-Green.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Neon-Green.png"

# GIF
# Assign input_dir variable to "${colorized_dir}/${input_file_no_path_or_ext}"
input_dir="${colorized_dir}/${input_file_no_path_or_ext}"

# Get new percentage (task 32 - gif)
percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

# Create new percentage without decimal
percentage_new="${percentage%%.*}"

# If percentage is empty, make it "0"
if [[ "$percentage_new" == "" ]]; then
  percentage_new="0"
fi

# Echo percentage to zenity progress
echo "$percentage_new" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: Creating GIF\n\nCreating: ${input_file_no_path_or_ext}.gif\n\n${percentage_new}%" ; sleep 0.2

# Convert decal to GIF
convert -dispose previous -delay 100 -loop 0 "${input_dir}/*.png" "${gif_dir}/${input_file_no_path_or_ext}.gif"

# Tablet (add 13 tasks - 45 total)
for decal in "${colorized_dir}/${input_file_no_path_or_ext}"/*.png ; do

  # Get decal basename
  decal_basename="$(basename "${decal}")"

  # Get new percentage
  percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

  # Create new percentage without decimal
  percentage_new="${percentage%%.*}"

  # If percentage is empty, make it "0"
  if [[ "$percentage_new" == "" ]]; then
    percentage_new="0"
  fi

  # Echo percentage to zenity progress
  echo "$percentage_new" ; sleep 0.2

  # Echo text to zenity progress
  echo "# Task: Creating tablet image\n\nCreating: ${decal_basename}\n\n${percentage_new}%" ; sleep 0.2

  # Create tablet images
  composite "$decal" "/usr/share/decal-converter/bg-tablet.png" -gravity Center -quality 95 "${tablet_dir}/${decal_basename}"
done

# Echo percentage to zenity progress
echo "100" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: All tasks finished\n\n100%" ; sleep 2
}
##########################################################
# Create function all_tasks_multiple - Perform all tasks #
##########################################################
all_tasks_multiple () {
# Select directory containing decals to convert
input_dir=$(zenity --file-selection --directory --filename="${HOME}/Desktop/" --title="Select the source decals directory")

# If the user selects the "cancel" button, close the script
if [[ "$?" == "1" ]]; then
  # Remove temp directory
  rm -rf "$temp_dir"
  exit
fi

# Set initial percentage
percentage="0"

# get total number of files in input directory
total_files="$(ls "$input_dir" 2> /dev/null | wc -l)"

# Multiply total_files variable
tasks="$(echo "${total_files}*45" | bc)"

# Get number to increment progress bar by (45 actions / 99)
increment="$(echo "scale=2; 99/${tasks}" | bc)"

# Set current decal number in loop
current_decal_number="0"

# Start loop
for decal in $input_dir/*; do

  # Set value for current decal in loop
  ((current_decal_number++))

  # Remove path from "$input_file"
  input_file_no_path="$(basename "${decal}")"

  # Get new percentage (Create backup - task 1)
  percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

  # Create new percentage without decimal
  percentage_new="${percentage%%.*}"

  # If percentage is empty, make it "0"
  if [[ "$percentage_new" == "" ]]; then
    percentage_new="0"
  fi

  # Echo percentage to zenity progress
  echo "$percentage_new" ; sleep 0.2

  # Echo text to zenity progress
  echo "# Task: Creating backup\n\nDecal ${current_decal_number} of ${total_files}\n\nCopying: ${input_file_no_path} to \"Original\" directory\n\n${percentage_new}%" ; sleep 0.2

  # Copy input file to "original" directory
  cp "$decal" "$original_dir"

  # Remove path and extension from input file
  input_file_no_path_or_ext="$(basename "${decal%.*}")"

  # Check if image is transparent
  transparency_check=$(identify -format %A "$decal")

  # If the file contains transparency
  if [[ "$transparency_check" == "True" ]]; then
    # Convert decal to jpg
    convert "$decal" -sharpen 0x -background white -alpha remove -alpha off "${temp_dir}/${input_file_no_path_or_ext}.jpg"
  else
    # Convert decal tp jpg
    convert "$decal" -sharpen 0x "${temp_dir}/${input_file_no_path_or_ext}.jpg"
  fi

  # Convert decal to pgm"
  convert "${temp_dir}/${input_file_no_path_or_ext}.jpg" "${temp_dir}/${input_file_no_path_or_ext}.pgm"

  # Convert bmp to svg
  potrace --svg "${temp_dir}/${input_file_no_path_or_ext}.pgm" -o "${temp_dir}/${input_file_no_path_or_ext}.svg"

  # Convert svg to png
  mogrify -background none -density 500 -format png "${temp_dir}/${input_file_no_path_or_ext}.svg"

  # Get input image width
  input_file_width="$(identify -format "%w" "${temp_dir}/${input_file_no_path_or_ext}.png")"

  # Get new percentage (Remove backgroud - task 2)
  percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

  # Create new percentage without decimal
  percentage_new="${percentage%%.*}"

  # If percentage is empty, make it "0"
  if [[ "$percentage_new" == "" ]]; then
    percentage_new="0"
  fi

  # Echo percentage to zenity progress
  echo "$percentage_new" ; sleep 0.2

  # Echo text to zenity progress
  echo "# Task: Remove Backgroud\n\nDecal ${current_decal_number} of ${total_files}\n\nRemoving background from: ${input_file_no_path_or_ext}\n\n${percentage_new}%" ; sleep 0.2

  # Get input image width
  input_file_width="$(identify -format "%w" "${temp_dir}/${input_file_no_path_or_ext}.png")"

  # Get input image height
  input_file_height="$(identify -format "%h" "${temp_dir}/${input_file_no_path_or_ext}.png")"

  # Resize larger image dimension to 750px, and then paste onto 800x800 transparent background in temp directory
  # Get new percentage (resize - task 3)
  percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

  # Create new percentage without decimal
  percentage_new="${percentage%%.*}"

  # If percentage is empty, make it "0"
  if [[ "$percentage_new" == "" ]]; then
    percentage_new="0"
  fi

  # Echo percentage to zenity progress
  echo "$percentage_new" ; sleep 0.2

  # Echo text to zenity progress
  echo "# Task: Resizing decal\n\nDecal ${current_decal_number} of ${total_files}\n\nResizing: ${input_file_no_path_or_ext}\n\n${percentage_new}%" ; sleep 0.2

  # Resize based on larger dimension
  if [[ "$input_file_width" -ge "$input_file_height" ]]; then
    convert "${temp_dir}/${input_file_no_path_or_ext}.png" -resize 750x -background transparent -gravity center -extent 800x800 "${temp_dir}/${input_file_no_path_or_ext}_resized.png"
  else convert "${temp_dir}/${input_file_no_path_or_ext}.png" -resize x750 -background transparent -gravity center -extent 800x800 "${temp_dir}/${input_file_no_path_or_ext}_resized.png"
  fi

  # Move resized-transparent file from temp directory to resized-transparent directory
  cp "${temp_dir}/${input_file_no_path_or_ext}_resized.png" "${resized_transparent}/${input_file_no_path_or_ext}.png"

  # Fill visible color with black
  # Reassign input_file_new variable to "${resized_transparent}/${input_file_no_path_or_ext}.png"
  input_file_new="${resized_transparent}/${input_file_no_path_or_ext}.png"

  # Reassign basename of input_file with no extension
  input_file_no_path_or_ext="$(basename "${input_file_new%.*}")"

  # Get new percentage (Black fill - task 4)
  percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

  # Create new percentage without decimal
  percentage_new="${percentage%%.*}"

  # If percentage is empty, make it "0"
  if [[ "$percentage_new" == "" ]]; then
    percentage_new="0"
  fi

  # Echo percentage to zenity progress
  echo "$percentage_new" ; sleep 0.2

  # Echo text to zenity progress
  echo "# Task: Fill all visible color with black\n\nDecal ${current_decal_number} of ${total_files}\n\nConverting: ${input_file_no_path_or_ext}.png\n\n${percentage_new}%" ; sleep 0.2

  # Fill png with black, and add to "Black-Fill" directory
  convert "$input_file_new" -fill "#000000" -colorize "100" "${black_fill_dir}/${input_file_no_path_or_ext}.png" 2>/dev/null

  # White background
  # Reassign input_file_new variable to "${black_fill_dir}/${input_file_no_path_or_ext}.png"
  input_file_new="${black_fill_dir}/${input_file_no_path_or_ext}.png"

  # Reassign basename of input_file with no extension
  input_file_no_path_or_ext="$(basename "${input_file_new%.*}")"

  # Get new percentage (White background - task 5)
  percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

  # Create new percentage without decimal
  percentage_new="${percentage%%.*}"

  # If percentage is empty, make it "0"
  if [[ "$percentage_new" == "" ]]; then
    percentage_new="0"
  fi

  # Echo percentage to zenity progress
  echo "$percentage_new" ; sleep 0.2

  # Echo text to zenity progress
  echo "# Task: Put decal on white background\n\nDecal ${current_decal_number} of ${total_files}\n\nConverting: ${input_file_no_path_or_ext}.png\n\n${percentage_new}%" ; sleep 0.2

  # Convert input_file to white background
  convert "$input_file_new" -background white -alpha remove -alpha off "${white_background_dir}/${input_file_no_path_or_ext}.png"

  # Colorize
  # Reassign input_file_new variable to "${resized_transparent}/${input_file_no_path_or_ext}.png"
  input_file_new="${resized_transparent}/${input_file_no_path_or_ext}.png"

  # Reassign basename of input_file with no extension
  input_file_no_path_or_ext="$(basename "${input_file_new%.*}")"

  # Create directory with decal name in colorized dir
  mkdir "${colorized_dir}/${input_file_no_path_or_ext}"

  # Create and compress white image
  # Get new percentage (Colorize white - task 6)
  percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

  # Create new percentage without decimal
  percentage_new="${percentage%%.*}"

  # If percentage is empty, make it "0"
  if [[ "$percentage_new" == "" ]]; then
    percentage_new="0"
  fi

  # Echo percentage to zenity progress
  echo "$percentage_new" ; sleep 0.2

  # Echo text to zenity progress
  echo "# Task: Colorize\n\nDecal ${current_decal_number} of ${total_files}\n\nCreating: ${input_file_no_path_or_ext}-White.png\n\n${percentage_new}%" ; sleep 0.2

  # Convert decal to white
  convert "$input_file_new" -fill "#ffffff" -colorize "100" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-White.png"

  # Get new percentage (Compress white - task 7)
  percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

  # Create new percentage without decimal
  percentage_new="${percentage%%.*}"

  # If percentage is empty, make it "0"
  if [[ "$percentage_new" == "" ]]; then
    percentage_new="0"
  fi

  # Echo percentage to zenity progress
  echo "$percentage_new" ; sleep 0.2

  # Echo text to zenity progress
  echo "# Task: Colorize\n\nDecal ${current_decal_number} of ${total_files}\n\nCompressing: ${input_file_no_path_or_ext}-White.png\n\n${percentage_new}%" ; sleep 0.2

  # Compress white decal
  pngquant --force --quality=60-100 --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-White.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-White.png"

  # Create and compress black image
  # Get new percentage (Colorize black - task 8)
  percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

  # Create new percentage without decimal
  percentage_new="${percentage%%.*}"

  # If percentage is empty, make it "0"
  if [[ "$percentage_new" == "" ]]; then
    percentage_new="0"
  fi

  # Echo percentage to zenity progress
  echo "$percentage_new" ; sleep 0.2

  # Echo text to zenity progress
  echo "# Task: Colorize\n\nDecal ${current_decal_number} of ${total_files}\n\nCreating: ${input_file_no_path_or_ext}-Black.png\n\n${percentage_new}%" ; sleep 0.2

  # Convert decal to black
  convert "$input_file_new" -fill "#000000" -colorize "100" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Black.png"

  # Get new percentage (Compress black - task 9)
  percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

  # Create new percentage without decimal
  percentage_new="${percentage%%.*}"

  # If percentage is empty, make it "0"
  if [[ "$percentage_new" == "" ]]; then
    percentage_new="0"
  fi

  # Echo percentage to zenity progress
  echo "$percentage_new" ; sleep 0.2

  # Echo text to zenity progress
  echo "# Task: Colorize\n\nDecal ${current_decal_number} of ${total_files}\n\nCompressing: ${input_file_no_path_or_ext}-Black.png\n\n${percentage_new}%" ; sleep 0.2

  # Compress black decal
  pngquant --force --quality=60-100 --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Black.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Black.png"

  # Create and compress Blue image
  # Get new percentage (Colorize blue - task 10)
  percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

  # Create new percentage without decimal
  percentage_new="${percentage%%.*}"

  # If percentage is empty, make it "0"
  if [[ "$percentage_new" == "" ]]; then
    percentage_new="0"
  fi

  # Echo percentage to zenity progress
  echo "$percentage_new" ; sleep 0.2

  # Echo text to zenity progress
  echo "# Task: Colorize\n\nDecal ${current_decal_number} of ${total_files}\n\nCreating: ${input_file_no_path_or_ext}-Blue.png\n\n${percentage_new}%" ; sleep 0.2

  # Convert decal to blue
  convert "$input_file_new" -fill "#1791d8" -colorize "100" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Blue.png"

  # Get new percentage (Compress blue - task 11)
  percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

  # Create new percentage without decimal
  percentage_new="${percentage%%.*}"

  # If percentage is empty, make it "0"
  if [[ "$percentage_new" == "" ]]; then
    percentage_new="0"
  fi

  # Echo percentage to zenity progress
  echo "$percentage_new" ; sleep 0.2

  # Echo text to zenity progress
  echo "# Task: Colorize\n\nDecal ${current_decal_number} of ${total_files}\n\nCompressing: ${input_file_no_path_or_ext}-Blue.png\n\n${percentage_new}%" ; sleep 0.2

  # Compress blue decal
  pngquant --force --quality=60-100 --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Blue.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Blue.png"

  # Create and compress Teal image
  # Get new percentage (Colorize teal - task 12)
  percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

  # Create new percentage without decimal
  percentage_new="${percentage%%.*}"

  # If percentage is empty, make it "0"
  if [[ "$percentage_new" == "" ]]; then
    percentage_new="0"
  fi

  # Echo percentage to zenity progress
  echo "$percentage_new" ; sleep 0.2

  # Echo text to zenity progress
  echo "# Task: Colorize\n\nDecal ${current_decal_number} of ${total_files}\n\nCreating: ${input_file_no_path_or_ext}-Teal.png\n\n${percentage_new}%" ; sleep 0.2

  # Convert decal to teal
  convert "$input_file_new" -fill "#29bbc8" -colorize "100" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Teal.png"

  # Get new percentage (Compress teal - task 13)
  percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

  # Create new percentage without decimal
  percentage_new="${percentage%%.*}"

  # If percentage is empty, make it "0"
  if [[ "$percentage_new" == "" ]]; then
    percentage_new="0"
  fi

  # Echo percentage to zenity progress
  echo "$percentage_new" ; sleep 0.2

  # Echo text to zenity progress
  echo "# Task: Colorize\n\nDecal ${current_decal_number} of ${total_files}\n\nCompressing: ${input_file_no_path_or_ext}-Teal.png\n\n${percentage_new}%" ; sleep 0.2

  # Compress teal decal
  pngquant --force --quality=60-100 --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Teal.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Teal.png"

  # Create and compress Red image
  # Get new percentage (Colorize red - task 14)
  percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

  # Create new percentage without decimal
  percentage_new="${percentage%%.*}"

  # If percentage is empty, make it "0"
  if [[ "$percentage_new" == "" ]]; then
    percentage_new="0"
  fi

  # Echo percentage to zenity progress
  echo "$percentage_new" ; sleep 0.2

  # Echo text to zenity progress
  echo "# Task: Colorize\n\nDecal ${current_decal_number} of ${total_files}\n\nCreating: ${input_file_no_path_or_ext}-Red.png\n\n${percentage_new}%" ; sleep 0.2

  # Convert decal to red
  convert "$input_file_new" -fill "#a01922" -colorize "100" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Red.png"

  # Get new percentage (Compress red - task 15)
  percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

  # Create new percentage without decimal
  percentage_new="${percentage%%.*}"

  # If percentage is empty, make it "0"
  if [[ "$percentage_new" == "" ]]; then
    percentage_new="0"
  fi

  # Echo percentage to zenity progress
  echo "$percentage_new" ; sleep 0.2

  # Echo text to zenity progress
  echo "# Task: Colorize\n\nDecal ${current_decal_number} of ${total_files}\n\nCompressing: ${input_file_no_path_or_ext}-Red.png\n\n${percentage_new}%" ; sleep 0.2

  # Compress red decal
  pngquant --force --quality=60-100 --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Red.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Red.png"

  # Create and compress Green image
  # Get new percenage (Colorize green - task 16)
  percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

  # Create new percentage without decimal
  percentage_new="${percentage%%.*}"

  # If percentage is empty, make it "0"
  if [[ "$percentage_new" == "" ]]; then
    percentage_new="0"
  fi

  # Echo percentage to zenity progress
  echo "$percentage_new" ; sleep 0.2

  # Echo text to zenity progress
  echo "# Task: Colorize\n\nDecal ${current_decal_number} of ${total_files}\n\nCreating: ${input_file_no_path_or_ext}-Green.png\n\n${percentage_new}%" ; sleep 0.2

  # Convert decal to green
  convert "$input_file_new" -fill "#008c35" -colorize "100" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Green.png"

  # Get new percentage (Compress green - task 17)
  percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

  # Create new percentage without decimal
  percentage_new="${percentage%%.*}"

  # If percentage is empty, make it "0"
  if [[ "$percentage_new" == "" ]]; then
    percentage_new="0"
  fi

  # Echo percentage to zenity progress
  echo "$percentage_new" ; sleep 0.2

  # Echo text to zenity progress
  echo "# Task: Colorize\n\nDecal ${current_decal_number} of ${total_files}\n\nCompressing: ${input_file_no_path_or_ext}-Green.png\n\n${percentage_new}%" ; sleep 0.2

  # Compress green decal
  pngquant --force --quality=60-100 --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Green.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Green.png"

  # Create and compress Silver image
  # Get new percentage (Colorize silver - task 18)
  percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

  # Create new percentage without decimal
  percentage_new="${percentage%%.*}"

  # If percentage is empty, make it "0"
  if [[ "$percentage_new" == "" ]]; then
    percentage_new="0"
  fi

  # Echo percentage to zenity progress
  echo "$percentage_new" ; sleep 0.2

  # Echo text to zenity progress
  echo "# Task: Colorize\n\nDecal ${current_decal_number} of ${total_files}\n\nCreating: ${input_file_no_path_or_ext}-Silver.png\n\n${percentage_new}%" ; sleep 0.2

  # Convert decal to silver
  convert "$input_file_new" -fill "#928F98" -colorize "100" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Silver.png"

  # Get new percentage (Compress silver - task 19)
  percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

  # Create new percentage without decimal
  percentage_new="${percentage%%.*}"

  # If percentage is empty, make it "0"
  if [[ "$percentage_new" == "" ]]; then
    percentage_new="0"
  fi

  # Echo percentage to zenity progress
  echo "$percentage_new" ; sleep 0.2

  # Echo text to zenity progress
  echo "# Task: Colorize\n\nDecal ${current_decal_number} of ${total_files}\n\nCompressing: ${input_file_no_path_or_ext}-Silver.png\n\n${percentage_new}%" ; sleep 0.2

  # Compress silver decal
  pngquant --force --quality=60-100 --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Silver.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Silver.png"

  # Create and compress Pink image
  # Get new percentage (Colorize pink - task 20)
  percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

  # Create new percentage without decimal
  percentage_new="${percentage%%.*}"

  # If percentage is empty, make it "0"
  if [[ "$percentage_new" == "" ]]; then
    percentage_new="0"
  fi

  # Echo percentage to zenity progress
  echo "$percentage_new" ; sleep 0.2

  # Echo text to zenity progress
  echo "# Task: Colorize\n\nDecal ${current_decal_number} of ${total_files}\n\nCreating: ${input_file_no_path_or_ext}-Pink.png\n\n${percentage_new}%" ; sleep 0.2

  # Convert decal to pink
  convert "$input_file_new" -fill "#FFADE5" -colorize "100" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Pink.png"

  # Get new percentage (Compress pink - task 21)
  percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

  # Create new percentage without decimal
  percentage_new="${percentage%%.*}"

  # If percentage is empty, make it "0"
  if [[ "$percentage_new" == "" ]]; then
    percentage_new="0"
  fi

  # Echo percentage to zenity progress
  echo "$percentage_new" ; sleep 0.2

  # Echo text to zenity progress
  echo "# Task: Colorize\n\nDecal ${current_decal_number} of ${total_files}\n\nCompressing: ${input_file_no_path_or_ext}-Pink.png\n\n${percentage_new}%" ; sleep 0.2

  # Compress pink decal
  pngquant --force --quality=60-100 --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Pink.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Pink.png"

  # Create and compress purple image
  # Get new percentage (Colorize purple - task 22)
  percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

  # Create new percentage without decimal
  percentage_new="${percentage%%.*}"

  # If percentage is empty, make it "0"
  if [[ "$percentage_new" == "" ]]; then
    percentage_new="0"
  fi

  # Echo percentage to zenity progress
  echo "$percentage_new" ; sleep 0.2

  # Echo text to zenity progress
  echo "# Task: Colorize\n\nDecal ${current_decal_number} of ${total_files}\n\nCreating: ${input_file_no_path_or_ext}-Purple.png\n\n${percentage_new}%" ; sleep 0.2

  # Convert decal to purple
  convert "$input_file_new" -fill "#452167" -colorize "100" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Purple.png"

  # Get new percentage (Compress purple - task 23)
  percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

  # Create new percentage without decimal
  percentage_new="${percentage%%.*}"

  # If percentage is empty, make it "0"
  if [[ "$percentage_new" == "" ]]; then
    percentage_new="0"
  fi

  # Echo percentage to zenity progress
  echo "$percentage_new" ; sleep 0.2

  # Echo text to zenity progress
  echo "# Task: Colorize\n\nDecal ${current_decal_number} of ${total_files}\n\nCompressing: ${input_file_no_path_or_ext}-Purple.png\n\n${percentage_new}%" ; sleep 0.2

  # Compress purple decal
  pngquant --force --quality=60-100 --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Purple.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Purple.png"

  # Create and compress Dark-Blue image
  # Get new percentage (Colorize dark-blue - task 24)
  percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

  # Create new percentage without decimal
  percentage_new="${percentage%%.*}"

  # If percentage is empty, make it "0"
  if [[ "$percentage_new" == "" ]]; then
    percentage_new="0"
  fi

  # Echo percentage to zenity progress
  echo "$percentage_new" ; sleep 0.2

  # Echo text to zenity progress
  echo "# Task: Colorize\n\nDecal ${current_decal_number} of ${total_files}\n\nCreating: ${input_file_no_path_or_ext}-Dark-Blue.png\n\n${percentage_new}%" ; sleep 0.2

  # Convert decal to dark blue
  convert "$input_file_new" -fill "#003478" -colorize "100" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Dark-Blue.png"

  # Get new percentage (Compress dark-blue - task 25)
  percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

  # Create new percentage without decimal
  percentage_new="${percentage%%.*}"

  # If percentage is empty, make it "0"
  if [[ "$percentage_new" == "" ]]; then
    percentage_new="0"
  fi

  # Echo percentage to zenity progress
  echo "$percentage_new" ; sleep 0.2

  # Echo text to zenity progress
  echo "# Task: Colorize\n\nDecal ${current_decal_number} of ${total_files}\n\nCompressing: ${input_file_no_path_or_ext}-Dark-Blue\n\n${percentage_new}%" ; sleep 0.2

  # Compress dark-blue decal
  pngquant --force --quality=60-100 --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Dark-Blue.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Dark-Blue.png"

  # Create and compress Orange image
  # Get percentage (Colorize orange - task 26)
  percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

  # Create new percentage without decimal
  percentage_new="${percentage%%.*}"

  # If percentage is empty, make it "0"
  if [[ "$percentage_new" == "" ]]; then
    percentage_new="0"
  fi

  # Echo percentage to zenity progress
  echo "$percentage_new" ; sleep 0.2

  # Echo text to zenity progress
  echo "# Task: Colorize\n\nDecal ${current_decal_number} of ${total_files}\n\nCreating: ${input_file_no_path_or_ext}-Orange.png\n\n${percentage_new}%" ; sleep 0.2

  # Convert decal to orange
  convert "$input_file_new" -fill "#d56f31" -colorize "100" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Orange.png"

  # Get new percentage (Compress orange - task 27)
  percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

  # Create new percentage without decimal
  percentage_new="${percentage%%.*}"

  # If percentage is empty, make it "0"
  if [[ "$percentage_new" == "" ]]; then
    percentage_new="0"
  fi

  # Echo percentage to zenity progress
  echo "$percentage_new" ; sleep 0.2

  # Echo text to zenity progress
  echo "# Task: Colorize\n\nDecal ${current_decal_number} of ${total_files}\n\nCompressing: ${input_file_no_path_or_ext}-Orange.png\n\n${percentage_new}%" ; sleep 0.2

  # Compress orange decal
  pngquant --force --quality=60-100 --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Orange.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Orange.png"

  # Create and compress Yellow image
  # Get new percentage (Colorize yellow - task 28)
  percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

  # Create new percentage without decimal
  percentage_new="${percentage%%.*}"

  # If percentage is empty, make it "0"
  if [[ "$percentage_new" == "" ]]; then
    percentage_new="0"
  fi

  # Echo percentage to zenity progress
  echo "$percentage_new" ; sleep 0.2

  # Echo text to zenity progress
  echo "# Task: Colorize\n\nDecal ${current_decal_number} of ${total_files}\n\nCreating: ${input_file_no_path_or_ext}-Yellow.png\n\n${percentage_new}%" ; sleep 0.2

  # Convert decal to yellow
  convert "$input_file_new" -fill "#f3e11f" -colorize "100" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Yellow.png"

  # Get new percentage (Compress yellow - task 29)
  percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

  # Create new percentage without decimal
  percentage_new="${percentage%%.*}"

  # If percentage is empty, make it "0"
  if [[ "$percentage_new" == "" ]]; then
    percentage_new="0"
  fi

  # Echo percentage to zenity progress
  echo "$percentage_new" ; sleep 0.2

  # Echo text to zenity progress
  echo "# Task: Colorize\n\nDecal ${current_decal_number} of ${total_files}\n\nCompressing: ${input_file_no_path_or_ext}-Yellow.png\n\n${percentage_new}%" ; sleep 0.2

  # Compress yellow decal
  pngquant --force --quality=60-100 --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Yellow.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Yellow.png"

  # Create and compress Neon-Green image
  # Get new percentage (Colorize neon green - task 30)
  percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

  # Create new percentage without decimal
  percentage_new="${percentage%%.*}"

  # If percentage is empty, make it "0"
  if [[ "$percentage_new" == "" ]]; then
    percentage_new="0"
  fi

  # Echo percentage to zenity progress
  echo "$percentage_new" ; sleep 0.2

  # Echo text to zenity progress
  echo "# Task: Colorize\n\nDecal ${current_decal_number} of ${total_files}\n\nCreating: ${input_file_no_path_or_ext}-Neon-Green.png\n\n${percentage_new}%" ; sleep 0.2

  # Convert decal to neon green
  convert "$input_file_new" -fill "#39FF14" -colorize "100" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Neon-Green.png"

  # Get new percentage (Compress neon green - task 31)
  percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

  # Create new percentage without decimal
  percentage_new="${percentage%%.*}"

  # If percentage is empty, make it "0"
  if [[ "$percentage_new" == "" ]]; then
    percentage_new="0"
  fi

  # Echo percentage to zenity progress
  echo "$percentage_new" ; sleep 0.2

  # Echo text to zenity progress
  echo "# Task: Colorize\n\nDecal ${current_decal_number} of ${total_files}\n\nCompressing: ${input_file_no_path_or_ext}-Neon-Green.png\n\n${percentage_new}%" ; sleep 0.2

  # Compress neon-green decal
  pngquant --force --quality=60-100 --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Neon-Green.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Neon-Green.png"

  # GIF
  # assign input_dir variable to "${colorized_dir}/${input_file_no_path_or_ext}"
  input_dir="${colorized_dir}/${input_file_no_path_or_ext}"

  # Convert decal to gif
  # Get new percentage (GIF - task 32)
  percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

  # Create new percentage without decimal
  percentage_new="${percentage%%.*}"

  # If percentage is empty, make it "0"
  if [[ "$percentage_new" == "" ]]; then
    percentage_new="0"
  fi

  # Echo percentage to zenity progress
  echo "$percentage_new" ; sleep 0.2

  # Echo text to zenity progress
  echo "# Task: Creating GIF\n\nDecal ${current_decal_number} of ${total_files}\n\nCreating: ${input_file_no_path_or_ext}.gif\n\n${percentage_new}%" ; sleep 0.2

  # Convert decal to GIF
    convert -dispose previous -delay 100 -loop 0 "${input_dir}/*.png" "${gif_dir}/${input_file_no_path_or_ext}.gif"

  # Tablet (add 13 tasks - 45 total)
  for decal in ${colorized_dir}/${input_file_no_path_or_ext}/*.png; do

    # Get decal basename
    decal_basename="$(basename "${decal}")"

    # Get filename without path or extension
    input_file_no_path_or_ext=$(basename "${decal_basename%.*}")

    # Get new percentage
    percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

    # Create new percentage without decimal
    percentage_new="${percentage%%.*}"

    # If percentage is empty, make it "0"
    if [[ "$percentage_new" == "" ]]; then
      percentage_new="0"
    fi

    # Echo percentage to zenity progress
    echo "$percentage_new" ; sleep 0.2

    # Echo text to zenity progress
    echo "# Task: Creating tablet image\n\nDecal ${current_decal_number} of ${total_files}\n\nCreating: ${input_file_no_path_or_ext}.png\n\n${percentage_new}%" ; sleep 0.2

    # Create tablet images
    composite "$decal" "/usr/share/decal-converter/bg-tablet.png" -gravity Center -quality 95 "${tablet_dir}/${decal_basename}"
  done
done

# Echo percentage to zenity progress
echo "100" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: All tasks finished\n\n100%" ; sleep 0.2
}
############################################################
# Create function for single background removal and resize #
############################################################
remove_background_resize_single () {

# Get input file
input_file="$(zenity --file-selection --filename="${HOME}/Desktop/" --title="Select your input directory")"

# If the user selects the "cancel" button, close the script
if [[ "$?" == "1" ]]; then
  # Remove temp directory
  rm -rf "$temp_dir"
  exit
fi

# Remove path from "$input_file"
input_file_no_path=$(basename "${input_file}")

# Remove path and extension from input directory
input_file_no_path_or_ext="$(basename "${input_file%.*}")"

# Convert to jpg,bmp,svg,png to remove background
# Check if image is transparent
transparency_check=$(identify -format %A "$input_file")

# If the file contains transparency
if [[ "$transparency_check" == "True" ]]; then
  # Convert decal to jpg
  convert "$input_file" -sharpen 0x -background white -alpha remove -alpha off "${temp_dir}/${input_file_no_path_or_ext}.jpg"
else
  # Convert decal to jpg
  convert "$input_file" -sharpen 0x "${temp_dir}/${input_file_no_path_or_ext}.jpg"
fi

# Convert decal to pgm"
convert "${temp_dir}/${input_file_no_path_or_ext}.jpg" "${temp_dir}/${input_file_no_path_or_ext}.pgm"

# Convert bmp to svg
potrace --svg "${temp_dir}/${input_file_no_path_or_ext}.pgm" -o "${temp_dir}/${input_file_no_path_or_ext}.svg"

# Convert svg to png
mogrify -background none -density 500 -format png "${temp_dir}/${input_file_no_path_or_ext}.svg"

# Get input image width
input_file_width="$(identify -format "%w" "${temp_dir}/${input_file_no_path_or_ext}.png")"

# Get input image height
input_file_height="$(identify -format "%h" "${temp_dir}/${input_file_no_path_or_ext}.png")"

# Resize larger image dimension to 750px, and then paste onto 800x800 transparent background
if [[ "$input_width" -ge "$input_height" ]]; then
  convert "${temp_dir}/${input_file_no_path_or_ext}.png" -resize 750x -background transparent -gravity center -extent 800x800 "${temp_dir}/${input_file_no_path_or_ext}_resized.png"
else convert "${temp_dir}/${input_file_no_path_or_ext}.png" -resize x750 -background transparent -gravity center -extent 800x800 "${temp_dir}/${input_file_no_path_or_ext}_resized.png"
fi

mv "${temp_dir}/${input_file_no_path_or_ext}_resized.png" "${resized_transparent}/${input_file_no_path_or_ext}.png"
}
##############################################################
# Create function for Multiple background removal and resize #
##############################################################
remove_background_resize_multiple () {

# Select input directory
input_dir=$(zenity --file-selection --directory="${HOME}/Desktop/" --title="Select your input directory")

# If the user selects the "cancel" button, close the script
if [[ "$?" == "1" ]]; then
  # Remove temp directory
  rm -rf "$temp_dir"
  exit
fi

# Count number of decal files
total_files=$(ls "$input_dir" 2> /dev/null | wc -l)

# Get number to increment progress bar by
increment=$(echo "scale=2; 100/${total_files}" | bc)

# Set initial percentage
percentage="0"

# Set current decal number in loop
current_decal_number="0"

# Create main loop of input files
for decal in "$input_dir/"*; do

  # Set value for current decal in loop
  ((current_decal_number++))

  # Increment percentage number
  percentage=$(echo "${percentage}+${increment}" | bc)

  # Create new percentage without decimal
  percentage_new="${percentage%%.*}"

  # If percentage is empty, make it "0"
  if [[ "$percentage_new" == "" ]]; then
    percentage_new="0"
  fi

  # Echo percentage number to zenity progress
  echo "$percentage_new" ; sleep 0.2

  # Echo text for zenity progress
  echo "# Task: Remove background and resize\n\nCurrent Decal: ${current_decal_number} of ${total_files}\n\nCreating: ${input_file_no_path_or_ext}.png\n\n${percentage_new}%" ; sleep 0.2

  # Get filname without path
  decal_basename=$(basename "${decal}")

  # Get filename without path or extension
  input_file_no_path_or_ext=$(basename "${decal_basename%.*}")

  # Convert to jpg,bmp,svg,png to remove background (task 2 - remove background)
  # Check if image is transparent
  transparency_check=$(identify -format %A "$decal")

  # If the file contains transparency
  if [[ "$transparency_check" == "True" ]]; then
    # Convert decal to jpg
    convert "$decal" -sharpen 0x -background white -alpha remove -alpha off "${temp_dir}/${input_file_no_path_or_ext}.jpg"
  else
    # Convert decal to jpg
    convert "$decal" -sharpen 0x "${temp_dir}/${input_file_no_path_or_ext}.jpg"
  fi

  # Convert decal to pgm"
  convert "${temp_dir}/${input_file_no_path_or_ext}.jpg" "${temp_dir}/${input_file_no_path_or_ext}.pgm"

  # Convert bmp to svg
  potrace --svg "${temp_dir}/${input_file_no_path_or_ext}.pgm" -o "${temp_dir}/${input_file_no_path_or_ext}.svg"

  # Convert svg to png
  mogrify -background none -density 500 -format png "${temp_dir}/${input_file_no_path_or_ext}.svg"

  # Get input image width
  input_width=$(identify -format "%w" "${temp_dir}/${input_file_no_path_or_ext}.png")

  # Get input image height
  input_height=$(identify -format "%h" "${temp_dir}/${input_file_no_path_or_ext}.png")

  # Resize larger image dimension to 750px, and then paste onto 800x800 transparent background
  if [[ "$input_width" > "$input_height" ]]; then
    convert "${temp_dir}/${input_file_no_path_or_ext}.png" -resize 750X -background transparent -gravity center -extent 800x800 "${temp_dir}/${input_file_no_path_or_ext}_resized.png"
  else convert "${temp_dir}/${input_file_no_path_or_ext}.png" -resize X750 -background transparent -gravity center -extent 800x800 "${temp_dir}/${input_file_no_path_or_ext}_resized.png"
  fi

  # Resize larger image dimension to 750px, and then paste onto 800x800 transparent background
  if [[ "$input_width" -ge "$input_height" ]]; then
    convert "${temp_dir}/${input_file_no_path_or_ext}.png" -resize 750x -background transparent -gravity center -extent 800x800 "${temp_dir}/${input_file_no_path_or_ext}_resized.png"
  else convert "${temp_dir}/${input_file_no_path_or_ext}.png" -resize x750 -background transparent -gravity center -extent 800x800 "${temp_dir}/${input_file_no_path_or_ext}_resized.png"
  fi

  mv "${temp_dir}/${input_file_no_path_or_ext}_resized.png" "${resized_transparent}/${input_file_no_path_or_ext}.png"
done

# Echo percentage to zenity progress
echo "100%" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: Remove background and resize finished\n\n100%" ; sleep 2
}
#####################################################################
# Create function for filling all visible color with black (single) #
#####################################################################
black_fill_single () {
# The input or "source" .png file
input_file=$(zenity --file-selection --filename="${resized_transparent}/" --title="Select the source decal")

# If the user selects the "cancel" button, close the script
if [[ "$?" == "1" ]]; then
  # Remove temp directory
  rm -rf "$temp_dir"
  exit
fi

# Remove path from variable "input_file"
input_file_no_path=$(basename "$input_file")

# Remove extension from variable "input_file_no_path
input_file_no_path_or_ext=${input_file_no_path%.*}

# Copy original image to original directory
cp "$input_file" "$original_dir"

# Fill png with black, and add to "Black-Fill" directory
convert "$input_file" -fill "#000000" -colorize "100" "${black_fill_dir}/${input_file_no_path_or_ext}.png"
}
#######################################################################
# Create function for filling all visible color with black (multiple) #
#######################################################################
black_fill_multiple () {
# The input or "source" .png directory
input_dir=$(zenity --file-selection --directory --filename="${resized_transparent}/" --title="Select a directory")

# If the user selects the "cancel" button, close the script
if [[ "$?" == "1" ]]; then
  # Remove temp directory
  rm -rf "$temp_dir"
  exit
fi

# Count number of decal files
total_files=$(ls "$input_dir" 2> /dev/null | wc -l)

# Get number to increment progress bar by
increment=$(echo "scale=2; 99/${total_files}" | bc)

# Set initial percentage
percentage="0"

# Set current decal number in loop
current_decal_number="0"

# Start looping through directory
for decal in "${input_dir}"/* ; do

  # Remove path for zenity progress
  decal_basename=$(basename "${decal%.*}")

  # Remove extension from variable "input_file_no_path
  input_file_no_path_or_ext=${decal_basename%.*}

  # Copy original file to "Original" directory (backup)
  cp "$decal" "$original_dir"

  # Set value for current decal in loop
  ((current_decal_number++))

  # Fill png with black, and add to Black-Fill"" directory
  convert "$decal" -fill "#000000" -colorize "100" "${black_fill_dir}/${input_file_no_path_or_ext}.png"

  # Increment percentage number
  percentage=$(echo "${percentage}+${increment}" | bc)

  # Create new percentage without decimal
  percentage_new="${percentage%%.*}"

  # If percentage is empty, make it "0"
  if [[ "$percentage_new" == "" ]]; then
    percentage_new="0"
  fi

  # Echo percentage number to zenity progress
  echo "$percentage_new" ; sleep 0.2

  # Echo text for zenity progress
  echo "# Task: Fill all visible color with black\n\nCurrent Decal: ${current_decal_number} of ${total_files}\n\nCreating: ${input_file_no_path_or_ext}.png\n\n${percentage_new}%" ; sleep 0.2
done

# Echo percentage to zenity progress
echo "100%" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: Fill all visible color with black finished\n\n100%" ; sleep 2
}
###################################################
# Create funcion for single file white background #
###################################################
white_background_single () {
# Select the single decal file to be converted to png format
input_file="$(zenity --file-selection --filename="${black_fill_dir}/" --title="Select the source decal")"

# If the user selects the "cancel" button, close the script
if [[ "$?" == "1" ]]; then
  # Remove temp directory
  rm -rf "$temp_dir"
  exit
fi

# Get basename of input_file with no extension
input_file_no_path_or_ext="$(basename "${input_file%.*}")"

# Convert input_file to white background
convert "$input_file" -background white -alpha remove -alpha off "${white_background_dir}/${input_file_no_path_or_ext}.png"
}
###################################################
# Create funcion for single file white background #
###################################################
white_background_multiple () {

# Select the single decal file to be converted to png format
input_dir="$(zenity --file-selection --directory --filename="$black_fill_dir/" --title="Select the source decal directory")"

# If the user selects the "cancel" button, close the script
if [[ "$?" == "1" ]]; then
  # Remove temp directory
  rm -rf "$temp_dir"
  exit
fi

# Count number of decal files
total_files=$(ls "$input_dir" 2> /dev/null | wc -l)

# Get number to increment progress bar by
increment="$(echo "scale=2; 99/${total_files}" | bc)"

# Set initial percentage
percentage="0"

# Set current decal number in loop
current_decal_number="0"

# Start loop
for decal in $input_dir/* ; do

  # Get basename of "decal"
  input_file_no_path="$(basename "$decal")"

  # Get basename of input_file with no extension
  input_file_no_path_or_ext="$(basename "${input_file_no_path%.*}")"

  # Set value for current decal in loop
  ((current_decal_number++))

  # Copy original file to "Original" directory (backup)
  cp "$decal" "$original_dir"

  # Get new percentage
  percentage="$(echo "scale=2; ${percentage}+${increment}" | bc)"

  # Create new percentage without decimal
  percentage_new="${percentage%%.*}"

  # If percentage is empty, make it "0"
  if [[ "$percentage_new" == "" ]]; then
    percentage_new="0"
  fi

  # Echo percentage to zenity progress
  echo "$percentage" ; sleep 0.2

  # Echo text to zenity progress
  echo "# Task: White Background\n\nCurrent Decal: ${current_decal_number} of ${total_files}\n\nAdding white background to: ${input_file_no_path_or_ext}.png\n\n${percentage_new}%" ; sleep 0.2

  # Convert input_file to white background
  convert "$decal" -background white -alpha remove -alpha off "${white_background_dir}/${input_file_no_path_or_ext}.png"
done
}
##################################################################################
# Create function for generating color decals and compressing png (single image) #
##################################################################################
colorize_single () {

# The input or "source" .png file
input_file=$(zenity --file-selection --filename="$black_fill_dir/" --title="Select the source decal")

# If the user selects the "cancel" button, close the script
if [[ "$?" == "1" ]]; then
  # Remove temp directory
  rm -rf "$temp_dir"
  exit
fi

# Remove path from variable "input_file"
input_file_no_path=$(basename "$input_file")

# Remove path and extension from variable "input_file"
input_file_no_path_or_ext=$(basename "${input_file%.*}")

# Create directory from decal name
mkdir -p "${colorized_dir}/${input_file_no_path_or_ext}"

# Set initial percentage
percentage="0"

# Set increment value
increment="3.807692308"

# Create and compress white image (task 1)
# Calculate percentage
percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)

# Create new percentage without decimal
percentage_new="${percentage%%.*}"

# If percentage is empty, make it "0"
if [[ "$percentage_new" == "" ]]; then
  percentage_new="0"
fi

# Echo percentage to zenity progress
echo "$percentage" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: Colorize and compress (Single file)\n\nCreating: ${input_file_no_path_or_ext}-White.png\n\n${percentage_new}%" ; sleep 0.2

# Convert decal to white
convert "$input_file" -fill "#ffffff" -colorize "100" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-White.png"

# Compressing (task 2)
percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)

# Create new percentage without decimal
percentage_new="${percentage%%.*}"

# If percentage is empty, make it "0"
if [[ "$percentage_new" == "" ]]; then
  percentage_new="0"
fi

# Echo percentage to zenity progress
echo "$percentage" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: Colorize and compress (Single file)\n\nCompressing: ${input_file_no_path_or_ext}-White.png\n\n${percentage_new}%" ; sleep 0.2

# Compress white decal
pngquant --force --quality=60-100 --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-White.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-White.png"

# Create and compress black image (task 3)
# Calculate percentage
percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)

# Create new percentage without decimal
percentage_new="${percentage%%.*}"

# If percentage is empty, make it "0"
if [[ "$percentage_new" == "" ]]; then
  percentage_new="0"
fi

# Echo percentage to zenity progress
echo "$percentage" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: Colorize and compress (Single file)\n\nCreating: ${input_file_no_path_or_ext}-Black.png\n\n${percentage_new}%" ; sleep 0.2

# Convert decal to black
convert "$input_file" -fill "#000000" -colorize "100" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Black.png"

# Compressing (task 4)
# Calculate percentage
percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)

# Create new percentage without decimal
percentage_new="${percentage%%.*}"

# If percentage is empty, make it "0"
if [[ "$percentage_new" == "" ]]; then
  percentage_new="0"
fi

# Echo percentage to zenity progress
echo "$percentage" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: Colorize and compress (Single file)\n\nCompressing: ${input_file_no_path_or_ext}-Black.png\n\n${percentage_new}%" ; sleep 0.2

# Compress black decal
pngquant --force --quality=60-100 --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Black.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Black.png"

# Create and compress Blue image (task 5)
# Calculate percentage
percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)

# Create new percentage without decimal
percentage_new="${percentage%%.*}"

# If percentage is empty, make it "0"
if [[ "$percentage_new" == "" ]]; then
  percentage_new="0"
fi

# Echo percentage to zenity progress
echo "$percentage" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: Colorize and compress (Single file)\n\nCreating: ${input_file_no_path_or_ext}-Blue.png\n\n${percentage_new}%" ; sleep 0.2

# Convert decal to blue
convert "$input_file" -fill "#1791d8" -colorize "100" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Blue.png"

# Compressing (task 6)
# Calculate percentage
percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)

# Create new percentage without decimal
percentage_new="${percentage%%.*}"

# If percentage is empty, make it "0"
if [[ "$percentage_new" == "" ]]; then
  percentage_new="0"
fi

# Echo percentage to zenity progress
echo "$percentage" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: Colorize and compress (Single file)\n\nCompressing: ${input_file_no_path_or_ext}-Blue.png\n\n${percentage_new}%" ; sleep 0.2

# Compress blue decal
pngquant --force --quality=60-100 --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Blue.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Blue.png"

# Create and compress Teal image (task 7)
# Calculate percentage
percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)

# Create new percentage without decimal
percentage_new="${percentage%%.*}"

# If percentage is empty, make it "0"
if [[ "$percentage_new" == "" ]]; then
  percentage_new="0"
fi

# Echo percentage to zenity progress
echo "$percentage" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: Colorize and compress (Single file)\n\nCreating: ${input_file_no_path_or_ext}-Teal.png\n\n${percentage_new}%" ; sleep 0.2

# Convert decal to teal
convert "$input_file" -fill "#29bbc8" -colorize "100" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Teal.png"

# Compressing (task 8)
# Calculate percentage
percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)

# Create new percentage without decimal
percentage_new="${percentage%%.*}"

# If percentage is empty, make it "0"
if [[ "$percentage_new" == "" ]]; then
  percentage_new="0"
fi

# Echo percentage to zenity progress
echo "$percentage" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: Colorize and compress (Single file)\n\nCompressing: ${input_file_no_path_or_ext}-Teal.png\n\n${percentage_new}%" ; sleep 0.2

# Compress teal decal
pngquant --force --quality=60-100 --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Teal.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Teal.png"

# Create and compress Red image (task 9)
# Calculate percentage
percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)

# Create new percentage without decimal
percentage_new="${percentage%%.*}"

# If percentage is empty, make it "0"
if [[ "$percentage_new" == "" ]]; then
  percentage_new="0"
fi

# Echo percentage to zenity progress
echo "$percentage" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: Colorize and compress (Single file)\n\nCreating: ${input_file_no_path_or_ext}-Red.png\n\n${percentage_new}%" ; sleep 0.2

# Convert decal to red
convert "$input_file" -fill "#a01922" -colorize "100" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Red.png"

# Compressing (task 10)
# Calculate percentage
percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)

# Create new percentage without decimal
percentage_new="${percentage%%.*}"

# If percentage is empty, make it "0"
if [[ "$percentage_new" == "" ]]; then
  percentage_new="0"
fi

# Echo percentage to zenity progress
echo "$percentage" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: Colorize and compress (Single file)\n\nCompressing: ${input_file_no_path_or_ext}-Red.png\n\n${percentage_new}%" ; sleep 0.2

# Compress red decal
pngquant --force --quality=60-100 --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Red.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Red.png"

# Create and compress Green image (task 11)
# Calculate percentage
percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)

# Create new percentage without decimal
percentage_new="${percentage%%.*}"

# If percentage is empty, make it "0"
if [[ "$percentage_new" == "" ]]; then
  percentage_new="0"
fi

# Echo percentage to zenity progress
echo "$percentage" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: Colorize and compress (Single file)\n\nCreating: ${input_file_no_path_or_ext}-Green.png\n\n${percentage_new}%" ; sleep 0.2

# Convert decal to green
convert "$input_file" -fill "#008c35" -colorize "100" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Green.png"

# Compressing (task 12)
# Calculate percentage
percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)

# Create new percentage without decimal
percentage_new="${percentage%%.*}"

# If percentage is empty, make it "0"
if [[ "$percentage_new" == "" ]]; then
  percentage_new="0"
fi

# Echo percentage to zenity progress
echo "$percentage" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: Colorize and compress (Single file)\n\nCompressing: ${input_file_no_path_or_ext}-Green.png\n\n${percentage_new}%" ; sleep 0.2

# Compress green decal
pngquant --force --quality=60-100 --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Green.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Green.png"

# Create and compress Silver image (task 13)
# Calculate new percentage
percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)

# Create new percentage without decimal
percentage_new="${percentage%%.*}"

# If percentage is empty, make it "0"
if [[ "$percentage_new" == "" ]]; then
  percentage_new="0"
fi

# Echo percentage to zenity progress
echo "$percentage" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: Colorize and compress (Single file)\n\nCreating: ${input_file_no_path_or_ext}-Silver.png\n\n${percentage_new}%" ; sleep 0.2

# Convert decal to silver
convert "$input_file" -fill "#928F98" -colorize "100" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Silver.png"

# Compressing (task 14)
# Calculate new percentage
percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)

# Create new percentage without decimal
percentage_new="${percentage%%.*}"

# If percentage is empty, make it "0"
if [[ "$percentage_new" == "" ]]; then
  percentage_new="0"
fi

# Echo percentage to zenity progress
echo "$percentage" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: Colorize and compress (Single file)\n\nCompressing: ${input_file_no_path_or_ext}-Silver.png\n\n${percentage_new}%" ; sleep 0.2

# Compress silver decal
pngquant --force --quality=60-100 --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Silver.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Silver.png"

# Create and compress Pink image (task 15)
# Calculate new percentage
percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)

# Create new percentage without decimal
percentage_new="${percentage%%.*}"

# If percentage is empty, make it "0"
if [[ "$percentage_new" == "" ]]; then
  percentage_new="0"
fi

# Echo percentage to zenity progress
echo "$percentage" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: Colorize and compress (Single file)\n\nCreating: ${input_file_no_path_or_ext}-Pink.png\n\n${percentage_new}%" ; sleep 0.2

# Convert decal to pink
convert "$input_file" -fill "#FFADE5" -colorize "100" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Pink.png"

# Compressing (task 16)
# Calculate new percentage
percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)

# Create new percentage without decimal
percentage_new="${percentage%%.*}"

# If percentage is empty, make it "0"
if [[ "$percentage_new" == "" ]]; then
  percentage_new="0"
fi

# Echo percentage to zenity progress
echo "$percentage" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: Colorize and compress (Single file)\n\nCompressing: ${input_file_no_path_or_ext}-Pink.png\n\n${percentage_new}%" ; sleep 0.2

# Compress pink decal
pngquant --force --quality=60-100 --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Pink.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Pink.png"

# Create and compress purple image (task 17)
# Calculate new percentage
percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)

# Create new percentage without decimal
percentage_new="${percentage%%.*}"

# If percentage is empty, make it "0"
if [[ "$percentage_new" == "" ]]; then
  percentage_new="0"
fi

# Echo percentage to zenity progress
echo "$percentage" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: Colorize and compress (Single file)\n\nCreating: ${input_file_no_path_or_ext}-Purple.png\n\n${percentage_new}%" ; sleep 0.2

# Convert decal to purple
convert "$input_file" -fill "#452167" -colorize "100" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Purple.png"

# Compressing (task 18)
# Calculate new percentage
percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)

# Create new percentage without decimal
percentage_new="${percentage%%.*}"

# If percentage is empty, make it "0"
if [[ "$percentage_new" == "" ]]; then
  percentage_new="0"
fi

# Echo percentage to zenity progress
echo "$percentage" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: Colorize and compress (Single file)\n\nCompressing: ${input_file_no_path_or_ext}-Purple.png\n\n${percentage_new}%" ; sleep 0.2

# Compress purple decal
pngquant --force --quality=60-100 --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Purple.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Purple.png"

# Create and compress Dark-Blue image (task 18)
# Calculate new percentage
percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)

# Create new percentage without decimal
percentage_new="${percentage%%.*}"

# If percentage is empty, make it "0"
if [[ "$percentage_new" == "" ]]; then
  percentage_new="0"
fi

# Echo percentage to zenity progress
echo "$percentage" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: Colorize and compress (Single file)\n\nCreating: ${input_file_no_path_or_ext}-Dark-Blue.png\n\n${percentage_new}%" ; sleep 0.2

# Convert decal to dark-blue
convert "$input_file" -fill "#003478" -colorize "100" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Dark-Blue.png"

# Compressing (task 19)
# Calculate new percentage
percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)

# Create new percentage without decimal
percentage_new="${percentage%%.*}"

# If percentage is empty, make it "0"
if [[ "$percentage_new" == "" ]]; then
  percentage_new="0"
fi

# Echo percentage to zenity progress
echo "$percentage" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: Colorize and compress (Single file)\n\nCompressing: ${input_file_no_path_or_ext}-Dark-Blue\n\n${percentage_new}%" ; sleep 0.2

# Convert decal to dark-blue
pngquant --force --quality=60-100 --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Dark-Blue.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Dark-Blue.png"

# Create and compress Orange image (task 20)
# Calculate new percentage
percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)

# Create new percentage without decimal
percentage_new="${percentage%%.*}"

# If percentage is empty, make it "0"
if [[ "$percentage_new" == "" ]]; then
  percentage_new="0"
fi

# Echo percentage to zenity progress
echo "$percentage" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: Colorize and compress (Single file)\n\nCreating: ${input_file_no_path_or_ext}-Orange.png\n\n${percentage_new}%" ; sleep 0.2

# Convert decal to orange
convert "$input_file" -fill "#d56f31" -colorize "100" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Orange.png"

# Compressing (task 21)
# Calculate new percentage
percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)

# Create new percentage without decimal
percentage_new="${percentage%%.*}"

# If percentage is empty, make it "0"
if [[ "$percentage_new" == "" ]]; then
  percentage_new="0"
fi

# Echo percentage to zenity progress
echo "$percentage" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: Colorize and compress (Single file)\n\nCompressing: ${input_file_no_path_or_ext}-Orange.png\n\n${percentage_new}%" ; sleep 0.2

# Compress orange decal
pngquant --force --quality=60-100 --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Orange.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Orange.png"

# Create and compress Yellow image (task 22)
# Calculate new percentage
percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)

# Create new percentage without decimal
percentage_new="${percentage%%.*}"

# If percentage is empty, make it "0"
if [[ "$percentage_new" == "" ]]; then
  percentage_new="0"
fi

# Echo percentage to zenity progress
echo "$percentage" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: Colorize and compress (Single file)\n\nCreating: ${input_file_no_path_or_ext}-Yellow.png\n\n${percentage_new}%" ; sleep 0.2
convert "$input_file" -fill "#f3e11f" -colorize "100" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Yellow.png"

# Compressing (task 23)
# Calculate new percentage
percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)

# Create new percentage without decimal
percentage_new="${percentage%%.*}"

# If percentage is empty, make it "0"
if [[ "$percentage_new" == "" ]]; then
  percentage_new="0"
fi

# Echo percentage to zenity
echo "$percentage" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: Colorize and compress (Single file)\n\nCompressing: ${input_file_no_path_or_ext}-Yellow.png\n\n${percentage_new}%" ; sleep 0.2

# Compress yellow decal
pngquant --force --quality=60-100 --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Yellow.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Yellow.png"

# Create and compress Neon-Green image (task 24)
# Calculate new percentage
percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)

# Create new percentage without decimal
percentage_new="${percentage%%.*}"

# If percentage is empty, make it "0"
if [[ "$percentage_new" == "" ]]; then
  percentage_new="0"
fi

# Echo percentage to zenity progress
echo "$percentage" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: Colorize and compress (Single file)\n\nCreating: ${input_file_no_path_or_ext}-Neon-Green.png\n\n${percentage_new}%" ; sleep 0.2

# Convert decal to neon-green
convert "$input_file" -fill "#39FF14" -colorize "100" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Neon-Green.png"

# Compressing (task 26)
# Calculate new percentage
percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)

# Create new percentage without decimal
percentage_new="${percentage%%.*}"

# If percentage is empty, make it "0"
if [[ "$percentage_new" == "" ]]; then
  percentage_new="0"
fi

# Echo percentage to zenity progress
echo "$percentage" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: Colorize and compress (Single file)\n\nCompressing: ${input_file_no_path_or_ext}-Neon-Green.png\n\n${percentage_new}%" ; sleep 0.2

# Compress neon-green decal
pngquant --force --quality=60-100 --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Neon-Green.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Neon-Green.png"

echo "100%" ; sleep 2
echo "# Finished Creating Decal Images" ; sleep 2
}
#####################################################################################
# Create function for generating color decals and compressing png (multiple images) #
#####################################################################################
colorize_multiple () {

# The input or "source" .png file
input_dir=$(zenity --file-selection --directory --filename="${black_fill_dir}/" --title="Select a directory")

# If the user selects the "cancel" button, close the script
if [[ "$?" == "1" ]]; then
  # Remove temp directory
  rm -rf "$temp_dir"
  exit
fi

# Set initial percentage
percentage="0"

# get total number of files in input directory
total_files=$(ls "$input_dir" 2> /dev/null | wc -l)

# Multiply total_files variable x 27 (27 processes performed)
tasks=$(echo "${total_files}*26" | bc)

# Get number to increment progress bar by
increment=$(echo "scale=2; 99/${tasks}" | bc)

# Set current decal number in loop
current_decal_number="0"

# Start looping through directory
for decal in "${input_dir}"/* ; do

  # Set value for current decal in loop
  ((current_decal_number++))

  # Remove path from variable "input_file"
  input_file_no_path=$(basename "$decal")

  # Remove path and extension from variable "input_file"
  input_file_no_path_or_ext=$(basename "${decal%.*}")

  # Create directory from decal name
  mkdir -p "${colorized_dir}/${input_file_no_path_or_ext}"

  # Create and compress white image (task 1)
  # Calculate percentage
  percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)

  # Create new percentage without decimal
  percentage_new="${percentage%%.*}"

  # If percentage is empty, make it "0"
  if [[ "$percentage_new" == "" ]]; then
    percentage_new="0"
  fi

  # Echo percentage to zenity progress
  echo "$percentage" ; sleep 0.2

  # Echo text to zenity progress
  echo "# Task: Colorize and compress (Multiple files)\n\nCurrent Decal: ${current_decal_number} of ${total_files}\n\nCreating: ${input_file_no_path_or_ext}-White.png\n\n${percentage_new}%" ; sleep 0.2

  # Convert decal to white
  convert "$decal" -fill "#ffffff" -colorize "100" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-White.png"

  # Compressing (task 2)
  percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)

  # Create new percentage without decimal
  percentage_new="${percentage%%.*}"

  # If percentage is empty, make it "0"
  if [[ "$percentage_new" == "" ]]; then
    percentage_new="0"
  fi

  # Echo percentage to zenity progress
  echo "$percentage" ; sleep 0.2

  # Echo text to zenity progress
  echo "# Task: Colorize and compress (Multiple files)\n\nCurrent Decal: ${current_decal_number} of ${total_files}\n\nCompressing: ${input_file_no_path_or_ext}-White.png\n\n${percentage_new}%" ; sleep 0.2

  # Compress white decal
  pngquant --force --quality=60-100 --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-White.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-White.png"

  # Create and compress black image (task 3)
  # Calculate percentage
  percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)

  # Create new percentage without decimal
  percentage_new="${percentage%%.*}"

  # If percentage is empty, make it "0"
  if [[ "$percentage_new" == "" ]]; then
    percentage_new="0"
  fi

  # Echo percentage to zenity progress
  echo "$percentage" ; sleep 0.2

  # Echo text to zenity progress
  echo "# Task: Colorize and compress (Multiple files)\n\nCurrent Decal: ${current_decal_number} of ${total_files}\n\nCreating: ${input_file_no_path_or_ext}-Black.png\n\n${percentage_new}%" ; sleep 0.2

  # Convert decal to black
  convert "$decal" -fill "#000000" -colorize "100" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Black.png"

  # Compressing (task 4)
  # Calculate percentage
  percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)

  # Create new percentage without decimal
  percentage_new="${percentage%%.*}"

  # If percentage is empty, make it "0"
  if [[ "$percentage_new" == "" ]]; then
    percentage_new="0"
  fi

  # Echo percentage to zenity progress
  echo "$percentage" ; sleep 0.2

  # Echo text to zenity progress
  echo "# Task: Colorize and compress (Multiple files)\n\nCurrent Decal: ${current_decal_number} of ${total_files}\n\nCompressing: ${input_file_no_path_or_ext}-Black.png\n\n${percentage_new}%" ; sleep 0.2

  # Compress black decal
  pngquant --force --quality=60-100 --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Black.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Black.png"

  # Create and compress Blue image (task 5)
  # Calculate percentage
  percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)

  # Create new percentage without decimal
  percentage_new="${percentage%%.*}"

  # If percentage is empty, make it "0"
  if [[ "$percentage_new" == "" ]]; then
    percentage_new="0"
  fi

  # Echo percentage to zenity progress
  echo "$percentage" ; sleep 0.2

  # Echo text to zenity progress
  echo "# Task: Colorize and compress (Multiple files)\n\nCurrent Decal: ${current_decal_number} of ${total_files}\n\nCreating: ${input_file_no_path_or_ext}-Blue.png\n\n${percentage_new}%" ; sleep 0.2

  # Convert decal to blue
  convert "$decal" -fill "#1791d8" -colorize "100" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Blue.png"

  # Compressing (task 6)
  # Calculate percentage
  percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)

  # Create new percentage without decimal
  percentage_new="${percentage%%.*}"

  # If percentage is empty, make it "0"
  if [[ "$percentage_new" == "" ]]; then
    percentage_new="0"
  fi

  # Echo percentage to zenity progress
  echo "$percentage" ; sleep 0.2

  # Echo text to zenity progress
  echo "# Task: Colorize and compress (Multiple files)\n\nCurrent Decal: ${current_decal_number} of ${total_files}\n\nCompressing: ${input_file_no_path_or_ext}-Blue.png\n\n${percentage_new}%" ; sleep 0.2

  # Compress blue decal
  pngquant --force --quality=60-100 --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Blue.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Blue.png"

  # Create and compress Teal image (task 7)
  # Calculate percentage
  percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)

  # Create new percentage without decimal
  percentage_new="${percentage%%.*}"

  # If percentage is empty, make it "0"
  if [[ "$percentage_new" == "" ]]; then
    percentage_new="0"
  fi

  # Echo percentage to zenity progress
  echo "$percentage" ; sleep 0.2

  # Echo text to zenity progress
  echo "# Task: Colorize and compress (Multiple files)\n\nCurrent Decal: ${current_decal_number} of ${total_files}\n\nCreating: ${input_file_no_path_or_ext}-Teal.png\n\n${percentage_new}%" ; sleep 0.2

  # Convert decal to teal
  convert "$decal" -fill "#29bbc8" -colorize "100" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Teal.png"

  # Compressing (task 8)
  # Calculate percentage
  percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)

  # Create new percentage without decimal
  percentage_new="${percentage%%.*}"

  # If percentage is empty, make it "0"
  if [[ "$percentage_new" == "" ]]; then
    percentage_new="0"
  fi

  # Echo percentage to zenity progress
  echo "$percentage" ; sleep 0.2

  # Echo text to zenity progress
  echo "# Task: Colorize and compress (Multiple files)\n\nCurrent Decal: ${current_decal_number} of ${total_files}\n\nCompressing: ${input_file_no_path_or_ext}-Teal.png\n\n${percentage_new}%" ; sleep 0.2

  # Compress teal decal
  pngquant --force --quality=60-100 --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Teal.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Teal.png"

  # Create and compress Red image (task 9)
  # Calculate percentage
  percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)

  # Create new percentage without decimal
  percentage_new="${percentage%%.*}"

  # If percentage is empty, make it "0"
  if [[ "$percentage_new" == "" ]]; then
    percentage_new="0"
  fi

  # Echo percentage to zenity progress
  echo "$percentage" ; sleep 0.2

  # Echo text to zenity progress
  echo "# Task: Colorize and compress (Multiple files)\n\nCurrent Decal: ${current_decal_number} of ${total_files}\n\nCreating: ${input_file_no_path_or_ext}-Red.png\n\n${percentage_new}%" ; sleep 0.2

  # Convert decal to red
  convert "$decal" -fill "#a01922" -colorize "100" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Red.png"

  # Compressing (task 10)
  # Calculate percentage
  percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)

  # Create new percentage without decimal
  percentage_new="${percentage%%.*}"

  # If percentage is empty, make it "0"
  if [[ "$percentage_new" == "" ]]; then
    percentage_new="0"
  fi

  # Echo percentage to zenity progress
  echo "$percentage" ; sleep 0.2

  # Echo text to zenity progress
  echo "# Task: Colorize and compress (Multiple files)\n\nCurrent Decal: ${current_decal_number} of ${total_files}\n\nCompressing: ${input_file_no_path_or_ext}-Red.png\n\n${percentage_new}%" ; sleep 0.2

  # Compress red decal
  pngquant --force --quality=60-100 --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Red.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Red.png"

  # Create and compress Green image (task 11)
  # Calculate percentage
  percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)

  # Create new percentage without decimal
  percentage_new="${percentage%%.*}"

  # If percentage is empty, make it "0"
  if [[ "$percentage_new" == "" ]]; then
    percentage_new="0"
  fi

  # Echo percentage to zenity progress
  echo "$percentage" ; sleep 0.2

  # Echo text to zenity progress
  echo "# Task: Colorize and compress (Multiple files)\n\nCurrent Decal: ${current_decal_number} of ${total_files}\n\nCreating: ${input_file_no_path_or_ext}-Green.png\n\n${percentage_new}%" ; sleep 0.2

  # Convert decal to green
  convert "$decal" -fill "#008c35" -colorize "100" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Green.png"

  # Compressing (task 12)
  # Calculate percentage
  percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)

  # Create new percentage without decimal
  percentage_new="${percentage%%.*}"

  # If percentage is empty, make it "0"
  if [[ "$percentage_new" == "" ]]; then
    percentage_new="0"
  fi

  # Echo percentage to zenity progress
  echo "$percentage" ; sleep 0.2

  # Echo text to zenity progress
  echo "# Task: Colorize and compress (Multiple files)\n\nCurrent Decal: ${current_decal_number} of ${total_files}\n\nCompressing: ${input_file_no_path_or_ext}-Green.png\n\n${percentage_new}%" ; sleep 0.2

  # Compress green decal
  pngquant --force --quality=60-100 --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Green.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Green.png"

  # Create and compress Silver image (task 13)
  # Calculate new percentage
  percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)

  # Create new percentage without decimal
  percentage_new="${percentage%%.*}"

  # If percentage is empty, make it "0"
  if [[ "$percentage_new" == "" ]]; then
    percentage_new="0"
  fi

  # Echo percentage to zenity progress
  echo "$percentage" ; sleep 0.2

  # Echo text to zenity progress
  echo "# Task: Colorize and compress (Multiple files)\n\nCurrent Decal: ${current_decal_number} of ${total_files}\n\nCreating: ${input_file_no_path_or_ext}-Silver.png\n\n${percentage_new}%" ; sleep 0.2

  # Convert decal to silver
  convert "$decal" -fill "#928F98" -colorize "100" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Silver.png"

  # Compressing (task 14)
  # Calculate new percentage
  percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)

  # Create new percentage without decimal
  percentage_new="${percentage%%.*}"

  # If percentage is empty, make it "0"
  if [[ "$percentage_new" == "" ]]; then
    percentage_new="0"
  fi

  # Echo percentage to zenity progress
  echo "$percentage" ; sleep 0.2

  # Echo text to zenity progress
  echo "# Task: Colorize and compress (Multiple files)\n\nCurrent Decal: ${current_decal_number} of ${total_files}\n\nCompressing: ${input_file_no_path_or_ext}-Silver.png\n\n${percentage_new}%" ; sleep 0.2

  # Compress silver decal
  pngquant --force --quality=60-100 --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Silver.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Silver.png"

  # Create and compress Pink image (task 15)
  # Calculate new percentage
  percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)

  # Create new percentage without decimal
  percentage_new="${percentage%%.*}"

  # If percentage is empty, make it "0"
  if [[ "$percentage_new" == "" ]]; then
    percentage_new="0"
  fi

  # Echo percentage to zenity progress
  echo "$percentage" ; sleep 0.2

  # Echo text to zenity progress
  echo "# Task: Colorize and compress (Multiple files)\n\nCurrent Decal: ${current_decal_number} of ${total_files}\n\nCreating: ${input_file_no_path_or_ext}-Pink.png\n\n${percentage_new}%" ; sleep 0.2

  # Convert decal to pink
  convert "$decal" -fill "#FFADE5" -colorize "100" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Pink.png"

  # Compressing (task 16)
  # Calculate new percentage
  percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)

  # Create new percentage without decimal
  percentage_new="${percentage%%.*}"

  # If percentage is empty, make it "0"
  if [[ "$percentage_new" == "" ]]; then
    percentage_new="0"
  fi

  # Echo percentage to zenity progress
  echo "$percentage" ; sleep 0.2

  # Echo text to zenity progress
  echo "# Task: Colorize and compress (Multiple files)\n\nCurrent Decal: ${current_decal_number} of ${total_files}\n\nCompressing: ${input_file_no_path_or_ext}-Pink.png\n\n${percentage_new}%" ; sleep 0.2

  # Compress pink decal
  pngquant --force --quality=60-100 --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Pink.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Pink.png"

  # Create and compress purple image (task 17)
  # Calculate new percentage
  percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)

  # Create new percentage without decimal
  percentage_new="${percentage%%.*}"

  # If percentage is empty, make it "0"
  if [[ "$percentage_new" == "" ]]; then
    percentage_new="0"
  fi

  # Echo percentage to zenity progress
  echo "$percentage" ; sleep 0.2

  # Echo text to zenity progress
  echo "# Task: Colorize and compress (Multiple files)\n\nCurrent Decal: ${current_decal_number} of ${total_files}\n\nCreating: ${input_file_no_path_or_ext}-Purple.png\n\n${percentage_new}%" ; sleep 0.2

  # Convert decal to purple
  convert "$decal" -fill "#452167" -colorize "100" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Purple.png"

  # Compressing (task 18)
  # Calculate new percentage
  percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)

  # Create new percentage without decimal
  percentage_new="${percentage%%.*}"

  # If percentage is empty, make it "0"
  if [[ "$percentage_new" == "" ]]; then
    percentage_new="0"
  fi

  # Echo percentage to zenity progress
  echo "$percentage" ; sleep 0.2

  # Echo text to zenity progress
  echo "# Task: Colorize and compress (Multiple files)\n\nCurrent Decal: ${current_decal_number} of ${total_files}\n\nCompressing: ${input_file_no_path_or_ext}-Purple.png\n\n${percentage_new}%" ; sleep 0.2

  # Compress purple decal
  pngquant --force --quality=60-100 --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Purple.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Purple.png"

  # Create and compress Dark-Blue image (task 18)
  # Calculate new percentage
  percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)

  # Create new percentage without decimal
  percentage_new="${percentage%%.*}"

  # If percentage is empty, make it "0"
  if [[ "$percentage_new" == "" ]]; then
    percentage_new="0"
  fi

  # Echo percentage to zenity progress
  echo "$percentage" ; sleep 0.2

  # Echo text to zenity progress
  echo "# Task: Colorize and compress (Multiple files)\n\nCurrent Decal: ${current_decal_number} of ${total_files}\n\nCreating: ${input_file_no_path_or_ext}-Dark-Blue.png\n\n${percentage_new}%" ; sleep 0.2

  # Convert decal to dark-blue
  convert "$decal" -fill "#003478" -colorize "100" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Dark-Blue.png"

  # Compressing (task 19)
  # Calculate new percentage
  percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)

  # Create new percentage without decimal
  percentage_new="${percentage%%.*}"

  # If percentage is empty, make it "0"
  if [[ "$percentage_new" == "" ]]; then
    percentage_new="0"
  fi

  # Echo percentage to zenity progress
  echo "$percentage" ; sleep 0.2

  # Echo text to zenity progress
  echo "# Task: Colorize and compress (Multiple files)\n\nCurrent Decal: ${current_decal_number} of ${total_files}\n\nCompressing: ${input_file_no_path_or_ext}-Dark-Blue\n\n${percentage_new}%" ; sleep 0.2

  # Convert decal to dark-blue
  pngquant --force --quality=60-100 --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Dark-Blue.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Dark-Blue.png"

  # Create and compress Orange image (task 20)
  # Calculate new percentage
  percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)

  # Create new percentage without decimal
  percentage_new="${percentage%%.*}"

  # If percentage is empty, make it "0"
  if [[ "$percentage_new" == "" ]]; then
    percentage_new="0"
  fi

  # Echo percentage to zenity progress
  echo "$percentage" ; sleep 0.2

  # Echo text to zenity progress
  echo "# Task: Colorize and compress (Multiple files)\n\nCurrent Decal: ${current_decal_number} of ${total_files}\n\nCreating: ${input_file_no_path_or_ext}-Orange.png\n\n${percentage_new}%" ; sleep 0.2

  # Convert decal to orange
  convert "$decal" -fill "#d56f31" -colorize "100" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Orange.png"

  # Compressing (task 21)
  # Calculate new percentage
  percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)

  # Create new percentage without decimal
  percentage_new="${percentage%%.*}"

  # If percentage is empty, make it "0"
  if [[ "$percentage_new" == "" ]]; then
    percentage_new="0"
  fi

  # Echo percentage to zenity progress
  echo "$percentage" ; sleep 0.2

  # Echo text to zenity progress
  echo "# Task: Colorize and compress (Multiple files)\n\nCurrent Decal: ${current_decal_number} of ${total_files}\n\nCompressing: ${input_file_no_path_or_ext}-Orange.png\n\n${percentage_new}%" ; sleep 0.2

  # Compress orange decal
  pngquant --force --quality=60-100 --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Orange.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Orange.png"

  # Create and compress Yellow image (task 22)
  # Calculate new percentage
  percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)

  # Create new percentage without decimal
  percentage_new="${percentage%%.*}"

  # If percentage is empty, make it "0"
  if [[ "$percentage_new" == "" ]]; then
    percentage_new="0"
  fi

  # Echo percentage to zenity progress
  echo "$percentage" ; sleep 0.2

  # Echo text to zenity progress
  echo "# Task: Colorize and compress (Multiple files)\n\nCurrent Decal: ${current_decal_number} of ${total_files}\n\nCreating: ${input_file_no_path_or_ext}-Yellow.png\n\n${percentage_new}%" ; sleep 0.2
  convert "$decal" -fill "#f3e11f" -colorize "100" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Yellow.png"

  # Compressing (task 23)
  # Calculate new percentage
  percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)

  # Create new percentage without decimal
  percentage_new="${percentage%%.*}"

  # If percentage is empty, make it "0"
  if [[ "$percentage_new" == "" ]]; then
    percentage_new="0"
  fi

  # Echo percentage to zenity
  echo "$percentage" ; sleep 0.2

  # Echo text to zenity progress
  echo "# Task: Colorize and compress (Multiple files)\n\nCurrent Decal: ${current_decal_number} of ${total_files}\n\nCompressing: ${input_file_no_path_or_ext}-Yellow.png\n\n${percentage_new}%" ; sleep 0.2

  # Compress yellow decal
  pngquant --force --quality=60-100 --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Yellow.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Yellow.png"

  # Create and compress Neon-Green image (task 24)
  # Calculate new percentage
  percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)

  # Create new percentage without decimal
  percentage_new="${percentage%%.*}"

  # If percentage is empty, make it "0"
  if [[ "$percentage_new" == "" ]]; then
    percentage_new="0"
  fi

  # Echo percentage to zenity progress
  echo "$percentage" ; sleep 0.2

  # Echo text to zenity progress
  echo "# Task: Colorize and compress (Multiple files)\n\nCurrent Decal: ${current_decal_number} of ${total_files}\n\nCreating: ${input_file_no_path_or_ext}-Neon-Green.png\n\n${percentage_new}%" ; sleep 0.2

  # Convert decal to neon-green
  convert "$decal" -fill "#39FF14" -colorize "100" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Neon-Green.png"

  # Compressing (task 26)
  # Calculate new percentage
  percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)

  # Create new percentage without decimal
  percentage_new="${percentage%%.*}"

  # If percentage is empty, make it "0"
  if [[ "$percentage_new" == "" ]]; then
    percentage_new="0"
  fi

  # Echo percentage to zenity progress
  echo "$percentage" ; sleep 0.2

  # Echo text to zenity progress
  echo "# Task: Colorize and compress (Multiple files)\n\nCurrent Decal: ${current_decal_number} of ${total_files}\n\nCompressing: ${input_file_no_path_or_ext}-Neon-Green.png\n\n${percentage_new}%" ; sleep 0.2

  # Compress neon-green decal
  pngquant --force --quality=60-100 --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Neon-Green.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Neon-Green.png"
done

echo "100%" ; sleep 2
echo "# Finished Creating colorized Decal Images" ; sleep 2
}
#############################################################
# Create function for generating a gif image (single image) #
#############################################################
gif_conversion_single () {

# Select the input directory
dir_input=$(zenity --file-selection --directory --filename="${colorized_dir}/" --title="GIF (Single file)")

# If the user selects the "cancel" button, close the script
if [[ "$?" == "1" ]]; then
  # Remove temp directory
  rm -rf "$temp_dir"
  exit
fi

# Directory where the gif directories are saved
dir_output="$gif_dir"

# Get directory name
directory_name=$(basename "$dir_input")

# Convert decal to gif
convert -dispose previous -delay 100 -loop 0 "${dir_input}/*.png" "${gif_dir}/${directory_name}.gif" 2>/dev/null
}
##########################################################################################
# Create function for generating gif images from "Colorized" directory (multiple images) #
##########################################################################################
gif_conversion_multiple() {

# The input directory
dir_input=$(zenity --file-selection --directory --filename="${colorized_dir}/" --title="Select a directory")

# If the user selects the "cancel" button, close the script
if [[ "$?" == "1" ]]; then
  # Remove temp directory
  rm -rf "$temp_dir"
  exit
fi

# Directory where the gif directories are saved
dir_output="$gif_dir"

# Count number of decal directories
total_directories=$(ls "$dir_input" 2> /dev/null | wc -l)

# Get number to increment progress bar by
increment=$(echo "scale=2; 99/${total_directories}" | bc)

# Set initial percentage
percentage="0"

# Set current decal number in loop
current_decal_number="0"

# Create loop
for decal in ${colorized_dir}/* ; do

  # Set value for current decal in loop
  ((current_decal_number++))

  # remove path for zenity progress
  decal_basename=$(basename "${decal%.*}")

  # Create new percentage without decimal
  percentage_new="${percentage%%.*}"

  # If percentage is empty, make it "0"
  if [[ "$percentage_new" == "" ]]; then
    percentage_new="0"
  fi

  # Convert decal to gif
  convert -dispose previous -delay 100 -loop 0 "${decal}/*.png" "${dir_output}/${decal_basename}.gif" 2>/dev/null

  # increment percentage number
  percentage=$(echo "${percentage}+${increment}" | bc)

  # Echo percentage number to zenity progress
  echo "$percentage" ; sleep 0.2

  # Echo text for zenity progress
  echo "# Task: GIF (Multiple files)\n\nCurrent Decal: ${current_decal_number} of ${total_directories}\n\nCreating: ${decal_basename}.gif\n\n${percentage_new}%"; sleep 0.2
done
}
####################################################################################
# Create function for tablet image creation for slideshow from colorized directory #
####################################################################################
create_tablet_images () {

# The input directory
dir_input="$colorized_dir"

# Count number of decals
total_files=$(ls $dir_input/*/*.png 2> /dev/null | wc -l)

# Get number to increment progress bar by
increment=$(echo "scale=2; 99/${total_files}" | bc)

# Set initial percentage
percentage="0"

# Set current decal number in loop
current_decal_number="0"

for decal in ${colorized_dir}/*/*.png ; do

  # Get decal basename
  decal_basename=$(basename "${decal}")

  # Set value for current decal in loop
  ((current_decal_number++))

  # increment percentage number
  percentage=$(echo "${percentage}+${increment}" | bc)

  # Create new percentage without decimal
  percentage_new="${percentage%%.*}"

  # If percentage is empty, make it "0"
  if [[ "$percentage_new" == "" ]]; then
    percentage_new="0"
  fi

   # Echo percentage number to zenity progress
  echo "$percentage" ; sleep 0.2

  # Echo text for zenity progress
  echo "# Task: Create tablet images\n\nCurrent Decal: ${current_decal_number} of ${total_files}\n\nCreating: ${decal_basename}\n\n${percentage_new}%"; sleep 0.2

  # Create tablet image
  composite "$decal" "/usr/share/decal-converter/bg-tablet.png" -gravity Center -quality 95 "${tablet_dir}/${decal_basename}"

done  | zenity --progress --auto-close --auto-kill --width="500" --height="100" --title="Creating tablet images"
}
#######################################
# Create a function for the help page #
#######################################
help_page () {

zenity --text-info --title="Decal Converter Help - Options / Usage / Info" --filename="/usr/share/decal-converter/help.txt" --cancel-label="Exit And Close Program" --ok-label="Back To Decal Converter" --width="800" --height="800"

if [[ "$?" == "1" ]]; then
  rm -rf "$temp_dir"
  exit
else exec "$0"
fi
}
#############################################################################################
# Create a function to clean decal directories - Remove files from within decal directories #
#############################################################################################
clean_decal_directories () {

# Remove files in decals directory, and restart script
rm -f ~/Decals/Original/*
rm -rf ~/Decals/Colorized/*
rm -f ~/Decals/Black-Fill/*
rm -f ~/Decals/White-Background/*
rm -f ~/Decals/GIF/*
rm -f ~/Decals/Tablet/*
rm -f ~/Decals/Resized-Transparent/*
}
###############
# MAIN SCRIPT #
###############
# See if "Decals" directory exists, and create if it doesn't
if [[ ! -d "${decals}" ]]; then
  zenity --info --title="Decals directory does not exist" --text="Since this is the first time running Decal Converter\n\n \*  A \"Decals\" directory will be created in your home directory\n\n \*  \"Decals\" will be added to your bookmarks" --width="500"

  # If user selects cancel then exit
  if [[ "$?" == "1" ]]; then
    # Remove temp directory
    rm -rf "$temp_dir"
    exit
  fi

  # Make directory main "Decals", and subdirectories if they don't exist
  if [[ ! -d "$decals" ]]; then
    mkdir -p "$decals"
    mkdir "$original_dir"
    mkdir "$colorized_dir"
    mkdir "$black_fill_dir"
    mkdir "$gif_dir"
    mkdir "$tablet_dir"
    mkdir "$resized_transparent"
    mkdir "$white_background_dir"
    mkdir "$temp_dir"
  fi
  # Change bookmark breakpoints from default 10 - 15
  dconf write /org/nemo/window-state/sidebar-bookmark-breakpoint 15

  # Add "Decals" directory to bookmarks
  echo "file://${HOME}/Decals Decals" >> "${HOME}/.config/gtk-3.0/bookmarks"
fi

# Ask user which task they would like to perform
action1=$(zenity --list --title="What would you like to do?" --text="Please select an option" --cancel-label="Exit" --column="Select" --column="Task to perform" TRUE "$opt1" FALSE "$opt2" FALSE "$opt3" FALSE "$opt4" FALSE "$opt5" FALSE "$opt6" FALSE "$opt7" FALSE "$opt8" FALSE "$opt9" FALSE "$opt10" --radiolist --width="350" --height="350")
if [[ "$?" == "1" ]]; then
  if [[ -d "$temp_dir" ]]; then
    rm -rf "$temp_dir"
  fi
  exit
fi

# All task single (Mirrored) - Single file
if [[ "$action1" == "$opt2" ]]; then
  all_tasks_single_mirrored | zenity --progress --auto-close --auto-kill --width="500" --height="100" --title="Performing all tasks - Mirrored (Single file)"
  # Ask user if they have more decals to do
  zenity --question --title="Do you have more decals?" --text="Would you like to Exit or Continue?" --ok-label="Continue" --cancel-label="Exit" --width="400" --height="100"
  if [[ "$?" == "0" ]]; then
    # Restart script
    exec "$0"
  elif [[ "$?" == "1" ]]; then
    # Remove temp directory
    rm -rf "$temp_dir"
    exit
  fi
fi

# Create tablet images from colorized directory
if [[ "$action1" == "$opt8" ]]; then
 create_tablet_images
 # Ask user if they have more decals to do
  zenity --question --title="Do you have more decals?" --text="Would you like to Exit or Continue?" --ok-label="Continue" --cancel-label="Exit" --width="400" --height="100"
  if [[ "$?" == "0" ]]; then
    # Restart script
    exec "$0"
  elif [[ "$?" == "1" ]]; then
    # Remove temp directory
    rm -rf "$temp_dir"
    exit
  fi
fi

# Clean decal directories
if [[ "$action1" == "$opt9" ]]; then
  clean_decal_directories
  exec "$0"
fi

# Help page
if [[ "$action1" == "$opt10" ]]; then
  help_page
fi

# Ask user if single or multiple files
action2=$(zenity --list --title="do you have a single file or multiple files?" --text="Please select an option" --cancel-label="Exit" --column="Select" --column="Task to perform" TRUE "$opt11" FALSE "$opt12" --radiolist --width="350" --height="175")
if [[ "$?" == "1" ]]; then
  # Remove temp directory
  rm -rf "$temp_dir"
  exit
fi

# Single file - All tasks
if [[ "$action1" == "$opt1" ]] && [[ "$action2" == "$opt11" ]]; then
  all_tasks_single | zenity --progress --auto-close --auto-kill --width="500" --height="100" --title="Performing all tasks (Single file)"

# Multiple files - All tasks
elif [[ "$action1" == "$opt1" ]] && [[ "$action2" == "$opt12" ]]; then
  all_tasks_multiple | zenity --progress --auto-close --auto-kill --width="500" --height="100" --title="Performing all tasks (Multiple files)"

# Single file - Background removal and resize
elif [[ "$action1" == "$opt3" ]] && [[ "$action2" == "$opt11" ]]; then
  remove_background_resize_single

# Multiple files - Background removal and resize
elif [[ "$action1" == "$opt3" ]] && [[ "$action2" == "$opt12" ]]; then
remove_background_resize_multiple | zenity --progress --auto-close --auto-kill  --width="500" --height="100" --title="Removing Background And Resizing"

# Single file - Black fill
elif [[ "$action1" == "$opt4" ]] && [[ "$action2" == "$opt11" ]]; then
  black_fill_single

# Multiple files - Black fill
elif [[ "$action1" == "$opt4" ]] && [[ "$action2" == "$opt12" ]]; then
  black_fill_multiple | zenity --progress --auto-close --auto-kill  --width="500" --height="100" --title="Filling Decal Color With Black"

# Single file - White background
elif [[ "$action1" == "$opt5" ]] && [[ "$action2" == "$opt11" ]]; then
  white_background_single

# Multiple files - White background
elif [[ "$action1" == "$opt5" ]] && [[ "$action2" == "$opt12" ]]; then
  white_background_multiple | zenity --progress --auto-close --auto-kill  --width="500" --height="100" --title="Decal on white background"

# Single colorize conversion
elif [[ "$action1" == "$opt6" ]] && [[ "$action2" == "$opt11" ]]; then
  colorize_single | zenity --progress --auto-close --auto-kill  --width="500" --height="100" --title="Colorizing decals (Single file)"

# Multiple colorize conversion
elif [[ "$action1" == "$opt6" ]] && [[ "$action2" == "$opt12" ]]; then
  colorize_multiple | zenity --progress --auto-close --auto-kill --width="500" --height="100" --title="Colorizing decals (Multiple files)"

# Single gif conversion
elif [[ "$action1" == "$opt7" ]] && [[ "$action2" == "$opt11" ]]; then
  gif_conversion_single

# Multiple gif conversion
elif [[ "$action1" == "$opt7" ]] && [[ "$action2" == "$opt12" ]]; then
  gif_conversion_multiple | zenity --progress --auto-close --auto-kill  --width="500" --title="Creating GIF images"
fi

# Ask user if they have more decals to do
zenity --question --title="Do you have more decals?" --text="Would you like to Exit or Continue?" --ok-label="Continue" --cancel-label="Exit" --width="400" --height="100"
if [[ "$?" == "0" ]]; then
  # Restart script
  exec "$0"
elif [[ "$?" == "1" ]]; then
  # Remove temp directory
  rm -rf "$temp_dir"
  exit
fi
