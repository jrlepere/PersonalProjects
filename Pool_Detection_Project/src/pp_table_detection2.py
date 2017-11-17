"""
pp_table_detection.py

Designed to be the leading module for table detection.
OBJECTIVE
    - Input: Image.
    - Output: Four points defining the 4 corners of the pool table.

@Author: Jake Lepere
@Date: 10/27/2017
"""

import sys
sys.path.append('/usr/local/lib/python2.7/site-packages')

from pp_defs import *
from pp_draw_utils import *
import cv2
import numpy as np

def get_table_corner_points(img):
    """
    Gets 4 points defining the pool table from the input image.
    @param img the input image
    @returns 4 points defining the corners of the pool table
    """

    img_height, img_width, img_channels = img.shape
    lower_bounds,upper_bounds = get_table_color_bounds()   # Get the bounds for the table felt color

    """
    Table Image Masking
    """
    res = cv2.cvtColor(img,cv2.COLOR_BGR2HSV)           # Convert image to HSV color space
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
    res = np.zeros((img_height,img_width,3),np.uint8)               # Blank image for contours
    color = (255,255,255)                                           # Contour drawing parameters
    thickness = 3
    cv2.drawContours(res,contours,-1,color,thickness)               # Draw contours on blank image

    """
    Canny Detection
    """
    blur = 9                                          # Blur parameter 
    res = cv2.medianBlur(res,blur)                    # Blur
    res = cv2.Canny(res,100,150,apertureSize = 3)     # Canny edge detection

    """
    Hough Line Detection
    """
    rho = 0.75                                        # Hough parameters
    theta = np.pi/180
    threshold = 150
    lines = cv2.HoughLines(res,rho,theta,threshold)   # Get lines

    """
    K-Mean 4 Line Clustering
    """
    criteria = (cv2.TERM_CRITERIA_EPS + cv2.TERM_CRITERIA_MAX_ITER,10,1.0)                           # K-Means parameters
    flags = cv2.KMEANS_PP_CENTERS
    n = 4
    max_iterations = 10 
    compactness,labels,centers = cv2.kmeans(np.float32(lines),n,None,criteria,max_iterations,flags)  # K-Means
    
    """
    Get And Return Points
    """
    growth = 100                                                                             # Offset to expand corners
    pts = _get_table_corners_from_lines_hough_space(centers,growth,img_width,img_height)   # Gets the corner points
    
    get_homography(img,pts,50)

    return pts

def _get_table_corners_from_lines_hough_space(lines,growth,img_width,img_height):
    """
    Gets the corners of the pool table from 4 lines defined in hough space.
    @param lines the lines
    @param growth an offset to grow the pool table for complete encapsulation
    @param img_width the width of the image
    @param img_height the height of the image
    @return the 4 points defining the pool table
    """
    mb_lines = _get_parameter_lines_from_hough_lines(lines)          # Convert to Parameter Space 
    return _get_table_corners_from_lines_parameter_space(mb_lines,growth,img_width,img_height)

def _get_table_corners_from_lines_parameter_space(lines,growth,img_width,img_height):
    """
    Gets the corners of the pool table from 4 lines.
    @param lines the lines of the table
    @param growth an offset to grow the pool table for complete encapsulation
    @param img_width the width of the image
    @param img_height the height of the image
    @return the 4 points defining the pool table
    """
    pts = _get_intersections_in_frame_parameter_space(lines,img_width,img_height)    # Gets intersections within frame bounds
    pts = _remove_unnecessary_pts(pts,lines,img_width,img_height)                    # Removes points not defining table corners
    _order_points_for_polygon_fill(pts)                                              # Order points in [] rather than Z
    #_grow_polygon_points(pts,growth)                                                 # Grow the points to encompass more of the table
    return pts

def _get_intersections_in_frame_parameter_space(lines,img_width,img_height):
    """
    Gets the intersection points that exist within the frame bounds.
    @param lines the lines in the form (m,b)
    @param img_width the width of the image
    @param img_height the height of the image
    @return an array of points defining the intersections in the frame
    """
    pts = []
    for i in range(len(lines)):
        for j in range(i+1,len(lines)):                                    # Compare each point
            x,y = _get_intersection_parameter_space(lines[i],lines[j])     # Get intercetions
            if x < img_width and x >= 0 and y < img_height and y >= 0:     # Intercetion is within frame bounds
                pts.append((x,y))
    return pts

