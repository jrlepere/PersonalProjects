import sys
sys.path.append('/usr/local/lib/python/site-packages')
import cv2
import numpy as np

def show_img(img):
    """
    Shows the image until q is pressed.
    @param img the image
    """
    window_name = "TEST"
    cv2.namedWindow(window_name,cv2.WINDOW_NORMAL)
    while (1):
        cv2.imshow(window_name,cv2.resize(img,(600,450)))
        k = cv2.waitKey(5)
        if k == ord('q'):
            break

def draw_lines_on_img_parameter_space(img,lines,color):
    """
    Draws the lines defined in Parameter Space on the image
    @param img the image
    @param lines the lines
    @param color the color
    """
    img_height, img_width, img_channels = img.shape
    for i in range(len(lines)):
        m,b = lines[i]
        x1,y1,x2,y2 = get_img_line_pts(m,b,img_width,img_height)
        cv2.line(img,(x1,y1),(x2,y2),color)

def draw_lines_on_img_hough_space(img,lines,color):
    """
    Draws the lines defined in Parameter Space on the image
    @param img the image
    @param lines the lines
    @param color the color
    """
    img_height, img_width, img_channels = img.shape
    for i in range(len(lines)):
        rho = lines[i][0][0]
        theta = lines[i][0][1]
        cos_theta = np.cos(theta)
        sin_theta = np.sin(theta)
        offset = 4000
        x = rho * cos_theta
        y = rho * sin_theta
        x1 = int(x + offset * (-1) * sin_theta)
        y1 = int(y + offset * cos_theta)
        x2 = int(x - offset * (-1) * sin_theta)
        y2 = int(y - offset * cos_theta)
        cv2.line(img,(x1,y1),(x2,y2),color)
    
def draw_points_on_img_parameter_space(img,pts,color):
    """
    Draws the points on the image
    @param img the image
    @param pts the points
    @param color the color
    """
    for i in range(len(pts)):
        x = pts[i][0]
        y = pts[i][1]
        cv2.circle(img,(x,y),10,color)

def draw_circles_on_img(img,circles):
    for i in circles[0,:]:
        cv2.circle(img,(i[0],i[1]),i[2],(0,255,0),2)
        cv2.circle(img,(i[0],i[1]),2,(0,0,255),3)
