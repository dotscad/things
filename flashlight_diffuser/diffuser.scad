/**
 * Parametric module to create a flashlight diffuser.
 *
 * This OpenSCAD library is part of the [dotscad](https://github.com/dotscad/dotscad)
 * project, an open collection of modules and Things for 3d printing.  Please check there
 * for the latest versions of this and other related files.
 *
 * @copyright  Chris Petersen, 2016
 * @license    http://creativecommons.org/licenses/LGPL/2.1/
 * @license    http://creativecommons.org/licenses/by-sa/3.0/
 *
 * @see        http://www.thingiverse.com/thing:1832034
 * @source     https://github.com/dotscad/things/blob/master/flashlight_diffuser/flashlight_diffuser.scad
 */

/* ******************************************************************************
 * Thingiverse Customizer parameters and rendering.
 * ****************************************************************************** */

/* [Global] */

// Inner diameter of the diffuser (e.g. 15.33 fits my Fenix LD02 AAA light)
diameter = 15.33;

// Height of the sleeve that fits over the end of the flashlight
sleeve_height = 12;

// Type of diffuser to print (more coming soon)
diffuser_type = "Dome"; // [Dome, None]

// Height of the diffuser (in case you want to make a tall one)
diffuser_height = 20;

/* [Hidden] */

// Seems useful to leave this high for larger diameters
$fn=75;

// A global overlap variable (to prevent printing glitches)
$o = .1;

/* ******************************************************************************
 * Render the part
 * ****************************************************************************** */

diffuser(diameter/2, sleeve_height, diffuser_type, diffuser_height);

/* ******************************************************************************
 * Main module code below:
 * ****************************************************************************** */

// This module is copied into place so thingiverse customizer will work.
// @see https://github.com/dotscad/dotscad/blob/master/on_arc.scad
module on_arc(radius, angle) {
    x = radius - radius * cos(angle);
    y = radius * sin(angle);
    translate([x,y,0])
        rotate([0,0,-angle])
            children();
}

// Dome diffuser
module dome_diffuser(radius, wall, height) {
    // Yes, this is the opposite of the "diffuser" module.  It's on purpose.
    outer_r = radius;
    inner_r = radius - wall;
    // The absolute minimum "height" (center of sphere radius) for inner and outer parts
    outer_height = max(0, height - outer_r);
    inner_height = outer_height;

    difference() {
        // outer cone
        hull() {
            translate([0,0,outer_height]) difference() {
                sphere(r=outer_r);
                translate([0,0,-outer_r]) cylinder(r=outer_r*2, h=outer_r);
            }
            cylinder(r=outer_r, h=$o);
        }
        // inner cone
        hull() {
            translate([0,0,inner_height]) union() {
                sphere(r=inner_r, $fn=8);
                hull() {
                    cylinder(r=inner_r, h=$o);
                    translate([0,0,sin(45/2)*inner_r]) cylinder(r=inner_r * cos(45/2), h=$o, $fn=8);
                }
            }
            cylinder(r=inner_r, h=$o);
        }
        // Chop off the bottom
        translate([0,0,-outer_r]) cylinder(r=inner_r, h=inner_height);
        // Cutout for testing purposes (openscad wireframe is too slow these days)
        // translate([-50,-50,-1]) cube([100,100,100], center=true);
    }
}


module diffuser(radius, sleeve_height, diffuser_type, diffuser_height) {
    // Larger diameters seem to need more structure
    wall = (radius < 20) ? 1 : 2;
    // Calculate the inner and outer radius values
    inner_r = radius;
    outer_r = radius + wall;

    // Radius of the friction-fit bumps
    bump_r = .5;
    // Radius of the "circle" used for the sleeve stop ledge
    stop_r = sqrt(2)*1.5; // square rotated 45 degrees,

    union() {
        // Cone
        if (diffuser_type == "Dome")
            translate([0,0,sleeve_height-$o]) dome_diffuser(outer_r, wall, diffuser_height);
        // Sleeve
        difference() {
            cylinder(r=outer_r, h=sleeve_height+$o);
            translate([0,0,-$o]) cylinder(r=inner_r, h=sleeve_height*2);
        }
        // "fit" enhancements
        intersection() {
            // Copy of the cylinder above to prevent clipping outside of the main shape.
            cylinder(r=outer_r, h=sleeve_height+$o);
            union() {
                // Friction-fit bumps
                translate([-inner_r,0,bump_r])
                    for(a = [0 : 45 : 360])
                    on_arc(inner_r, a) {
                        hull() {
                            translate([-bump_r,0,0]) sphere(r=bump_r);
                            translate([0,0,sleeve_height-bump_r*2]) sphere(r=bump_r);
                        }
                    }
                // A stop, so you don't press it on too far
                translate([0,0,sleeve_height - .8]) rotate_extrude()
                    translate([inner_r, -sqrt(2)*stop_r/2]) hull() {
                        rotate(45) square(stop_r);
                        translate([0,.8]) rotate(45) square(stop_r);
                    }
            }
        }
    }
}

