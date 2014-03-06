/**
 * Parametric module to create an angled ergonomic support for the Apple Magic Trackpad.
 *
 * This OpenSCAD library is part of the [dotscad](https://github.com/dotscad/dotscad)
 * project, an open collection of modules and Things for 3d printing.  Please check there
 * for the latest versions of this and other related files.
 *
 * @copyright  Chris Petersen, 2014
 * @license    http://creativecommons.org/licenses/LGPL/2.1/
 * @license    http://creativecommons.org/licenses/by-sa/3.0/
 *
 * @see        http://www.thingiverse.com/thing:263636
 * @source     https://github.com/dotscad/things/blob/master/magic_trackpad_ergonomic_support/magic_trackpad_ergonomic_support.scad
 */

/* ******************************************************************************
 * Thingiverse Customizer parameters and rendering.
 * ****************************************************************************** */

/* [Global] */

// Target angle of elevation
angle = 10; // [5:45]

// Which hand you use for the trackpad
handed = "left"; // [right,left]

/* [Hidden] */

// A global overlap variable (to prevent printing glitches)
o = .1;

// Render the part
trackpad_platform(angle, handed);

/* ******************************************************************************
 * Main module code below:
 * ****************************************************************************** */

module round_corner($fn=25) {
    difference() {
        translate([-5,-5,0]) cube([10,10,200]);
        translate([5,5,-1]) cylinder(r=5, h=202);
    }
}

module lower_wall(d, $fn=25) {
    hull() {
        cube([3,1,5]);
        translate([1.5,0,5.5]) rotate([0,90,90]) cylinder(r=1.5,h=d-15);
        intersection() {
            cube([3,d,7]);
            translate([1.5,d-16,-5]) rotate([0,90,0])
                rotate_extrude(convexity = 10, $fn=25)
                translate([10.5, 0, 0])
                circle(r = 1.5);
        }
    }
}

module back_wall(d, angle, $fn=25) {
    difference() {
        union() {
            cube([d+(tan(angle)*2),11,8]);
            translate([0,1.3,8]) rotate([0,90,0]) cylinder(r=1.3,h=d+(tan(angle)*2));
        }
        translate([-o,11,9+2]) rotate([0,90,0]) cylinder(r=9,h=200);
    }
}

module trackpad_platform(angle, handed) {
    d = (13 * 10) + 3; // 13cm on a side, plus a little fudge for the wall
    difference() {
        union() {
            // platform walls
            rotate([0,-angle,0]) union() {
                if (handed == "right") {
                    translate([0,-2,0]) back_wall(d, angle);
                    lower_wall(d);
                }
                else {
                    translate([d+(tan(angle)*2),d+2,0]) rotate([0,0,180]) back_wall(d, angle);
                    translate([3,d,0]) rotate([0,0,180]) lower_wall(d);
                }
            }
            difference() {
                // base
                difference() {
                    translate([0,(handed == "right" ? -2 : 0),o]) difference() {
                        cube([d,d+2,d]);
                        rotate([0,-angle,0]) translate([-o,-o,2]) cube([d*2,d*2,d*2]);
                    }
                    translate([cos(angle)*23,(handed == "right" ? d-30 : -5),-o])
                        cube([cos(angle)*(d-23)-cos(angle)*20, 40, 200]);
                    translate([0,(handed == "right" ? 8+10 : -10+35),-o]) hull() {
                        for(t = [ [3+5+cos(angle)*10,0,0],
                                  [3+5+cos(angle)*10,d-43,0],
                                  [cos(angle)*(d-10)-5,d-43,0],
                                  [cos(angle)*(d-10)-5,0,0]
                                ]) {
                            translate(t) cylinder(r=5,h=d);
                        }
                    }
                }
                // Rounded edges
                if (handed == "right") {
                    for (tr=[ [ [0,d,-o],                    [0,0,-90] ],
                              [ [cos(angle)*d,d,-o],         [0,0,180] ],
                              [ [cos(angle)*(d-20),d,-o],    [0,0,-90] ],
                              [ [cos(angle)*(20+3),d,-o],    [0,0,180] ],
                              [ [cos(angle)*(20+3),d-20,-o], [0,0,90]  ],
                              [ [cos(angle)*(d-20),d-20,-o], [0,0,0]   ],
                            ] ) {
                        translate(tr[0]) rotate(tr[1]) round_corner();
                    }
                }
                else {
                    for (tr=[ [ [0,0,-o],                           [0,0,0]   ],
                              [ [cos(angle)*d,0,-o],                [0,0,90]  ],
                              [ [cos(angle)*d-cos(angle)*20,0,-o],  [0,0,0]   ],
                              [ [cos(angle)*(20+3),0,-o],           [0,0,90]  ],
                              [ [cos(angle)*(20+3),20,-o],          [0,0,180] ],
                              [ [cos(angle)*d-cos(angle)*20,20,-o], [0,0,-90] ],
                            ] ) {
                        translate(tr[0]) rotate(tr[1]) round_corner();
                    }
                }
            }
        }
        // Max-width cutoff
        translate([cos(angle)*d,-d/2,-d/2]) cube([d*2,d*2,d*2]);
    }
}
