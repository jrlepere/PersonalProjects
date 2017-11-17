"""
pp_defs.py

Defines functions for to pass global variables.

@Author: Jake Lepere
@Date: 10/27/2017
"""

import sys
sys.path.append('/usr/local/lib/python2.7/site-packages')

from pp_draw_utils import *
import cv2
import numpy as np

TABLE_COLOR_LOWER_BOUNDS = np.array([70,95,40])
TABLE_COLOR_UPPER_BOUNDS = np.array([110,220,110])
POOL_TABLE_HEIGHT = 200
POOL_TABLE_WIDTH = POOL_TABLE_HEIGHT * 2

def get_table_color_bounds():
    """
    Gets the lower and upper bounds for the table color.
    @return a tuple containing the lower and upper bounds for the pool table color
    """
    return (TABLE_COLOR_LOWER_BOUNDS,TABLE_COLOR_UPPER_BOUNDS)

def get_table_width():
    """
    Gets the width of the pool table.
    @return the width of the pool table
    """
    return POOL_TABLE_WIDTH

def get_table_height():
    """
    Gets the height of the pool table.
    @returns the height of the pool table
    """
    return POOL_TABLE_HEIGHT

def get_homography(img,table_corner_points,offset):
    """
    Calculates a homography matrix from the corner points
    @param table_corner_points the corner points of the table
    @return a 3x3 homography matrix
    """
    #TODO: format scr_pts
    pts = table_corner_points
    src_pts = []
    src_pts.append([pts[3][0],pts[3][1],1])
    src_pts.append([pts[2][0],pts[2][1],1])
    src_pts.append([pts[0][0],pts[0][1],1])
    src_pts.append([pts[1][0],pts[1][1],1])
    src_pts = np.array(src_pts)
    dst_pts = []
    dst_pts.append([0+offset,0+offset,1])
    dst_pts.append([0+offset,POOL_TABLE_HEIGHT+(offset),1])
    dst_pts.append([POOL_TABLE_WIDTH+(offset),0+offset,1])
    dst_pts.append([POOL_TABLE_WIDTH+(offset),POOL_TABLE_HEIGHT+(offset),1])
    dst_pts = np.array(dst_pts)
    HOMOGRAPHY_MATRIX, status = cv2.findHomography(src_pts,dst_pts)
    img_out = cv2.warpPerspective(img,HOMOGRAPHY_MATRIX,(get_table_width()+int(offset*2.5),get_table_height()+int(offset*2.5)))
    show_img(img)
    
    lower_bounds,upper_bounds = get_table_color_bounds()

    res = cv2.cvtColor(img_out,cv2.COLOR_BGR2HSV)
    mask = 255 - cv2.inRange(res,lower_bounds,upper_bounds)
    img_out = cv2.bitwise_and(img_out,img_out,mask = mask)
    show_img(img_out)

    blur = cv2.GaussianBlur(img_out,(3,3),10)
    show_img(blur)

    res = cv2.Canny(img_out,50,80,apertureSize = 3)
    show_img(res)
    
    dp = 1
    min_dist = 100
    param_1 = 50
    param_2 = 10
    min_radius = 10
    max_radius = 20
    circles = cv2.HoughCircles(res,cv2.HOUGH_GRADIENT,dp,min_dist,param1=param_1,param2=param_2,minRadius=min_radius,maxRadius=max_radius)
    if circles is None:
        raise Exception("Could not find any circles from Hough transform")

    draw_circles_on_img(img_out,circles)
    show_img(img_out)

    #TODO: Check status
    return HOMOGRAPHY_MATRIX

