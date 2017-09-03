from pymouse import PyMouse
import time
import pyscreenshot as pss
import sys
import os
import subprocess as sp
from pynput.keyboard import Key, Controller
import re
import numpy as np

#takes screenshots and advances the frame, for converting individual image
#files of any format into a single pdf.

#NOTES: pyscreenshot can use any one of several backends. right now its using scrot.
#imagemagick is also installed, because it's necessary for the `convert` command,
#but pyscreenshot knows not to use it because it makes blackboxes in some cases.

n_pages = sys.argv[1]
sleep_time = sys.argv[2]
write_path = sys.argv[3]

os.chdir(write_path)

#instantiate mouse and keyboard control objects
m = PyMouse()
k = Controller()

#define bounding box borders
input('Move mouse to top left corner of screenshot box and press [enter].')
bx1, by1 = m.position()
input('Move mouse to bottom right corner of screenshot box and press [enter].')
bx2, by2 = m.position()

input('Move mouse to click location and press [enter] to execute program.')
x, y = m.position() #this defines where the mouse will click

for i in range(1, int(n_pages)):

    #take a screenshot and save it as PNG
    im = pss.grab(bbox=(bx1,by1,bx2,by2)) # X1,Y1,X2,Y2
    img_name = write_path + '/img_' + str(i)
    png_name = img_name + '.png'
    im.save(png_name)

    #convert PNG to PDF and remove PNG
    pdf_name = img_name + '.pdf'
    sp.call(['convert', png_name, pdf_name])
    sp.call(['rm', png_name])

    #click mouse or press arrow key and wait for user-specified time
    if i == 1:
        m.click(x,y)
    else:
        k.press(Key.right)
        k.release(Key.right)
    time.sleep(int(sleep_time)) #allow time for next image to load

#get list of PDFs to stitch
dirfiles = os.listdir(write_path) #get list of all files in dir
indiv_pdfs = list(filter(lambda x: '.pdf' in x, dirfiles)) #get just the pdfs

#sort them by image number
img_nums = [int(re.search(r'img\_(\d+)\.pdf', i).group(1)) for i in indiv_pdfs]
indiv_pdfs = list(np.array(indiv_pdfs)[np.argsort(img_nums)])

#execute `echo <files> out.pdf | xargs pdfunite` (stitch PDFs together)
p1 = sp.Popen(['echo'] + indiv_pdfs + ['out.pdf'], stdout=sp.PIPE)
p1.wait() #wait for subprocess to finish before executing next one
p2 = sp.Popen(['xargs', 'pdfunite'], stdin=p1.stdout)
p2.wait()

#remove individual PDFs
sp.call(['rm'] + indiv_pdfs)
