pvc100PipeInnerDia=26.25;  // 1 inch
pvc100PipeOuterDia=33.5; // 1.32 inches
pvc100FittingInnerDia=pvc100PipeOuterDia;
pvc100FittingOuterDia=42.8; // 1.7 inches

pvc125PipeInnerDia=31.75;  // 1.25 inches
pvc125PipeOuterDia=42.25; // 1.665 inches
pvc125FittingInnerDia=pvc125PipeOuterDia;
pvc125FittingOuterDia=50.45;  // 1.985 inches
pvc125FittingInsertionDepth=32; // ~1.25 inches

pvcFittingTolerance=0.75;

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
rearPvcInsertAngle=-8;
rearPvcInsertPostExtensionXOffset=-10;
rearPvcInsertPostExtensionYOffset=10;

leftSide=true;

// This angle allows the body to be oriented such that it more or less aligns with
// an imaginary line from front to back between the seat posts.  The "short-side"
// seat post insert on the front seat post is not directly aligned, and is
// a little different on the left and right side of the seat.
receiverVerticalAngle=(leftSide) ? -2 : -2;
receiverAngleOffsetAdjust=(leftSide) ? 1.5 : 1;

// Note: This angle "helps" the ultimate position/orientation of the center body
// but must be combined with some tilt in the 45 degree PVC elbow.  This
// is also affected by the receiverVerticalAngle.
insertVerticalAngle=(leftSide) ? 2 : -4;

keyBottomRotationAdjust=(leftSide) ? -2 : 1;

overlap=0.001;
$fn=50;

union() {
    translate([0,0,-bracketWidth/2]) 
        pvcPassThruBody();
    translate([-pvc125FittingOuterDia/2-bracketCasingThickness/4,hobieChairLegInsertOffset,0])
        // Note: receiverVerticalAngle is applied to the opening so the exterior can remain flat for printing
        rotate([0,-90,0])
            frontInsertionReceiver();
    rotate([0,0,rearPvcInsertAngle])
        translate([pvc125FittingOuterDia/2+bracketCasingThickness/3,-rearPvcInsertOffset,0])
            rotate([0,insertVerticalAngle,0])
            rotate([0,90,0])
                rearPvcInsertPost();
}

module rearPvcInsertPost() {
    cylinder(d=pvc100FittingInnerDia, h=rearPvcInsertLength);
}


module frontInsertionReceiver() {
    insertionReceiverOuterDia=hobieChairLegInsertDia+frontInsertionReceiverCasingThickness*2;
    insertionReceiverOverallLength=hobieChairLegInsertDepth+bracketCasingThickness;
    difference() {
        cylinder(d=insertionReceiverOuterDia,
            h=insertionReceiverOverallLength);
    translate([0,0,bracketCasingThickness+overlap])
        translate([receiverAngleOffsetAdjust,0,0])  // offset to recenter
            rotate([0,receiverVerticalAngle,keyBottomRotationAdjust])  // apply the vertical angle internally
                frontInsertionReceiverCutout();
        // flatten the sides of the cylinder
        translate([-insertionReceiverOuterDia/2-bracketWidth/2,
                -insertionReceiverOuterDia/2-overlap,-overlap])
            cube([insertionReceiverOuterDia/2+overlap,
                insertionReceiverOuterDia+overlap*2,
                insertionReceiverOverallLength+overlap*2]);
        translate([bracketWidth/2-overlap,
                -insertionReceiverOuterDia/2-overlap,-overlap])
            cube([insertionReceiverOuterDia/2+overlap,
                insertionReceiverOuterDia+overlap*2,
                insertionReceiverOverallLength+overlap*2]);
    }
}

module frontInsertionReceiverCutout() {
    flatSideCornerHeight=1.5;
    bevelHeight=3;
    bevelFactor=1.5;
    actualKeyWidth=hobieChairLegKeyRidgeWidth+hobieChairLegKeyRidgeTolerance*2;
    actualKeyHeight=hobieChairLegKeyRidgeHeight+hobieChairLegKeyRidgeTolerance*2;
    
