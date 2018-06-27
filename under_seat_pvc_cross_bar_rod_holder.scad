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


overlap=0.001;
$fn=50;

union() {
    translate([0,0,-bracketWidth/2]) 
        pvcPassThruBody();
    translate([-pvc125FittingOuterDia/2-bracketCasingThickness/4,hobieChairLegInsertOffset,0])
        rotate([0,-90,0])
            frontInsertionReceiver();
    rotate([0,0,rearPvcInsertAngle])
        translate([pvc125FittingOuterDia/2+bracketCasingThickness/3,-rearPvcInsertOffset,0])
            rotate([0,90,0])
                rearPvcInsertPost();
}

module rearPvcInsertPost() {
    cylinder(d=pvc100FittingInnerDia, h=rearPvcInsertLength);
}


module frontInsertionReceiver() {
    actualKeyWidth=hobieChairLegKeyRidgeWidth+hobieChairLegKeyRidgeTolerance*2;
    actualKeyHeight=hobieChairLegKeyRidgeHeight+hobieChairLegKeyRidgeTolerance*2;
    insertionReceiverOuterDia=hobieChairLegInsertDia+frontInsertionReceiverCasingThickness*2;
    insertionReceiverOverallLength=hobieChairLegInsertDepth+bracketCasingThickness;
    difference() {
        cylinder(d=insertionReceiverOuterDia,
            h=insertionReceiverOverallLength);
        translate([0,0,bracketCasingThickness+overlap])
            cylinder(d=hobieChairLegInsertDia,h=hobieChairLegInsertDepth+overlap);
        translate([-actualKeyWidth/2,
                -hobieChairLegInsertDia/2-actualKeyHeight,
                bracketCasingThickness+overlap])
            cube([actualKeyWidth,
                actualKeyHeight+hobieChairLegKeyRidgeHeightCurvatureOverlap,
                hobieChairLegInsertDepth+overlap]);
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

module pvcPassThruBody() {
    difference() {
        hull() {
            cylinder(d=pvc125FittingOuterDia+2*bracketCasingThickness, h=bracketWidth);
            // Upper extension to make a base for the hobie chair receiver
            translate([-pvc125FittingOuterDia/2-bracketCasingThickness-frontInsertionReceiverExtensionXOffset,
                    pvc125FittingOuterDia/2+frontInsertionReceiverExtensionYOffset,0])
                cylinder(d=bodyExtensionRoundoffDia, h=bracketWidth);
            // Lower extension to make a base for the hobie chair receiver
            translate([-pvc125FittingOuterDia/2-bracketCasingThickness-frontInsertionReceiverLowerExtensionXOffset,
                    -pvc125FittingOuterDia/2-frontInsertionReceiverLowerExtensionYOffset,0])
                cylinder(d=bodyExtensionRoundoffDia, h=bracketWidth);
            // Extension to make a base for the pvc insert post
            translate([pvc125FittingOuterDia/2+bracketCasingThickness+rearPvcInsertPostExtensionXOffset,
                    -pvc125FittingOuterDia/2-rearPvcInsertPostExtensionYOffset,0])
                cylinder(d=bodyExtensionRoundoffDia, h=bracketWidth);
        }
        // hole for pvc fitting
        translate([0,0,-overlap])
            cylinder(d=pvc125FittingOuterDia+pvcFittingTolerance*2, h=bracketWidth+overlap*2);
        
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