include <front_plug_common.scad>
include <battery_box_plug_common.scad>

receptacleBracketLength=80;
mountingPlateThickness=20;

wireThruHoleToCircuitBreakerLength=40;
wireThruHoleToCircuitBreakerInset=5;
wireThruHoleToCircuitBreakerCenterOffset=15;

interiorTolerance=2;

$fn=50;
overlap=0.001;

union() {
    difference() {
            hull() {
                // right edges when viewed from x:z towards +y
                // top (extended by receptacleBracketCornerDia/2 for now to match the other part)
                translate([+receptacleSideWidth/2-receptacleBracketCornerDia/2,
                        receptacleSideWidth/2,0])
                    cylinderSphereEdge(receptacleBracketLength,receptacleBracketCornerDia);
                // bottom
                translate([+receptacleSideWidth/2-receptacleBracketCornerDia/2,
                        -receptacleSideWidth/2+receptacleBracketCornerDia/2,0])
                    cylinderSphereEdge(receptacleBracketLength,receptacleBracketCornerDia);
                
                // left edges when viewed from x:z towards +y
                // top (extended by receptacleBracketCornerDia/2 for now to match the other part)
                translate([-receptacleSideWidth/2+receptacleBracketCornerDia/2,
                        receptacleSideWidth/2,0])
                    cylinderSphereEdge(receptacleBracketLength,receptacleBracketCornerDia);
                // bottom
                translate([-receptacleSideWidth/2+receptacleBracketCornerDia/2,
                        -receptacleSideWidth/2+receptacleBracketCornerDia/2,0])
                    cylinderSphereEdge(receptacleBracketLength,receptacleBracketCornerDia);
            }
        // Larger cutout to accommodate mounting ring    
        translate([0,0,mountingPlateThickness])
            cylinder(d=receptacleMountingRingInsetDia+interiorTolerance*2,
                h=receptacleBracketLength-mountingPlateThickness+overlap*2);
        // smaller cutout for threaded part of receptacle
        translate([0,0,-overlap])
            cylinder(d=receptacleInnerDia+interiorTolerance*2, h=receptacleBracketLength+overlap*2);
            
        // mountScrewHoles in bottom    
        translate([-receptacleSideWidth*3/10,-receptacleSideWidth/2-overlap,receptacleBracketLength/5])
            rotate([-90,0,0])
                cylinder(d=mountScrewHoleDia, h=mountScrewHoleDepth+overlap);
        translate([-receptacleSideWidth*3/10,-receptacleSideWidth/2-overlap,receptacleBracketLength*4/5])
            rotate([-90,0,0])
                cylinder(d=mountScrewHoleDia, h=mountScrewHoleDepth+overlap);
        translate([receptacleSideWidth*3/10,-receptacleSideWidth/2-overlap,receptacleBracketLength/5])
            rotate([-90,0,0])
                cylinder(d=mountScrewHoleDia, h=mountScrewHoleDepth+overlap);
        translate([receptacleSideWidth*3/10,-receptacleSideWidth/2-overlap,receptacleBracketLength*4/5])
            rotate([-90,0,0])
                cylinder(d=mountScrewHoleDia, h=mountScrewHoleDepth+overlap);

        // receptacle plate screw holes in front
        translate([receptacleFaceplateScrewCenterWidth/2,0,overlap])
            cylinder(d=receptacleFaceplateScrewHoleDia, 
                h=receptacleFaceplateScrewDepth+overlap);
        translate([-receptacleFaceplateScrewCenterWidth/2,0,overlap])
            cylinder(d=receptacleFaceplateScrewHoleDia, 
                h=receptacleFaceplateScrewDepth+overlap);
    }
    
}

// sphere against x:y origin (position adjusted from default sphere position)
module cylinderSphereEdge(length, cornerDia) {
    hull() {
        translate([0,0,cornerDia/2])
            sphere(d=receptacleBracketCornerDia);
        // back side
        translate([0,0,length-1])
            cylinder(d=receptacleBracketCornerDia,h=1);
    }
}

// Trial Print 1 Notes
// DONE: Add mounting holes for screws to go into the bottom face
// FIXED: Face is shorter than the other part by about 3mm
// FIXED: receptacleMountingRingInsetDia is about 2mm too small (maybe forgot to add a tolerance var??)
// FIXED: receptacleInnerDia is about 2mm too small (tolerance again??)
// FIXED: Front Face prints against bed.  Corners are sloppy/shrunken.  Maybe curve them.
// FIXED: Missing screw holes for mounting plate face
// Assembly: Unless the wires can be pushed through the other part as the parts are
//      moved together, assembly will be difficult/impossible because there isn't
//      room for excess wire.
