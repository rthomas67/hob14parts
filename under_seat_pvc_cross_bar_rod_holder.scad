pvc100PipeInnerDia=26.25;  // 1 inch
pvc100PipeOuterDia=33.5; // 1.32 inches

pvc125PipeInnerDia=31.75;  // 1.25 inches
pvc125PipeOuterDia=42.25; // 1.665 inches
pvc125FittingInnerDia=pvc125PipeOuterDia;
pvc125FittingOuterDia=50.45;  // 1.985 inches
pvc125FittingInsertionDepth=32; // ~1.25 inches

bracketWidth=30;
bracketCasingThickness=10;

bodyExtensionRoundoffDia=9;
rearPvcInsertPostExtensionXOffset=5;
rearPvcInsertPostExtensionYOffset=-5;
frontInsertionReceiverExtensionXOffset=-5;
frontInsertionReceiverExtensionYOffset=5;

hobieChairLegInsertDia=24.3;
hobieChairLegInsertDepth=40;
hobieChairLegInsertOffset=10;

// height of "blade" that fits into the alignment key slot on one side
hobieChairLegKeyRidgeHeight=3.25;
hobieChairLegKeyRidgeHeightCurvatureOverlap=0.5;
hobieChairLegKeyRidgeWidth=4;

rearPvcInsertLength=40;
rearPvcInsertOffset=20;
rearPvcInsertAngle=20;


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
    cylinder(d=pvc100PipeInnerDia, h=rearPvcInsertLength);
}


module frontInsertionReceiver() {
    difference() {
        cylinder(d=hobieChairLegInsertDia+bracketCasingThickness*2,h=hobieChairLegInsertDepth+bracketCasingThickness);
        translate([0,0,bracketCasingThickness+overlap])
            cylinder(d=hobieChairLegInsertDia,h=hobieChairLegInsertDepth+overlap);
        translate([-hobieChairLegKeyRidgeWidth/2,
                -hobieChairLegInsertDia/2-hobieChairLegKeyRidgeHeight,
                bracketCasingThickness+overlap])
            cube([hobieChairLegKeyRidgeWidth,
                hobieChairLegKeyRidgeHeight+hobieChairLegKeyRidgeHeightCurvatureOverlap,
                hobieChairLegInsertDepth+overlap]);
    }
}

module pvcPassThruBody() {
    difference() {
        hull() {
            cylinder(d=pvc125FittingOuterDia+2*bracketCasingThickness, h=bracketWidth);
            // Extension to make a base for the hobie chair receiver
            translate([-pvc125FittingOuterDia/2-bracketCasingThickness-frontInsertionReceiverExtensionXOffset,
                    pvc125FittingOuterDia/2+frontInsertionReceiverExtensionYOffset,0])
                cylinder(d=bodyExtensionRoundoffDia, h=bracketWidth);
            // Extension to make a base for the pvc insert post
            translate([pvc125FittingOuterDia/2+bracketCasingThickness+rearPvcInsertPostExtensionXOffset,
                    -pvc125FittingOuterDia/2-rearPvcInsertPostExtensionYOffset,0])
                cylinder(d=bodyExtensionRoundoffDia, h=bracketWidth);
        }
        translate([0,0,-overlap])
            cylinder(d=pvc125FittingOuterDia, h=bracketWidth+overlap*2);
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