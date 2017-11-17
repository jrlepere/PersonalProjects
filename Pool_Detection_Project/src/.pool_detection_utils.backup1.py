import sys
sys.path.append('/usr/local/lib/python/site-packages')
import cv2

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

def get_intersections_in_frame(pts,img_width,img_height):
    """
    Gets the intersection points that exist within the frame bounds.
    @param pts the points
    @param img_width the width of the image
    @param img_height the height of the image
    """
    pts2 = []
    for i in range(len(centers)):
        for j in range(i+1,len(centers)):
            x,y = get_intersection(pts[i],pts[j])
            if x < img_width and x >= 0 and y < img_height and y >= 0:
                pts2.append((x,y))
    pts = pts2

def order_points_for_polygon_fill(pts):
    '''
    Orders the pts to correctly draw the polygon. Used for the FillPoly function.
    @param pts the points.
    @return the points in an np.array.
    '''
    # TODO
    temp = pts[3]
    pts[3] = pts[2]
    pts[2] = temp

def grow_polygon_points(pts,growth):
    """
    Grows a 4 sided polygon defined by 4 points.
    @param pts the points defining the 4 sided polygon.
    @param growth the offset to grow the points.
    """
    
    min_x1 = 0
    min_x2 = 1
    if pts[min_x2][0] < pts[min_x1][0]:
        min_x1 = 1
        min_x2 = 0
    min_y1 = 0
    min_y2 = 1
    if pts[min_y2][1] < pts[min_y1][1]:
        min_y1 = 1
        min_y2 = 0
    for i in range(2,len(pts)):
        if pts[i][0] < pts[min_x2][0]:
            if pts[i][0] < pts[min_x1][0]:
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
    
    for i in range(len(pts)):
        if i == min_x1 or i == min_x2:
            pts[i] = (pts[i][0] - growth, pts[i][1])
        else:
            pts[i] = (pts[i][0] + growth, pts[i][1])
        if i == min_y1 or i == min_y2:
            pts[i] = (pts[i][0], pts[i][1] - growth)
        else:
            pts[i] = (pts[i][0], pts[i][1] + growth)
    
