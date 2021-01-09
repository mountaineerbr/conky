#!/bin/bash
# converts the standard jpg to a sphere picture by the use of imagemagick
convert ~/.conky/Aurora/2_processes_thin/spotify/lastpic_xl -resize 300x300  \
			~/.conky/Aurora/2_processes_thin/spotify/sphere_lut.png   -fx 'p{ v*w, j }' \
          	~/.conky/Aurora/2_processes_thin/spotify/sphere_overlay.png   -compose HardLight  -composite \
          	~/.conky/Aurora/2_processes_thin/spotify/sphere_mask.png -alpha off -compose CopyOpacity -composite \
          	~/.conky/Aurora/2_processes_thin/spotify/lastpic_xl_conv.png
