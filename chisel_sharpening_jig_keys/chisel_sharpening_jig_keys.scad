/**
 * A parametric module for creating stop blocks/keys for the Robert Larson
 * chisel and plane iron sharpening jig:
 *
 * http://smile.amazon.com/Robert-Larson-800-1800-Honing-Guide/dp/B000CFNCKS/ref=sr_1_1
 *
 * This OpenSCAD library is part of the [dotscad](https://github.com/dotscad/dotscad)
 * project, an open collection of modules and Things for 3d printing.  Please
 * check there for the latest versions of this and other related files.
 *
 * @copyright  Chris Petersen, 2016
 * @license    http://creativecommons.org/licenses/LGPL/2.1/
 * @license    http://creativecommons.org/licenses/by-sa/3.0/
 *
 * @see        http://www.thingiverse.com/thing:xxxx
 * @source     https://github.com/dotscad/things/blob/master/chisel_sharpening_jig_keys/chisel_sharpening_jig_keys.scad
 */

// A global overlap variable (to prevent printing glitches)
$o = .1;

// 

type = "Chisel"; // ["Chisel", "Plane"]
angle = 30; // [30, 25]

// chisel: 30° = 30mm, 25° = 40mm
// plane: 30° = 38mm, 25° = 50mm
size = (type == "Chisel") ? (angle == 30 ? 30 : 40) : (angle == 30 ? 38 : 50);

h = 52; // 2 inches
wall=3; // because it seems to work
text_depth = .3  * 2; // set to a ratio of your extruder width

rotate([0,-90,0])
difference() {
    union() {
        cube([h, size + .1, wall]);
        translate([0,size, 0])
            cube([h, wall, 5+wall]);
        translate([0,0,-15+$o])
            cube([h, wall, 15+$o]);
        *translate([0,0, 0])
            cube([wall, size, 10]);
    }
    
    translate([1.5,5,wall-text_depth])
        rotate([0,0,0])
        linear_extrude(height = 2)
        text(str(angle, "°", type), size=8.5, valign="bottom", font="Liberation Sans", $fn=50);
    translate([9,18,wall-text_depth])
        rotate([0,0,0])
        linear_extrude(height = 2)
        text(str(size, "mm"), size=8.5, valign="bottom", font="Liberation Sans", $fn=50);
}
