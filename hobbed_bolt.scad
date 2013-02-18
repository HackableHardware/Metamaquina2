// Hobbed Bolt dimensions for a lasercut version of the GregsWade Extruder
//
// (c) 2013 Felipe C. da S. Sanches <fsanches@metamaquina.com.br>
//
// Licensed under the terms of the GNU General Public License
// version 3 (or later).

MDF_thickness = 6;
bearing_thickness = 7; //based on 608zz_bearing.scad
M8_washer_thickness = 1.5; //based on washer.scad
wade_large_thickness = 6; //based on wade_big.stl (using projection(cut=true))
M8_nut_thickness = 6; //based on nut.scad

bolt_diameter = 7.7; //The hobbed bolt diameter must not be any greater than 7.7 
         // otherwise it wont fit in the 608zz bearing.

//hobbing_position = 22; //3d printed wade block
hobbing_position = MDF_thickness*3/2 + bearing_thickness + 2*M8_washer_thickness + wade_large_thickness;

hobbing_width = 16;
screw_length = 2 * M8_washer_thickness + M8_nut_thickness;
bolt_length = hobbing_position + MDF_thickness*3/2 + bearing_thickness + screw_length;

echo(str("hobbing position: ", hobbing_position));
echo(str("bolt_length: ", bolt_length));
echo(str("screw_length: ", screw_length));

module roundline(x1,y1,x2,y2, color="black", thickness=0.3){
  color(color){
    hull(){
      translate([x1,y1])
      circle(r=thickness/2, $fn=20);

      translate([x2,y2])
      circle(r=thickness/2, $fn=20);
    }
  }
}

module line(x1,y1,x2,y2, color="black", thickness=1){
  angle = atan2(y2-y1, x2-x1);
  length = sqrt((x2-x1)*(x2-x1) + (y2-y1)*(y2-y1));

  color(color){
    translate([x1,y1]){
      rotate([0,0,angle])
      translate([0,-thickness/2])
      square([length,thickness]);
    }
  }
}


module Square(x1,y1,x2,y2){
  roundline(x1,y1,x2,y1);
  roundline(x2,y1,x2,y2);
  roundline(x2,y2,x1,y2);
  roundline(x1,y2,x1,y1);
}

module RegularPolygon(N,r, even_odd=false){
  if (even_odd){
    for (i=[1:N/2])
      roundline(r*cos(2*i*360/N), r*sin(2*i*360/N),
                r*cos((2*i+1)*360/N), r*sin((2*i+1)*360/N));
  } else {
    for (i=[1:N])
      roundline(r*cos(i*360/N), r*sin(i*360/N),
                r*cos((i+1)*360/N), r*sin((i+1)*360/N));
  }
}

module Hexagon(r){
  RegularPolygon(6,r);
}

module Circle(r, even_odd=false){
  RegularPolygon(60,r, even_odd=even_odd);
}

module bolt_hex_head_frontal_view(D){
  //ISO standard for NON-STRUCTURAL hexagonal bolt head dimensions:
  e = 1.8 * D;
  s = 1.6 * D;

  translate([-15,0]){
    dimension(-s/2, 14, s/2, 14);
    rotate([0,0,90])
    dimension(-e/2, 12, e/2, 12);

    rotate([0,0,30])
    Hexagon(e/2);

    Circle(D/2, even_odd=true);
    dimension(-D/2, 10, D/2, 10);

    Circle(e/2*sqrt(3)/2);
  }
}

module arrow(x,y,angle,length=1, width=0.4, thickness=0.1){
  translate([x,y])
  rotate([0,0,angle])
  hull(){
    circle(r=thickness, $fn=20);

    translate([length, width/2])
    circle(r=thickness, $fn=20);

    translate([length, -width/2])
    circle(r=thickness, $fn=20);
  }
}

module head(D){
  //ISO standard for NON-STRUCTURAL hexagonal bolt head dimensions:
  e = 1.8 * D;
  h = 0.7 * D;

  Square(-h, -e/2, 0, e/2);
  Square(-h, -e/4, 0, e/4);

  dimension(-h,16,0,16);
}

module body(diameter, length){
  Square(0, -diameter/2, length, diameter/2);
  dimension(0,-10, length,-10);
}

module glyph(char, fontsize){
  scale(fontsize/12){
    import("font.dxf", layer=char);
  }
}

module dimension_label(x, y, string, spacing=0.7, fontsize=2){
//draw dimension text at coordinate x,y

  text_length = (len(string)+1) * spacing*fontsize;
  translate([x - text_length/2,y + fontsize/3]){
    for (i=[0:len(string)-1]){
      translate([spacing*fontsize*i,0]) glyph(string[i], fontsize);
      echo(string[i]);
    }

    translate([len(string)*spacing*fontsize, 0]) glyph("mm", fontsize);
  }
}

module dimension(x1,y1, x2,y2, color="blue"){
  length = round(1000*sqrt((x2-x1)*(x2-x1)+(y2-y1)*(y2-y1)))/1000.0;
  angle = atan2(y2-y1, x2-x1);

  color(color){
    arrow(x1,y1, 0);
    roundline(x1,y1+1, x1,y1-6);

    arrow(x2,y2, -180);
    roundline(x2,y2+1, x2,y2-6);

    roundline(x1,y1, x2,y2);
    dimension_label((x1+x2)/2, (y1+y2)/2, str(length));
  }
}

module hobbing(position, diameter, length){
  N=6;
  dimension(0,11, position,11);
  dimension(position-length/2, 12, position+length/2, 12, color="red");

  translate([position,0]){
    for (i=[0:N])
    Square(-length/2, -(i/N)*diameter/2, length/2, (i/N)*diameter/2);
  }
}

module screw(diameter, length){
  N=10;
  spacing=3;
  dimension(bolt_length-length,11, bolt_length,11);

  Square(bolt_length-length, -diameter/2, bolt_length, diameter/2);

color("black")
  translate([bolt_length-length, -diameter/2])
  intersection(){
    square([length, diameter]);
    for(i=[0:N]){
      line(i*spacing-diameter, -1, i*spacing, diameter+1);
    }
  }
}

module wade_large(){
  color("brown")
  projection(cut=true){
    rotate([0,-90])
    rotate([0,0,10])
    import("MM_wade-big.stl");
  }
}

module wade_large_3d(){
    rotate([0,-90])
    rotate([0,0,10])
    import("MM_wade-big.stl");
}

use <thingiverse_20413.scad>;
module wade_block_3d(){
  jhead_mount=256;
  wade(hotend_mount=jhead_mount, layer_thickness=0.25);
}

module wade_block_2d(){
  projection(cut=true)
  wade_block_3d();
}

wade_height = 6;
translate([wade_height,0]){
  wade_large();
//  %wade_large_3d();
}

//%wade_block_3d();

module parafuso_trator(){
  bolt_hex_head_frontal_view(bolt_diameter);

  head(bolt_diameter);
  body(diameter=bolt_diameter, length=bolt_length);
  hobbing(position=hobbing_position, diameter=bolt_diameter, length=hobbing_width);
  screw(diameter=bolt_diameter, length=screw_length);
}

parafuso_trator();
