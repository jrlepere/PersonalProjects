"""
pp_ball_detection.py

Designed to be the leading module for ball detection.
OBJECTIVE
    - Input: Image and table corner points.
    - Output: Points defining ball location on table

@Author: Jake Lepere
@Data: 10/27/2017
"""

import sys
sys.path.append('/usr/local/lib/python2.7/site-packages')

from pp_defs import *
from pp_draw_utils import *
import cv2
import numpy as np


def get_ball_coordinate_points(img,table_corner_points):
    """
    Gets the ball coordinates on the image defined by the table corner points.
    @param img the image
    @param table_corner_points the corner points of the table
    @returns the coordinates of the ball on the table
    """
    
    img_height, img_width, img_channels = img.shape  
    lower_bounds, upper_bounds = get_table_color_bounds()

    """
    Table Mask
    """
    mask = np.zeros((img_height,img_width,3),np.uint8)
    cv2.fillPoly(mask,np.array([table_corner_points],dtype = np.int32),(255,255,255))
    res = cv2.bitwise_and(img,mask)
    show_img(res)

    """
    Negative Color Mask
    """
    res2 = cv2.cvtColor(res,cv2.COLOR_BGR2HSV)
    mask = 255 - cv2.inRange(res2,lower_bounds,upper_bounds)
    res2 = cv2.bitwise_and(res2,res2,mask = mask)
    res2 = cv2.cvtColor(res2,cv2.COLOR_HSV2BGR)

    """
    Canny Edge Detection
    """
    res2 = cv2.medianBlur(res2,3)
    res2 = cv2.Canny(res2,100,150,apertureSize = 3)

    """
    Hough Circle Detection
    """
    dp = 1
    min_dist = 70
    param_1 = 50
    param_2 = 10
    min_radius = 10
    max_radius = 20
    circles = cv2.HoughCircles(res2,cv2.HOUGH_GRADIENT,dp,min_dist,param1=param_1,param2=param_2,minRadius=min_radius,maxRadius=max_radius)
    if circles is None:
        raise Exception("Could not find any circles from Hough transform")
    
    """
    Remove Falsely Detected Circles
    """
    remove_pocket_circles(circles,table_corner_points,res)

    return circles

def remove_pocket_circles(circles,table_corner_points,img):
    """
    Removes the circles detected from the pockets
    @param circles the circles
    @param table_corner_points the corner points of the table
    @param img the image
    """
    '''
    homography_matrix = get_homography(table_corner_points)
    corner_pt_proj = []
    for pt in table_corner_points:
        pt_proj = cv2.perspectiveTransform(np.array([np.array([[pt[0],pt[1]]],dtype='float32')]),homography_matrix)
        x = int(pt_proj[0][0][0])
        y = int(pt_proj[0][0][1])
        corner_pt_proj.append([x,y])
    circles_r = []
    threshold = 5
    for pt in circles[0][0:]:
        pt_proj = cv2.perspectiveTransform(np.array([np.array([[pt[0],pt[1]]],dtype='float32')]),homography_matrix)
        x = int(pt_proj[0][0][0])
        y = int(pt_proj[0][0][1])
        print (x,y)
        for cp in corner_pt_proj:
            print "   " + str(np.linalg.norm(np.array([x,y,1]) - np.array([cp[0],cp[1],1])))
        if abs(x) < threshold and abs(y) < threshold:     # TOP-LEFT
            continue
        if abs(x) < threshold and abs(y - get_table_width()) < threshold:     # BOTTOM-LEFT
            continue
        circles_r.append(pt)
    # WITHIN RANGE AND AVERAGE COLOR IS WITHIN FELT SPECS
    circles = circles_r
    show_img(img)
    '''
    img_height, img_width, img_channels = img.shape  
    for pt in circles[0][0:]:
        x = pt[0]
        y = pt[1]
        r = pt[2]
        mask = np.zeros((img_height,img_width),np.uint8)
        cv2.circle(mask,(x,y),r,255,thickness=-1)
        data = cv2.bitwise_and(img,img,mask=mask)
    show_img(data)

#img_out = cv2.warpPerspective(img,homography_matrix,(get_table_width(),get_table_height()))
#show_img(img_out)
