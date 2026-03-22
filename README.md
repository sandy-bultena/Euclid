# Euclid's Elements

## Purpose

To create videos and PDF documents that can describe Euclid's Elements in a more modern approach (i.e. using algebra to describe what is going on, rather than just using words)

## Access to videos and PDFs

* PDFs: 	Look in the `Propositions/PDF` folder
* Videos: https://www.youtube.com/sandybultena

## Documentation and Examples

[Documentation](./Documenation)

[Examples](./Documentation/Examples)

## Raison d'être

Many moons ago, I wnated to revisit my university geometry course, by going through all the examples in the text book.  Unfortunately, the textbook assumed I had remembered all of my rudimentary geometry, which I had not.

I decided that I would work my way through the Elements, and teach myself what I had forgotten.  I bought a book, based on the Heath's translation.  I tried reading the book.  Keeping track of angles `ABC`, `ACB` and `BCA` with line `AB` etc, was too hard to keep track of for me.  And then reading all the text just got me confused unless I started labelling the lines and angles, and writing the algebra.

So, I decided, we live in a modern age, let me check youtube.  I could not find any videos that explained the Elements in any way other than a Heath's translation.

So that is how I came upon the idea of creating my own videos.

## Caveats

These videos/pdfs are not for advance mathematicians or purists.  I am *loosely* translating the Elements. I gloss over the finer details.  For example, Euclid makes a distinction between a `measure` and a `number`.  I do not.

Some comments on my youtube channel have been written by people who are obviously very upset with me over this issue.  I do not plan to change my approach.

## Tools

I am a coder by profession and hobby.  I did not like the tools that were available, so I created my own in perl/Tk.  However, as time passed, it was no longer feasible to maintain perl/Tk (it stopped working on my new Mac) so I commissioned Alex Emily Oxorn to rewrite the tools in python using 3b1b manim libraries.

### Current Software Framework

This library, located in directory `./euclidlib`

#### Third Party

* Python 3.12
* manimlib v1.7.1 by 3b1b [github](https://github.com/3b1b/manim) (this in turn requires 3rd party software)

## Authors & Copyright

### Creative Content (videos / presentation, etc):

​	(c) Sandy Bultena 2013, 2014, 2015, 2016, 2017, 2018, 2026 

​	licensed under the http://creativecommons.org/llicenses/by-nc/3.0

​       * Note that Book1 python propositions were translated from perl to python by Alex Emily Oxorn

### Software:

​	(_library using manimgl_) (`./euclidlib`) (c) Alex Emily Oxorn 2026

​	(_library using perl/tk_) (`./lib`) (c) Sandy Bultena 2013, 2014, 2015, 2016, 2017, 2018. 

​	

## Issues

Feel free to raise issues, or create pull requests for improvements or corrections.
