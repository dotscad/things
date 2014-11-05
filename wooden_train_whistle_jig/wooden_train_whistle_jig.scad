/**
 * wooden_train_whistle_jig.scad
 *
 * Jig based on [Steve Ramsey's wooden train whistle](http://www.woodworkingformeremortals.com/2012/12/make-wood-train-whistle.html).
 *
 * This is intended to help produce consistent drill holes and cut lines, and speed up
 * the process of making a train whistle by reducing the number of tedious measurements,
 * leaving you more time to enjoy actually working with the wood.  It includes:
 *
 *  * Guide holes for drilling.
 *  * Guide holes for marking your preferred drilling points (if you don't want to use
 *    the larger guide holes).
 *  * Measured cut-outs for marking band-saw "window" cuts
 *  * Measured cut-out for marking the cut point for the mouthpiece (which you should
 *    mark and cut off before marking any other cuts).
 *
 * This OpenSCAD library is part of the [dotscad](https://github.com/dotscad/dotscad)
 * project, an open collection of modules and Things for 3d printing.  Please check there
 * for the latest versions of this and other related files.
 *
 * @copyright  Chris Petersen, 2014
 * @license    http://creativecommons.org/licenses/LGPL/2.1/
 * @license    http://creativecommons.org/licenses/by-sa/3.0/
 *
 * @see        http://www.thingiverse.com/thing:?????
 * @source     https://github.com/dotscad/things/blob/master/wooden_train_whistle_jig/wooden_train_whistle_jig.scad
 */

use <../../dotscad/pie.scad>;
use <../dotscad/pie.scad>;
use <dotscad/pie.scad>;
use <pie.scad>;

//
// Customizer parameters and rendering
//

/* [Global] */

// mm diameter of the whistle tube hole.  Larger measurements are useful if you intend to strengthen the hole with metal tubing.
bore = 9.525; // [19.05:3/4", 12.7:1/2", 9.525:3/8"]
bore2 = 12.7; // [19.05:3/4", 12.7:1/2", 9.525:3/8"]
bore3 = 19.05; // [19.05:3/4", 12.7:1/2", 9.525:3/8"]

// mm thickness of the base (longer means a better guide hole).
base=20;

// mm thickness of the wall that will hold the wood in place on the jig.
wall=2.5;

// mm width of the wood (1.5" is 38.1mm but measurements suggest leaving some extra room)
w = 40;

/* [Hidden] */

h = 75;  // height of the entire jig -- taller means more control

point_max = 12.7/2; // Radius of the large end of the center point guide hole.
point_min = 1;      // Radius of the small end of the center point guide hole.

mouthpiece_cut = 25.4; // 1" - thickness of the mouthpiece to cut off

cap_width = 15.875; // 5/8"

module jig($fn=75) {
    o=.1;
    bore_fuzz = .25;  // a little extra radius to account for shrinkage
    cutout_fuzz = .5; // offset for PLA shrinkage and pencil width
    rbore1 = bore/2 + bore_fuzz; // radius for bore size 1
    rbore2 = bore2/2 + bore_fuzz; // radius for bore size 2
    rbore3 = bore3/2 + bore_fuzz; // radius for bore size 3
    offset1 = (w - 4*rbore1) / 3; // wall offset for bore size 1
    offset2 = (w - 4*rbore2) / 3; // wall offset for bore size 2
    offset3 = (w - 4*rbore3) / 3; // wall offset for bore size 3
    difference() {
        translate([-wall-w/2,-wall-w/2,-base])
            difference() {
                cube([w+wall*2,w+wall*2,h]);
                translate([wall,wall,base]) cube([w,w,h+o]);
                // Guides for marking drill points
                translate([wall + w*.5,wall + w*.5,-o]) cylinder(r1=point_max, r2=point_min, h=base+o*2);
                // Need to pick which offset we want here...  No need for bore3 since that's not a drill point
                //translate([wall + offset1 + rbore1,wall + offset1 + rbore1,-o]) cylinder(r1=point_max, r2=point_min, h=base+o*2);
                translate([wall + offset2 + rbore2,wall + offset2 + rbore2,-o]) cylinder(r1=point_max, r2=point_min, h=base+o*2);
                // Actual drill guides
                translate([wall + offset1*2 + rbore1*3,wall + offset1 + rbore1,-o]) cylinder(r=rbore1, h=base+o*2);
                translate([wall + offset2 + rbore2,wall + offset2*2 + rbore2*3,-o]) cylinder(r=rbore2, h=base+o*2);
                translate([wall + offset3*2 + rbore3*3,wall + offset3*2 + rbore3*3,-o]) cylinder(r=rbore3, h=base+o*2);
            }
        // whistle "window" hole cuts
        rotate([0,0,135]) translate([0,-w*sqrt(2)/4+cutout_fuzz,cap_width]) window_cutout();
        rotate([0,0,-45]) translate([0,-w*sqrt(2)/4+cutout_fuzz,cap_width]) window_cutout();
        // mouthpiece depth cut -- can just reuse the window cutout here.
        rotate([0,0,45]) translate([0,-w*sqrt(2)/3,mouthpiece_cut]) window_cutout();
        // Bevel the bottom edge
        translate([0,w/2+wall,-base]) rotate([45,0,0]) cube([2*w,wall,wall], center=true);
        translate([0,-w/2-wall,-base]) rotate([45,0,0]) cube([2*w,wall,wall], center=true);
        translate([w/2+wall,0,-base]) rotate([45,0,90]) cube([2*w,wall,wall], center=true);
        translate([-w/2-wall,0,-base]) rotate([45,0,90]) cube([2*w,wall,wall], center=true);
    }
}

module window_cutout($fn=6) {
    angle = atan(.75 / (3/8 * sqrt(2))); // ~ 54.74 degrees
	translate([w,0,0]) rotate([0,-90,0]) pie(w, angle, w*2, -90);
}

jig();
