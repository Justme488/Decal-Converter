## Decal-Converter<br />
### A utility to convert decal images to png, gif, fill all visible color with black, colorize, and compress for Raven's Decals.<br />
### This uses Zenity, Imagemagick, and Pngquant (Only tested on linux mint 20.3 cinnamon)<br /><br />

### I made a script to build the .deb file from github<br />Copy and paste the following code into your terminal:<br />

`wget --secure-protocol=TLSv1_2 -O "${HOME}/Desktop/build-decal-converter.sh" "https://raw.githubusercontent.com/Justme488/build-decal-converter/main/build-decal-converter.sh" && chmod u+x "${HOME}/Desktop/build-decal-converter.sh" && sh "${HOME}/Desktop/build-decal-converter.sh"`

<br />


**Features:**<br />
+ Single or multiple convert decal image to png<br />
+ Single or multiple colorize and compress decals images to White, Black, Blue, Teal, Red, green, Silver, Pink, Dark Blue, Orange, Yellow, and Neon-Green (You must use a transparent png file)<br />
+ fill all visible color in decal with black (You must use a transparent png file)<br /> 
+ Saves png converted, colorized, filled and original decals to folder in home directory<br />
+ Creates shortcut in Menu > Graphics > Decal Converter<br />

**Colors are:**<br />
- White - #ffffff<br />
- Black - #000000<br />
- Blue - #1791d8<br />
- Teal - #29bbc8<br />
- Red - #a01922<br />
- Green - #008c35<br />
- Silver - #928F98<br />
- Pink - #ffade5<br />
- Dark-Blue = #003478<br />
- Orange = #d56f31<br />
- Yellow = #f3e11f<br />
- Neon-Green = ##39FF14<br />

**Creates the following directories in `HOME` directory**<br />
+ Decals/Black-Fill<br />
+ Decals/Colorized<br />
+ Decals/Original<br />
+ Decals/PNG<br />
+ Decals/GIF<br /><br />
