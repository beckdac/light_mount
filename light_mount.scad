// all measurements in mm

// global rendering parameters
$fn = 64;

// parametic figures
// the thickness of the mounting plate polyhedron at the top
thickness_angle = 1.1 * 25.4;
// thicknes at bottom
thickness = 2;
// width of the plate
width = 110;
// height of the plate
height = 140;
// diameter of the main wire hole
hole_diameter = 40;
// plate to box screw ring diameter
box_screw_ring_d = 60;
// plate to box screw diameter
box_screw_d = 4;
// light to plate screw ring diameter
light_screw_ring_d = 80;
// light to plate screw diameter
light_screw_d = 4;
// offset from halfway point for rings
ring_offset = 5;

// the bounding polyhedron for the plate body
mount_points = [
  [  0,  0,  0 ],  //0
  [ width,  0,  0 ],  //1
  [ width,  height,  0 ],  //2
  [  0,  height,  0 ],  //3
  [  0,  0,  thickness ],  //4
  [ width,  0,  thickness ],  //5
  [ width,  height,  thickness_angle ],  //6
  [  0,  height,  thickness_angle ]]; //7
// orientation of the polyhedron points
mount_faces = [
  [0,1,2,3],  // bottom
  [4,5,1,0],  // front
  [7,6,5,4],  // top
  [5,6,2,1],  // right
  [6,7,3,2],  // back
  [7,4,0,3]]; // left
  
module main() {
    difference() {
        plate_body();
        slotted_screw_ring(box_screw_ring_d, box_screw_d, ring_offset, 0);
        slotted_screw_ring(light_screw_ring_d, light_screw_d, ring_offset, 45);
    }
}

module slotted_screw_ring(screw_ring_d, screw_d, ring_offset, slot_angle) {
    // box screw ring
	translate([0, 0, -0.01])
    difference () {
        translate([width / 2, height / 2, 0]) {
            difference() {
                cylinder(h=2 * thickness + thickness_angle, d=screw_ring_d + screw_d + 2);
                cylinder(h=2 * thickness + thickness_angle, d=screw_ring_d - screw_d / 2);    
            }
        }
        difference() {
            plate_body();
            translate([width / 2, height / 2, 0]) {
                rotate([0, 0, slot_angle]) {
                    translate([ring_offset, + ring_offset, 0]) 
                        cube([screw_ring_d, screw_ring_d, thickness_angle], center=false);
                    translate([- ring_offset - screw_ring_d, + ring_offset, 0]) 
                        cube([screw_ring_d, screw_ring_d, thickness_angle], center=false);
                    translate([ring_offset, - ring_offset - screw_ring_d, 0]) 
                        cube([screw_ring_d, screw_ring_d, thickness_angle], center=false);
                    translate([- ring_offset - screw_ring_d, - screw_ring_d - ring_offset, 0]) 
                        cube([screw_ring_d, screw_ring_d, thickness_angle], center=false);
                }
            }
        }
	}
 }

// the main polyhedron of the mounting plate with the wire hole cutout
module plate_body() {
    difference() {
         // the plate body
        polyhedron( mount_points, mount_faces, center=true);
        // the main wire hole
        translate([width / 2, height / 2, -.01])
            cylinder(h=2 * thickness + thickness_angle, d=hole_diameter);
    }
}

// render the mount
main();
