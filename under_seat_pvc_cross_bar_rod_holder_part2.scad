include <insertion_receiver.scad>
include <pvc_connectors.scad>
include <under_seat_pvc_cross_bar_rod_holder_common.scad>
include <connector_spline.scad>

bracketWidth=40;
bracketCasingThickness=20;

setScrewHoleDia=3;

bodyExtensionRoundoffDia=9;
bodyEdgeRoundOffDia=3;

leftSide=false;

// These align the key and the angle of the cutout hole on the receiver
// for the rear chair-leg insert post
rearInsertionReceiverVerticalAngle=(leftSide) ? 0 : 0;

rearInsertionReceiverKeyAngleOffsetAdjust=(leftSide) ? 2 : 0;

rearInsertionReceiverCasingThickness=10;

connectorPostMiddleDia=38;
connectorPostMiddleLength=(leftSide) ? 25 : 23;

connectorPostTopRotationX=(leftSide) ? -20 : -17.5;
connectorPostTopRotationY=(leftSide) ? 20 : -19;
connectorPostTopLength=(leftSide) ? 20 : 20;

connectorPostBottomRotationX=(leftSide) ? -20 : -18.5;
connectorPostBottomRotationY=(leftSide) ? -20 : 19;
connectorPostBottomLength=(leftSide) ? 20 : 22;

splineCutoutSizeFactor=1.075;

overlap=0.001;
$fn=50;

// TODO: Find a simple way to create a spline (linear extrude a cartoon sun shape or use a low $fn cylinder)
// TODO: Cut out a (negative) spline into which the other part will glue

union() {
    // TODO: re-position & re-orient to mate up with the
    // solid end of the receiver (on x/y plane).
    // TODO: OR... still do the connectorPostTransform to set the position, 
    // and then flip/reorient the whole thing.  
    // TODO: OR... build the connector post upside down (from the top at x/y plane center) instead
  //      translate([0,0,60])
  //          rotate([180,0,0]) 
    difference() {
        connectorPost(connectorPostMiddleLength,connectorPostMiddleDia,
                connectorPostTopRotationX,connectorPostTopRotationY,
                connectorPostTopLength,connectorPostBottomRotationX,
                connectorPostBottomRotationY,
                connectorPostBottomLength);
            translate([0,0,-overlap])
            connectorSplineCutout(connectorSplineRidgeCount,connectorSplineLength,
                connectorSplineDia*splineCutoutSizeFactor,
                    connectorSplineRidgeDepth,connectorSplineTaperFactor);
        }
        connectorPostTransform(connectorPostMiddleLength,connectorPostMiddleDia,
                connectorPostTopRotationX,connectorPostTopRotationY,connectorPostTopLength,
                connectorPostBottomRotationX,connectorPostBottomRotationY,
                connectorPostBottomLength) {
//    rotate([180,0,0])
            insertionReceiver(rearInsertionReceiverVerticalAngle,
                rearInsertionReceiverKeyAngleOffsetAdjust,
                rearInsertionReceiverCasingThickness, (leftSide) ? "L" : "R");
        }
}

/*
 * apply this to a part that is centered on the x/y plane before
 * moving it to the spot where the connector post starts to put
 * it at the other end of the connector post.
 */
module connectorPostTransform(postLength, postDia, 
        topRotationX,topRotationY, topLength, 
        bottomRotationX, bottomRotationY,bottomLength) {
    // 3 stages of move then rotate into displaced position
    translate([0,0,bottomLength]) rotate([bottomRotationX,bottomRotationY,0]) 
        translate([0,0,postLength])
            rotate([topRotationX,topRotationY,0]) translate([0,0,topLength])
                children();
}
/*
 * Creates a post with an angled section at the top and bottom to create a flat interface
 * on each end.  Used to connect two other parts at odd angles
 * 
 * Bottom flat-interface will be aligned with the x/y plane.
 */
module connectorPost(postLength, postDia, 
        topRotationX,topRotationY, topLength, 
        bottomRotationX,bottomRotationY,bottomLength) {
    hull() {
  //      union() {  // uncomment for diagnostics... instead of hull
            // base (middle) part -- cut a cylinder off on the top at the rotation angles
            translate([0,0,bottomLength]) rotate([bottomRotationX,bottomRotationY,0]) {
            difference() {
                translate([0,0,-postDia])
                    cylinder(d=postDia, h=postLength+postDia*2);
                // cut off top
                translate([0,0,postLength])
                    rotate([topRotationX/2,topRotationY/2,0])
                        cylinder(d=postDia*2, h=postDia*2);
                // cut off bottom
                rotate([-bottomRotationX/2,-bottomRotationY/2,0])
                    translate([0,0,-postDia*2])
                    cylinder(d=postDia*2, h=postDia*2);
            }
            // top-part -- cut a cylinder off on the bottom at the topRotation angles
            translate([0,0,postLength])
                rotate([topRotationX/2,topRotationY/2,0])
                    difference() {
                        // Note: This one rotates after moving it to cut at the bottom.
                        rotate([topRotationX/2,topRotationY/2,0])
                            translate([0,0,-topLength*0.5])
                                cylinder(d=postDia, h=topLength*1.5);
                        translate([0,0,-topLength])
                            cylinder(d=postDia*2, h=topLength);
                    }
            }
            // bottom-part -- cut a cylinder off on the top at the bottomRotation angles
            difference() {
                        cylinder(d=postDia, h=bottomLength*1.5);
                        translate([0,0,bottomLength])
                            rotate([bottomRotationX/2,bottomRotationY/2,0])
                                cylinder(d=postDia*2, h=bottomLength);
                }
        
    }
}
