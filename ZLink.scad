// z_threaded_bar_link (a.k.a. z-link)
//
// These are the plastic parts that link the XPlatform to the 
// Z-axis threaded bars.
//
// (c) 2013 Metamáquina <http://www.metamaquina.com.br/>
//
// Author:
// * Felipe C. da S. Sanches <fsanches@metamaquina.com.br>
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

include <Metamaquina2.h>;
include <ZLink.h>;
include <BillOfMaterials.h>;
include <render.h>;

module FullZLink(nut_borders=false, clearance = 0.2, hull_size=0, wing_thickness=8.5, top_opening=true){
  difference(){
    union(){
      linear_extrude(height=wing_thickness){
        difference(){
          //the wings
          hull(){
            for (i=[-1,1])
    			    translate([i*dx_z_threaded, 0])
    			    circle(r=6);
          }

          //holes for bolts
          for (i=[-1,1])
            translate([i*dx_z_threaded, 0])
            circle(r=m3_diameter/2 + 0.3, $fn=20);
        }
      }

      //nut borders
      if (nut_borders)
      for (i=[-1,1])
    		translate([i*dx_z_threaded, 0, wing_thickness]) cylinder(r=5, h=2, $fn=6);
    }

    //holes for nuts
    if (nut_borders)
    for (i=[-1,1])
      translate([i*dx_z_threaded, 0, wing_thickness-0.6]) cylinder(r=3, h=5, $fn=6);

    //hexagonal central hole for M8 nuts, spring and threaded rod
    translate([0,0,ZLink_rod_height])
    rotate([90,0])
    cylinder(r=8, $fn=6, h=50, center=true);      
  }

  //ZLink main-body, for passing the threaded rod, the spring and the M8 nuts
  translate([0,Zlink_hole_height, ZLink_rod_height])
  rotate([90, 0, 0]){
    linear_extrude(height=XPlatform_height - thickness)
    difference(){
      circle($fn=6, r=11);
      circle($fn=6, r=8);
    }

    linear_extrude(height=7)
    intersection(){
      difference(){
        circle($fn=60, r=12);
        circle($fn=6, r=8);
      }

      square([100,19], center=true);
    }

    translate([0,0,XPlatform_height - thickness - 20])
    linear_extrude(height=20)
    intersection(){
      difference(){
        circle($fn=60, r=12);
        circle($fn=6, r=8);
      }

      square([100,19], center=true);
    }

    translate([0,0,7]){
      linear_extrude(height=4)
      difference(){
        circle($fn=6, r=10);
        hull(){
          for (i=[-1,1])
          translate([0,i*hull_size/2])
            circle($fn=20, r=(8+clearance)/2);
        }
      }
    }
  }
}

module ZLink(nut_borders=false, clearance = 0.2, hull_size=0, wing_thickness=8.5, top_opening=true){
  BillOfMaterials(category="3D Printed", partname="ZLink", ref="MM2_ZL");

  material("ABS"){
    //wings with holes for bolts
    difference(){
      FullZLink(nut_borders=nut_borders, clearance=clearance, hull_size=0, wing_thickness=wing_thickness);

      if (top_opening){
        translate([0,0,23.3])
        rotate([90, 0])
        cylinder(h=100, r=8, $fn=6, center=true);
      }
    }
  }
}

ZLink();

