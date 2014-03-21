EXPhotoViewer
=============

A "drop in" photo viewer for iOS, SUPER easy to use, it has the "zoom the rest of the app away effect"
It works with any UIImageView, just laying around, in a table, in a cell in a custom made carousel, everywhere!

Whats the **"EX"** for? it is for **EX**TRA AWESOME!!!

![image](https://raw.githubusercontent.com/Julioacarrettoni/EXPhotoViewer/master/screenshots/iPhone_animated.gif)

##What it does
It will take the image and:

* animate it from the current position to the center of the screen to a "fit" position where all the image can be seen, if the image is not big enought to cover the screen it will just center (look at the iPad screens for more detail)
* The background will dim a little.
* The rest of the app will back away a little.
* The full screen image can be zoomed in and out and can be scrolled in any direction if zoomed enought.
* To exit the full screen mode just tap anywhere.

## Usage
Import "EXPhotoViewer.h"

Then if for example "anImageView" contains the image you would like to show, just do:

    [EXPhotoViewer showImageFrom:anImageView];

and Voila! the rest is just **MAGIC!** *(actually just a bunch of code)*

look at `ThumbCollectionCell.m` line `15` if you would like to see an usage example.

##Installation
Just include the followings files to your project:
EXPhotoViewer

    EXPhotoViewer.h
    EXPhotoViewer.m
    EXPhotoViewer.xib
And you are done, no library or framework or weird hacky  compiler flag or anything.

##Screenshots

### iPhone
![image](https://raw.githubusercontent.com/Julioacarrettoni/EXPhotoViewer/master/screenshots/iphone_screenshot_1.png)
![image](https://raw.githubusercontent.com/Julioacarrettoni/EXPhotoViewer/master/screenshots/iphone_screenshot_2.png)
![image](https://raw.githubusercontent.com/Julioacarrettoni/EXPhotoViewer/master/screenshots/ipad_screenshot_1.png)
![image](https://raw.githubusercontent.com/Julioacarrettoni/EXPhotoViewer/master/screenshots/ipad_screenshot_2.png)

##LICENSE
Simple MIT license, look at the `LICENSE` file for more details