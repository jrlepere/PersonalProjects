import sys
sys.path.append('/usr/local/lib/python2.7/site-packages')

import cv2
import numpy as np
from matplotlib import pyplot as plt

img = cv2.imread('pooltable.png')
gray = cv2.cvtColor(img,cv2.COLOR_BGR2GRAY)
edges = cv2.Canny(gray,50,100,apertureSize = 3)

plt.imshow(edges)
plt.show()

rho = 1
theta = np.pi/180
threshold = 150

lines = cv2.HoughLines(edges,rho,theta,threshold)
for i in range(len(lines)):
    for rho, theta in lines[i]:
        a = np.cos(theta)
        b = np.sin(theta)
        x0 = a*rho
        y0 = b*rho
        x1 = int(x0 + 1000*(-b))
        y1 = int(y0 + 1000*(a))
        x2 = int(x0 - 1000*(-b))
        y2 = int(y0 - 1000*(a))
        cv2.line(img,(x1,y1),(x2,y2),(0,0,255),2)

circles = cv2.HoughCircles(edges,cv2.HOUGH_GRADIENT,1,100,param1=100,param2=30)
circles = np.uint16(np.around(circles))
for i in circles[0,:]:
    cv2.circle(img,(i[0],i[1]),i[2],(0,255,0),2)
    cv2.circle(img,(i[0],i[1]),2,(0,0,255),3)

cv2.imwrite("pooltable_hough2.png",img)
img_hough = cv2.imread("pooltable_hough2.png")
plt.imshow(img_hough)
plt.show()
