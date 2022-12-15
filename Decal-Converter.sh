#!/usr/bin/env bash
################################################################################################
# Decal converter by Ed Houseman jr - Created 10/27/22                                         #
################################################################################################
# This script relies on Imagemagick, Pngquant and Zenity installed on a Unix system            #
################################################################################################
# Photos MUST be in .png format, and have a transparent background                             #
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
######################

############################
##### Define variables #####
############################

###################
##### Options #####
###################

# single conversion
opt1="Single conversion"

# Multiple conversion
opt2="Multiple conversion"

# Convert file to .png
opt3="Convert decal to png"

# Colorize decals
opt4="Colorize decal (White, Black, Blue, Teal, Red, Green)"

# Fill with color
opt5="Fill all visible color in decal with black"

#######################
##### Directories #####
#######################

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
input_file_no_path=$(basename "$input_file")
input_file_stripped=${input_file_no_path%.*}

  # Check if file already exists in PNG folder
  if [[ -f "${png_converted_dir/$input_file_stripped.png}" ]]; then
    zenity --error --title="File already exists" --text="The selected file already exist \n \n  Please check and/or rename file, and try again" --width=400 --height=100

    # Restart function "png_conversion_single"
    png_conversion_single
  fi

# Convert the single decal file to png format, and save in png folder
convert "$input_file" "$png_converted_dir/$input_file_stripped.png"

zenity --question --title="Do you have more decals?" --text="Would you like to Exit or Continue?" --ok-label="Continue" --cancel-label="Exit" --width=400 --height=100
  if [[ "$?" == "0" ]]; then
    exec "$0"
  elif [[ "$?" == "1" ]]; then
    exit
  fi
}

