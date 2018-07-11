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