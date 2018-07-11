include <insertion_receiver.scad>
include <pvc_connectors.scad>

bracketWidth=40;
bracketCasingThickness=20;

setScrewHoleDia=3;

bodyExtensionRoundoffDia=9;
bodyEdgeRoundOffDia=3;

frontInsertionReceiverExtensionXOffset=-5;
frontInsertionReceiverExtensionYOffset=-3;

frontInsertionReceiverLowerExtensionXOffset=-5;
frontInsertionReceiverLowerExtensionYOffset=-3;

frontInsertionReceiverCasingThickness=10;

hobieChairLegInsertDia=24.3;
hobieChairLegInsertDepth=40;
hobieChairLegInsertOffset=0;

// height of "blade" that fits into the alignment key slot on one side
hobieChairLegKeyRidgeHeight=3.25;
hobieChairLegKeyRidgeHeightCurvatureOverlap=0.5;
hobieChairLegKeyRidgeWidth=4;
hobieChairLegKeyRidgeTolerance=0.5;

// Note: Difference between the insert angle and the front receiver
// angle is about 8 degrees down
// i.e. If the receiver is horizontal, the insert angles down a bit
rearPvcInsertLength=40;
rearPvcInsertOffset=10;
rearPvcInsertAngle=0;  // was -8 before adding "z post" - TODO: Remove this
rearPvcInsertPostExtensionXOffset=-0;  // was -10
rearPvcInsertPostExtensionYOffset=0;   // was 10

leftSide=false;

// This angle allows the body to be oriented such that it more or less aligns with
// an imaginary line from front to back between the seat posts.  The "short-side"
// seat post insert on the front seat post is not directly aligned, and is
// a little different on the left and right side of the seat.
frontInsertionReceiverVerticalAngle=(leftSide) ? -2 : -2;
// This re-centers the cutout.
frontInsertionReceiverVerticalAngleOffsetAdjust=(leftSide) ? 2.5 : 1;

frontInsertionReceiverKeyAngleOffsetAdjust=(leftSide) ? 1.5 : 1;

// These align the key and the angle of the cutout hole on the receiver
// for the rear chair-leg insert post
rearInsertionReceiverVerticalAngle=(leftSide) ? 0 : 0;
// This re-centers the cutout.
rearInsertionReceiverVerticalAngleOffsetAdjust=(leftSide) ? 0 : 0;

rearInsertionReceiverKeyAngleOffsetAdjust=(leftSide) ? 2 : 0;

// Note: This angle "helps" the ultimate position/orientation of the center body
// but must be combined with some tilt in the 45 degree PVC elbow.  This
// is also affected by the receiverVerticalAngle.
insertVerticalAngle=(leftSide) ? -0 : 0;  // was -4 and 4

connectorPostDia=38;

connectorPostLength=(leftSide) ? 30 : 30;

connectorPostTopRotationX=(leftSide) ? -20 : -20;
connectorPostTopRotationY=(leftSide) ? 20 : 20;
connectorPostTopLength=(leftSide) ? 20 : 20;

connectorPostBottomRotationX=(leftSide) ? -20 : -15;
connectorPostBottomRotationY=(leftSide) ? -20 : -15;
connectorPostBottomLength=(leftSide) ? 20 : 20;

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
        translate([0,0,60])
            rotate([180,0,0]) 
                connectorPost(connectorPostLength,connectorPostDia,
                        connectorPostTopRotationX,connectorPostTopRotationY,
                        connectorPostTopLength,connectorPostBottomRotationX,connectorPostBottomRotationY,
                        connectorPostBottomLength);
//                connectorPostTransform(connectorPostLength,connectorPostDia,
//                        connectorPostTopRotationX,connectorPostTopRotationY,connectorPostTopLength,
//                        connectorPostBottomRotationX,connectorPostBottomRotationY,
//                        connectorPostBottomLength) {
    rotate([180,0,0])
                    insertionReceiver(rearInsertionReceiverVerticalAngle,
                        rearInsertionReceiverVerticalAngleOffsetAdjust,
                        rearInsertionReceiverKeyAngleOffsetAdjust);
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
    translate([0,0,bottomLength]) rotate([bottomRotationX,bottomRotationX,0]) 
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
