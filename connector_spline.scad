pConnectorSplineOverlap=0.001;

//connectorSpline(20,30,20,3,0.95);
//%connectorSplineCutout(20,30,20,3,0.95);

module connectorSpline(pConnectorSplineRidgeCount, pConnectorSplineLength, pConnectorSplineDia,
        pConnectorSplineRidgeDepth,pConnectorSplineTaperFactor) {
    difference() {
        cylinder(d1=pConnectorSplineDia, d2=pConnectorSplineDia*pConnectorSplineTaperFactor,
                h=pConnectorSplineLength, $fn=50);
        for (c=[0:pConnectorSplineRidgeCount]) {
            rotate([0,0,c*360/pConnectorSplineRidgeCount])
                translate([pConnectorSplineDia/2+pConnectorSplineOverlap,0,-pConnectorSplineOverlap])
                    rotate([0,0,180])
                        cylinder(d=pConnectorSplineRidgeDepth,
                            h=pConnectorSplineLength+pConnectorSplineOverlap*2, $fn=3);
        }
    }
}

module connectorSplineCutout(pConnectorSplineRidgeCount, pConnectorSplineLength, pConnectorSplineDia,
        pConnectorSplineRidgeDepth,pConnectorSplineTaperFactor) {
    scale([1.05,1.05,1.01]) 
        connectorSpline(pConnectorSplineRidgeCount, pConnectorSplineLength, 
            pConnectorSplineDia, pConnectorSplineRidgeDepth,pConnectorSplineTaperFactor);
}