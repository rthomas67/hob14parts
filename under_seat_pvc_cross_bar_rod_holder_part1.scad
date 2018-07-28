include <insertion_receiver.scad>
include <pvc_connectors.scad>
include <under_seat_pvc_cross_bar_rod_holder_common.scad>
include <connector_spline.scad>

leftSide=false;

showReferences=false;


bracketWidth=40;
bracketCasingThickness=20;

setScrewHoleDia=3;

bodyExtensionRoundoffDia=9;
bodyEdgeRoundOffDia=3;

frontInsertionReceiverCasingThickness=10;

// Note: Difference between the insert angle and the front receiver
// angle is about 8 degrees down
// i.e. If the receiver is horizontal, the insert angles down a bit
rearPvcInsertOffset=10;
connectorSplineAngle=-8;
connectorSplineXOffset=-2;
connectorSplineYOffset=5;

connectorSplineXPositionAdjust=2;
connectorSplineYPositionAdjust=-15;

// This angle allows the body to be oriented such that it more or less aligns with
// an imaginary line from front to back between the seat posts.  The "short-side"
// seat post insert on the front seat post is not directly aligned, and is
// a little different on the left and right side of the seat.
// This could also be described as "yaw" adjustment.
frontInsertionReceiverVerticalAngle=(leftSide) ? 1 : -2.5;

// This angle rotates the key around so the PVC cross bar is level
// under the chair.
// This could also be described as "roll" adjustment.
frontInsertionReceiverKeyAngleOffsetAdjust=(leftSide) ? 1 : -1.5;

// The main body hangs down close to the floor if the receiver is
// lollypop-stick normal to the main body.  This controls the up/down
// tilt of the centerline of the receiver relative to the center of
// the main body.
frontInsertionReceiverInclineAngle=5;

frontInsertionExtensionBasePositionYOffset=-1;
frontInsertionExtensionBaseSizeReduction=5;

overlap=0.001;
$fn=50;


if (showReferences && leftSide) color([0.5,0,0], t=0.5) 
    import("draft_renders/under_seat_pvc_cross_bar_rod_holder_part1_left_draft5.stl");
if (showReferences && !leftSide) color([0.5,0,0], t=0.5) 
    import("draft_renders/under_seat_pvc_cross_bar_rod_holder_part1_draft1.stl");

union() {
    translate([0,0,-bracketWidth/2]) 
        pvcPassThruBody();
    // receiver
    translate([-pvc125FittingOuterDia/2-bracketCasingThickness/4,hobieChairLegInsertOffset,0])
        // Note: receiverVerticalAngle is applied to the opening so the exterior can remain flat for printing
        rotate([0,-90,frontInsertionReceiverInclineAngle])
            insertionReceiver(frontInsertionReceiverVerticalAngle,
                    frontInsertionReceiverKeyAngleOffsetAdjust,
                    frontInsertionReceiverCasingThickness, (leftSide) ? "L" : "R");
    translate([pvc125FittingOuterDia/2+bracketCasingThickness+connectorSplineXPositionAdjust,
            connectorSplineYPositionAdjust,0])
        rotate([connectorSplineAngle,90,0])
            connectorSpline(connectorSplineRidgeCount,connectorSplineLength,
                connectorSplineDia,connectorSplineRidgeDepth,connectorSplineTaperFactor);

}

module pvcPassThruBody() {
    minkowskiAdjustedBracketWidth=bracketWidth-bodyEdgeRoundOffDia;
    bracketOuterDia=pvc125FittingOuterDia+2*bracketCasingThickness;
    extraForPvcInsertBaseRotation=2;
    difference() {
        minkowski() {
            translate([0,0,bodyEdgeRoundOffDia/2])
            hull() {
                cylinder(d=bracketOuterDia-bodyEdgeRoundOffDia, 
                        h=minkowskiAdjustedBracketWidth);
                // Extension to make a base for the insertion receiver
                translate([-bracketOuterDia/2+6,frontInsertionExtensionBasePositionYOffset,0])
                    receiverExtensionBase(
                        minkowskiAdjustedBracketWidth, 
                        pvc125FittingOuterDia-frontInsertionExtensionBaseSizeReduction);
                // Extension to make a base for the pvc insert spline
                translate([pvc125FittingOuterDia/2+bracketCasingThickness
                            +connectorSplineXOffset,
                        -pvc125FittingOuterDia/2-connectorSplineYOffset,0])
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

/*
 * Flat side on the main body from which the receiver extends.
 */
module receiverExtensionBase(bodyWidth, baseHeight) {
    rotate([0,0,frontInsertionReceiverInclineAngle])
    hull() {
        // Upper barrel-shaped corner
        translate([0,baseHeight/2,0])
            cylinder(d=bodyExtensionRoundoffDia, h=bodyWidth);
        // Lower barrel-shaped corner
        translate([0,-baseHeight/2,0])
            cylinder(d=bodyExtensionRoundoffDia, h=bodyWidth);
    }
}
