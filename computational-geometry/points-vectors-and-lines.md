# Points, Vectors and Lines

This defines a number of useful structures regarding points, vectors and lines, as well as useful methods.

## Vector

A point may be represented simply as a vector.

```cpp
#include <cmath> // sqrt

typedef long double ld;

struct vec2 {
    ld x,y;

    // Default constructor
    vec2(ld x, ld y): x(x), y(y) {}

    // The reason for this constructor
    // is to represent a vector between
    // two points. For instance, the
    // vector from point A to point B
    // is equal to B's position minus
    // A's position, and this constructor
    // allows that to be represented as
    // vec2(A, B).
    vec2(const vec2& a, const vec2& b): x(b.x-a.x), y(b.y-a.y) {}

    vec2 operator+= (const vec2& o) { x+=o.x; y+=o.y; return *this; }
    vec2 operator-= (const vec2& o) { x-=o.x; y-=o.y; return *this; }
    vec2 operator*= (const ld v)    { x*=v;   y*=v;   return *this; }
    vec2 operator/= (const ld v)    { x/=v;   y/=v;   return *this; }

    ld norm()    { return sqrt(x*x + y*y); }
    ld normsqr() { return      x*x + y*y;  }
};

inline vec2 operator+ (vec2 l, const vec2& o) { l+=o; return l; }
inline vec2 operator- (vec2 l, const vec2& o) { l-=o; return l; }
inline vec2 operator* (vec2 l, const ld v)    { l*=v; return l; }
inline vec2 operator* (const ld v, vec2 r)    { r*=v; return r; }
inline vec2 operator/ (vec2 l, const ld v)    { l/=v; return l; }
inline vec2 operator/ (const ld v, vec2 r)    { r/=v; return r; }

inline ld dot(const vec2& l, const vec2& o) { return l.x*o.y + o.x*l.y; }

// an analog of the 3D vector
// cross product. useful for,
// among other things, line
// segment intersections.
inline ld cross(const vec2& l, const vec2& o) { return l.x*o.y - o.x*l.y; }
```

## Lines

A line may be represented as a combination of two vectors, representing two points on a line. The advantage of this approach is that it allows both line segments and lines to be represented in the same data structure.

```cpp
typedef long double ld;

struct line {
    vec2 p1,p2;

    line(vec2 p1, vec2 p2): p1(p1), p2(p2) {}

    // These functions do not check
    // that the gradient is not equal
    // to infinity (p1.x = p2.x).
    ld gradient()  { return (p2.y - p1.y) / (p2.x - p1.x); }
    ld intercept() { return  p1.y - p1.x * gradient();     }
};
```

## Useful functions

```cpp
// http://paulbourke.net/geometry/pointlineplane/
// Note the solution is quite similar
// in higher dimensions.
ld distToLine(vec2 p, line l) {
    // This can be adjusted easily
    // to return the intersection point.
    ld u = dot(vec2(l.p1,p),vec2(l.p1,l.p2)) / vec2(l.p1,l.p2).normsqr();
    // If the distance is to a line
    // segment and you wish to ensure
    // that the nearest point is
    // on the line segment, all that
    // you need to do is test that
    // u is in the range [0,1].

    vec2 inter = l.p1 + u*vec2(l.p1,l.p2);
    return vec2(p,inter).norm();
}

// Sign of a double
// https://stackoverflow.com/a/4609795/3943306
inline int sign(ld val) {
    // It may be necessary to ensure
    // that the value is approximately
    // equal to 0, because of precision.
    // i.e. fabs(val) < EPSILON
    return (0.0 < val) - (val < 0.0);
}

// Determine which 'side'
// of a line a point lies on.
// This is 0 if the point
// lies on an extension of the
// line segment i.e. all three
// points are collinear,
// negative if the point is
// below the line,
// and positive if the point is
// above the line.
inline ld side(vec2 p, line l) {
    return cross(vec2(l.p1,l.p2),vec2(l.p1,p));
}

// Checks that two points
// are on different sides
// of a line. A point
// collinear to a line is
// considered to be
// on neither side, i.e.
// if one of the points is
// collinear this function
// will necessarily
// return true.
inline bool differentSide(vec2 p1, vec2 p2, line l) {
    return side(p1,l)*side(p2,l) <= 0.0;
}

inline bool onSegment(vec2 p, line l) {
    return (p.x <= max(l.p1.x, l.p2.x) && p.x >= min(l.p1.x, l.p2.x) &&
            p.y <= max(l.p1.y, l.p2.y) && p.y >= min(l.p1.y, l.p2.y));
}

// returns a true/false
// value, whether or not
// the lines intersect.
// http://www.cdn.geeksforgeeks.org/check-if-two-given-line-segments-intersect/
// if you are guaranteed
// that no lines are
// collinear and
// intersecting, i.e.
// no two lines intersect
// at more than one point
// (or are collinear
//  and intersect at
//  an endpoint)
// then the special tests
// are unnecessary.
bool linesIntersect(line l1, line l2) {
    ld a = sign(side(l1.p1, line(l1.p2, l2.p1))),
       b = sign(side(l1.p1, line(l1.p2, l2.p2))),
       c = sign(side(l2.p1, line(l2.p2, l1.p1))),
       d = sign(side(l2.p1, line(l2.p2, l1.p2)));
    
    return ((a != b   && c != d)               ||
            (a == 0.0 && onSegment(l2.p1, l1)) ||
            (b == 0.0 && onSegment(l2.p2, l1)) ||
            (c == 0.0 && onSegment(l1.p1, l2)) ||
            (d == 0.0 && onSegment(l1.p2, l2)));
}
```



