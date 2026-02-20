mkdir -p wallpaper
for i in *.{jpg,png,jpeg}; do 
    ffmpeg -i "$i" -vf "scale=1920:1080" "wallpaper/$i"; 
done
    
