// (c) 2011 Guy 'DeuxVis' P. <device@ymail.com>
// (c) 2013 Metamáquina <http://www.metamaquina.com.br/>
//
// Authors:
// * Guy 'DeuxVis' P. <device@ymail.com>
// * Felipe C. da S. Sanches <fsanches@metamaquina.com.br>
// * Rafael H. de L. Moretti <rafael.moretti@gmail.com>
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

use <gears.scad>;
include <BillOfMaterials.h>;
include <render.h>;

module motor_gear(teeth=11, shaft_diameter=5, bevel=0.5){
  base_r=10.5;

  BillOfMaterials(category="3D Printed", partname="Small Extruder Gear", ref="MM2_SEG");

  {//TODO: Add this part to the CAD model
    BillOfMaterials("M3x8 grubscrew - TODO", ref="H_M3x8_sc");
  }

  material("ABS")
  render()
  translate([0,0,5])
  difference() {
    union() {
      //gear
      union(){
        herringbone_gear( teeth=teeth, $fn=50 );

        //we don't want a hole here
        cylinder(h=10,r=5, center=true);
      }

      translate( [0, 0, 13] )
      mirror( [0, 0, 1] )
      difference() {
        //base
        rotate_extrude($fn=120){
          square( [base_r, 8] );
          square( [base_r+1, 7] );
          translate( [base_r, 7] ) circle( 1, $fn=50 );
        }

        //captive nut and grub holes
        translate( [0, 20, 4] ) rotate( [90, 0, 0] ) union() {
          //enterance
          translate( [0, -3, 14.5] ) cube( [5.4, 6, 2.4], center=true );
          //nut
          translate( [0, 0, 13.3] ) rotate( [0, 0, 30] ) cylinder( r=3.12, h=2.4, $fn=6 );
          //grub hole
          cylinder( r=1.5, h=20, $fn=20 );
        }
      }
    }

    //shaft hole
    translate( [0, 0, -6] )
    linear_extrude(height=20)
    intersection(){
        circle(r=shaft_diameter/2);
      translate([-shaft_diameter/2,-shaft_diameter/2]) square([shaft_diameter, shaft_diameter-bevel]);
    }
  }
}

module motor_gear_positioned_for_printing(){
  translate([0,0,18])
  rotate([180,0])
  motor_gear();
}

motor_gear_positioned_for_printing();
