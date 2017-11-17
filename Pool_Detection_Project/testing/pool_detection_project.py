import sys
sys.path.append('/usr/local/lib/python2.7/site-packages')

import cv2
import numpy as np
from matplotlib import pyplot as plt

# --- DEFINITIONS --- #
#file_name = "/Users/JLepere2/Desktop/CalPolyPomona/Masters_Project/photos/IMG_0311.jpg"
file_name = "/Users/JLepere2/Desktop/CalPolyPomona/Masters_Project/photos/IMG_0316.jpg"
window_name = "POOL TABLE DETECTION"

def detect_table(img):
    
    # --- Variables --- #
    img_height, img_width, img_channels = img.shape
    
    # --- COLOR MASK --- #
    # MAYBE HSV????
    lower_bounds = np.array([40,40,10])
    upper_bounds = np.array([160,160,60])
    mask = cv2.inRange(img,lower_bounds,upper_bounds)
    res = cv2.bitwise_and(img,img,mask = mask)
    
    # --- CONTOUR --- #
    imgray = cv2.cvtColor(res,cv2.COLOR_BGR2GRAY)
    tmp,thresh = cv2.threshold(imgray,255,255,255)
    retr = cv2.RETR_EXTERNAL
    tmp, contours, hierarchy = cv2.findContours(thresh,retr,cv2.CHAIN_APPROX_SIMPLE)    
    blank_image = np.zeros((img_height,img_width,3),np.uint8)
    cv2.drawContours(blank_image,contours,-1,(255,255,255),3)
    res = blank_image
    
    # --- CANNY --- #
    res = cv2.medianBlur(res,7)
    res = cv2.Canny(res,100,150,apertureSize = 3)
    
    # --- HOUGH --- #
    rho = 1
    theta = np.pi/180
    threshold = 130
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
    height, width = res.shape
    accepted_lines.append([(0,0)])
    accepted_lines.append([(0,np.pi/2)])
    accepted_lines.append([(width-1,0)])
    accepted_lines.append([(height-1,np.pi/2)])
    for i in range(len(accepted_lines)):
        for rho,theta in accepted_lines[i]:
            a = np.cos(theta)
            b = np.sin(theta)
            x0 = a*rho
            y0 = b*rho
            x1 = int(x0 + 2600*(-b))
            y1 = int(y0 + 2600*(a))
            x2 = int(x0 - 2600*(-b))
            y2 = int(y0 - 2600*(a))
            cv2.line(img,(x1,y1),(x2,y2),(0,255,255),2)
    pts = []
    # --- GET INTERSECTIONS --- #
    for i in range(len(accepted_lines)):
        j = i + 1
        while j < len(accepted_lines):
            rho1, theta1 = accepted_lines[i][0]
            rho2, theta2 = accepted_lines[j][0]
            if theta1 == theta2:
                j += 1
                continue
            A = np.array([[np.cos(theta1), np.sin(theta1)],
                          [np.cos(theta2), np.sin(theta2)]
                        ])
            b = np.array([[rho1], [rho2]])
            x0, y0 = np.linalg.solve(A, b)
            x0, y0 = int(np.round(x0)), int(np.round(y0))
            pts.append((x0,y0))
            if abs(x0) < 5000 and abs(y0) < 5000:
                cv2.circle(img,(x0,y0),5,(255,0,255),5)
            j += 1
    
if __name__ == "__main__":

    img = cv2.imread(file_name)
    cv2.namedWindow(window_name,cv2.WINDOW_NORMAL)
    detect_table(img)
        
    while (1):
        cv2.imshow(window_name,cv2.resize(img,(600,450)))
        k = cv2.waitKey(5)
        if k == ord('q'):
            break      
    
    cv2.destroyAllWindows()
    
