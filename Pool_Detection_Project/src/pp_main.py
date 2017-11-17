import sys
sys.path.append('/usr/local/lib/python2.7/site-packages')

from pp_draw_utils import *
from pp_table_detection2 import get_table_corner_points
from pp_ball_detection import get_ball_coordinate_points
import cv2
import numpy as np
from matplotlib import pyplot as plt

# --- DEFINITIONS --- #
#file_name = "/Users/JLepere2/Desktop/CalPolyPomona/Masters_Project/photos/IMG_0330.jpg"
file_name = "/Users/JLepere2/Desktop/CalPolyPomona/Masters_Project/photos/IMG_0316.jpg"
window_name = "POOL TABLE DETECTION"

def detect_table(img):
    
    table_corner_points = get_table_corner_points(img)
    #ball_coordinates = get_ball_coordinate_points(img,table_corner_points)    
    #draw_circles_on_img(img,ball_coordinates)
    #show_img(img)

if __name__ == "__main__":

    img = cv2.imread(file_name)
    detect_table(img)
    cv2.destroyAllWindows()
    
