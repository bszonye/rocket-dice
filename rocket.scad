layer = 0.2;

height = 24;

hex1v = [for (a=[0:60:359]) [cos(a), sin(a)]];
hex1a = hex1v / sin(60);

module die(h=height, center=false) {
    apothem = h/4;
    module pip(y, z) {
        side = apothem/sin(60);
        rx = (side - 4*layer) / 6;
        rq = layer * floor(rx/layer);  // quantize to layer height
        r = rq / cos(30);  // extrapolate to sphere
        x = apothem + r*sin(30);
        translate([x, y*(2*rq+layer), z*(2*rq+layer)]) sphere(r);
    }
    module pips(n) {
        if (n==1) rotate(30) {
            pip(0, 0);
        }
        else if (n==2) rotate(270) {
            pip(1, 1);
            pip(-1, -1);
        }
        else if (n==3) rotate(150) {
            pip(1, 1);
            pip(0, 0);
            pip(-1, -1);
        }
        else if (n==4) rotate(330) {
            pip(1, 1);
            pip(-1, 1);
            pip(-1, -1);
            pip(1, -1);
        }
        else if (n==5) rotate(90) {
            pip(0, 0);
            pip(1, 1);
            pip(-1, 1);
            pip(-1, -1);
            pip(1, -1);
        }
        else if (n==6) rotate(210) {
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
            linear_extrude(h, center=true) polygon(h/4*hex1a);
            for (n=[1:1:6]) pips(n);
        }
    }
}

module rocket(h=height, center=false) {
    apothem = h/4;
    d = 0.6 * h;
    module fin() {
        a = 30;
        fd = h/20;
        fh = h/3;
        fw = fh/2;
        fa2 = fh*fh/4;
        fb2 = fw*fw/4;
        y = sqrt((fa2 + fb2 - (fb2 - fa2)*sin(a))/2);
        x = sqrt((fa2 + fb2 - (fa2 - fb2)*sin(a))/2);
        dr = apothem/sin(60);
        translate([-dr+x, 0, -h/2+5/6*y]) {
            rotate([90, a, 0]) scale([fw/fh, 1, 1])
                cylinder(fd, d=fh, center=true);
        }
    }
    translate([0, 0, center ? 0 : h/2]) {
        scale([d/h, d/h, 1]) sphere(h/2);
        translate([0, 0, -h/2]) cylinder(h/2, d=2/5*d);
        for (a=[0:120:359]) rotate(a) fin();
    }
}

module rocket_die(h=height, center=false) {
    translate([0, 0, center ? 0 : h/2]) intersection() {
        rocket(h, center=true);
        die(h, center=true);
    }
}

rocket_die(center=true, $fa=1, $fs=1/4);
