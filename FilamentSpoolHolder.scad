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

//utils
use <rounded_square.scad>;
use <tslot.scad>;
include <render.h>;
include <BillOfMaterials.h>;
use <mm2logo.scad>;

//measures
thickness = 6;
margin = 5;

feet_height = 12;
feet_width = 50;
base_height = 80;

total_width = 160+2*thickness+2*margin;

top_cut_height = 20;
top_cut_width = 30;

radius = 15;
rad=3/2;

spool_holder_width = 160+2*margin+2*thickness;
spool_holder_height = 40;

tslot_length = 16;
tslot_diameter = 3;

locker_diameter=35;
locker_length=thickness;


margin2=8;

bar_diameter=25;
bar_length= spool_holder_width+locker_length*2+2*margin2;

total_height = 160/2+35/2-bar_diameter/2+top_cut_height+feet_height+top_cut_width/2;
radius_feet=5;

diameter=3;


//side panel
module FilamentSpoolHolder_sidepanel_face(){

  difference(){
    union(){
      hull()
      for (i=[-1,1]){
          translate([i*40,total_height-radius])
          circle(r=radius);

          translate([i*(total_width/2-radius),base_height])
          circle(r=radius);

          translate([i*total_width/2,feet_height])
          circle(r=0.1);
      }

      for (i=[-1,1]){
      translate([i*(total_width-feet_width)/2,(feet_height+radius_feet)/2])
      rounded_square([feet_width,feet_height+radius_feet], corners=[radius_feet, radius_feet, radius_feet, radius_feet], center=true);
    }
}

    union(){
      translate([0,(total_height-top_cut_height/2)])
      square([top_cut_width,top_cut_height],center = true);

      translate([0,(total_height-top_cut_height)])
      circle(r=top_cut_width/2);

//logo
      translate([-3,(base_height*0.7)])
      scale(5) mm_logo();

//tslots
      for (i=[-1,1]){
          translate([i*(total_width/2-thickness),15])
          TSlot_holes();
}
      }  
    }
  }

//other side panel
module FilamentSpoolHolder_othersidepanel_face(){
difference(){
union(){
translate([0,(base_height)/2])
      square([spool_holder_width-2*thickness,spool_holder_height],center = true);

//tslots joints
      for (i=[-1,1]){
        translate([i*(spool_holder_width/2-thickness/2),15])
        TSlot_joints(50);
        }
}
union(){
//logo
translate([-spool_holder_width/3.2,(spool_holder_height/1.3)])
   scale(0.6) MM2_logo();

      //tslots for other side panel
      for (i=[-1,1]){
        translate([i*(spool_holder_width/2), base_height/2])
        rotate([0,0,i*90])
        t_slot_shape(tslot_diameter,tslot_length);
        }
      }
    }
  }

//bar
module FilamentSpoolHolder_bar_face(){
      circle(r=bar_diameter/2,center=true);
  }

//locker 
module FilamentSpoolHolder_locker_face(){
difference(){
      circle(r=locker_diameter/2,center=true);

      circle(r=bar_diameter/2,center=true);
     }
    }

//spool 
module FilamentSpoolHolder_spool_face(){
difference(){
      circle(r=160/2,center=true);

      circle(r=35/2,center=true);
     }
    }

module FilamentSpoolHolder_sidepanel_sheet(){
  BillOfMaterials(category="Lasercut wood", partname="Filament Spool Holder Side Panel");
  material("lasercut")
  linear_extrude(height=thickness)
  FilamentSpoolHolder_sidepanel_face();
}

module FilamentSpoolHolder_othersidepanel_sheet(){
  BillOfMaterials(category="Lasercut wood", partname="Filament Spool Holder Side Panel");
  material("lasercut")
  linear_extrude(height=thickness)
  FilamentSpoolHolder_othersidepanel_face();
}

module FilamentSpoolHolder_bar_sheet(){
  BillOfMaterials(category="Lasercut wood", partname="Filament Spool Holder Bar"); //adicionar na lista
  material("lasercut")
linear_extrude(height=bar_length)
  FilamentSpoolHolder_bar_face();
}

module FilamentSpoolHolder_locker_sheet(){
  BillOfMaterials(category="Lasercut wood", partname="Filament Spool Holder Locker"); //adicionar na lista
  material("lasercut")
linear_extrude(height=locker_length)
  FilamentSpoolHolder_locker_face();
}

module FilamentSpoolHolder_spool_sheet(){
 // BillOfMaterials(category="Lasercut wood", partname="Spool"); //adicionar na lista
 // material("lasercut")
color("red")
linear_extrude(height=160)
  FilamentSpoolHolder_spool_face();
}

module FilamentSpoolHolder(){
  translate([0, -1*spool_holder_width/2+thickness])
  rotate([90,0,0])
  FilamentSpoolHolder_sidepanel_sheet();

  translate([0, 1*spool_holder_width/2-thickness])
  rotate([90,0,180])
  FilamentSpoolHolder_sidepanel_sheet();
}

module FilamentSpoolHolder_othersidepanel(){
  translate([0, -1*(total_width/2-thickness/2-6)])
  rotate([90,0,0])
  FilamentSpoolHolder_othersidepanel_sheet();

  translate([0, 1*(total_width/2-thickness/2-6)])
  rotate([90,0,180])
  FilamentSpoolHolder_othersidepanel_sheet();
}

module FilamentSpoolHolder_bar(){
difference(){
  translate([-(bar_length)/2,0,(total_height-top_cut_height-(top_cut_width-bar_diameter)/2)])
  rotate([0,90,0])
  FilamentSpoolHolder_bar_sheet();

for(j=[-1,1]){
for(i=[0:40]){
 translate([j*(1*(bar_length-margin2)/2),0,(total_height-top_cut_height-(top_cut_width-bar_diameter)/2+locker_diameter/2)-i])
   circle(r=rad, center=true);
      }
    }
  }
}

module FilamentSpoolHolder_locker(){

difference(){

union(){
 translate([1*((bar_length-2*margin2-2*locker_length)/2),0,(total_height-top_cut_height-(top_cut_width-bar_diameter)/2)])
  rotate([0,90,0])
 FilamentSpoolHolder_locker_sheet();


 translate([-1*((bar_length-2*margin2)/2),0,(total_height-top_cut_height-(top_cut_width-bar_diameter)/2)])
  rotate([0,90,0])
 FilamentSpoolHolder_locker_sheet();
}
for(j=[-1,1]){
for(i=[0:40]){
 translate([j*(1*(bar_length-margin2)/2),0,(total_height-top_cut_height-(top_cut_width-bar_diameter)/2+locker_diameter/2)-i])
   circle(r=rad, center=true);
     }
   }
  }
}

module FilamentSpoolHolder_spool(){
  translate([-160/2,0,(total_height-top_cut_height-35/2+bar_diameter/2-(top_cut_width-bar_diameter)/2)])
  rotate([0,90,0])
  FilamentSpoolHolder_spool_sheet();

}

  rotate([0,0,90])


FilamentSpoolHolder();
FilamentSpoolHolder_othersidepanel();
FilamentSpoolHolder_bar();
FilamentSpoolHolder_locker();
FilamentSpoolHolder_spool();

