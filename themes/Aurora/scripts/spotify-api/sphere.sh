#!/bin/bash
# converts the standard jpg to a sphere picture by the use of imagemagick
convert ~/.conky/Aurora/scripts/spotify-api/lastpic_xl.png -resize 300x300  \
			~/.conky/Aurora/scripts/spotify-api/sphere_lut.png   -fx 'p{ v*w, j }' \
          	~/.conky/Aurora/scripts/spotify-api/sphere_overlay.png   -compose HardLight  -composite \
          	~/.conky/Aurora/scripts/spotify-api/sphere_mask.png -alpha off -compose CopyOpacity -composite \
          	~/.conky/Aurora/scripts/spotify-api/lastpic_xl_conv.png
#   convert ~/.conky/Aurora/scripts/spotify-api/lastpic_xl.png -resize 300x300 ~/.conky/Aurora/scripts/spotify-api/sphere_lut.png -fx 'p{ v*w, j }' ~/.conky/Aurora/scripts/spotify-api/sphere_overlay.png   -compose HardLight  -composite ~/.conky/Aurora/scripts/spotify-api/sphere_mask.png -alpha off -compose CopyOpacity -composite ~/.conky/Aurora/scripts/spotify-api/lastpic_xl_conv.png
#