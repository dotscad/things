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

//
// Customizer parameters and rendering
//

/* [Global] */

// mm diameter of the whistle tube hole.  Larger measurements are useful if you intend to strengthen the hole with metal tubing.
bore = 12.7; // [19.05:3/4", 12.7:1/2", 9.525:3/8"]

// mm thickness of the base (longer means a better guide hole).
base=20;

// mm thickness of the wall that will hold the wood in place on the jig.
wall=3;

// mm width of the wood (1.5" is 38.1mm but measurements suggest leaving some extra room)
w = 40;

/* [Hidden] */

h = 65;  // height of the entire jig

point_max = 12.7/2; // Radius of the large end of the center point guide hole.
point_min = .75;    // Radius of the small end of the center point guide hole.

mouthpiece_cut = 25.4; // 1" - thickness of the mouthpiece to cut off

module jig($fn=50) {
    o=.1;
    difference() {
        translate([-wall-w/2,-wall-w/2,-base])
        difference() {
            cube([w+wall*2,w+wall*2,h]);
            translate([wall,wall,base]) cube([w,w,h+o]);
            // Guides for marking drill points
            translate([wall + w*.25,wall + w*.25,-o]) cylinder(r1=point_max, r2=point_min, h=base+o*2);
            translate([wall + w*.75,wall + w*.75,-o]) cylinder(r1=point_max, r2=point_min, h=base+o*2);
            translate([wall + w*.5,wall + w*.5,-o]) cylinder(r1=point_max, r2=point_min, h=base+o*2);
            // Actual drill guides (need to find metal tubing for this...)
            // steve actually puts these 3/8" in rather than centered...
            translate([wall + w*.75,wall + w*.25,-o]) cylinder(r=bore/2, h=base+o*2);
            translate([wall + w*.25,wall + w*.75,-o]) cylinder(r=bore/2, h=base+o*2);
        }

        // mouthpiece depth cut
        rotate([0,0,45]) translate([0,-w*sqrt(2)/3,mouthpiece_cut]) cutout();
        // whistle hole cuts
        rotate([0,0,135]) translate([0,-w*sqrt(2)/4,0]) cutout();
        rotate([0,0,-45]) translate([0,-w*sqrt(2)/4,0]) cutout();
    }
}

module cutout() {
    // cutouts
	width = w;
	len    = width*2;
	translate([0,-width/sqrt(2),0])
		difference() {
			rotate([45,0,0]) cube([len,width,width], center=true);
			translate([0,0,-width]) cube([len * 2,width * 2, width * 2], center=true);
		}
}

jig();