###############################################
# Create function for multiple png conversion #
###############################################
png_conversion_multiple () {

# Select the input folder
input_dir=$(zenity --file-selection --directory --filename="Desktop" --title="Select a directory" --text="Select the directory with your decals \n that need to be converted to png")

  # If the user selects the "cancel" button, close the script
  if [[ "$?" == "1" ]]; then
    exit
  fi

# Start looping through folder
for i in "${input_dir}"/*.* ; do

# Remove path and extension from input directory
input_file_no_path=$(basename "$i")
input_file_stripped=${input_file_no_path%.*}

  # Check if file already exists in PNG folder
  if [[ ! -f "${png_converted_dir/$input_file_stripped.png}" ]]; then

    # Convert the single decal file to png format, and save in png folder
    convert "$i" "$png_converted_dir/$input_file_stripped.png"
  fi
done

# Ask user if they have more decals to do
zenity --question --title="Do you have more decals?" --text="Would you like to Exit or Continue?" --ok-label="Continue" --cancel-label="Exit" --width=400 --height=100
  if [[ "$?" == "0" ]]; then
    exec "$0"
  elif [[ "$?" == "1" ]]; then
    exit
  fi
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

# Remove extension from variable "input_file_no_path
input_file_stripped=${input_file_no_path%.*}

  # If the file name is not .png
  if [[ "$input_file" != *.png ]]; then

    # Error box stating the selected file is not a .png file
    zenity --error --text="The selected file \"$(basename "$input_file")\" is not a png file \n \n Please try again" --width=400 --height=100

    # Restart "colorize_single" function
    colorize_single
  fi

# Check if image is transparent
transparency_check=$(identify -format %A "$input_file")

  # If the file contains no transparency
  if [[ "$transparency_check" == "False" ]]; then

    # Error box stating the selected file has no transparency
    zenity --error --text="The selected file \"$(basename "$input_file")\" contains no transparency \n \n Please try again" --width=400 --height=100

    # Restart colorize_single function
    colorize_single
  fi

    # If the directory doesn't exist
    if [[ ! -d "${colorized_dir}/${input_file_stripped}" ]]; then 

      # Copy original image to original folder
      cp "$input_file" "$original_dir"

      # Create directory from decal name
      mkdir -p "${colorized_dir}/${input_file_stripped}"

      # Create, watermark, and compress white image 
      # Creating
      (echo "5" ; sleep 0.5
      echo "# Creating ${colorized_dir}/${input_file_stripped}/${input_file_stripped}-White.png"; sleep 0.5
      convert "$input_file" -fill "#ffffff" -colorize "100" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-White.png"

      # Adding watermark
      echo "10" ; sleep 0.5
      echo "# Adding watermark to ${colorized_dir}/${input_file_stripped}/${input_file_stripped}-White.png"; sleep 0.5
      composite -dissolve 50% -gravity Center "/usr/share/Decal-Color-Changer/watermark.png" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-White.png" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-White.png"

      # Compressing
      echo "15" ; sleep 0.5
      echo "# Compressing ${colorized_dir}/${input_file_stripped}/${input_file_stripped}-White.png"; sleep 0.5
      pngquant --force --quality=40-100 --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-White.png" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-White.png"

      # Create, watermark, and compress black image
      # Creating
      echo "20" ; sleep 0.5
      echo "# Creating ${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Black.png"; sleep 0.5
      convert "$input_file" -fill "#000000" -colorize "100" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Black.png"

      # Add watermark
      echo "25" ; sleep 0.5
      echo "# Adding watermark to ${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Black.png"; sleep 0.5
      composite -dissolve 50% -gravity Center "/usr/share/Decal-Color-Changer/watermark.png" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Black.png" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Black.png"

      # Compressing
      echo "30" ; sleep 0.5
      echo "# Compressing ${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Black.png"; sleep 0.5
      pngquant --force --quality=40-100 --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Black.png" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Black.png"

      # Create, watermark, and compress Blue image
      # Creating
      echo "35" ; sleep 0.5
      echo "# Creating ${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Blue.png"; sleep 0.5
      convert "$input_file" -fill "#1791d8" -colorize "100" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Blue.png"

      # Add watermark
      echo "40" ; sleep 0.5
      echo "# Adding watermark to ${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Blue.png"; sleep 0.5
      composite -dissolve 50% -gravity Center "/usr/share/Decal-Color-Changer/watermark.png" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Blue.png" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Blue.png"

      # Compressing
      echo "45" ; sleep 0.5
      echo "# Compressing ${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Blue.png"; sleep 0.5
      pngquant --force --quality=40-100 --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Blue.png" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Blue.png"

      # Create, watermark, and compress Teal image
      # Creating
      echo "50" ; sleep 0.5
      echo "# Creating ${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Teal.png"; sleep 0.5
      convert "$input_file" -fill "#29bbc8" -colorize "100" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Teal.png"

      # Add watermark
      echo "55" ; sleep 0.5
      echo "# Adding watermark to ${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Teal.png"; sleep 0.5
      composite -dissolve 50% -gravity Center "/usr/share/Decal-Color-Changer/watermark.png" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Teal.png" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Teal.png"

      # Compressing
      echo "60" ; sleep 0.5
      echo "# Compressing ${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Teal.png"; sleep 0.5
      pngquant --force --quality=40-100 --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Teal.png" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Teal.png"

      # Create, watermark, and compress Red image
      # Creating
      echo "65" ; sleep 0.5
      echo "# Creating ${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Red.png"; sleep 0.5
      convert "$input_file" -fill "#a01922" -colorize "100" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Red.png"

      # Add watermark
      echo "70" ; sleep 0.5
      echo "# Adding watermark to ${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Red.png"; sleep 0.5
      composite -dissolve 50% -gravity Center "/usr/share/Decal-Color-Changer/watermark.png" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Red.png" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Red.png"

      # Compressing
      echo "75" ; sleep 0.5
      echo "# Compressing ${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Red.png"; sleep 0.5
      pngquant --force --quality=40-100 --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Red.png" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Red.png"

      # Create, watermark, and compress Green image
      # Creating
      echo "80" ; sleep 0.5
      echo "# Creating ${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Green.png"; sleep 0.5
      convert "$input_file" -fill "#008c35" -colorize "100" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Green.png"

      # Add watermark
      echo "85" ; sleep 0.5
      echo "# Adding watermark to ${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Green.png"; sleep 0.5
      composite -dissolve 50% -gravity Center "/usr/share/Decal-Color-Changer/watermark.png" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Green.png" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Green.png"

      # Compressing
      echo "90" ; sleep 0.5
      echo "# Compressing ${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Green.png"; sleep 0.5
      pngquant --force --quality=40-100 --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Green.png" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Green.png"

      echo "100" ; sleep 0.5
      echo "# Finished Creating Decal Images"; sleep 0.5
      ) | zenity --progress --title="Creating Decal Images" --percentage=0 --auto-close --auto-kill --width=800 --height=100

      zenity --question --title="Do you have more decals?" --text="Would you like to Exit or Continue?" --ok-label="Continue" --cancel-label="Exit" --width=400 --height=100
        if [[ "$?" == "0" ]]; then
          exec "$0"
        elif [[ "$?" == "1" ]]; then
          exit
        fi
    fi
}

###############################################################################
# Create function for generating color decals, watermark, and compressing png #
###############################################################################
colorize_multiple () {

# The input or "source" .png file
input_dir=$(zenity --file-selection --directory --filename="Desktop" --title="Select a directory")

  # If the user selects the "cancel" button, close the script
  if [[ "$?" == "1" ]]; then
    exit
  fi

# Start looping through folder
for i in "${input_dir}"/*.* ; do

# Remove path and extension from input directory
input_file_no_path=$(basename "$i")
input_file_stripped=${input_file_no_path%.*}

# Check if image is transparent
transparency_check=$(identify -format %A "$i")

  # If the file contains no transparency
  if [[ "$transparency_check" == "True" ]] && [[ ! -d "${colorized_dir}/${input_file_stripped}" ]]; then

    # Copy original image to original folder
    cp "$i" "$original_dir"
    mkdir -p "${colorized_dir}/${input_file_stripped}"

    # Create, watermark, and compress white image 
    # Creating
    (echo "4" ; sleep 0.5
    echo "# Creating ${colorized_dir}/${input_file_stripped}/${input_file_stripped}-White.png"; sleep 0.5
    convert "$i" -fill "#ffffff" -colorize "100" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-White.png"

    # Adding watermark
    echo "12" ; sleep 0.5
    echo "# Adding watermark to ${colorized_dir}/${input_file_stripped}/${input_file_stripped}-White.png"; sleep 0.5
    composite -dissolve 50% -gravity Center "/usr/share/Decal-Color-Changer/watermark.png" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-White.png" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-White.png"

    # Compressing
    echo "16" ; sleep 0.5
    echo "# Compressing ${colorized_dir}/${input_file_stripped}/${input_file_stripped}-White.png"; sleep 0.5
    pngquant --force --quality=40-100 --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-White.png" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-White.png"

    # Create, watermark, and compress black image
    # Creating
    echo "20" ; sleep 0.5
    echo "# Creating ${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Black.png"; sleep 0.5
    convert "$i" -fill "#000000" -colorize "100" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Black.png"

    # Add watermark
    echo "28" ; sleep 0.5
    echo "# Adding watermark to ${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Black.png"; sleep 0.5
    composite -dissolve 50% -gravity Center "/usr/share/Decal-Color-Changer/watermark.png" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Black.png" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Black.png"

    # Compressing
    echo "32" ; sleep 0.5
    echo "# Compressing ${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Black.png"; sleep 0.5
    pngquant --force --quality=40-100 --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Black.png" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Black.png"

    # Create, watermark, and compress Blue image
    # Creating
    echo "36" ; sleep 0.5
    echo "# Creating ${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Blue.png"; sleep 0.5
    convert "$i" -fill "#1791d8" -colorize "100" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Blue.png"

    # Add watermark
    echo "44" ; sleep 0.5
    echo "# Adding watermark to ${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Blue.png"; sleep 0.5
    composite -dissolve 50% -gravity Center "/usr/share/Decal-Color-Changer/watermark.png" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Blue.png" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Blue.png"

    # Compressing
    echo "48" ; sleep 0.5
    echo "# Compressing ${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Blue.png"; sleep 0.5
    pngquant --force --quality=40-100 --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Blue.png" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Blue.png"

    # Create, watermark, and compress Teal image
    # Creating
    echo "52" ; sleep 0.5
    echo "# Creating ${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Teal.png"; sleep 0.5
    convert "$i" -fill "#29bbc8" -colorize "100" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Teal.png"

    # Add watermark
    echo "60" ; sleep 0.5
    echo "# Adding watermark to ${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Teal.png"; sleep 0.5
    composite -dissolve 50% -gravity Center "/usr/share/Decal-Color-Changer/watermark.png" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Teal.png" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Teal.png"

    # Compressing
    echo "64" ; sleep 0.5
    echo "# Compressing ${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Teal.png"; sleep 0.5
    pngquant --force --quality=40-100 --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Teal.png" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Teal.png"

    # Create, watermark, and compress Red image
    # Creating
    echo "68" ; sleep 0.5
    echo "# Creating ${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Red.png"; sleep 0.5
    convert "$i" -fill "#a01922" -colorize "100" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Red.png"

    # Add watermark
    echo "76" ; sleep 0.5
    echo "# Adding watermark to ${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Red.png"; sleep 0.5
    composite -dissolve 50% -gravity Center "/usr/share/Decal-Color-Changer/watermark.png" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Red.png" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Red.png"

    # Compressing
    echo "80" ; sleep 0.5
    echo "# Compressing ${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Red.png"; sleep 0.5
    pngquant --force --quality=40-100 --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Red.png" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Red.png"

    # Create, watermark, and compress Green image
    # Creating
    echo "84" ; sleep 0.5
    echo "# Creating ${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Green.png"; sleep 0.5
    convert "$i" -fill "#008c35" -colorize "100" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Green.png"

    # Add watermark
    echo "92" ; sleep 0.5
    echo "# Adding watermark to ${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Green.png"; sleep 0.5
    composite -dissolve 50% -gravity Center "/usr/share/Decal-Color-Changer/watermark.png" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Green.png" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Green.png"

    # Compressing
    echo "96" ; sleep 0.5
    echo "# Compressing ${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Green.png"; sleep 0.5
    pngquant --force --quality=40-100 --strip --skip-if-larger --verbose --output "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Green.png" "${colorized_dir}/${input_file_stripped}/${input_file_stripped}-Green.png"

    echo "100" ; sleep 0.5
    echo "# Finished Creating Decal Images"; sleep 0.5

    ) | zenity --progress --title="Creating Decal Images" --percentage=0 --auto-close --auto-kill --width=800 --height=100
  fi
done
zenity --question --title="Do you have more decals?" --text="Would you like to Exit or Continue?" --ok-label="Continue" --cancel-label="Exit" --width=400 --height=100
  if [[ "$?" == "0" ]]; then
    exec "$0"
  elif [[ "$?" == "1" ]]; then
    exit
  fi
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
    zenity --error --text="The selected file \"$(basename "$input_file")\" contains no transparency \n \n Please try again" --width=400 --height=100

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
zenity --question --title="Do you have more decals?" --text="Would you like to Exit or Continue?" --ok-label="Continue" --cancel-label="Exit" --width=400 --height=100
  if [[ "$?" == "0" ]]; then
    exec "$0"
  elif [[ "$?" == "1" ]]; then
    exit
  fi
}

#######################################################################
# Create function for filling all visible color with black (multiple) #
#######################################################################
black_fill_multiple() {

# The input or "source" .png file
input_dir=$(zenity --file-selection --directory --filename="Desktop" --title="Select a directory")

  # If the user selects the "cancel" button, close the script
  if [[ "$?" == "1" ]]; then
    exit
  fi

# Start looping through folder
for i in "${input_dir}"/*.* ; do

# Remove path and extension from input directory
input_file_no_path=$(basename "$i")
input_file_stripped=${input_file_no_path%.*}

# Check if image is transparent
transparency_check=$(identify -format %A "$i")

  # If the file contains no transparency
  if [[ "$transparency_check" == "True" ]] && [[ ! -d "${black_fill_dir}/${input_file_stripped}" ]]; then

    # Copy original image to original folder
    cp "$i" "$original_dir"

    # Fill png with black, and add to Black-Fill"" directory
    convert "$i" -fill "#000000" -colorize "100" "${black_fill_dir}/${input_file_no_path}"
  fi
done
zenity --question --title="Do you have more decals?" --text="Would you like to Exit or Continue?" --ok-label="Continue" --cancel-label="Exit" --width=400 --height=100
  if [[ "$?" == "0" ]]; then
    exec "$0"
  elif [[ "$?" == "1" ]]; then
    exit
fi
}

#######################
##### MAIN SCRIPT #####
#######################

# See if "Decals" folder exists, and create if it doesn't
if [[ ! -d "${HOME}/Decals" ]]; then
zenity --info --title="Decals folder does not exist" --text="Since this is the first time running Decal Converter\n\n \*  A \"Decals\" folder will be created in your home directory\n\n \*  \"Decals\" will be added to your bookmarks" --width=500

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

# Change bookmark breakpoints from default 10 - 15
dconf write /org/nemo/window-state/sidebar-bookmark-breakpoint 15

# Add "Decals" folder to bookmarks
echo "file://${HOME}/Decals Decals" >> "${HOME}/.config/gtk-3.0/bookmarks"
fi

# ask user if single or multiple files
action1=$(zenity --list --title="do you have a single file or multiple files?" --text="Please select an option" --column="Select" --column="Task to perform" FALSE "$opt1" FALSE "$opt2" --radiolist --width=350 --height=175)
  if [[ "$?" == "1" ]]; then
    exit
  fi

# Ask user what they would like to do (convert to png, colorize, or fill with black)
action2=$(zenity --list --title="What would you like to do?" --text="Please select an option" --column="Select" --column="Task to perform" FALSE "$opt3" FALSE "$opt4" FALSE "$opt5" --radiolist --width=400 --height=200)

  if [[ "$?" == "1" ]]; then
    exit
  fi

  # Single png conversion
  if [[ "$action1" == "$opt1" ]] && [[ "$action2" == "$opt3" ]]; then
    png_conversion_single

  # Multiple png conversion
  elif [[ "$action1" == "$opt2" ]] && [[ "$action2" == "$opt3" ]]; then
    png_conversion_multiple

  # Single colorize
  elif [[ "$action1" == "$opt1" ]] && [[ "$action2" == "$opt4" ]]; then
    colorize_single

  # Multiple colorize
  elif [[ "$action1" == "$opt2" ]] && [[ "$action2" == "$opt4" ]]; then
    colorize_multiple

  # Single black fill
  elif [[ "$action1" == "$opt1" ]] && [[ "$action2" == "$opt5" ]]; then
  black_fill_single

  # Multiple black fill
  elif [[ "$action1" == "$opt2" ]] && [[ "$action2" == "$opt5" ]]; then
    black_fill_multiple
  fi
