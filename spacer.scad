// (c) 2013 Felipe C. da S. Sanches <fsanches@metamaquina.com.br>
// Licensed under the terms of the GNU General Public License
// version 3 (or later).

include <spacer.h>;
include <color.h>;
include <Metamaquina2.h>;
include <BillOfMaterials.h>;

spacers_clearance = 0.1; // extra room for the spacers hole diameter

module double_M3_lasercut_spacer(){
  M3_spacer();

  translate([0,0,thickness])
  M3_spacer();
}

module M3_spacer(){
  BillOfMaterials("M3 Lasercut spacer");

  color(sheet_color)
  linear_extrude(height=thickness)
  M3_spacer_face();
}

module M3_spacer_face(){
  difference(){
    circle(r=m3_diameter*1.5, $fn=30);
    circle(r=(m3_diameter + spacers_clearance)/2, $fn=30);
  }
}

module set_of_M3_spacers(w=4, h=4){
  for (x=[1:w]){
    for (y=[1:h]){
      translate([x*3.2*m3_diameter, y*3.2*m3_diameter])
      M3_spacer_face();
    }
  }
}

module M4_spacer(){
  BillOfMaterials("M4 Lasercut spacer");

  color(sheet_color)
  linear_extrude(height=thickness)
  M4_spacer_face();
}

module M4_spacer_face(){
  difference(){
    circle(r=m4_diameter*1.5, $fn=30);
    circle(r=(m4_diameter + spacers_clearance)/2, $fn=30);
  }
}

module set_of_M4_spacers(w=4, h=4){
  for (x=[1:w]){
    for (y=[1:h]){
      translate([x*3.2*m4_diameter, y*3.2*m4_diameter])
      M4_spacer_face();
    }
  }
}

module hexspacer_38mm(){
  BillOfMaterials(str("Female-female 38mm Hexspacer (CBTS135A)"));

  generic_hexspacer(length=38);
}

module hexspacer_32mm(){
  BillOfMaterials(str("Female-female 32mm Hexspacer (CBTS130A)"));

  generic_hexspacer(length=32);
}

module generic_hexspacer(D=8, d=m3_diameter, h=hexspacer_length){
  if (render_metal){
    color(metal_color)
    linear_extrude(height=h)
    difference(){
      circle(r=D/2, $fn=6);
      circle(r=d/2, $fn=20);
    }
  }
}

module generic_nylonspacer(D=8, d=m4_diameter, h=nylonspacer_length){
  if (render_nylon){
    color(white_nylon_color)
    linear_extrude(height=h)
    difference(){
      circle(r=D/2, $fn=20);
      circle(r=d/2, $fn=20);
    }
  }
}