def _grow_polygon_points(pts,growth):
    """
    Grows a 4 sided polygon defined by 4 points.
    @param pts the points defining the 4 sided polygon.
    @param growth the offset to grow the points.
    """
        
    min_x1 = 0                               # Initialize smallest x to 1st point
    min_x2 = 1                               # Initialize second smallest x to 2nd point
    if pts[min_x2][0] < pts[min_x1][0]:      # Swap if assumption was incorrect
        min_x1 = 1
        min_x2 = 0
    min_y1 = 0                               # Initialize smallest y to 1st point
    min_y2 = 1                               # Initialize second smallest y to 2nd point
    if pts[min_y2][1] < pts[min_y1][1]:      # Swap if assumption was incorrect
        min_y1 = 1
        min_y2 = 0
    for i in range(2,len(pts)):              # For other 2 points
        if pts[i][0] < pts[min_x2][0]:       # Point is less than 2nd smallest
            if pts[i][0] < pts[min_x1][0]:   # Point is also less than 1st smallest
                min_x2 = min_x1
                min_x1 = i
            else:
                min_x2 = i
        if pts[i][1] < pts[min_y2][1]:
            if pts[i][1] < pts[min_y1][1]:
                min_y2 = min_y1
                min_y1 = i
            else:
                min_y2 = i
    print
    print pts
    print "min_x1: " + str(min_x1) 
    print "min_x2: " + str(min_x2) 
    print "min_y1: " + str(min_y1) 
    print "min_y2: " + str(min_y2) 
    for i in range(len(pts)):                           # For each point
        if i == min_x1 or i == min_x2:                  # x is minimum, shrink
            pts[i] = (pts[i][0] - growth, pts[i][1])
        else:                                           # x is maximum, grow
            pts[i] = (pts[i][0] + growth, pts[i][1])
        if i == min_y1 or i == min_y2:                  # y is minimum, shrink
            pts[i] = (pts[i][0], pts[i][1] - growth) 
        else:                                           # y is maximum, grow
            pts[i] = (pts[i][0], pts[i][1] + growth)
    
def _get_intersection_parameter_space(l1, l2):
    ''' 
    Returns the intersection of two lines.
    @param l1 a tuple of the form (m,b) where m is the slope and b is the intercept.
    @param l2 ^
    @return The intersection of the l1 and l2 in the form (x,y).
    '''
    m1, b1 = l1
    m2, b2 = l2
    if m1 == m2:                                                                                          # Parallel lines
        raise Exception("The lines are parallel: " + str(l1) + " , " + str(l2) + ". No intersection.")
    A = np.array([[-1.0 * m1, 1.0], [-1.0 * m2, 1.0]])                                                    # Ax = b
    b = np.array([[b1], [b2]])
    x, y = np.linalg.solve(A, b)                                                                          # Solve linear matrix
    x, y = int(np.round(x)), int(np.round(y))
    return (x,y)

def _get_img_line_pts(m,b,img_width,img_height):
    '''
    Gets the intesection of the line with the frame lines of the image.
    @param m the slope of the line.
    @param b the y-intercept of the line.
    @param img_width the width of the image.
    @param img_height the height of the image.
    @returns the two intersecting points in the form (x1,y1,x2,y2).
    '''
    def init_xy(x,y,found_1,found_2,x1,y1,x2,y2):
        '''
        Helper function for initializing x and y points.
        '''
        if not found_1:
            x1 = x
            y1 = y
            found_1 = True
        elif not found_2:
            x2 = x
            y2 = y
            found_2 = True
        else:
            print "ERROR: Already found intersecting points."
        return (found_1,found_2,x1,y1,x2,y2)
    x1 = 0
    y1 = 0
    x2 = 0
    y2 = 0
    found_1 = False
    found_2 = False
    i = 0
    while i < 4:
        if i == 0:
            # y = 0
            y = 0
            x = int((-1.0) * (b / m))
            if not (x < 0 or x > img_width):
                found_1,found_2,x1,y1,x2,y2 = init_xy(x,y,found_1,found_2,x1,y1,x2,y2)
        elif i == 1:
            # x = 0
            y = int(b)
            x = 0
            if not (y < 0 or y > img_height):
                found_1,found_2,x1,y1,x2,y2 = init_xy(x,y,found_1,found_2,x1,y1,x2,y2)
        elif i == 2:
            # y = img_height
            y = int(img_height)
            x = int((img_height - b)/m)
            if not (x < 0 or x > img_width):
                found_1,found_2,x1,y1,x2,y2 = init_xy(x,y,found_1,found_2,x1,y1,x2,y2)
        elif i == 3:
            # x = img_width
            y = int(m*img_width + b)
            x = int(img_width)
            if not (y < 0 or y > img_height):
                found_1,found_2,x1,y1,x2,y2 = init_xy(x,y,found_1,found_2,x1,y1,x2,y2)
        i += 1
    
    if not found_1 or not found_2:
        print "ERROR: Could not find 2 intersecting points on the frame."
    else:
        return (x1,y1,x2,y2)

