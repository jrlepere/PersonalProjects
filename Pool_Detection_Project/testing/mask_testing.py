import sys
sys.path.append('/usr/local/lib/python2.7/site-packages')

import cv2
import numpy as np
from matplotlib import pyplot as plt


# --- DEFINITIONS --- #
file_name = "/Users/JLepere2/Desktop/CalPolyPomona/Masters_Project/photos/IMG_0330.jpg"
window_name = "TABLE DETECTION"
r_low_tb_name = "R_LOW"
r_high_tb_name = "R_HIGH"
g_low_tb_name = "G_LOW"
g_high_tb_name = "G_HIGH"
b_low_tb_name = "B_LOW"
b_high_tb_name = "B_HIGH"
image_selector_tb_name = "IMAGE"

def detect_table(img,lower_bounds,upper_bounds):
    hsv = cv2.cvtColor(img,cv2.COLOR_BGR2HSV)
    mask = cv2.inRange(img,lower_bounds,upper_bounds)
    res = cv2.bitwise_and(img,img,mask = mask)
    return hsv

def nothing(x):
    pass

if __name__ == "__main__":
    
    img = cv2.imread(file_name)
    img_height, img_width, img_channels = img.shape

    # --- GUI DEFINITIONS --- #
    cv2.namedWindow(window_name,cv2.WINDOW_NORMAL)
    cv2.createTrackbar(image_selector_tb_name,window_name,0,4,nothing)
    #cv2.createTrackbar(r_low_tb_name,window_name,0,255,nothing)
    #cv2.createTrackbar(r_high_tb_name,window_name,0,255,nothing)
    #cv2.createTrackbar(g_low_tb_name,window_name,0,255,nothing)
    #cv2.createTrackbar(g_high_tb_name,window_name,0,255,nothing)
    #cv2.createTrackbar(b_low_tb_name,window_name,0,255,nothing)
    #cv2.createTrackbar(b_high_tb_name,window_name,0,255,nothing)

    while (1):
        image_to_show = cv2.getTrackbarPos(image_selector_tb_name,window_name)
        if image_to_show == 0:
            res = img
        elif image_to_show >= 1:
            #r_low = cv2.getTrackbarPos(r_low_tb_name,window_name)
            #r_high = cv2.getTrackbarPos(r_high_tb_name,window_name)
            #g_low = cv2.getTrackbarPos(g_low_tb_name,window_name)
            #g_high = cv2.getTrackbarPos(g_high_tb_name,window_name)
            #b_low = cv2.getTrackbarPos(b_low_tb_name,window_name)
            #b_high = cv2.getTrackbarPos(b_high_tb_name,window_name)
            lower_bounds = np.array([60,60,10])
            upper_bounds = np.array([110,110,60])
            res = detect_table(img,lower_bounds,upper_bounds)
            if image_to_show >= 2:
                imgray = cv2.cvtColor(res,cv2.COLOR_BGR2GRAY)
                tmp,thresh = cv2.threshold(imgray,255,255,255)
                retr = cv2.RETR_EXTERNAL
                tmp, contours, hierarchy = cv2.findContours(thresh,retr,cv2.CHAIN_APPROX_SIMPLE)    
                blank_image = np.zeros((img_height,img_width,3),np.uint8)
                cv2.drawContours(blank_image,contours,-1,(255,255,255),3)
                res = blank_image
                if image_to_show >= 3:
                    res = cv2.medianBlur(res,7)
                    res = cv2.Canny(res,100,150,apertureSize = 3)
                    if image_to_show >= 4:
                        rho = 1
                        theta = np.pi/180
                        threshold = 100
                        lines = cv2.HoughLines(res,rho,theta,threshold)
                        rho_threshold = 50
                        theta_threshold = 0.05
                        accepted_lines = []
                        for i in range(len(lines)):
                            for rho,theta in lines[i]:
                                found_similar = False
                                for j in range(len(accepted_lines)):
                                    for accepted_rho, accepted_theta in accepted_lines[j]:
                                        if abs(accepted_rho - rho) < rho_threshold and abs(accepted_theta - theta) < theta_threshold:
                                            found_similar = True
                                if not found_similar:
                                    accepted_lines.append(lines[i])
                        new_img = img.copy()
                        for i in range(len(lines)):
                            for rho,theta in lines[i]:
                                a = np.cos(theta)
                                b = np.sin(theta)
                                x0 = a*rho
                                y0 = b*rho
                                x1 = int(x0 + 2000*(-b))
                                y1 = int(y0 + 2000*(a))
                                x2 = int(x0 - 2000*(-b))
                                y2 = int(y0 - 2000*(a))
                                cv2.line(new_img,(x1,y1),(x2,y2),(0,255,255),2)
                        res = new_img
    
        cv2.imshow(window_name,cv2.resize(res,(600,450)))
        k = cv2.waitKey(5)
        if k == ord('q'):
            break      
    
    cv2.destroyAllWindows()

