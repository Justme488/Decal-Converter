#!/usr/bin/env bash
#########################################################################################################################################################################
# Decal converter by Ed Houseman jr - Created 10/27/22 - Revised 3/18/25                                                                                                #
#########################################################################################################################################################################
# This script relies on Imagemagick, Pngquant, and Zenity installed on a Unix system - Tested on Linux Mint 22.1 Cinnamon                                               #
#########################################################################################################################################################################
# Operations: Create backup, Trim decal padding, Resize to 800x800px, Fill visible color with black, Convert to GIF, Colorize, Decal on white background, Tablet images #
#########################################################################################################################################################################
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
# Single decal - normal
opt1="Single Decal - Normal"

# AIO - Perform all tasks (Single file - Mirrored)
opt2="Single Decal ( Mirrored )"

# Trim and resize
opt3="Multiple Decals"

# Clean Decal Directories - Fresh start
opt4="Clean Decal Directories"

# Help
opt5="Help - Options / Usage / Info"

#############
# Functions #
#############
#########################################
# Create function "single_decal_normal" #
#########################################
single_decal_normal () {
# Get number to increment progress bar by (45 actions / 99)
increment="2.2"

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

# Remove path and extension from input directory
input_file_no_path_or_ext=$(basename "${input_file%.*}")

# Get file extension
input_file_extension="${input_file##*.}"

# Get new percentage (task 1 - backup original decal)
percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

# Create new percentage without decimal
percentage_new="${percentage%%.*}"

# If percentage is empty, make it "0"
if [[ "$percentage_new" == "" ]]; then
  percentage_new="0"
fi

# Echo percentage to zenity progress
echo "$percentage_new" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: Creating backup\n\nCopying: ${input_file}\n\n${percentage_new}%" ; sleep 0.2

# If input_file is a remove bg file, remove "-removebg-preview" from filename. Then copy to "Original" directory (create backup - renamed)
if [[ "$input_file" == *"-removebg-preview.png" ]]; then
  cp "$input_file" "${original_dir}/${input_file_no_path_or_ext%-removebg-preview*}.${input_file_extension}"
  
  #reassign input_file variable
  input_file="${original_dir}/${input_file_no_path_or_ext%-removebg-preview*}.${input_file_extension}"
  
  # Remove path from "$input_file"
  input_file_no_path=$(basename "${input_file}")

  # Remove path and extension from input directory
  input_file_no_path_or_ext=$(basename "${input_file%.*}")

  # Get file extension
  input_file_extension="${input_file##*.}"
else
  # Copy input file to "original" directory (create backup)
  cp "$input_file" "$original_dir"
fi

# Reassign input_file
input_file="${original_dir}/${input_file_no_path_or_ext}.${input_file_extension}"

# Remove path from "$input_file"
input_file_no_path=$(basename "${input_file}")

# Remove path and extension from input directory
input_file_no_path_or_ext=$(basename "${input_file%.*}")

# Get file extension
input_file_extension="${input_file##*.}"

# Trim padding
# Get new percentage (task 2 - Trim padding)
percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

# Create new percentage without decimal
percentage_new="${percentage%%.*}"

# If percentage is empty, make it "0"
if [[ "$percentage_new" == "" ]]; then
  percentage_new="0"
fi

# Echo percentage to zenity progress
echo "$percentage_new" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: Trim Decal\n\nTrimming: ${input_file_no_path_or_ext}.png\n\n${percentage_new}%" ; sleep 0.2

# Echo percentage to zenity progress
echo "$percentage_new" ; sleep 0.2

# Trim image
convert -background "none" "$input_file" -trim +repage -alpha "on" -bordercolor "transparent" -border "5x5" -flatten -quality "95" "${temp_dir}/${input_file_no_path_or_ext}_trimmed.png" 
 
# Get input image width
input_file_width=$(identify -format "%w" "${temp_dir}/${input_file_no_path_or_ext}_trimmed.png")

# Get input image height
input_file_height=$(identify -format "%h" "${temp_dir}/${input_file_no_path_or_ext}_trimmed.png")

# Resize larger image dimension to 750px, and then paste onto 800x800 transparent background in temp directory
# Get new percentage (task 3 - resize)
percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

# Create new percentage without decimal
percentage_new="${percentage%%.*}"

# If percentage is empty, make it "0"
if [[ "$percentage_new" == "" ]]; then
  percentage_new="0"
fi

# Echo percentage to zenity progress
echo "$percentage_new" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: Resizing Decal\n\nResizing: ${input_file_no_path_or_ext}.png\n\n${percentage_new}%" ; sleep 0.2

# Resize based on larger dimension
if [[ "$input_file_width" -ge "$input_file_height" ]]; then
  convert -background "none" "${temp_dir}/${input_file_no_path_or_ext}_trimmed.png" -resize "750x" -sharpen "0x1" -gravity "center" -background "none" -extent "800x800" -quality "95" "${temp_dir}/${input_file_no_path_or_ext}_resized.png"
else
  convert -background "none" "${temp_dir}/${input_file_no_path_or_ext}_trimmed.png" -resize "x750" -sharpen "0x1" -gravity "center" -background "none" -extent "800x800" -quality "95" "${temp_dir}/${input_file_no_path_or_ext}_resized.png"
fi

# Copy resized decal in temp folder to remove "_resized" from filename
cp "${temp_dir}/${input_file_no_path_or_ext}_resized.png" "${temp_dir}/${input_file_no_path_or_ext}.png"

# Reassign input_file_new variable to "${resized_dir}/${input_file_no_path_or_ext}_resized.png"
input_file_new="${temp_dir}/${input_file_no_path_or_ext}.png"

# Get input file with no path or extension
input_file_no_path_or_ext=$(basename "${input_file_new%.*}")

# Get new percentage (task 4 - black fill)
percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

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
convert "$input_file_new" -sharpen "0x1" -alpha "on" -background "transparent" -fill "#000000" -colorize "100" -quality "95" "${black_fill_dir}/${input_file_no_path_or_ext}.png"

# White background
# Get new percentage (task 5 - white background)
percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

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
convert "${input_file_new}" -background "white" -alpha "remove" -alpha "off" -flatten -quality "95" "${white_background_dir}/${input_file_no_path_or_ext}.png"

# Colorize
# Create directory with decal name in colorized
mkdir "${colorized_dir}/${input_file_no_path_or_ext}"

# Create and compress white image
# Get new percentage (task 6 - colorize white)
percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

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
convert  "$input_file_new" -sharpen "0x1" -fill "#ffffff" -colorize "100%" -quality "95" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-White.png"

# Get new percentage (task 7 - compress white image)
percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

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
pngquant --force --quality="60-100" --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-White.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-White.png"

# Create and compress black image
# Get new percentage (task 8 - colorize black)
percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

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
convert "$input_file_new" -sharpen "0x1" -fill "#000000" -colorize "100" -quality "95" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Black.png"

# Get new percentage (task 9 - compress black)
percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

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
pngquant --force --quality="60-100" --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Black.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Black.png"

# Create and compress Blue image
# Get new percentage (task 10 - colorize blue)
percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

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
convert "$input_file_new" -sharpen "0x1" -fill "#1791d8" -colorize "100" -quality "95" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Blue.png"

# Get new percentage (task 11 - compress blue)
percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

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
pngquant --force --quality="60-100" --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Blue.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Blue.png"

# Create and compress Teal image
# Get new percentage (task 12 - colorize teal)
percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

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
convert "$input_file_new" -sharpen "0x1" -fill "#29bbc8" -colorize "100" -quality "95" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Teal.png"

# Get new percentage (task 13 - compress teal)
percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

# Echo percentage to zenity progress
echo "$percentage_new" ; sleep 0.2

# Create percentage without decimal
percentage_new="${percentage%%.*}"

# Echo text to zenity progress
echo "# Task: Colorize\n\nCompressing: ${input_file_no_path_or_ext}-Teal.png\n\n${percentage_new}%" ; sleep 0.2

# Compress teal decal
pngquant --force --quality="60-100" --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Teal.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Teal.png"

# Create and compress Red image
# Get new percentage (task 14 - colorize red)
percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

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
convert "$input_file_new" -sharpen "0x1" -fill "#a01922" -colorize "100" -quality "95" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Red.png"

# Get new percentage (task 15 - compress red)
percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

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
pngquant --force --quality="60-100" --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Red.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Red.png"

# Create and compress Green image
# Get new percentage (task 16 - colorize green)
percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

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
convert "$input_file_new" -sharpen "0x1" -fill "#008c35" -colorize "100" -quality "95" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Green.png"

# Get new percentage (task 17 - compress green)
percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

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
pngquant --force --quality="60-100" --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Green.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Green.png"

# Create and compress Silver image
# Get new percentage (task 18 - colorize silver)
percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

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
convert "$input_file_new" -sharpen "0x1" -fill "#928F98" -colorize "100" -quality "95" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Silver.png"

# Get new percentage (task 19 - compress silver)
percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

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
pngquant --force --quality="60-100" --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Silver.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Silver.png"

# Create and compress Pink image
# Get new percentage (task 20 - colorize pink)
percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

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
convert "$input_file_new" -sharpen "0x1" -fill "#FFADE5" -colorize "100" -quality "95" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Pink.png"

# Get new percentage (task 21 - compress pink)
percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

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
pngquant --force --quality="60-100" --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Pink.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Pink.png"

# Create and compress purple image
# Get new percentage (task 22 - colorize purple)
percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

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
convert "$input_file_new" -sharpen "0x1" -fill "#452167" -colorize "100" -quality "95" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Purple.png"

# Get new percentage (task 23 - compress purple)
percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

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
pngquant --force --quality="60-100" --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Purple.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Purple.png"

# Create and compress Dark-Blue image
# Get new percentage (task 24 - colorize dark blue)
percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

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
convert "$input_file_new" -sharpen "0x1" -fill "#003478" -colorize "100" -quality "95" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Dark-Blue.png"

# Get new percentage (task 25 - compress dark blue)
percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

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
pngquant --force --quality="60-100" --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Dark-Blue.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Dark-Blue.png"

# Create and compress Orange image
# Get percentage (task 26 - colorize orange)
percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

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
convert "$input_file_new" -sharpen "0x1" -fill "#d56f31" -colorize "100" -quality "95" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Orange.png"

# Get new percentage (task 27 - compress orange)
percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

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
pngquant --force --quality="60-100" --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Orange.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Orange.png"

# Create and compress Yellow image
# Get new percentage (task 28 - colorize yellow)
percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

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
convert "$input_file_new" -sharpen "0x1" -fill "#f3e11f" -colorize "100" -quality "95" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Yellow.png"

# Get new percentage (task 29 - compress yellow)
percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

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
pngquant --force --quality="60-100" --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Yellow.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Yellow.png"

# Create and compress Neon-Green image
# Get new percentage (task 30 - colorize neon green)
percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

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
convert "$input_file_new" -sharpen "0x1" -fill "#39FF14" -colorize "100" -quality "95" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Neon-Green.png"

# Get new percentage (task 31 - compress neon-green)
percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

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
pngquant --force --quality="60-100" --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Neon-Green.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Neon-Green.png"

# GIF
# Assign input_dir variable to "${colorized_dir}/${input_file_no_path_or_ext}"
input_dir="${colorized_dir}/${input_file_no_path_or_ext}"

# Get new percentage (task 32 - gif)
percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

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
convert -dispose previous -delay "100" -loop "0" "${input_dir}/"*.png -quality "95" "${gif_dir}/${input_file_no_path_or_ext}.gif"

# Tablet (add 13 tasks - 45 total)
for decal in "${colorized_dir}/${input_file_no_path_or_ext}/"*.png ; do

  # Get decal basename
  decal_basename=$(basename "${decal}")

  # Get new percentage
  percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

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
  composite "$decal" "/usr/share/decal-converter/bg-tablet.png" -gravity "center" "${tablet_dir}/${decal_basename}"
  
done

# Echo percentage to zenity progress
echo "100" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: All tasks finished\n\n100%" ; sleep 2
}
###########################################
# Create function "single_decal_mirrored" #
###########################################
single_decal_mirrored () {
# Get number to increment progress bar by (45 actions / 99)
increment="2.2"

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

# Remove path and extension from input directory
input_file_no_path_or_ext=$(basename "${input_file%.*}")

# Get file extension
input_file_extension="${input_file##*.}"

# Get new percentage (task 1 - backup original decal)
percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

# Create new percentage without decimal
percentage_new="${percentage%%.*}"

# If percentage is empty, make it "0"
if [[ "$percentage_new" == "" ]]; then
  percentage_new="0"
fi

# Echo percentage to zenity progress
echo "$percentage_new" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: Creating backup\n\nCopying: ${input_file}\n\n${percentage_new}%" ; sleep 0.2

# If input_file is a remove bg file, remove "-removebg-preview" from filename. Then copy to "Original" directory (create backup - renamed)
if [[ "$input_file" == *-removebg-preview.png ]]; then
  cp "$input_file" "${original_dir}/${input_file_no_path_or_ext%-removebg-preview*}.${input_file_extension}"
  
  #reassign input_file variable
  input_file="${original_dir}/${input_file_no_path_or_ext%-removebg-preview*}.${input_file_extension}"
  
  # Remove path from "$input_file"
  input_file_no_path=$(basename "${input_file}")

  # Remove path and extension from input directory
  input_file_no_path_or_ext=$(basename "${input_file%.*}")

  # Get file extension
  input_file_extension="${input_file##*.}"
else
  # Copy input file to "original" directory (create backup)
  cp "$input_file" "${original_dir}/${input_file_no_path}"
fi

# Reassign input_file
input_file="${original_dir}/${input_file_no_path_or_ext}.${input_file_extension}"

# Remove path from "$input_file"
input_file_no_path=$(basename "${input_file}")

# Remove path and extension from input directory
input_file_no_path_or_ext=$(basename "${input_file%.*}")

# Get file extension
input_file_extension="${input_file##*.}"

# Trim padding
# Get new percentage (task 2 - Trim padding)
percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

# Create new percentage without decimal
percentage_new="${percentage%%.*}"

# If percentage is empty, make it "0"
if [[ "$percentage_new" == "" ]]; then
  percentage_new="0"
fi

# Echo percentage to zenity progress
echo "$percentage_new" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: Trim Decal\n\nTrimming: ${input_file_no_path_or_ext}-Mirrored.png\n\n${percentage_new}%" ; sleep 0.2

# Echo percentage to zenity progress
echo "$percentage_new" ; sleep 0.2

# Trim image
convert -background "none" "$input_file" -flop -trim +repage -alpha "on" -bordercolor "transparent" -border "5x5" -flatten -quality "95" "${temp_dir}/${input_file_no_path_or_ext}-Mirrored_trimmed.png" 

# Get input image width
input_file_width=$(identify -format "%w" "${temp_dir}/${input_file_no_path_or_ext}-Mirrored_trimmed.png")

# Get input image height
input_file_height=$(identify -format "%h" "${temp_dir}/${input_file_no_path_or_ext}-Mirrored_trimmed.png")

# Resize larger image dimension to 750px, and then paste onto 800x800 transparent background in temp directory
# Get new percentage (task 3 - resize)
percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

# Create new percentage without decimal
percentage_new="${percentage%%.*}"

# If percentage is empty, make it "0"
if [[ "$percentage_new" == "" ]]; then
  percentage_new="0"
fi

# Echo percentage to zenity progress
echo "$percentage_new" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: Resizing Decal\n\nResizing: ${input_file_no_path_or_ext}-mirrored.png\n\n${percentage_new}%" ; sleep 0.2

# Resize based on larger dimension
if [[ "$input_file_width" -ge "$input_file_height" ]]; then
  convert -background "none" "${temp_dir}/${input_file_no_path_or_ext}-Mirrored_trimmed.png" -resize "750x" -sharpen "0x1" -gravity "center" -background "none" -extent "800x800" -quality "95" "${temp_dir}/${input_file_no_path_or_ext}-Mirrored_resized.png"
else
  convert -background "none" "${temp_dir}/${input_file_no_path_or_ext}-Mirrored_trimmed.png" -resize "x750" -sharpen "0x1" -gravity "center" -background "none" -extent "800x800" -quality "95" "${temp_dir}/${input_file_no_path_or_ext}-Mirrored_resized.png"
fi

# Reassign input_file_new variable to "${resized_dir}/${input_file_no_path_or_ext}_resized.png"
input_file_new="${temp_dir}/${input_file_no_path_or_ext}-Mirrored_resized.png"

# Reassign basename of input_file with no extension, and remove "_resized" from filename
input_file_no_path_or_ext=$(basename "${input_file_new%_resized.*}")

# Get new percentage (task 4 - black fill)
percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

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
convert "$input_file_new" -sharpen "0x1" -alpha "on" -background "transparent" -fill "#000000" -colorize "100" -quality "95" "${black_fill_dir}/${input_file_no_path_or_ext}.png"

# White background
# Get new percentage (task 5 - white background)
percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

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
convert "${input_file_new}" -background "white" -alpha "remove" -alpha "off" -flatten -quality "95" "${white_background_dir}/${input_file_no_path_or_ext}.png"

# Colorize
# Create directory with decal name in colorized
mkdir "${colorized_dir}/${input_file_no_path_or_ext}"

# Create and compress white image
# Get new percentage (task 6 - colorize white)
percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

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
convert  "$input_file_new" -sharpen "0x1" -fill "#ffffff" -colorize "100%" -quality "95" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-White.png"

# Get new percentage (task 7 - compress white image)
percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

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
pngquant --force --quality="60-100" --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-White.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-White.png"

# Create and compress black image
# Get new percentage (task 8 - colorize black)
percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

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
convert "$input_file_new" -sharpen "0x1" -fill "#000000" -colorize "100" -quality "95" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Black.png"

# Get new percentage (task 9 - compress black)
percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

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
pngquant --force --quality="60-100" --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Black.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Black.png"

# Create and compress Blue image
# Get new percentage (task 10 - colorize blue)
percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

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
convert "$input_file_new" -sharpen "0x1" -fill "#1791d8" -colorize "100" -quality "95" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Blue.png"

# Get new percentage (task 11 - compress blue)
percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

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
pngquant --force --quality="60-100" --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Blue.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Blue.png"

# Create and compress Teal image
# Get new percentage (task 12 - colorize teal)
percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

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
convert "$input_file_new" -sharpen "0x1" -fill "#29bbc8" -colorize "100" -quality "95" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Teal.png"

# Get new percentage (task 13 - compress teal)
percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

# Echo percentage to zenity progress
echo "$percentage_new" ; sleep 0.2

# Create percentage without decimal
percentage_new="${percentage%%.*}"

# Echo text to zenity progress
echo "# Task: Colorize\n\nCompressing: ${input_file_no_path_or_ext}-Teal.png\n\n${percentage_new}%" ; sleep 0.2

# Compress teal decal
pngquant --force --quality="60-100" --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Teal.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Teal.png"

# Create and compress Red image
# Get new percentage (task 14 - colorize red)
percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

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
convert "$input_file_new" -sharpen "0x1" -fill "#a01922" -colorize "100" -quality "95" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Red.png"

# Get new percentage (task 15 - compress red)
percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

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
pngquant --force --quality="60-100" --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Red.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Red.png"

# Create and compress Green image
# Get new percentage (task 16 - colorize green)
percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

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
convert "$input_file_new" -sharpen "0x1" -fill "#008c35" -colorize "100" -quality "95" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Green.png"

# Get new percentage (task 17 - compress green)
percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

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
pngquant --force --quality="60-100" --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Green.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Green.png"

# Create and compress Silver image
# Get new percentage (task 18 - colorize silver)
percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

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
convert "$input_file_new" -sharpen "0x1" -fill "#928F98" -colorize "100" -quality "95" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Silver.png"

# Get new percentage (task 19 - compress silver)
percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

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
pngquant --force --quality="60-100" --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Silver.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Silver.png"

# Create and compress Pink image
# Get new percentage (task 20 - colorize pink)
percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

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
convert "$input_file_new" -sharpen "0x1" -fill "#FFADE5" -colorize "100" -quality "95" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Pink.png"

# Get new percentage (task 21 - compress pink)
percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

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
pngquant --force --quality="60-100" --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Pink.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Pink.png"

# Create and compress purple image
# Get new percentage (task 22 - colorize purple)
percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

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
convert "$input_file_new" -sharpen "0x1" -fill "#452167" -colorize "100" -quality "95" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Purple.png"

# Get new percentage (task 23 - compress purple)
percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

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
pngquant --force --quality="60-100" --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Purple.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Purple.png"

# Create and compress Dark-Blue image
# Get new percentage (task 24 - colorize dark blue)
percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

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
convert "$input_file_new" -sharpen "0x1" -fill "#003478" -colorize "100" -quality "95" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Dark-Blue.png"

# Get new percentage (task 25 - compress dark blue)
percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

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
pngquant --force --quality="60-100" --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Dark-Blue.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Dark-Blue.png"

# Create and compress Orange image
# Get percentage (task 26 - colorize orange)
percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

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
convert "$input_file_new" -sharpen "0x1" -fill "#d56f31" -colorize "100" -quality "95" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Orange.png"

# Get new percentage (task 27 - compress orange)
percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

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
pngquant --force --quality="60-100" --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Orange.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Orange.png"

# Create and compress Yellow image
# Get new percentage (task 28 - colorize yellow)
percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

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
convert "$input_file_new" -sharpen "0x1" -fill "#f3e11f" -colorize "100" -quality "95" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Yellow.png"

# Get new percentage (task 29 - compress yellow)
percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

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
pngquant --force --quality="60-100" --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Yellow.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Yellow.png"

# Create and compress Neon-Green image
# Get new percentage (task 30 - colorize neon green)
percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

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
convert "$input_file_new" -sharpen "0x1" -fill "#39FF14" -colorize "100" -quality "95" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Neon-Green.png"

# Get new percentage (task 31 - compress neon-green)
percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

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
pngquant --force --quality="60-100" --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Neon-Green.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Neon-Green.png"

# GIF
# Assign input_dir variable to "${colorized_dir}/${input_file_no_path_or_ext}"
input_dir="${colorized_dir}/${input_file_no_path_or_ext}"

# Get new percentage (task 32 - gif)
percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

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
convert -dispose previous -delay "100" -loop "0" "${input_dir}/"*.png -quality "95" "${gif_dir}/${input_file_no_path_or_ext}.gif"

# Tablet (add 13 tasks - 45 total)
for decal in "${colorized_dir}/${input_file_no_path_or_ext}/"*.png ; do

  # Get decal basename
  decal_basename=$(basename "${decal}")

  # Get new percentage
  percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

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
  composite "$decal" "/usr/share/decal-converter/bg-tablet.png" -gravity "center" "${tablet_dir}/${decal_basename}"
done

# Echo percentage to zenity progress
echo "100" ; sleep 0.2

# Echo text to zenity progress
echo "# Task: All tasks finished\n\n100%" ; sleep 2
}
#####################################
# Create function "multiple_decals" #
#####################################
multiple_decals () {

# Select directory containing decals to convert
input_dir=$(zenity --file-selection --directory --filename="Desktop" --title="Select the source decals directory")

# If the user selects the "cancel" button, close the script
if [[ "$?" == "1" ]]; then
  exit
fi

# Set initial percentage
percentage="0"

# get total number of files in input directory
total_files=$(ls "$input_dir" 2> /dev/null | wc -l)

# Multiply total_files variable
tasks=$(echo "${total_files}*45" | bc)

# Get number to increment progress bar by (45 actions / 99)
increment=$(echo "scale=2; 99/${tasks}" | bc)

# Set current decal number in loop
current_decal_number="0"

# Start loop
for decal in "${input_dir}/"*; do

  # Assign "input_file" to "$decal"
  input_file="$decal"  

  # Remove path from "$input_file"
  input_file_no_path=$(basename "${input_file}")

  # Remove path and extension from "input_file"
  input_file_no_path_or_ext=$(basename "${input_file%.*}")

  # Get file extension from "input_file"
  input_file_extension="${input_file##*.}"

  # Get new percentage (task 1 - backup original decal)
  percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

  # Create new percentage without decimal
  percentage_new="${percentage%%.*}"

  # If percentage is empty, make it "0"
  if [[ "$percentage_new" == "" ]]; then
    percentage_new="0"
  fi

  # Echo percentage to zenity progress
  echo "$percentage_new" ; sleep 0.2

  # Echo text to zenity progress
  echo "# Task: Creating backup\n\nCopying: ${input_file_no_path}\n\n${percentage_new}%" ; sleep 0.2

  # If decal has "-removebg-preview" in filename, remove it. Then copy to "Original" directory (create backup - renamed)
  if [[ "$input_file" == *-removebg-preview.png ]]; then
    cp "$input_file" "${original_dir}/${input_file_no_path_or_ext%-removebg-preview*}.${input_file_extension}"
  
    #assign input_file variable
    input_file="${original_dir}/${input_file_no_path_or_ext%-removebg-preview*}.${input_file_extension}"
  
    # Remove path from "$input_file"
    input_file_no_path=$(basename "${input_file}")

    # Remove path and extension from input directory
    input_file_no_path_or_ext=$(basename "${input_file%.*}")

    # Get file extension
    input_file_extension="${input_file##*.}"
  else
    # Copy input file to "original" directory (Task 1 - Create backup)
    cp "$input_file" "${original_dir}/${input_file_no_path}"
  fi

  # Reassign input_file
  input_file="${original_dir}/${input_file_no_path_or_ext}.${input_file_extension}"

  # Remove path from "$input_file"
  input_file_no_path=$(basename "${input_file}")

  # Remove path and extension from input directory
  input_file_no_path_or_ext=$(basename "${input_file%.*}")

  # Get file extension
  input_file_extension="${input_file##*.}"

  # Trim padding
  # Get new percentage (task 2 - Trim padding)
  percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

  # Create new percentage without decimal
  percentage_new="${percentage%%.*}"

  # If percentage is empty, make it "0"
  if [[ "$percentage_new" == "" ]]; then
    percentage_new="0"
  fi

  # Echo percentage to zenity progress
  echo "$percentage_new" ; sleep 0.2

  # Echo text to zenity progress
  echo "# Task: Trim Decal\n\nTrimming: ${input_file_no_path_or_ext}.png\n\n${percentage_new}%" ; sleep 0.2

  # Echo percentage to zenity progress
  echo "$percentage_new" ; sleep 0.2

  # Trim image
  convert -background "none" "$input_file" -trim +repage -alpha "on" -bordercolor "transparent" -border "5x5" -flatten -quality "95" "${temp_dir}/${input_file_no_path_or_ext}_trimmed.png" 

  # Get input image width
  input_file_width=$(identify -format "%w" "${temp_dir}/${input_file_no_path_or_ext}_trimmed.png")

  # Get input image height
  input_file_height=$(identify -format "%h" "${temp_dir}/${input_file_no_path_or_ext}_trimmed.png")

  # Resize larger image dimension to 750px, and then paste onto 800x800 transparent background in temp directory
  # Get new percentage (task 3 - resize)
  percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

  # Create new percentage without decimal
  percentage_new="${percentage%%.*}"

  # If percentage is empty, make it "0"
  if [[ "$percentage_new" == "" ]]; then
    percentage_new="0"
  fi

  # Echo percentage to zenity progress
  echo "$percentage_new" ; sleep 0.2

  # Echo text to zenity progress
  echo "# Task: Resizing Decal\n\nResizing: ${input_file_no_path_or_ext}.png\n\n${percentage_new}%" ; sleep 0.2

  # Resize based on larger dimension
  if [[ "$input_file_width" -ge "$input_file_height" ]]; then
    convert -background "none" "${temp_dir}/${input_file_no_path_or_ext}_trimmed.png" -resize "750x" -sharpen "0x1" -gravity "center" -background "none" -extent "800x800" -quality "95" "${temp_dir}/${input_file_no_path_or_ext}_resized.png"
  else
    convert -background "none" "${temp_dir}/${input_file_no_path_or_ext}_trimmed.png" -resize "x750" -sharpen "0x1" -gravity "center" -background "none" -extent "800x800" -quality "95" "${temp_dir}/${input_file_no_path_or_ext}_resized.png"
  fi

  # Copy resized decal to temp directory without "_resized" in filename
  cp "${temp_dir}/${input_file_no_path_or_ext}_resized.png" "${temp_dir}/${input_file_no_path_or_ext}.png"

  # Reassign input_file_new variable to "${resized_dir}/${input_file_no_path_or_ext}_resized.png"
  input_file_new="${temp_dir}/${input_file_no_path_or_ext}.png"

  # Reassign basename of input_file with no extension
  input_file_no_path_or_ext=$(basename "${input_file_new%.*}")

  # Get new percentage (task 4 - black fill)
  percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

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
  convert "$input_file_new" -sharpen "0x1" -alpha "on" -background "transparent" -fill "#000000" -colorize "100" -quality "95" "${black_fill_dir}/${input_file_no_path_or_ext}.png"

  # White background
  # Get new percentage (task 5 - white background)
  percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

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
  convert "${input_file_new}" -background "white" -alpha "remove" -alpha "off" -flatten -quality "95" "${white_background_dir}/${input_file_no_path_or_ext}.png"

  # Colorize
  # Create directory with decal name in colorized
  mkdir "${colorized_dir}/${input_file_no_path_or_ext}"

  # Create and compress white image
  # Get new percentage (task 6 - colorize white)
  percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

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
  convert  "$input_file_new" -sharpen "0x1" -fill "#ffffff" -colorize "100%" -quality "95" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-White.png"

  # Get new percentage (task 7 - compress white image)
  percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

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
  pngquant --force --quality="60-100" --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-White.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-White.png"

  # Create and compress black image
  # Get new percentage (task 8 - colorize black)
  percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

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
  convert "$input_file_new" -sharpen "0x1" -fill "#000000" -colorize "100" -quality "95" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Black.png"

  # Get new percentage (task 9 - compress black)
  percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

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
  pngquant --force --quality="60-100" --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Black.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Black.png"

  # Create and compress Blue image
  # Get new percentage (task 10 - colorize blue)
  percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

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
  convert "$input_file_new" -sharpen "0x1" -fill "#1791d8" -colorize "100" -quality "95" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Blue.png"

  # Get new percentage (task 11 - compress blue)
  percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

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
  pngquant --force --quality="60-100" --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Blue.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Blue.png"

  # Create and compress Teal image
  # Get new percentage (task 12 - colorize teal)
  percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

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
  convert "$input_file_new" -sharpen "0x1" -fill "#29bbc8" -colorize "100" -quality "95" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Teal.png"

  # Get new percentage (task 13 - compress teal)
  percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

  # Echo percentage to zenity progress
  echo "$percentage_new" ; sleep 0.2

  # Create percentage without decimal
  percentage_new="${percentage%%.*}"

  # Echo text to zenity progress
  echo "# Task: Colorize\n\nCompressing: ${input_file_no_path_or_ext}-Teal.png\n\n${percentage_new}%" ; sleep 0.2

  # Compress teal decal
  pngquant --force --quality="60-100" --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Teal.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Teal.png"

  # Create and compress Red image
  # Get new percentage (task 14 - colorize red)
  percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

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
  convert "$input_file_new" -sharpen "0x1" -fill "#a01922" -colorize "100" -quality "95" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Red.png"

  # Get new percentage (task 15 - compress red)
  percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

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
  pngquant --force --quality="60-100" --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Red.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Red.png"

  # Create and compress Green image
  # Get new percentage (task 16 - colorize green)
  percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

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
  convert "$input_file_new" -sharpen "0x1" -fill "#008c35" -colorize "100" -quality "95" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Green.png"

  # Get new percentage (task 17 - compress green)
  percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

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
  pngquant --force --quality="60-100" --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Green.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Green.png"

  # Create and compress Silver image
  # Get new percentage (task 18 - colorize silver)
  percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

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
  convert "$input_file_new" -sharpen "0x1" -fill "#928F98" -colorize "100" -quality "95" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Silver.png"

  # Get new percentage (task 19 - compress silver)
  percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

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
  pngquant --force --quality="60-100" --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Silver.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Silver.png"

  # Create and compress Pink image
  # Get new percentage (task 20 - colorize pink)
  percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

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
  convert "$input_file_new" -sharpen "0x1" -fill "#FFADE5" -colorize "100" -quality "95" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Pink.png"

  # Get new percentage (task 21 - compress pink)
  percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

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
  pngquant --force --quality="60-100" --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Pink.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Pink.png"

  # Create and compress purple image
  # Get new percentage (task 22 - colorize purple)
  percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

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
  convert "$input_file_new" -sharpen "0x1" -fill "#452167" -colorize "100" -quality "95" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Purple.png"

  # Get new percentage (task 23 - compress purple)
  percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

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
  pngquant --force --quality="60-100" --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Purple.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Purple.png"

  # Create and compress Dark-Blue image
  # Get new percentage (task 24 - colorize dark blue)
  percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

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
  convert "$input_file_new" -sharpen "0x1" -fill "#003478" -colorize "100" -quality "95" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Dark-Blue.png"

  # Get new percentage (task 25 - compress dark blue)
  percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

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
  pngquant --force --quality="60-100" --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Dark-Blue.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Dark-Blue.png"

  # Create and compress Orange image
  # Get percentage (task 26 - colorize orange)
  percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

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
  convert "$input_file_new" -sharpen "0x1" -fill "#d56f31" -colorize "100" -quality "95" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Orange.png"

  # Get new percentage (task 27 - compress orange)
  percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

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
  pngquant --force --quality="60-100" --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Orange.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Orange.png"

  # Create and compress Yellow image
  # Get new percentage (task 28 - colorize yellow)
  percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

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
  convert "$input_file_new" -sharpen "0x1" -fill "#f3e11f" -colorize "100" -quality "95" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Yellow.png"

  # Get new percentage (task 29 - compress yellow)
  percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

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
  pngquant --force --quality="60-100" --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Yellow.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Yellow.png"

  # Create and compress Neon-Green image
  # Get new percentage (task 30 - colorize neon green)
  percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

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
  convert "$input_file_new" -sharpen "0x1" -fill "#39FF14" -colorize "100" -quality "95" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Neon-Green.png"

  # Get new percentage (task 31 - compress neon-green)
  percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

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
  pngquant --force --quality="60-100" --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Neon-Green.png" "${colorized_dir}/${input_file_no_path_or_ext}/${input_file_no_path_or_ext}-Neon-Green.png"

  # GIF
  # Assign input_dir variable to "${colorized_dir}/${input_file_no_path_or_ext}"
  input_dir="${colorized_dir}/${input_file_no_path_or_ext}"

  # Get new percentage (task 32 - gif)
  percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

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
  convert -dispose previous -delay "100" -loop "0" "${input_dir}/"*.png -quality "95" "${gif_dir}/${input_file_no_path_or_ext}.gif"

  # Tablet (add 13 tasks - 45 total)
  for decal in "${colorized_dir}/${input_file_no_path_or_ext}/"*.png ; do

    # Get decal basename
    decal_basename=$(basename "${decal}")

    # Get new percentage
    percentage=$(echo "scale=5; ${percentage}+${increment}" | bc)

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
    composite "$decal" "/usr/share/decal-converter/bg-tablet.png" -gravity "center" "${tablet_dir}/${decal_basename}"
  done
done
  # Echo percentage to zenity progress
  echo "100" ; sleep 0.2

  # Echo text to zenity progress
  echo "# Task: All tasks finished\n\n100%" ; sleep 2
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
    mkdir "$white_background_dir"
    mkdir "$temp_dir"
  fi
  # Change bookmark breakpoints from default 10 - 15
  dconf write /org/nemo/window-state/sidebar-bookmark-breakpoint 15

  # Add "Decals" directory to bookmarks
  echo "file://${HOME}/Decals Decals" >> "${HOME}/.config/gtk-3.0/bookmarks"
fi

# Ask user which task they would like to perform
action1=$(zenity --list --title="What would you like to do?" --text="Please select an option" --cancel-label="Exit" --column="Select" --column="Task to perform" TRUE "$opt1" FALSE "$opt2" FALSE "$opt3" FALSE "$opt4" FALSE "$opt5"  --radiolist --width="350" --height="250")
if [[ "$?" == "1" ]]; then
  if [[ -d "$temp_dir" ]]; then
    rm -rf "$temp_dir"
  fi
  exit
fi

# Single decal - Normal
if [[ "$action1" == "$opt1" ]]; then
  single_decal_normal | zenity --progress --auto-close --auto-kill --width="500" --height="100" --title="Single Decal - Normal"

# Single decal - Mirrored
elif [[ "$action1" == "$opt2" ]]; then
  single_decal_mirrored | zenity --progress --auto-close --auto-kill --width="500" --height="100" --title="Single Decal - Mirrored"

# Multiple decals
elif [[ "$action1" == "$opt3" ]]; then
  multiple_decals | zenity --progress --auto-close --auto-kill --width="500" --height="100" --title="Multiple Decals"

# Clean decal directories
elif [[ "$action1" == "$opt4" ]]; then
  clean_decal_directories
  exec "$0"

# Help page
elif [[ "$action1" == "$opt5" ]]; then
  help_page
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
