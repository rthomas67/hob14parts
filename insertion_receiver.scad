module insertionReceiver(insertionReceiverVerticalAngle,
        insertionReceiverVerticalAngleOffsetAdjust, 
        insertionReceiverKeyBottomRotationAdjust) {
    insertionReceiverOuterDia=hobieChairLegInsertDia+frontInsertionReceiverCasingThickness*2;
    insertionReceiverOverallLength=hobieChairLegInsertDepth+bracketCasingThickness;
    difference() {
        cylinder(d=insertionReceiverOuterDia,
            h=insertionReceiverOverallLength);
    translate([0,0,bracketCasingThickness+overlap])
        translate([insertionReceiverVerticalAngleOffsetAdjust,0,0])  // offset to recenter
            rotate([0,insertionReceiverVerticalAngle,insertionReceiverKeyBottomRotationAdjust])
                // apply the vertical angle internally
                insertionReceiverCutout();
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

module insertionReceiverCutout() {
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

