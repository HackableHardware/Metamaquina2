// Reimplementation of Josef Průša's belt clamp
// Adapted for eighter laser cutting or 3d printing.
//
// (c) 2013 Felipe C. da S. Sanches <fsanches@metamaquina.com.br>
// Licensed under the terms of the GNU General Public License
// version 3 (or later).

module belt_clamp_holder(){
  r = 5;
  s = 28 - 2*r;
  hull(){
    for (p=[[s,0], [s,s], [0,0]]){
      translate(p)
      circle(r=r, $fn=20);
    }
  }
}

//2d shape (good for the lasercutter)
module beltclamp_curves(width, r){
  d = width/2-r;

  difference(){
    hull(){
      for (x=[-d,d]){
        translate([x, 0])
        circle(r=5, $fn=20);
      }
    }

    //These are holes for M3 bolts, but we want
    // some clearance so they'll have 3.3mm diameter.
    for (x=[-d,d]){
      translate([x, 0])
      circle(r=3.3/2, $fn=20);
    }
  }
}

// This seems to be designed for T5.
//TODO: Adapt this for 2mm GT2? (add a belt_pitch parameter?)
module teeth_for_belt(belt_width=6){
  for (y=[-2:2])
    translate([0,y*2.5])
    square([belt_width+2, 1.8], center = true);
}

module beltclamp(width=28, height=6, r=5, teeth_depth=0.5){
  render()
  difference(){
    linear_extrude(height=height)
    beltclamp_curves(width, r);

    translate([0, 0, height-teeth_depth]){
      linear_extrude(height = teeth_depth+1)
      teeth_for_belt();
    }
  }
}

beltclamp();
