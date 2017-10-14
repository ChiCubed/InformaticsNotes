# Algorithms

## Graham scan

### Summary

Graham scan is used to determine the convex hull of a set of points.

Essentially, the algorithm involves two main passes: sorting the points based on their angle from an arbitrarily chosen point \(for instance, the bottom-most or left-most point\), and eliminating points that can't be on the convex hull. The second pass involves stepping through each point, and removing the second-from-top on the current convex hull if it causes an interior angle greater than 180 degrees \(i.e. cannot be part of the convex hull\).

### Complexity

$$O(NlogN)$$ due to the complexity of sorting points. The main pass is actually $$O(N)$$ \(every point is added and popped at most once\).

### Code

```cpp
#include <bits/stdc++.h>

using namespace std;

typedef long double ld;

struct vec2 {
    ld x,y;
    vec2(ld x, ld y): x(x), y(y) {}
    vec2(const vec2& a, const vec2& b): x(b.x-a.x), y(b.y-a.y) {}
    
    ld normsqr() { return x*x + y*y; }
} rootPoint; // rootPoint is a point needed as a reference for sorting

inline ld cross(const vec2& l, const vec2& o) { return l.x*o.y - o.x*l.y; }

inline vec2 secondFromTop(const vector<vec2>& v) {
    // assumes that the vector has size >= 2.
    return *(v.rbegin()+1);
}

inline int sign(ld val) {
    return (0.0 < val) - (val < 0.0);
}

inline ld side(vec2 p, line l) {
    return cross(vec2(l.p1,l.p2),vec2(l.p1,p));
}

// Function to compare two points, used
// by the sorting function.
int comp(const vec2& a, const vec2& b) {
    int s = sign(side(rootPoint, a, b);
    if (s == 0) {
        return vec2(rootPoint, b).normsqr() >=
               vec2(rootPoint, a).normsqr()
             ? -1 : 1;
    }
    return s;
}

vector<vec2> stack;

// http://www.geeksforgeeks.org/convex-hull-set-2-graham-scan/
void convexHull(vector<vec2>& points) {
    // get the leftmost point
    int m = 0;
    ld mx = points[0].x;
    for (int i = 1; i < points.size(); ++i) {
        // In case of a tie, we arbitrarily
        // pick the lower point.
        if ((points[i].x < mx) ||
            (points[i].x == mx && points[i].y < points[m].y)) {
            mx = points[i].x;
            m = i;
        }
    }
    
    // We now ensure the lowest point is
    // at the start, so it doesn't get sorted.
    swap(points[0], points[m]);
    
    // Sorting
    rootPoint = points[0];
    sort(points.begin()+1, points.end(), comp);
    
    // We'll now remove all
    // the points that are at the same
    // angle but further than other points.
    int m = 1;
    for (int i = 1; i < points.size(); ++i) {
        while (i < points.size()-1 &&
               sign(side(rootPoint, points[i], points[i+1])) == 0)
           ++i;
       
        points[m++] = points[i];
    }
    
    if (m < 3) {
        // Not enough points for convex hull
        return;
    }
    
    stack.push_back(points[0]);
    stack.push_back(points[1]);
    stack.push_back(points[2]);
    
    for (int i = 3; i < m; ++i) {
        while (sign(side(secondFromTop(stack),
                         stack.back(), points[i])) >= 0)
            stack.pop_back();
        stack.push_back(points[i]);
    }
    
    // stack is now populated
    // with the convex hull.
}
```



