#!/usr/bin/env bash
################################################################################################
# Decal converter by Ed Houseman jr - Created 10/27/22                                         #
################################################################################################
# This script relies on Imagemagick, Pngquant and Zenity installed on a Unix system            #
################################################################################################
# Photos MUST be in .png format, and have a transparent background                             #
################################################################################################
# Options include: Convert to PNG, Convert to GIF, Colorize, Fill visible color with black     #
################################################################################################
# This generate new photos of decals, in a new folder (from white or black) to the colors of:  #
#                    ###########################################################################
# Colors are:        #
# *White - #ffffff   #
# *Black - #000000   #
# *Blue - #1791d8    #
# *Teal - #29bbc8    #
# *Red - #a01922     #
# *Green - #008c35   #
# *Silver - #928F98  #
# *Pink - #FFADE5    #
######################

##############################
##### Define directories #####
##############################

# Main decal directory
decals="${HOME}/Decals"

# Original Decal backup folder
original_dir="${HOME}/Decals/Original"

# Colorized folder
colorized_dir="${HOME}/Decals/Colorized"

# Converted to png folder
png_converted_dir="${HOME}/Decals/PNG"

# Color fill folder
black_fill_dir="${HOME}/Decals/Black-Fill"

# GIF folder
gif_dir="${HOME}/Decals/GIF"

##########################
##### Define options #####
##########################

# Convert decal to PNG
opt1="Convert To PNG"

# Convert decal to GIF
opt2="Convert To GIF"

# Colorize decal
opt3="Colorize Decals"

# Replace all visible color in decal to black
opt4="Fill All Visible Color With Black"

# single conversion
opt5="Single conversion"

# Multiple conversion
opt6="Multiple conversion"

#####################
##### Functions #####
#####################

#############################################
# Create function for single png conversion #
#############################################
png_conversion_single () {

# Select the single decal file to be converted to png format
input_file=$(zenity --file-selection --title="Select the source decal")

  # If the user selects the "cancel" button, close the script
  if [[ "$?" == "1" ]]; then
    exit
  fi

# Remove path and extension from input directory
input_file_stripped=$(basename "${input_file%.*}")

  # Check if file already exists in PNG folder
  if [[ -f "${png_converted_dir}/${input_file_stripped}.png" ]]; then
    zenity --error --title="File already exists" --text="The selected file ( ${input_file_stripped}.png ) already exist\n\nPlease check and/or rename file, and try again" --width=400 --height=100

    # Restart function "png_conversion_single"
    png_conversion_single
  fi

# Copy original file to "Original" folder (backup)
cp "$input_file" "$original_dir"

# Convert the single decal file to png format, and save in png folder
convert "$input_file" "${png_converted_dir}/${input_file_stripped}.png"
}