    // Note: Allowing the cutout to be rotated depends on the top of this to
    // be extended a bit.  The "bevel" shapes at the mouth provide the extra length.
    union() {
        hull() {
            cylinder(d=hobieChairLegInsertDia,h=hobieChairLegInsertDepth+overlap);
            // corners of wide flat side of cutout
            rotate([0,0,25])
                translate([-hobieChairLegInsertDia/2,0,0])
                    cylinder(d=flatSideCornerHeight, h=hobieChairLegInsertDepth+overlap);
            rotate([0,0,-25])
                translate([-hobieChairLegInsertDia/2,0,0])
                    cylinder(d=flatSideCornerHeight, h=hobieChairLegInsertDepth+overlap);
            // corners of narrow slot opposite wide flat side
            rotate([0,0,10])
                translate([hobieChairLegInsertDia/2,0,0])
                    cylinder(d=flatSideCornerHeight, h=hobieChairLegInsertDepth+overlap);
            rotate([0,0,-10])
                translate([hobieChairLegInsertDia/2,0,0])
                    cylinder(d=flatSideCornerHeight, h=hobieChairLegInsertDepth+overlap);
            // corners of narrow slot opposite key slot
            rotate([0,0,10])
                translate([0,hobieChairLegInsertDia/2,0])
                    cylinder(d=flatSideCornerHeight, h=hobieChairLegInsertDepth+overlap);
            rotate([0,0,-10])
                translate([0,hobieChairLegInsertDia/2,0])
                    cylinder(d=flatSideCornerHeight, h=hobieChairLegInsertDepth+overlap);
        }
        // key slot
        translate([-actualKeyWidth/2,
                -hobieChairLegInsertDia/2-actualKeyHeight, 0])
            cube([actualKeyWidth,
                actualKeyHeight+hobieChairLegKeyRidgeHeightCurvatureOverlap,
                hobieChairLegInsertDepth+overlap]);
        // bevel out at mouth
        translate([0,0,hobieChairLegInsertDepth-bevelHeight])
            cylinder(d1=hobieChairLegInsertDia,d2=hobieChairLegInsertDia*bevelFactor,h=10);
        keyHeightWidthDifference=abs(actualKeyHeight-actualKeyWidth);
        translate([0,-hobieChairLegInsertDia/2-actualKeyHeight/2+keyHeightWidthDifference/2,
                hobieChairLegInsertDepth-bevelHeight])
            rotate([0,0,45])
            // note: setting $fn for 4 sides cuts the dia down, so it has to be re-enlarged
            // note: angles on this tiny part need to be bigger, so bevelFactor is increased a bit
            cylinder(d1=actualKeyWidth*1.4, d2=actualKeyWidth*1.4*bevelFactor*1.25, 
                    h=actualKeyWidth, $fn=4);
        
    }
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
    }
}
    

//pvcElbow45(pvc125FittingInnerDia, pvc125FittingOuterDia, pvc125FittingInsertionDepth);

module pvcElbow45(pvcElbow45InnerDia, pvcElbow45OuterDia, pvcElbow45InsertionDepth) {
    pvcElbow45OuterBendExtraLength=pvcElbow45OuterDia;
    union() {
        pvcElbow45Half(pvcElbow45InnerDia, pvcElbow45OuterDia, 
            pvcElbow45InsertionDepth, pvcElbow45OuterBendExtraLength);
        mirror([0,0,1])
            pvcElbow45Half(pvcElbow45InnerDia, pvcElbow45OuterDia, 
                pvcElbow45InsertionDepth, pvcElbow45OuterBendExtraLength);
    }
}

module pvcElbow45Half(pvcElbow45InnerDia, pvcElbow45OuterDia, pvcElbow45InsertionDepth, pvcElbow45OuterBendExtraLength) {
    translate([0,0,-pvcElbow45InsertionDepth-pvcElbow45OuterBendExtraLength/4])
    difference() {
        %cylinder(d=pvcElbow45OuterDia, h=pvcElbow45InsertionDepth+pvcElbow45OuterBendExtraLength);
        %translate([-pvcElbow45OuterDia,pvcElbow45OuterDia/2,pvcElbow45InsertionDepth])
            rotate([45+45/2,0,0])
                cube([pvcElbow45OuterDia*2,pvcElbow45OuterDia*2,pvcElbow45OuterDia*2]);
    }
}