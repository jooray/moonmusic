## No longer maintained

I do not maintain this project any more. If you are after my other audio
experiments, see [markdown2audio](https://github.com/jooray/markdown2audio).

For what I am building now, see my
[project showcase](https://juraj.bednar.io/showcase/).

I also write books and work on things that are not code: my cypherpunk novel
[Tamers of Entropy](https://tamersofentropy.net/), my English podcast
[Option Plus](https://optionplus.io/), [my blog](https://juraj.bednar.io/en/blog-en/),
and [everything else](https://juraj.bednar.io/en). There is also
[more about me](https://juraj.bednar.io/en/about-me/).

This is an experimental synthesizer based on 
http://arss.sourceforge.net/

Our code is released under BSD license.

(c) 2012 Juraj Bednar <jooray+moonmusic@gmail.com>
         Radovan Misovic <lol@sn0wcrash.net>

Created at music hack day

Installation
------------

Download and install arss, open this sketch in Processing.org,
install Minim (may be already part of your Processing distribution),
fullscreen.

We switched to OpenCV from processing.video for webcam capture,
because processing.video does not work under Linux. You have
two options: install OpenCV on any platform or edit the source
and change according to comments (Processing capture parts
are marked and commented, you need to comment out OpenCV parts.
Sadly, processing nor java have preprocessor, so apart from maintaining
two branches, there is no way to switch it easily).

Edit path to arss on the top of the file

Run and enjoy

Usage
-----

ENTER stores and analyses the image coming from default camera

!, @, # (Shift-1, Shift-2, Shift-3 on US keyboard) loads the analyzed image
to layer 1, 2, 3

1, 2, 3 toggles playing of the particular layer (it always plays from the
start, think about it when timing the run)

keys z,x,c,...,< (lower part of US keyboard) control b/w threshold

Key a toggles b/w and grayscale modes

"i" toggles invert