###############################################
# Create function for multiple png conversion #
###############################################
png_conversion_multiple () {

# Select the input folder
input_dir=$(zenity --file-selection --directory --filename="Desktop" --title="Select a directory" --text="Select the directory with your decals\nthat need to be converted to png")

  # If the user selects the "cancel" button, close the script
  if [[ "$?" == "1" ]]; then
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

# Start looping through folder
for decal in "${input_dir}"/* ; do

# Copy original file to "Original" folder (backup)
cp "$decal" "$original_dir"

# Set value for current decal in loop
((current_decal_number++))

# Remove path and extension from input directory
input_file_stripped=$(basename "${decal%.*}")

  # Check if file already exists in PNG folder
  if [[ ! -f "${decal}.png" ]]; then

    # Convert the single decal file to png format, and save in png folder
    convert "$decal" "${png_converted_dir}/{$input_file_stripped}.png" 2>/dev/null
  fi

# increment percentage number
percentage=$(echo "${percentage}+${increment}" | bc)

# Echo percentage number to zenity progress
echo "0${percentage}" ; sleep 0.2

# remove path for zenity progress
decal_basename=$(basename "${decal%.*}")

# Echo text for zenity progress
echo "# Creating: ${decal_basename}.png\n\nCurrent Decal: ${current_decal_number} of ${total_files}     \( ${decal_basename} \)\n" ; sleep 0.2
done
}

#############################################################
# Create function for generating a gif image (single image) #
#############################################################
gif_conversion_single () {

# Select the input folder
dir_input=$(zenity --file-selection --directory --filename="${HOME}/Decals/Colorized")

  # If the user selects the "cancel" button, close the script
  if [[ "$?" == "1" ]]; then
    exit
  fi

# Directory where the gif folders are saved
dir_output="${HOME}/Decals/GIF"

# Get folder name
folder_name=$(basename "${dir_input}")

  # Convert decal to gif (if it doesn't exist)
  if [[ ! -f "${dir_input}.gif" ]]; then
    convert -delay 100 -loop 0 "${dir_input}/*.png" "${gif_dir}/${folder_name}.gif" 2>/dev/null
  fi
}

#######################################################################################
# Create function for generating gif images from "Colorized" folder (multiple images) #
#######################################################################################

# Create a function for gif generation from "Colorized" folder
gif_conversion_multiple () {

# Directory where the decal folders are
dir_input="${HOME}/Decals/Colorized"

# Directory where the gif folders are saved
dir_output="${HOME}/Decals/GIF"

# Count number of decal folders
total_folders=$(find "$dir_input" -mindepth 1 -maxdepth 1 -type d 2> /dev/null | wc -l)

# error box if Decals/Colorized is empty
if [[ "$total_folders" == "0" ]]; then
  zenity --error --title="Colorized folder is empty!" --text="Your \"Colorized\" folder is empty\n\nPlease add folders to ${HOME}/Decals/Colorized to continue" --width="400" --height="100" 
fi
# Get number to increment progress bar by
increment=$(echo "scale=2; 100/${total_folders}" | bc)

# Set initial percentage
percentage="0"

# Set current decal number in loop
current_decal_number="0"

# Create loop 
for decal in "${HOME}/Decals/Colorized"/* ; do

# Set value for current decal in loop
((current_decal_number++))

# remove path for zenity progress
decal_basename=$(basename "${decal%.*}")

  # Convert decal to gif (if it doesn't exist)
  if [[ ! -f "${decal}.gif" ]]; then
    convert -delay 100 -loop 0 "${decal}/*.png" "${dir_output}/${decal_basename}.gif" 2>/dev/null
  fi
# increment percentage number
percentage=$(echo "${percentage}+${increment}" | bc)

# Echo percentage number to zenity progress
echo "0${percentage}" ; sleep 0.2

# Echo text for zenity progress
echo "# Creating: ${decal_basename}.gif \n\nCurrent Decal: ${current_decal_number} of ${total_folders}    \( ${decal_basename} \)"; sleep 0.2
done
}

##############################################################################################
# Create function for generating color decals, watermark, and compressing png (single image) #
##############################################################################################
colorize_single () {

# The input or "source" .png file
input_file=$(zenity --file-selection --title="Select the source decal")

  # If the user selects the "cancel" button, close the script
  if [[ "$?" == "1" ]]; then
    exit
  fi

# Remove path from variable "input_file"
input_file_no_path=$(basename "$input_file")

# Remove path and extension from variable "input_file"
input_file_stripped=$(basename "${input_file%.*}")


  # If the file name is not .png
  if [[ "$input_file" != *.png ]]; then

    # Error box stating the selected file is not a .png file
    zenity --error --text="The selected file ( ${input_file_no_path} ) is not a png file\n\nPlease try again" --width=400 --height=100

    # Restart "colorize_single" function
    colorize_single
  fi

# Check if image is transparent
transparency_check=$(identify -format %A "$input_file")

  # If the file contains no transparency
  if [[ "$transparency_check" == "False" ]]; then

    # Error box stating the selected file has no transparency
    zenity --error --text="The selected file ( ${input_file_no_path} ) contains no transparency\n\nPlease try again" --width=400 --height=100

    # Restart colorize_single function
    colorize_single
  fi

  # If the directory doesn't exist
  if [[ ! -d "${colorized_dir}/${input_file_stripped}" ]]; then 

    # Copy original image to original folder
    cp "$input_file" "$original_dir"

    # Create directory from decal name
    mkdir -p "${colorized_dir}/${input_file_stripped}"
  fi

# Set initial percentage
percentage="0"

# Set increment value
increment="3.846153846"

# Create, watermark, and compress white image 
      # Creating
      percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)
      echo "0${percentage}" ; sleep 0.2
      echo "# Creating: ${input_file_stripped}-White.png\n" ; sleep 0.2
      convert "$input_file" -fill "#ffffff" -colorize "100" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-White.png"

      # Adding watermark
      percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)
      echo "0${percentage}" ; sleep 0.2
      echo "# Watermarking: ${input_file_stripped}-White.png\n" ; sleep 0.2
      composite -dissolve 50% -gravity Center "/usr/share/decal-converter/watermark.png" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-White.png" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-White.png"

      # Compressing
      percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)
      echo "0${percentage}" ; sleep 0.2
      echo "# Compressing: ${input_file_stripped}-White.png\n" ; sleep 0.2
      pngquant --force --quality=40-100 --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-White.png" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-White.png"

      # Create, watermark, and compress black image
      # Creating
      percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)
      echo "0${percentage}" ; sleep 0.2
      echo "# Creating: ${input_file_stripped}-Black.png\n" ; sleep 0.2
      convert "$input_file" -fill "#000000" -colorize "100" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Black.png"

      # Add watermark
      percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)
      echo "0${percentage}" ; sleep 0.2
      echo "# Watermarking: ${input_file_stripped}-Black.png\n" ; sleep 0.2
      composite -dissolve 50% -gravity Center "/usr/share/decal-converter/watermark.png" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Black.png" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Black.png"

      # Compressing
      percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)
      echo "0${percentage}" ; sleep 0.2
      echo "# Compressing: ${input_file_stripped}-Black.png\n" ; sleep 0.2
      pngquant --force --quality=40-100 --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Black.png" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Black.png"

      # Create, watermark, and compress Blue image
      # Creating
      percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)
      echo "${percentage}" ; sleep 0.2
      echo "# Creating: ${input_file_stripped}-Blue.png\n" ; sleep 0.2
      convert "$input_file" -fill "#1791d8" -colorize "100" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Blue.png"

      # Add watermark
      percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)
      echo "${percentage}" ; sleep 0.2
      echo "# Watermarking: ${input_file_stripped}-Blue.png\n" ; sleep 0.2
      composite -dissolve 50% -gravity Center "/usr/share/decal-converter/watermark.png" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Blue.png" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Blue.png"

      # Compressing
      percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)
      echo "${percentage}" ; sleep 0.2
      echo "# Compressing: ${input_file_stripped}-Blue.png\n" ; sleep 0.2
      pngquant --force --quality=40-100 --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Blue.png" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Blue.png"

      # Create, watermark, and compress Teal image
      # Creating
      percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)
      echo "${percentage}" ; sleep 0.2
      echo "# Creating: ${input_file_stripped}-Teal.png\n" ; sleep 0.2
      convert "$input_file" -fill "#29bbc8" -colorize "100" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Teal.png"

      # Add watermark
      percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)
      echo "${percentage}" ; sleep 0.2
      echo "# Watermarking ${input_file_stripped}-Teal.png\n" ; sleep 0.2
      composite -dissolve 50% -gravity Center "/usr/share/decal-converter/watermark.png" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Teal.png" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Teal.png"

      # Compressing
      percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)
      echo "${percentage}" ; sleep 0.2
      echo "# Compressing: ${input_file_stripped}-Teal.png\n" ; sleep 0.2
      pngquant --force --quality=40-100 --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Teal.png" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Teal.png"

      # Create, watermark, and compress Red image
      # Creating
      percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)
      echo "${percentage}" ; sleep 0.2
      echo "# Creating: ${input_file_stripped}-Red.png\n" ; sleep 0.2
      convert "$input_file" -fill "#a01922" -colorize "100" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Red.png"

      # Add watermark
      percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)
      echo "${percentage}" ; sleep 0.2
      echo "# Watermarking: ${input_file_stripped}-Red.png\n" ; sleep 0.2
      composite -dissolve 50% -gravity Center "/usr/share/decal-converter/watermark.png" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Red.png" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Red.png"

      # Compressing
      percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)
      echo "${percentage}" ; sleep 0.2
      echo "# Compressing: ${input_file_stripped}-Red.png\n" ; sleep 0.2
      pngquant --force --quality=40-100 --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Red.png" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Red.png"

      # Create, watermark, and compress Green image
      # Creating
      percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)
      echo "${percentage}" ; sleep 0.2
      echo "# Creating: ${input_file_stripped}-Green.png\n" ; sleep 0.2
      convert "$input_file" -fill "#008c35" -colorize "100" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Green.png"

      # Add watermark
      percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)
      echo "${percentage}" ; sleep 0.2
      echo "# Watermarking: ${input_file_stripped}-Green.png\n" ; sleep 0.2
      composite -dissolve 50% -gravity Center "/usr/share/decal-converter/watermark.png" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Green.png" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Green.png"

      # Compressing
      percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)
      echo "${percentage}" ; sleep 0.2
      echo "# Compressing: ${input_file_stripped}-Green.png\n" ; sleep 0.2
      pngquant --force --quality=40-100 --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Green.png" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Green.png"


      # Create, watermark, and compress Silver image
      # Creating
      percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)
      echo "${percentage}" ; sleep 0.2
      echo "# Creating: ${input_file_stripped}-Silver.png\n" ; sleep 0.2
      convert "$input_file" -fill "#928F98" -colorize "100" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Silver.png"

      # Add watermark
      percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)
      echo "${percentage}" ; sleep 0.2
      echo "# Watermarking: ${input_file_stripped}-Silver.png\n" ; sleep 0.2
      composite -dissolve 50% -gravity Center "/usr/share/decal-converter/watermark.png" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Silver.png" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Silver.png"

      # Compressing
      percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)
      echo "${percentage}" ; sleep 0.2
      echo "# Compressing: ${input_file_stripped}-Silver.png\n" ; sleep 0.2
      pngquant --force --quality=40-100 --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Silver.png" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Silver.png"
      
      # Create, watermark, and compress Pink image
      # Creating
      percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)
      echo "${percentage}" ; sleep 0.2
      echo "# Creating: ${input_file_stripped}-Pink.png\n" ; sleep 0.2
      convert "$input_file" -fill "#FFADE5" -colorize "100" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Pink.png"

      # Add watermark
      percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)
      echo "${percentage}" ; sleep 0.2
      echo "# Watermarking: ${input_file_stripped}-Pink.png\n" ; sleep 0.2
      composite -dissolve 50% -gravity Center "/usr/share/decal-converter/watermark.png" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Pink.png" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Pink.png"

      # Compressing
      percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)
      echo "${percentage}" ; sleep 0.2
      echo "# Compressing: ${input_file_stripped}-Pink.png\n" ; sleep 0.2
      pngquant --force --quality=40-100 --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Pink.png" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Pink.png"
      
      echo "100" ; sleep 0.2
      echo "# Finished Creating Decal Images"; sleep 0.2
} 

################################################################################################
# Create function for generating color decals, watermark, and compressing png (multiple image) #
################################################################################################

colorize_multiple () {

# The input or "source" .png file
input_dir=$(zenity --file-selection --directory --filename="Desktop" --title="Select a directory")

  # If the user selects the "cancel" button, close the script
  if [[ "$?" == "1" ]]; then
    exit
  fi

# Set initial percentage
percentage="0"

# get total number of files in input folder
total_files=$(ls "$input_dir" 2> /dev/null | wc -l)

# Multiply total_files variable x 24 (24 processes performed)
tasks=$(echo "${total_files}*24" | bc) 

# Get number to increment progress bar by
increment=$(echo "scale=2; 100/${tasks}" | bc)

# Set current decal number in loop
current_decal_number=0 

# Start looping through folder
for decal in "${input_dir}"/* ; do

# Remove path and extension from input directory
input_file_no_path=$(basename "$decal")
input_file_stripped=$(basename "${decal%.*}")

# remove path for zenity progress
decal_basename=$(basename "${decal%.*}")

# Set value for current decal in loop
((current_decal_number++))

# Check if image is transparent
transparency_check=$(identify -format %A "$decal")

  # If the file contains no transparency
  if [[ "$transparency_check" == "True" ]] && [[ ! -d "${colorized_dir}/${input_file_stripped}" ]]; then

    # Copy original image to original folder
    cp "$decal" "$original_dir"
    mkdir -p "${colorized_dir}/${input_file_stripped}"

    # Create, watermark, and compress white image 
    # Creating
    percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)
    echo "0${percentage}" ; sleep 0.2
    echo "# Creating: ${input_file_stripped}-White.png\n\nCurrent Decal: ${current_decal_number} of ${total_files}    ( ${input_file_stripped} )\n" ; sleep 0.2
    convert "$decal" -fill "#ffffff" -colorize "100" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-White.png"
     
    # Adding watermark
    percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)
    echo "0${percentage}" ; sleep 0.2
    echo "# Watermarking: ${input_file_stripped}-White.png\n\nCurrent Decal: ${current_decal_number} of ${total_files}    ( ${input_file_stripped} )\n" ; sleep 0.2
    composite -dissolve 50% -gravity Center "/usr/share/decal-converter/watermark.png" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-White.png" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-White.png"

    # Compressing
    percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)
    echo "0${percentage}" ; sleep 0.2
    echo "# Compressing: ${input_file_stripped}-White.png\n\nCurrent Decal: ${current_decal_number} of ${total_files}    ( ${input_file_stripped} )\n" ; sleep 0.2
    pngquant --force --quality=40-100 --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-White.png" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-White.png"

    # Create, watermark, and compress black image
    # Creating
    percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)
    echo "0${percentage}" ; sleep 0.2
    echo "# Creating: ${input_file_stripped}-Black.png \n\nCurrent Decal: ${current_decal_number} of ${total_files}    ( ${input_file_stripped} )\n" ; sleep 0.2
    convert "$decal" -fill "#000000" -colorize "100" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Black.png"

    # Add watermark
    percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)
    echo "0${percentage}" ; sleep 0.2
    echo "# Watermarking: ${input_file_stripped}-Black.png\n\nCurrent Decal: ${current_decal_number} of ${total_files}    ( ${input_file_stripped} )\n" ; sleep 0.2
    composite -dissolve 50% -gravity Center "/usr/share/decal-converter/watermark.png" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Black.png" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Black.png"

    # Compressing
    percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)
    echo "0${percentage}" ; sleep 0.2
    echo "# Compressing: ${input_file_stripped}-Black.png\n\nCurrent Decal: ${current_decal_number} of ${total_files}    ( ${input_file_stripped} )\n" ; sleep 0.2
    pngquant --force --quality=40-100 --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Black.png" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Black.png"

    # Create, watermark, and compress Blue image
    # Creating
    percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)
    echo "0${percentage}" ; sleep 0.2
    echo "# Creating: ${input_file_stripped}-Blue.png\n\nCurrent Decal: ${current_decal_number} of ${total_files}    ( ${input_file_stripped} )\n" ; sleep 0.2
    convert "$decal" -fill "#1791d8" -colorize "100" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Blue.png"

    # Add watermark
    percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)
    echo "0${percentage}" ; sleep 0.2
    echo "# Watermarking: ${input_file_stripped}-Blue.png\n\nCurrent Decal: ${current_decal_number} of ${total_files}    ( ${input_file_stripped} )\n" ; sleep 0.2
    composite -dissolve 50% -gravity Center "/usr/share/decal-converter/watermark.png" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Blue.png" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Blue.png"

    # Compressing
    percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)
    echo "0${percentage}" ; sleep 0.2
    echo "# Compressing: ${input_file_stripped}-Blue.png\n\nCurrent Decal: ${current_decal_number} of ${total_files}    ( ${input_file_stripped} )\n" ; sleep 0.2
    pngquant --force --quality=40-100 --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Blue.png" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Blue.png"

    # Create, watermark, and compress Teal image
    # Creating
    percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)
    echo "0${percentage}" ; sleep 0.2
    test_percentage=$("($percentage+0.5)/1" | bc)
    echo "# Creating: ${input_file_stripped}-Teal.png\n\nCurrent Decal: ${current_decal_number} of ${total_files}    ( ${input_file_stripped} )\n" ; sleep 0.2
    convert "$decal" -fill "#29bbc8" -colorize "100" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Teal.png"

    # Add watermark
    percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)
    echo "0${percentage}" ; sleep 0.2
    test_percentage=$("($percentage+0.5)/1" | bc)
    echo "# Watermarking: ${input_file_stripped}-Teal.png\n\nCurrent Decal: ${current_decal_number} of ${total_files}    ( ${input_file_stripped} )\n" ; sleep 0.2
    composite -dissolve 50% -gravity Center "/usr/share/decal-converter/watermark.png" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Teal.png" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Teal.png"

    # Compressing
    percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)
    echo "0${percentage}" ; sleep 0.2
    test_percentage=$("($percentage+0.5)/1" | bc)
    echo "# Compressing: ${input_file_stripped}-Teal.png\n\nCurrent Decal: ${current_decal_number} of ${total_files}    ( ${input_file_stripped} )\n" ; sleep 0.2
    pngquant --force --quality=40-100 --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Teal.png" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Teal.png"

    # Create, watermark, and compress Red image
    # Creating
    percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)
    echo "0${percentage}" ; sleep 0.2
    test_percentage=$("($percentage+0.5)/1" | bc)
    echo "# Creating: ${input_file_stripped}-Red.png\n\nCurrent Decal: ${current_decal_number} of ${total_files}    ( ${input_file_stripped} )\n" ; sleep 0.2
    convert "$decal" -fill "#a01922" -colorize "100" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Red.png"

    # Add watermark
    percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)
    echo "0${percentage}" ; sleep 0.2
    test_percentage=$("($percentage+0.5)/1" | bc)
    echo "# Watermarking: ${input_file_stripped}-Red.png\n\nCurrent Decal: ${current_decal_number} of ${total_files}    ( ${input_file_stripped} )\n" ; sleep 0.2
    composite -dissolve 50% -gravity Center "/usr/share/decal-converter/watermark.png" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Red.png" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Red.png"

    # Compressing
    percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)
    echo "0${percentage}" ; sleep 0.2
    test_percentage=$("($percentage+0.5)/1" | bc)
    echo "# Compressing: ${input_file_stripped}-Red.png\n\nCurrent Decal: ${current_decal_number} of ${total_files}    ( ${input_file_stripped} )\n" ; sleep 0.2
    pngquant --force --quality=40-100 --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Red.png" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Red.png"

    # Create, watermark, and compress Green image
    # Creating
    percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)
    echo "0${percentage}" ; sleep 0.2
    test_percentage=$("($percentage+0.5)/1" | bc)
    echo "# Creating: ${input_file_stripped}-Green.png\n\nCurrent Decal: ${current_decal_number} of ${total_files}    ( ${input_file_stripped} )\n" ; sleep 0.2
    convert "$decal" -fill "#008c35" -colorize "100" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Green.png"

    # Add watermark
    percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)
    echo "0${percentage}" ; sleep 0.2
    test_percentage=$("($percentage+0.5)/1" | bc)
    echo "# Watermarking: ${input_file_stripped}-Green.png\n\nCurrent Decal: ${current_decal_number} of ${total_files}    ( ${input_file_stripped} )\n" ; sleep 0.2
    composite -dissolve 50% -gravity Center "/usr/share/decal-converter/watermark.png" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Green.png" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Green.png"

    # Compressing
    percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)
    echo "0${percentage}" ; sleep 0.2
    echo "# Compressing: ${input_file_stripped}-Green.png\n\nCurrent Decal: ${current_decal_number} of ${total_files}    ( ${input_file_stripped} )\n" ; sleep 0.2
    pngquant --force --quality=40-100 --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Green.png" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Green.png"

    # Create, watermark, and compress Silver image
    # Creating
    percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)
    echo "0${percentage}" ; sleep 0.2
    echo "# Creating: ${input_file_stripped}-Silver.png\n\nCurrent Decal: ${current_decal_number} of ${total_files}    ( ${input_file_stripped} )\n" ; sleep 0.2
    convert "$decal" -fill "#928F98" -colorize "100" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Silver.png"

    # Add watermark
    percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)
    echo "0${percentage}" ; sleep 0.2
    echo "# Watermarking: ${input_file_stripped}-Silver.png\n\nCurrent Decal: ${current_decal_number} of ${total_files}    ( ${input_file_stripped} )\n" ; sleep 0.2
    composite -dissolve 50% -gravity Center "/usr/share/decal-converter/watermark.png" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Silver.png" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Silver.png"

    # Compressing
    percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)
    echo "0${percentage}" ; sleep 0.2
    echo "# Compressing: ${input_file_stripped}-Silver.png\n\nCurrent Decal: ${current_decal_number} of ${total_files}    ( ${input_file_stripped} )\n" ; sleep 0.2
    pngquant --force --quality=40-100 --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Silver.png" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Silver.png"

     # Create, watermark, and compress Pink image
    # Creating
    percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)
    echo "0${percentage}" ; sleep 0.2
    echo "# Creating: ${input_file_stripped}-Pink.png\n\nCurrent Decal: ${current_decal_number} of ${total_files}    ( ${input_file_stripped} )\n" ; sleep 0.2
    convert "$decal" -fill "#FFADE5" -colorize "100" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Pink.png"

    # Add watermark
    percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)
    echo "0${percentage}" ; sleep 0.2
    echo "# Watermarking: to ${input_file_stripped}-Pink.png\n\nCurrent Decal: ${current_decal_number} of ${total_files}    ( ${input_file_stripped} )\n" ; sleep 0.2
    composite -dissolve 50% -gravity Center "/usr/share/decal-converter/watermark.png" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Pink.png" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Pink.png"

    # Compressing
    percentage=$(echo "scale=2; ${percentage}+${increment}" | bc)
    echo "0${percentage}" ; sleep 0.2
    echo "# Compressing: ${input_file_stripped}-Pink.png\n\nCurrent Decal: ${current_decal_number} of ${total_files}    ( ${input_file_stripped} )\n" ; sleep 0.2
    pngquant --force --quality=40-100 --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Pink.png" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Pink.png"
  fi
done
}

#####################################################################
# Create function for filling all visible color with black (single) #
#####################################################################
black_fill_single() {

# The input or "source" .png file
input_file=$(zenity --file-selection --title="Select the source decal")

  # If the user selects the "cancel" button, close the script
  if [[ "$?" == "1" ]]; then
    exit
  fi

# Remove path from variable "input_file"
input_file_no_path=$(basename "$input_file")

# Remove extension from variable "input_file_no_path
input_file_stripped=${input_file_no_path%.*}

  # If the file name is not .png
  if [[ "$input_file" != *.png ]]; then

    # Error box stating the selected file is not a .png file
    zenity --error --text="The selected file \"$(basename "$input_file")\" is not a png file \n \n Please try again" --width=400 --height=100

    # Restart "black_fill_single" function
    black_fill_single
  fi

# Check if image is transparent
transparency_check=$(identify -format %A "$input_file")

  # If the file contains no transparency
  if [[ "$transparency_check" == "False" ]]; then

    # Error box stating the selected file has no transparency
    zenity --error --text="The selected file \"$(basename "$input_file")\" contains no transparency \n \n Please try again" --width="400" --height="100"

    # Restart "black_fill_single" function
    black_fill_single
  fi

  # If the directory doesn't exist
  if [[ ! -d "${black_fill_dir}/${input_file_stripped}" ]]; then 

    # Copy original image to original folder
    cp "$input_file" "$original_dir"

    # Create directory for black fill
    #mkdir -p "${black_fill_dir}/${input_file_stripped}"

    # Fill png with black, and add to Black-Fill"" directory
    convert "$input_file" -fill "#000000" -colorize "100" "${black_fill_dir}/${input_file_no_path}"
  fi
}

#######################################################################
# Create function for filling all visible color with black (multiple) #
#######################################################################
black_fill_multiple() {

# The input or "source" .png folder
input_dir=$(zenity --file-selection --directory --filename="Desktop" --title="Select a directory")

  # If the user selects the "cancel" button, close the script
  if [[ "$?" == "1" ]]; then
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

# Start looping through folder
for decal in "${input_dir}"/* ; do

# Copy original file to "Original" folder (backup)
cp "$decal" "$original_dir"

# Set value for current decal in loop
((current_decal_number++))

# Remove path and extension from input directory
input_file_stripped=$(basename "${decal%.*}")

  # Check if file already exists in PNG folder
  if [[ ! -f "${black_fill_dir}/${decal}.png" ]]; then
    # Fill png with black, and add to Black-Fill"" directory
    convert "$decal" -fill "#000000" -colorize "100" "${black_fill_dir}/${input_file_stripped}.png"
  fi

# increment percentage number
percentage=$(echo "${percentage}+${increment}" | bc)

# Echo percentage number to zenity progress
echo "0${percentage}" ; sleep 0.2

# remove path for zenity progress
decal_basename=$(basename "${decal%.*}")

# Echo text for zenity progress
echo "# Creating: ${input_file_stripped}.png\n\nCurrent Decal: ${current_decal_number} of ${total_files}     \( ${decal_basename} \)\n" ; sleep 0.2
done
}

#######################
##### MAIN SCRIPT #####
#######################

# See if "Decals" folder exists, and create if it doesn't
if [[ ! -d "${HOME}/Decals" ]]; then
zenity --info --title="Decals folder does not exist" --text="Since this is the first time running Decal Converter\n\n \*  A \"Decals\" folder will be created in your home directory\n\n \*  \"Decals\" will be added to your bookmarks" --width="500"

# if user selects cancel then exit
  if [[ "$?" == "1" ]]; then
    exit
  fi

# Make directory "Decals" if it doesn't exist
mkdir -p $decals
mkdir -p $original_dir
mkdir -p $colorized_dir
mkdir -p $png_converted_dir
mkdir -p $black_fill_dir
mkdir -p $gif_dir

# Change bookmark breakpoints from default 10 - 15
dconf write /org/nemo/window-state/sidebar-bookmark-breakpoint 15

# Add "Decals" folder to bookmarks
echo "file://${HOME}/Decals Decals" >> "${HOME}/.config/gtk-3.0/bookmarks"
fi

##################
# Define Actions #
##################

# ask user which task they would like to perform
action1=$(zenity --list --title="What would you like to do?" --text="Please select an option" --column="Select" --column="Task to perform" FALSE "$opt1" FALSE "$opt2" FALSE "$opt3" FALSE "$opt4" --radiolist --width=350 --height=250)
  if [[ "$?" == "1" ]]; then
    exit
  fi

# ask user if single or multiple files
action2=$(zenity --list --title="do you have a single file or multiple files?" --text="Please select an option" --column="Select" --column="Task to perform" FALSE "$opt5" FALSE "$opt6" --radiolist --width=350 --height=175)
  if [[ "$?" == "1" ]]; then
    exit
  fi

# Single png conversion
if [[ "$action1" == "$opt1" ]] && [[ "$action2" == "$opt5" ]]; then
  png_conversion_single

# Multiple png conversion
elif [[ "$action1" == "$opt1" ]] && [[ "$action2" == "$opt6" ]]; then
  png_conversion_multiple | zenity --progress --auto-close --auto-kill  --width="500" --height="100" --title="Creating PNG images"

# Single gif conversion
elif [[ "$action1" == "$opt2" ]] && [[ "$action2" == "$opt5" ]]; then
  gif_conversion_single

# Multiple gif conversion
elif [[ "$action1" == "$opt2" ]] && [[ "$action2" == "$opt6" ]]; then
  gif_conversion_multiple | zenity --progress --auto-close --auto-kill  --width="500" --title="Creating GIF images"

# Single colorize conversion
elif [[ "$action1" == "$opt3" ]] && [[ "$action2" == "$opt5" ]]; then
  colorize_single | zenity --progress --auto-close --auto-kill --width="500" --height="100" --title="Creating Decal Images"

# Multiple colorize conversion
elif [[ "$action1" == "$opt3" ]] && [[ "$action2" == "$opt6" ]]; then
  colorize_multiple | zenity --progress --auto-close --auto-kill --width="500" --height="100" --title="Creating Decal Images"

# Single black fill conversion
elif [[ "$action1" == "$opt4" ]] && [[ "$action2" == "$opt5" ]]; then
  black_fill_single

# Multiple black fill conversion
elif [[ "$action1" == "$opt4" ]] && [[ "$action2" == "$opt6" ]]; then
  black_fill_multiple | zenity --progress --auto-close --auto-kill  --width="500" --height="100" --title="Filling Decal Color With Black"
fi

# Ask user if they have more decals to do
zenity --question --title="Do you have more decals?" --text="Would you like to Exit or Continue?" --ok-label="Continue" --cancel-label="Exit" --width="400" --height="100"
  if [[ "$?" == "0" ]]; then
    exec "$0"
  elif [[ "$?" == "1" ]]; then
    exit
  fi