def _remove_unnecessary_pts(pts,lines,img_width,img_height):
    '''
    Removes unnecessary points.
    @param pts the points.
    @param lines the lines.
    @param img_width the width of the image.
    @param img_height the height of the image.
    @returns the 4 points for the pool table.
    '''
    if len(pts) < 4:
        raise Exception("Less than 4 points, not acceptable!")
    elif len(pts) == 4:
        return pts
    elif len(pts) == 5:
        return _get_4_pts_from_5(lines,img_width,img_height)
    elif len(pts) == 6:
        raise Exception("6 points, not implemented!")              # TODO
    else:
        raise Exception("Greater than 6 points, not acceptable!")

def _get_4_pts_from_5(lines,img_width,img_height):
    '''
    Gets 4 points from 5.
    @param lines an array of (m,b) where m is the slope and b in the intercept.
    @param img_width the width of the image.
    @param img_height the height of the image.
    @returns 4 points defining the table.
    '''
    # 6 intersections maximum.
    # Because we have 5 points, one intersection occurs outside of the frame.
    # Therefore, this point is the intersection of two 'parallel' lines. Other two lines are 'parallel' and perpendicular.
    # 'Parallel' because in theory they should be, but perspective alters this.
    p_lines_1 = []                                                                 # 1st set of parallel lines
    p_lines_2 = []                                                                 # 2nd set of parallel lines
    for i in range(len(lines)):
        j = i + 1
        while j < len(lines):
            x,y = _get_intersection_parameter_space(lines[i],lines[j])             # Intersection of each point
            if not(x < img_width and x >= 0 and y < img_height and y >= 0):        # Intersection of points is NOT within the frame!
                p_lines_1.append(lines[i])                                         # These lines are 'parallel'
                p_lines_1.append(lines[j])
                for k in range(len(lines)):                                        # The other two lines are 'parallel'
                    if k != i and k != j:
                        p_lines_2.append(lines[k])
            j += 1
    if len(p_lines_1) != len(p_lines_2) != 2:
        raise Exception("Could not get 4 lines from 5")
    pts = []                                                                       # TODO: improve efficiency and storage
    for i in range(len(p_lines_1)):
        for j in range(len(p_lines_2)):
            pts.append(_get_intersection_parameter_space(p_lines_1[i],p_lines_2[j]))
    return pts

def _get_parameter_lines_from_hough_lines(lines):
    """
    Converts an array of lines in Hough Space to an array of lines in Parameter Space. (rho,theta) => (m,b)
    @param lines the lines in Hough Space
    @return an array of lines in Parameter Space
    """
    mb = []
    for i in range(len(lines)):
        rho = lines[i][0]
        theta = lines[i][1]
        cos_theta = np.cos(theta)
        sin_theta = np.sin(theta)
        m = (-1.0) * (cos_theta / sin_theta)
        b = rho / sin_theta
        mb.append((m,b))
    return mb


def _order_points_for_polygon_fill(pts):
    '''
    Orders the pts to correctly draw the polygon. Used for the FillPoly function.
    @param pts the points.
    @return the points in an np.array.
    '''
    # TODO
    temp = pts[3]
    pts[3] = pts[2]
    pts[2] = temp

