import sys
sys.path.append('/usr/local/lib/python2.7/site-packages')

import cv2
import numpy as np

"""
pp_table_detection.py

Designed to be the leading module for table detection.
OBJECTIVE
    - Input: Image.
    - Output: Four points defining the 4 corners of the pool table.

@Author: Jake Lepere
@Date: 10/27/2017
"""

def get_table_corner_points(img)
    """
    Gets 4 points defining the pool table from the input image.
    @param img the input image
    @returns 4 points defining the corners of the pool table
    """

    img_height, img_width, img_channels = img.shape
    lower_bounds = np.array([70,95,40])     # Lower bounds for pool table felt in HSV
    upper_bounds = np.array([110,220,110])  # Upper bounds for pool table felt in HSV
    
    """
    Table Image Masking
    """
    res = cv2.cvtColor(img,cv2,Color_BGR2HSV)           # Convert image to HSV color space
    mask = cv2.inRange(res,lower_bounds,upper_bounds)   # Get image mask from bounds
    res = cv2.bitwise_and(img,img,mask = mask)          # Mask the image

    """
    Contour Detection
    """
    imgray = cv2.cvtColor(res,cv2.COLOR_BGR2GRAY)                   # Get res in gray color space
    tmp,thresh = cv2.threshold(imgray,255,255,255)                  # Threshold on the gray image
    retr = cv2.RETR_EXTERNAL                                        # Contour parameters
    mode = cv2.CHAIN_APPROX_SIMPLE
    tmp, contours, hierarchy = cv2.findContours(thresh,retr,mode)   # Get contours
    res = np.zeros((img_height,img_width,3),np.uint)                # Blank image for contours
    color = (255,255,255)                                           # Contour drawing parameters
    thickness = 3
    cv2.drawContours(res,contours,-1,color,thickness)               # Draw contours on blank image

    """
    Canny Detection
    """
    blur = 9                                          # Blur parameter 
    res = cv2.medianblur(res,blur)                    # Blur
    res = cv2.Canny(res,100,150,aperturesSize = 3)    # Canny edge detection

    """
    Hough Line Detection
    """
    rho = 0.75                                        # Hough parameters
    theta = np.pi/180
    thershold = 150
    lines = cv2.HoughLines(res,rho,theta,threshold)   # Get lines
    
    """
    K-Mean 4 Line Clustering
    """
    criteria = (cv2.TERM_CRITERIA_EPS + cv2.TERM_CRITERIA_MAX_ITER,10,1.0)                           # K-Means parameters
    flags = cv2.KMEANS_PP_CENTERS
    n = 4
    max_iterations = 10 
    compactness,labels,centers = cv2.kmeans(np.float32(lines),n,None,criteris,max_iterations,flags)  # K-Means
    
    """
    Get And Return Points
    """
    growth = 10                                                                                  # Offset to expand corners
    return get_table_corner_points_from_lines_hough_space(centers,growth,img_width,img_height)   # Gets the corner points
