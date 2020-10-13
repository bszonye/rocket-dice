layer = 0.2;

height = 32;
diameter = 12;

hex1v = [for (a=[0:60:359]) [cos(a), sin(a)]];
hex1a = hex1v / sin(60);

module die(h=height, d=diameter, center=false) {
    apothem = d/2;  // hexagon center to face
    edge = apothem/sin(60);  // hexagon edge / center to vertex
    module pip(y, z) {
        // pip radius
        rp = (edge - 2) / 4;
        rq = layer * floor(rp/layer);  // quantize to layer height
        dz = 2*rq + layer;
        dy = dz * tan(30);
        // pip depth
        a = 45;  // pip angle
        dp = rq * sin(a);
        translate([apothem-dp, y*dy, z*dz]) rotate([0, 90, 0])
            cylinder(h=2*dp, r1=0, r2=2*rq, $fa=15, $fs=layer);
    }
    module pips(n) {
        if (n==1) rotate(90) {
            pip(0, 0);
        }
        else if (n==2) rotate(330) {
            pip(1, 1);
            pip(-1, -1);
        }
        else if (n==3) rotate(210) {
            pip(1, 1);
            pip(0, 0);
            pip(-1, -1);
        }
        else if (n==4) rotate(30) {
            pip(1, 1);
            pip(-1, 1);
            pip(-1, -1);
            pip(1, -1);
        }
        else if (n==5) rotate(150) {
            pip(0, 0);
            pip(1, 1);
            pip(-1, 1);
            pip(-1, -1);
            pip(1, -1);
        }
        else if (n==6) rotate(270) {
            pip(1, 1);
            pip(-1, 1);
            pip(1, 0);
            pip(-1, 0);
            pip(1, -1);
            pip(-1, -1);
        }
    }
    translate([0, 0, center ? 0 : h/2]) {
        difference() {
            linear_extrude(h, center=true) polygon(apothem*hex1a);
            for (n=[1:1:6]) pips(n);
        }
    }
}

module rocket(h=height, d=diameter, center=false) {
    apothem = d/2;  // hexagon center to face
    edge = apothem/sin(60);  // hexagon edge / center to vertex
    module fin() {
        fd = h/20;
        translate([0, 0, -h/2]) rotate([90, 0, 0]) intersection() {
            cylinder(fd, r=edge, center=true);
            linear_extrude(fd, center=true) square(edge);  // one quadrant only
        }
    }
    sd = 2.04*edge;
    translate([0, 0, center ? 0 : h/2]) {
        scale([sd/h, sd/h, 1]) sphere(h/2);
        translate([0, 0, -h/2]) cylinder(h/2, d=d/2);
        for (a=[0:120:359]) rotate(a) fin();
    }
}

module rocket_die(h=height, d=diameter, center=false) {
    translate([0, 0, center ? 0 : h/2]) intersection() {
        rocket(h, d, center=true);
        die(h, d, center=true);
    }
}

rocket_die(center=true, $fa=3, $fs=layer);
