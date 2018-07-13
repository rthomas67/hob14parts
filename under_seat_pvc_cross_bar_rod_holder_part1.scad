include <insertion_receiver.scad>
include <pvc_connectors.scad>
include <under_seat_pvc_cross_bar_rod_holder_common.scad>
include <connector_spline.scad>

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

// Note: Difference between the insert angle and the front receiver
// angle is about 8 degrees down
// i.e. If the receiver is horizontal, the insert angles down a bit
rearPvcInsertOffset=10;
connectorSplineAngle=-8;
connectorSplineXOffset=0;
connectorSplineYOffset=10;
connectorSplineXPositionAdjust=2;
connectorSplineYPositionAdjust=-15;

leftSide=true;

// This angle allows the body to be oriented such that it more or less aligns with
// an imaginary line from front to back between the seat posts.  The "short-side"
// seat post insert on the front seat post is not directly aligned, and is
// a little different on the left and right side of the seat.
// This could also be described as "yaw" adjustment.
frontInsertionReceiverVerticalAngle=(leftSide) ? -2.5 : -2;

// This angle rotates the key around so the PVC cross bar is level
// under the chair.
// This could also be described as "roll" adjustment.
frontInsertionReceiverKeyAngleOffsetAdjust=(leftSide) ? -1.5 : 1;

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

overlap=0.001;
$fn=50;

union() {
    translate([0,0,-bracketWidth/2]) 
        pvcPassThruBody();
    translate([-pvc125FittingOuterDia/2-bracketCasingThickness/4,hobieChairLegInsertOffset,0])
        // Note: receiverVerticalAngle is applied to the opening so the exterior can remain flat for printing
        rotate([0,-90,0])
            insertionReceiver(frontInsertionReceiverVerticalAngle,
                    frontInsertionReceiverKeyAngleOffsetAdjust,
                    frontInsertionReceiverCasingThickness, (leftSide) ? "L" : "R");
    translate([pvc125FittingOuterDia/2+bracketCasingThickness+connectorSplineXPositionAdjust,connectorSplineYPositionAdjust,0])
        rotate([connectorSplineAngle,90,0])
            connectorSpline(connectorSplineRidgeCount,connectorSplineLength,
                connectorSplineDia,connectorSplineRidgeDepth,connectorSplineTaperFactor);

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
                translate([pvc125FittingOuterDia/2+bracketCasingThickness+connectorSplineXOffset,
                        -pvc125FittingOuterDia/2-connectorSplineYOffset,0])
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
        stampXOffset=-5;
        translate([stampXOffset,pvc125FittingOuterDia/2-fontHeight-stampYInset,
            bracketWidth-stampDepth]) {
            linear_extrude(height=stampDepth*4) {
                if (leftSide) {
                    text("L",font="lintsec",size=fontHeight);
                } else {
                    text("R",font="lintsec",size=fontHeight);
                }
            }
        }
    }
}
