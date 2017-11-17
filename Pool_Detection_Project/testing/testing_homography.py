import sys
sys.path.append('/usr/local/lib/python2.7/site-packages')
sys.path.append('../src')

from pool_detection_utils import *

import cv2
import numpy as np
import glob

images = glob.glob('*')
print images
for fname in images:
    img = cv2.imread(fname)
    show_img(img)    
