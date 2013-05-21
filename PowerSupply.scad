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
include <BillOfMaterials.h>;
include <PowerSupply.h>;
include <bolts.h>;
include <washers.h>;
include <render.h>;
include <colors.h>;
include <rounded_square.scad>;
include <tslot.scad>;

box_height = 50; //TODO
detail = false;
mount_positions = [[5, 6],
                  [6, PowerSupply_height - 22],
                  [PowerSupply_width - 5, 5],
                  [PowerSupply_width - 12, PowerSupply_height - 21]
];

module HiquaPowerSupply_holes(){
  for (p = mount_positions){
    translate(p)
    circle(r=5/2, $fn=20);
  }

  translate([thickness,-(box_height-thickness)/2])
  TSlot_holes(width=(box_height-thickness)/2);

  translate([PowerSupply_width-thickness,-(box_height-thickness)/2])
  TSlot_holes(width=(box_height-thickness)/2);
}

module oldHiquaPowerSupply(){
  BillOfMaterials("Power Supply");

  {//TODO: Add this to the CAD model
    BillOfMaterials("Power Supply cable");
  }

  if (render_metal){
    color(metal_color){
      cube([PowerSupply_thickness, PowerSupply_width, PowerSupply_height]);
    }
  }
}

metal_sheet_thickness = 1;
bottom_offset = 11;
top_offset = 5;
pcb_thickness = 2;
pcb_height = 9 - pcb_thickness;
pcb_bottom_advance = 2;

module circle_pattern(r, spacing_x, spacing_y, x,y){
  $fn=6;
  for (i=[1:x]){
    for (j=[1:y]){
      translate([(i+(1/2)*(j%2)) * spacing_x, j * spacing_y])
      circle(r=r);
    }
  }
}

module HiquaPowerSupply(){
  BillOfMaterials("Power Supply");

  {//TODO: Add this to the CAD model
    BillOfMaterials("Power Supply cable");
  }

  if (render_metal){
    color(metal_color){
      cube([PowerSupply_width, PowerSupply_height, metal_sheet_thickness]);

      translate([PowerSupply_width - metal_sheet_thickness, 0])
      cube([metal_sheet_thickness, PowerSupply_height, PowerSupply_thickness]);

      translate([0,bottom_offset])
      difference(){
        cube([PowerSupply_width, PowerSupply_height - bottom_offset - top_offset, PowerSupply_thickness]);

        translate([metal_sheet_thickness, metal_sheet_thickness])
        cube([PowerSupply_width - 2*metal_sheet_thickness, PowerSupply_height - bottom_offset - top_offset - 2*metal_sheet_thickness, PowerSupply_thickness - metal_sheet_thickness]);

        if (detail){
          translate([-23.5, 7, PowerSupply_thickness - 1.5*metal_sheet_thickness]){
            linear_extrude(height=2*metal_sheet_thickness)
            circle_pattern(r=4.6/2, spacing_x=6, spacing_y = 5, x=21,y=34);
          }
        }
      }
    }
  }

  if (render_pcb){
    color(pcb_color){
      translate([metal_sheet_thickness, -pcb_bottom_advance, pcb_height])
      cube([PowerSupply_width - 2*metal_sheet_thickness, PowerSupply_height - top_offset, pcb_thickness]);
    }
  }
}

module HiquaPowerSupply_subassembly(th=thickness){
  HiquaPowerSupply();
  PowerSupplyBox();

  for (p = mount_positions){
    translate([PowerSupply_width - p[0], p[1]]){
      translate([0, 0, -th - m3_washer_thickness]){
        M3_washer();

        rotate([180,0])
        M3x10();
      }
    }
  }
}

HiquaPowerSupply_subassembly();



module PowerSupplyBox_side_face(){
  difference(){
    square([PowerSupply_width, box_height-thickness]);

    translate([PowerSupply_width-metal_sheet_thickness, box_height-thickness-bottom_offset])
    square([metal_sheet_thickness,bottom_offset]);

    translate([thickness,0])
    TSlot_holes(width=box_height-thickness);

    translate([PowerSupply_width-thickness,0])
    TSlot_holes(width=box_height-thickness);
  }
}

module PowerSupplyBox_bottom_face(){
  difference(){
    square([PowerSupply_width, PowerSupply_thickness]);

    translate([thickness,0])
    TSlot_holes(width=PowerSupply_thickness-thickness);

    translate([PowerSupply_width-thickness,0])
    TSlot_holes(width=PowerSupply_thickness-thickness);
  }
}

module PowerSupplyBox_front_face(){
  difference(){
    square([PowerSupply_thickness - thickness, box_height - thickness]);
    translate([0,box_height-thickness-(bottom_offset+pcb_bottom_advance)])
    rounded_square([9+2,bottom_offset+pcb_bottom_advance], corners=[0,2,0,0]);

    translate([-thickness,(box_height-thickness)/2])
    rotate(-90)
    t_slot_shape(3,16);

    translate([(PowerSupply_thickness-thickness)/2,-thickness])
    t_slot_shape(3,16);

    translate([PowerSupply_thickness,(box_height-thickness)/2])
    rotate(90)
    t_slot_shape(3,16);
  }

  translate([- thickness/2,(box_height-thickness)/4])
  t_slot_joints((box_height-thickness)/2, thickness=thickness);

  translate([0,-thickness/2])
  rotate(-90)
  t_slot_joints(PowerSupply_thickness-thickness, thickness=thickness);

  translate([PowerSupply_thickness - thickness/2,0])
  t_slot_joints(box_height-thickness, thickness=thickness);
}

module PowerSupplyBox_back_face(){
  PowerSupplyBox_front_face();
}


module PowerSupplyBox_side_sheet(){
  BillOfMaterials(category="Lasercut wood", partname="Power Supply Box side sheet");

  if (render_lasercut){
    color(sheet_color){
      linear_extrude(height=thickness)
      PowerSupplyBox_side_face();
    }
  }
}

module PowerSupplyBox_bottom_sheet(){
  BillOfMaterials(category="Lasercut wood", partname="Power Supply Box bottom sheet");

  if (render_lasercut){
    color(sheet_color){
      linear_extrude(height=thickness)
      PowerSupplyBox_bottom_face();
    }
  }
}

module PowerSupplyBox_front_sheet(){
  BillOfMaterials(category="Lasercut wood", partname="Power Supply Box front sheet");

  if (render_lasercut){
    color(sheet_color){
      linear_extrude(height=thickness)
      PowerSupplyBox_front_face();
    }
  }
}

module PowerSupplyBox_back_sheet(){
  BillOfMaterials(category="Lasercut wood", partname="Power Supply Box back sheet");

  if (render_lasercut){
    color(sheet_color){
      linear_extrude(height=thickness)
      PowerSupplyBox_back_face();
    }
  }
}


module PowerSupplyBox(){
  translate([0,-box_height+thickness+bottom_offset,PowerSupply_thickness - thickness])
  PowerSupplyBox_side_sheet();

  translate([0,-box_height+bottom_offset+thickness,0])
  rotate([90,0,0])
  PowerSupplyBox_bottom_sheet();

  translate([thickness*(1+1/2),-box_height+bottom_offset+thickness,0])
  rotate([0,-90,0])
  PowerSupplyBox_front_sheet();

  translate([PowerSupply_width - thickness/2,-box_height+bottom_offset+thickness,0])
  rotate([0,-90,0])
  PowerSupplyBox_back_sheet();
}
