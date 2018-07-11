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

union() {
    translate([0,0,-bracketWidth/2]) 
        pvcPassThruBody();
    translate([-pvc125FittingOuterDia/2-bracketCasingThickness/4,hobieChairLegInsertOffset,0])
        // Note: receiverVerticalAngle is applied to the opening so the exterior can remain flat for printing
        rotate([0,-90,0])
            insertionReceiver(frontInsertionReceiverVerticalAngle,
                    frontInsertionReceiverVerticalAngleOffsetAdjust,
                    frontInsertionReceiverKeyAngleOffsetAdjust);
}

module pvcPassThruBody() {
    minkowskiAdjustedBracketWidth=bracketWidth-bodyEdgeRoundOffDia;
    extraForPvcInsertBaseRotation=2;
    difference() {
        minkowski() {
            translate([0,0,bodyEdgeRoundOffDia/2])
            hull() {
                cylinder(d=pvc125FittingOuterDia+2*bracketCasingThickness-bodyEdgeRoundOffDia, 
                        h=minkowskiAdjustedBracketWidth);
                // Upper extension to make a base for the hobie chair receiver
                translate([-pvc125FittingOuterDia/2-bracketCasingThickness-frontInsertionReceiverExtensionXOffset,
                        pvc125FittingOuterDia/2+frontInsertionReceiverExtensionYOffset,0])
                    cylinder(d=bodyExtensionRoundoffDia, h=minkowskiAdjustedBracketWidth);
                // Lower extension to make a base for the hobie chair receiver
                translate([-pvc125FittingOuterDia/2-bracketCasingThickness-frontInsertionReceiverLowerExtensionXOffset,
                        -pvc125FittingOuterDia/2-frontInsertionReceiverLowerExtensionYOffset,0])
                    cylinder(d=bodyExtensionRoundoffDia, h=minkowskiAdjustedBracketWidth);
                // Extension to make a base for the pvc insert post
                translate([pvc125FittingOuterDia/2+bracketCasingThickness+rearPvcInsertPostExtensionXOffset,
                        -pvc125FittingOuterDia/2-rearPvcInsertPostExtensionYOffset,0])
                    rotate([0,insertVerticalAngle,0])
                        cylinder(d=bodyExtensionRoundoffDia, h=minkowskiAdjustedBracketWidth);
            }
            sphere(d=bodyEdgeRoundOffDia);
        }
        // hole for pvc fitting
        translate([0,0,-overlap-extraForPvcInsertBaseRotation/2])
            cylinder(d=pvc125FittingOuterDia+pvcFittingTolerance*2, 
            h=bracketWidth+overlap*2+extraForPvcInsertBaseRotation);
        
        setScrewCutLength=pvc125FittingOuterDia/2+bracketCasingThickness;
        setScrewCenterZPos=bracketWidth/2;
        // bottom set screw hole
        translate([0,0,setScrewCenterZPos])
            rotate([90,0,0])
                cylinder(d=setScrewHoleDia, h=setScrewCutLength);
        // top set screw hole
        translate([0,0,setScrewCenterZPos])
            rotate([-90,0,0])
                cylinder(d=setScrewHoleDia, h=setScrewCutLength);
        // Left or Right Stamp
        stampDepth=0.2;
        fontHeight=8;
        stampYInset=-12;
        stampXOffset=(leftSide) ? -12 : -16;
        translate([stampXOffset,pvc125FittingOuterDia/2-fontHeight-stampYInset,
            bracketWidth-stampDepth]) {
            linear_extrude(height=stampDepth*4) {
                if (leftSide) {
                    text("LEFT",font="lintsec",size=fontHeight);
                } else {
                    text("RIGHT",font="lintsec",size=fontHeight);
                }
            }
        }
    }
}
