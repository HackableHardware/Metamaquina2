// (c) 2013 Felipe C. da S. Sanches <fsanches@metamaquina.com.br>
// Licensed under the terms of the GNU General Public License
// version 3 (or later).
//
// Based on data from:
// http://www.pankajinternational.com/DomedCapNutsDIN1587.htm

module M6_domed_cap_nut(){
  DIN_1587(6, 9.5, 4.75, 12, 8.29, 5.15, 10.00, 11.05);
}

module M8_domed_cap_nut(){
  DIN_1587(8, 12.5, 6.25, 15, 11.35, 6.68, 13.00, 14.38);
}

module M10_domed_cap_nut(){
  DIN_1587(10, 16, 8, 18, 13.35, 8.18, 17.00, 18.90);
}

module M12_domed_cap_nut(){
  DIN_1587(12, 18, 9, 22, 16.35, 9.68, 19.00, 21.10);
}

module M14_domed_cap_nut(){
  DIN_1587(14, 21, 10.5, 25, 18.35, 11.22, 22.00, 24.49);
}

module M16_domed_cap_nut(){
  DIN_1587(16, 23, 11.5, 28, 21.42, 13.22, 24.00, 26.75);
}

module M18_domed_cap_nut(){
  DIN_1587(18, 26, 13, 32, 25.42, 15.22, 27.00, 30.14);
}

module M20_domed_cap_nut(){
  DIN_1587(20, 28, 14, 34, 26.42, 16.22, 30.00, 33.53);
}

module M22_domed_cap_nut(){
  DIN_1587(22, 31, 15.5, 39, 29.42, 17.22, 32.00, 35.72);
}

module M24_domed_cap_nut(){
  DIN_1587(24, 34, 17, 42, 35.00, 18.22, 36.00, 39.98);
}

function hipotenusa(a, b) = sqrt(a*a + b*b); 

//E/2 = x * sqrt(3)/2
//x=E/sqrt(3);

module DIN_1587(D, C, R, B, A, H, E, F){
  render(){
    difference(){
      union(){
        //dome
        translate([0, 0, B-R])
        sphere(r=R, $fn=60);
        cylinder(r=R, h=B-R, $fn=60);

        //hexagon
        intersection(){
          cylinder(r=E/sqrt(3), h=H, $fn=6);
          sphere(r=hipotenusa(E/2, H), $fn=60);
          translate([0,0,H])
          sphere(r=hipotenusa(E/2, H), $fn=60);
        }
      }

      //hole
      translate([0,0,-1])
      cylinder(r=D/2, h=A+1, $fn=20);
    }
  }
}

M6_domed_cap_nut();

translate([15, 0, 0])
M8_domed_cap_nut();

translate([34, 0, 0])
M10_domed_cap_nut();

translate([57, 0, 0])
M12_domed_cap_nut();

translate([83, 0, 0])
M14_domed_cap_nut();

translate([112, 0, 0])
M16_domed_cap_nut();

translate([144, 0, 0])
M18_domed_cap_nut();

translate([182, 0, 0])
M20_domed_cap_nut();

translate([224, 0, 0])
M22_domed_cap_nut();

translate([270, 0, 0])
M24_domed_cap_nut();

