// (c) 2013 Felipe C. da S. Sanches <fsanches@metamaquina.com.br>
// Licensed under the terms of the GNU General Public License
// version 3 (or later).

include <Metamaquina-config.scad>;
include <NEMA-dimensions.scad>;
use <lasercut_extruder.scad>;
use <tslot.scad>;
use <rounded_square.scad>;
use <608zz_bearing.scad>;
use <washers.scad>;
use <nuts.scad>;
use <domed_cap_nuts.scad>;
use <RAMBo.scad>;
use <NEMA.scad>;
use <mm2logo.scad>;
use <endstop.scad>;
use <jhead.scad>;
//use <pulley.scad>;

use <ZLink.scad>;
include <ZLink-params.scad>;

m8_nut_height = 6.3; //TODO: check the datasheets
m8_washer_height = 1.5; //TODO: check the datasheets
lm8uu_diameter = 15;
lm8uu_length=24;
sandwich_hexspacer_length = 12; //TODO: check availability
RAMBo_x = 1;
RAMBo_y = 133;

//platic parts
use <belt-clamp.scad>;
use <bar-clamp.scad>;
use <coupling.scad>;

pcbextra = 5; //extra space to the rear of the pcb that holds the connector.
rods_diameter_clearance = 0.1 //extra room for the X and Z rods

//For the actual build volume we avoid using the marginal
//region around the heated bed

HeatedBed_X = BuildVolume_X + 15; // 215 mm
HeatedBed_Y = BuildVolume_Y + 15 + pcbextra; // 220 mm

hack_couplings = 5; // for astethical purposes, the z-couplings are animated rotating <hack_couplings> times slower than the correct mechanical behaviour

time = $t;
function carx_demo(time) = sin(360*time*7)*BuildVolume_X/2;
function cary_demo(time) = cos(360*time*7)*BuildVolume_Y/2;
//function carz_demo(time) = (0.5+0.5*sin(360*time))*0.3*BuildVolume_Y/2 + 0.7*BuildVolume_Y/2;
function carz_demo(time) = time*BuildVolume_Z;
function coupling_demo(time) = (360*carz_demo(time)/1.25)/hack_couplings;

/* Positioning of the extruder assembly */
XCarPosition = carx_demo(time);
YCarPosition = cary_demo(time);
ZCarPosition = carz_demo(time);

//-------------------------

//machine configs:

/* whether or not to add holes for a PowerSupply manufactured by Hiqua and sold 
by Nodaji in Brazil */
HIQUA_POWERSUPPLY=true;

powersupply_cut_width = 25;

/* dimensions of the machine feet */
feetwidth = 50;
feetheight = 12;

/*Here are a bunch of constants that determine the overall positioning 
and dimensions of the several acrylic/plywood panels:*/

BuildPlatform_SidePanels_distance = 40;
SidePanels_distance = HeatedBed_X + 2*BuildPlatform_SidePanels_distance;

RightPanel_baseheight = 92;
RightPanel_basewidth = 2*(HeatedBed_Y)+10;

//Z_rods_distance = 388; //PrusaAir2
Z_rods_distance = SidePanels_distance + 2*(z_rod_z_bar_distance + NEMA17_width/2 + 5);

//TODO: machine_width = ?;
machine_height = BuildVolume_Z + 207.2; //why?

XZStage_offset = 20;
XZStage_position = RightPanel_basewidth/2 + XZStage_offset;
z_max_endstop_x = XZStage_position - 40;
z_max_endstop_y = machine_height - 25;

baseh = 35;
ArcPanel_rear_advance = 105;
horiz_bars_length = SidePanels_distance + 2*(m8_nut_height + m8_washer_height);
base_bars_height = 17;
base_bars_Zdistance = 50;

bar_cut_length=13;
Y_rod_length = RightPanel_basewidth - 2*(bar_cut_length + m8_diameter/2) + 24;
Y_rod_height = base_bars_Zdistance + base_bars_height + 10.2;//TODO
BottomPanel_width=60;
Z_rod_sidepanel_distance = (Z_rods_distance - SidePanels_distance)/2 + thickness;

YPlatform_height = Y_rod_height + lm8uu_diameter/2;
pcb_height = YPlatform_height + 10;
BuildPlatform_height = pcb_height+2;

//machine_x_dim is the actual width of the whole machine
machine_x_dim = Z_rods_distance+2*(lm8uu_diameter/2+thickness);

XEnd_extra_width = 30;
XEnd_box_size = lm8uu_diameter/2 + z_rod_z_bar_distance + ZLink_rod_height;

//height of the bottom panel acrylic/plywood sheet:
BottomPanel_zoffset = feetheight + NEMA17_length;

Z_rod_length = machine_height - BottomPanel_zoffset + thickness;
Z_bar_length = thickness + machine_height - BottomPanel_zoffset - motor_shaft_length;

margin=4;
tslot_extra=thickness+margin; //todo
XPlatform_width = X_rods_distance + X_rods_diameter + 2*margin + 2* tslot_extra;
XEnd_width = XPlatform_width+XEnd_extra_width;
num_extruders = 1;
extra_extruder_length = 50; //TODO
XCarriage_padding = 6;
XCarriage_nozzle_hole_radius = 20;
XCarriage_width = XPlatform_width + 22;
//XCarriage_width = XPlatform_width;
//XCarriage_width = XEnd_width;
XCarriage_length = 82 + (num_extruders-1) * extra_extruder_length;
XCarriage_lm8uu_distance = XCarriage_length - 30;

nozzle_tip_distance = 17; //TODO: calculate this based on nozzle_total_length and XCarriage acrylic/plywood height

nozzle_hole_width = 50;
nozzle_hole_length = machine_x_dim - 2*XEnd_box_size - nozzle_hole_width - 2*thickness - 2*20;

belt_offset = 26;
belt_width=5;
belt_clamp_height = 9;
PulleyRadius = 6;
IdlerRadius = 11;
XMotor_height = 31;
XIdler_height = XMotor_height + PulleyRadius - IdlerRadius;
X_rod_length = machine_x_dim - 2*thickness;
X_rod_height = XMotor_height + PulleyRadius - lm8uu_diameter/2 - 2*thickness;

RightPanel_backwidth = 55;
RightPanel_backheight = machine_height - RightPanel_baseheight;

rear_backtop_advance = XZStage_position - (XPlatform_width/2 + XEnd_extra_width + 10) - RightPanel_backwidth;

RightPanel_topheight = 35;
RightPanel_topwidth = XZStage_position + 30 - rear_backtop_advance;

module bar_cut(l=2*bar_cut_length){
    translate([-l/2,0]) circle(r=m8_diameter/2);
    square([l, m8_diameter], center=true);
    translate([l/2,0]) circle(r=m8_diameter/2);
}


bolts = [
/*BottomPanel*/
  [SidePanels_distance/2,   BottomPanel_width*(3/4), BottomPanel_zoffset,      0, 90,0],
  [SidePanels_distance/2,  -BottomPanel_width*(3/4), BottomPanel_zoffset,      0, 90,0],
  [-SidePanels_distance/2,  BottomPanel_width*(3/4), BottomPanel_zoffset,      0,-90,0],
  [-SidePanels_distance/2, -BottomPanel_width*(3/4), BottomPanel_zoffset,      0,-90,0],
/*TopPanel*/
  [-SidePanels_distance/2+thickness/2, 0, machine_height + thickness,      0,0,0],
/*RightPanel*/
/*LeftPanel*/

];

if (preview_metal && render_bolts){
  color(metal_color){
    for (p = bolts){
      translate([p[0],p[1],p[2]])
      rotate([p[3],p[4],p[5]])
      t_slot_bolt_washer_nut(3,16);
    }
  }
}

// 2d shapes for laser-cutting:

//This is based on measurements of
// a HIQUA power supply
PowerSupply_width=110;
PowerSupply_height=198;
PowerSupply_thickness=50;
module HiquaPowerSupply_holes(){
  translate([5, 6])
  circle(r=5/2, $fn=20);

  translate([6, PowerSupply_height - 22])
  circle(r=5/2, $fn=20);

  translate([PowerSupply_width - 5, 5])
  circle(r=5/2, $fn=20);

  translate([PowerSupply_width - 12, PowerSupply_height - 21])
  circle(r=5/2, $fn=20);
}

module HiquaPowerSupply(){
  if (preview_powersupply){
    color(powersupply_color){
      cube([PowerSupply_thickness, PowerSupply_width, PowerSupply_height]);
    }
  }
}

module RodEndTop_face(){
  RodEnd_face(z_rod_z_bar_distance+8);
}

module SecondaryRodEndTop_face(){
  SecondaryRodEnd_face(z_rod_z_bar_distance+8);
}

module RodEndBottom_face(){
  RodEnd_face(0, third_hole=false);
}

module RodEnd_face(L, third_hole=true){
  R=12;
  r=6;
  difference(){
    union(){
      translate([-R,-R])
      rounded_square([R,2*R], corners=[R,0,R,0]);
      translate([0,-R])
      rounded_square([L+r,2*R], corners=[0,r,0,r]);
    }

    //holes
    translate([L, -(R-4)])
    circle(r=m3_diameter/2, $fn=20);
    translate([L, (R-4)])
    circle(r=m3_diameter/2, $fn=20);

    if (third_hole){
      translate([-(R-4), 0])
      circle(r=m3_diameter/2, $fn=20);
    }
  }
}

//!SecondaryRodEnd_face(z_rod_z_bar_distance+8);
module SecondaryRodEnd_face(L, third_hole=true){
  R=12;
  r=6;
  difference(){
    RodEnd_face(L, third_hole=true);

    circle(r=(m8_diameter + rods_diameter_clearance)/2, $fn=20);

    translate([L-8,0])
    circle(r=m8_diameter/2 + 2, $fn=20);
  }
}

module YMotorHolder_face(){
  r = 12;
  H = (50-2*r)*sqrt(2) + 2*r;
  hack=r*0.8;

  render(){
    difference(){
      union(){
        polygon(points=[[base_bars_height + base_bars_Zdistance/2 - H/2 + hack, 0], [base_bars_height + base_bars_Zdistance/2 - H/2, 0], [base_bars_height + base_bars_Zdistance/2 - H/2, 50+r], [base_bars_height + base_bars_Zdistance/2 + H/2, 50+r], [base_bars_height + base_bars_Zdistance/2 + H/2, 30]]);

        translate([base_bars_height,0])
        rotate([0,0,30]) circle(r=r, $fn=6);
        translate([base_bars_height + base_bars_Zdistance,30])
        rotate([0,0,30]) circle(r=r, $fn=6);

        translate([base_bars_height + base_bars_Zdistance/2, 60])
        rotate([0,0,-45])
        rounded_square([50,50], corners=[r,r,r,r], center=true);
      }    

      translate([base_bars_height + base_bars_Zdistance/2, 60])
      rotate([0,0,-45])
      NEMA17_holes();

      //holes for rear bars
      translate([base_bars_height,0])
      rotate([0,0,30]) circle(r=m8_diameter/2, $fn=20);
      translate([base_bars_height + base_bars_Zdistance,30])
      rotate([0,0,30]) circle(r=m8_diameter/2, $fn=20);
    }
  }
}


module holes_for_motor_wires(){
  height=40;
  x=120;
  heights = [60,120,180];

  translate([210, height])
  zip_tie_holes();

  translate([x+20, height])
  zip_tie_holes();

  translate([x, height-10])
  rotate([0,0,45])
  zip_tie_holes(d=7);

  translate([50, height-10])
  zip_tie_holes(d=5);

  for (h = heights){
    translate([x, h])
    rotate([0,0,90])
    zip_tie_holes(d=20);
  }

}

//!MachineLeftPanel_face();
module MachineLeftPanel_face(){
  difference(){
    MachineSidePanel_face();

    translate([RAMBo_x, RAMBo_y]){
      RAMBo_holes();
      RAMBo_wiring_hole();
    }

    translate([z_max_endstop_x, z_max_endstop_y])
      for (i=[-1,1])
        translate([endstop_holder_width/2+i*microswitch_holes_distance/2,-endstop_holder_height/2])
        circle(r=m3_diameter/2, $fn=20);

    holes_for_motor_wires();
    //holes_for_z_endstop_wires();
    //holes_for_x_motor_and_endstop_wires();
    //holes_for_endstops();
  }
}

module holes_for_endstops(){
  translate([30,265])
  zip_tie_holes();
}

module holes_for_z_endstop_wires(){
  translate([80,337]){
    zip_tie_holes(d=7);

    translate([7,0])
    hull()
    zip_tie_holes(r=2, d=10);

    translate([120,0])
    zip_tie_holes(d=7);

    translate([60,0])
    zip_tie_holes(d=7);
  }
}

module holes_for_x_motor_and_endstop_wires(){
  translate([80,240]){
    hull(){
      rotate([0,0,90])
      zip_tie_holes(d=12, r=2);
    }

    translate([0,10])
    rotate([0,0,90])
    zip_tie_holes(d=12);
  }
}

powersupply_Yposition = base_bars_height*2 + 5;

//!MachineRightPanel_face();
module MachineRightPanel_face(){
  difference(){
    MachineSidePanel_face();

    if (HIQUA_POWERSUPPLY){
      translate([rear_backtop_advance+RightPanel_backwidth - PowerSupply_width - XZStage_offset, powersupply_Yposition])
      HiquaPowerSupply_holes();
    }

    //holes for zipties to hold the power supply cord
    translate([30 + feetwidth/2,feetheight*2]){
      zip_tie_holes();

      translate([10,0])
      zip_tie_holes();
    }

    //zip-tie holes for RAMBo power wires
    translate([30 + feetwidth,feetheight*2.5]){
      translate([10,-3])
      rotate([0,0,90])
      zip_tie_holes();

      translate([20,2])
      zip_tie_holes(d=10);

      translate([120,10])
      zip_tie_holes();
    }
    

    //hole for power supply wiring
    translate([30 + feetwidth,feetheight])
    rounded_square([powersupply_cut_width, feetheight], corners=[0,0,5,5]);
  }
}

//!MachineSidePanel_face();
module MachineSidePanel_face(){
  union(){
    difference(){
      MachineSidePanel_plainface();

      //holes for inserting front bars
      translate([30, base_bars_height]) bar_cut();
      translate([0, base_bars_Zdistance + base_bars_height]) bar_cut();

      //holes for inserting rear bars
      translate([RightPanel_basewidth-30, base_bars_height]) bar_cut();
      translate([RightPanel_basewidth, base_bars_Zdistance + base_bars_height]) bar_cut();

      //cut for attaching bottom panel
      if (zmotors_on_top){
        //in case ZMotors are installed on the top
        translate([XZStage_position, feetheight]){
          translate([BottomPanel_width/2 + BottomPanel_width/4, thickness/2])
          circle(r=m3_diameter/2, $fn=20);

          translate([-BottomPanel_width/2, 0])
          square([BottomPanel_width, thickness]);

          translate([-BottomPanel_width/2 - BottomPanel_width/4, thickness/2])
          circle(r=m3_diameter/2, $fn=20);
        }
      } else {
        //in case ZMotors are installed on the bottom
        translate([XZStage_position, BottomPanel_zoffset]){
          translate([BottomPanel_width/2 + BottomPanel_width/4, thickness/2])
          circle(r=m3_diameter/2, $fn=20);

          translate([-BottomPanel_width/2, 0])
          square([BottomPanel_width, thickness]);

          translate([-BottomPanel_width/2 - BottomPanel_width/4, thickness/2])
          circle(r=m3_diameter/2, $fn=20);
        }

        //hole for z motors wiring
        translate([XZStage_position - 12, feetheight-5])
        rounded_square([24, 24+5], corners=[5,5,5,5]);

      }

      //tslots for top panel
      translate([rear_backtop_advance, machine_height+thickness]){
        translate([5, 0])
        rotate([0,0,180])
        t_slot_shape(3, 16);

        translate([RightPanel_topwidth-25, 0])
        rotate([0,0,180])
        t_slot_shape(3, 16);
      }

      //tslots for arc panel
      translate([XZStage_position - ArcPanel_rear_advance + thickness/2, machine_height]){
        translate([0, -50])
        TSlot_holes();

        //translate([0, -ArcPanel_height/2 - 25])
        //TSlot_holes();

        translate([0, -ArcPanel_height])
        TSlot_holes();
      }

      if (zmotors_on_top){     
        //tslot for bottom panel
        translate([XZStage_position,feetheight])
        t_slot_shape(3, 16);
      }
    }

    //tslots for top panel
    translate([rear_backtop_advance-20, machine_height+thickness/2])
    rotate([0,0,-90])
    TSlot_joints();

    translate([rear_backtop_advance + RightPanel_topwidth - 50, machine_height+thickness/2])
    rotate([0,0,-90])
    TSlot_joints();

    if (zmotors_on_top){
      //tslot for bottom panel
      translate([XZStage_position + BottomPanel_width/2, feetheight + thickness/2])
      rotate([0,0,90])
      TSlot_joints(BottomPanel_width);
    }
  }
}

//!MachineRightPanel_face();

//!MachineSidePanel_plainface();
module MachineSidePanel_plainface(){
  r1=0.1;
  r2=60;
  H=150;
  k=19;
  union(){
    hull($fn=80){
      translate([rear_backtop_advance-k, machine_height-r1]) circle(r=r1);
      translate([r2, RightPanel_baseheight + H]) circle(r=r2);
    }

    //top
    translate([rear_backtop_advance, machine_height - RightPanel_topheight])
    rounded_square([RightPanel_topwidth, RightPanel_topheight], corners=[0, 15, 0, 0]);

    //back
    translate([rear_backtop_advance, RightPanel_baseheight])
    square([RightPanel_backwidth, RightPanel_backheight]);
    polygon(points = [ [rear_backtop_advance-k, machine_height], [rear_backtop_advance, machine_height], [rear_backtop_advance, RightPanel_baseheight], [0,RightPanel_baseheight], [0,RightPanel_baseheight + H]]);

    //base
    translate([0,RightPanel_baseheight - baseh])
    rounded_square([RightPanel_basewidth, baseh], corners=[0,0,0,15]);

    polygon(points = [ [30, feetheight], [0,RightPanel_baseheight - baseh], [30,RightPanel_baseheight - baseh]]);
    translate([30, feetheight])
    square([RightPanel_basewidth-60,RightPanel_baseheight - feetheight]);
    polygon(points = [ [RightPanel_basewidth-30, feetheight], [RightPanel_basewidth,RightPanel_baseheight - baseh], [RightPanel_basewidth-30,RightPanel_baseheight - baseh]]);

    //feet
    translate([RightPanel_basewidth-30-feetwidth,0])
    rounded_square([feetwidth, feetheight], corners=[5, 5, 0, 0]);
    translate([30,0])
    rounded_square([feetwidth, feetheight], corners=[5, 5, 0, 0]);
  }
}

module TopPanel_holes(){
  translate([Z_rods_distance/2,0]){
    //holes for Zrod and Zbar
    circle(r=(m8_diameter + 2*rods_diameter_clearance)/2, $fn=20);
    translate([8, 0]) circle(r=m3_diameter/2, $fn=20);
    translate([-z_rod_z_bar_distance - 8, -8]) circle(r=m3_diameter/2, $fn=20);
    translate([-z_rod_z_bar_distance - 8, 8]) circle(r=m3_diameter/2, $fn=20);

    if (zmotors_on_top){
      translate([-z_rod_z_bar_distance,0]){
        //holes for Z motors
        NEMA17_holes();

        //hole for zmotor wiring
        translate([0,40])
        rounded_square([6,16], corners=[3,3,3,3], center=true);
      }
    } else {
      translate([-z_rod_z_bar_distance,0]){
        //This hole's diameter is considerably larger than the threaded rod diameter
        // in order to allow slightly bent rods to freely move. Otherwise, we would potentially have more whobble as a result of a tightly fixed rod.
        circle(r=(m8_diameter+4)/2, $fn=20);
      }
    }

    translate([0,-30-25]){
      translate([-Z_rod_sidepanel_distance + thickness/2, 25])
        TSlot_holes();

      translate([-Z_rod_sidepanel_distance + thickness/2, RightPanel_topwidth-5])
        TSlot_holes();
    }
  }
}

ArcPanel_width = SidePanels_distance - 2 * thickness;
ArcPanel_height = 140; //TODO: make it depend on the machine height
module MachineArcPanel_face(){
  render(){
    difference(){
      union(){
        translate([-ArcPanel_width/2, ArcPanel_height - 53])
        square([ArcPanel_width,53]);

        translate([-ArcPanel_width/2, 0])
        rounded_square([20,ArcPanel_height], corners=[5,5,5,5]);
        translate([+ArcPanel_width/2-20, 0])
        rounded_square([20,ArcPanel_height], corners=[5,5,5,5]);

        polygon(points=[ [-ArcPanel_width/2, 0], [-ArcPanel_width/2, ArcPanel_height],[-ArcPanel_width/2 + 60, ArcPanel_height], [-ArcPanel_width/2 + 10, 0] ]);

        polygon(points=[ [ArcPanel_width/2, 0], [ArcPanel_width/2, ArcPanel_height],[ArcPanel_width/2 - 60, ArcPanel_height], [ArcPanel_width/2 - 10, 0] ]);

        //tslots for top panel
        translate([0,ArcPanel_height + thickness/2]){
          translate([-ArcPanel_width/2, 0])
          rotate([0,0,-90])
          TSlot_joints();

          translate([25, 0])
          rotate([0,0,90])
          TSlot_joints();

          translate([ArcPanel_width/2, 0])
          rotate([0,0,90])
          TSlot_joints();
        }

        //tslots for left panel
        translate([-ArcPanel_width/2 - thickness/2, 0]){
          translate([0, ArcPanel_height - 50])
          TSlot_joints();

          //translate([0, ArcPanel_height/2 - 25])
          //TSlot_joints();

          TSlot_joints();
        }

        //tslots for right panel
        translate([ArcPanel_width/2 + thickness/2, 0]){
          translate([0, ArcPanel_height - 50])
          TSlot_joints();

          //translate([0, ArcPanel_height/2 - 25])
          //TSlot_joints();

          TSlot_joints();
        }
      }


      //Metamaquina2 logo
      translate([-191/2, ArcPanel_height - 44])
        MM2_logo();

      //tslots for top panel
      translate([0,ArcPanel_height + thickness]){
        translate([-ArcPanel_width/2 + 25, 0])
        rotate([0,0,180])
        t_slot_shape(3,16);

        rotate([0,0,180])
        t_slot_shape(3,16);

        translate([ArcPanel_width/2 - 25, 0])
        rotate([0,0,180])
        t_slot_shape(3,16);
      }

      //tslots for right panel
      translate([ArcPanel_width/2 + thickness, 0]){
        translate([0, 25])
        rotate([0,0,90])
        t_slot_shape(3,16);

/*
        translate([0, ArcPanel_height/2])
        rotate([0,0,90])
        t_slot_shape(3,16);
*/


        translate([0, ArcPanel_height - 25])
        rotate([0,0,90])
        t_slot_shape(3,16);
      }

      //tslots for left panel
      translate([-ArcPanel_width/2 - thickness, 0]){
        translate([0, 25])
        rotate([0,0,-90])
        t_slot_shape(3,16);

/*
        translate([0, ArcPanel_height/2])
        rotate([0,0,-90])
        t_slot_shape(3,16);
*/

        translate([0, ArcPanel_height - 25])
        rotate([0,0,-90])
        t_slot_shape(3,16);
      }
    }
  }
}

module top_hole_for_extruder_wires(){
  translate([0,120])
  rotate([0,0,90])
  hull(){
    zip_tie_holes(d=16, r=4);
  }
}

//!MachineTopPanel_face();
module MachineTopPanel_face(){
  sidewidth=78;
  difference(){
    union(){
      translate([-machine_x_dim/2,-30])
      rounded_square([sidewidth, 60], corners=[30, 2, 0, 0]);

      translate([machine_x_dim/2 - sidewidth,-30])
      rounded_square([sidewidth, 60], corners=[2, 30, 0, 0]);

      translate([0,60]){
        translate([-machine_x_dim/2,-30])
        rounded_square([sidewidth, 100], corners=[0, 0, sidewidth, 0], $fn=90);

        translate([machine_x_dim/2 - sidewidth,-30])
        rounded_square([sidewidth, 100], corners=[0, 0, 0, sidewidth], $fn=90);
      }

      translate([0,127])
      rounded_square([Z_rods_distance - 2*Z_rod_sidepanel_distance + 8*thickness, 61], corners=[10,10,10,10], center=true);
    }

    top_hole_for_extruder_wires();    

    //tslots for arc panel
    translate([0,ArcPanel_rear_advance - thickness/2]){
      translate([-ArcPanel_width/2, 0])
      rotate([0,0,-90])
      TSlot_holes();

      translate([25, 0])
      rotate([0,0,90])
      TSlot_holes();

      translate([ArcPanel_width/2, 0])
      rotate([0,0,90])
      TSlot_holes();
    }

    TopPanel_holes(); 
    mirror([1,0,0]) TopPanel_holes();
  }
}

module BottomPanel_holes(){
    //holes for Z rods
    translate([Z_rods_distance/2,0]){
      circle(r=(m8_diameter + 2*rods_diameter_clearance)/2);
      translate([0, -8]) circle(r=m3_diameter/2, $fn=20);
      translate([0, 8]) circle(r=m3_diameter/2, $fn=20);
      //translate([8, 0]) circle(r=m3_diameter/2, $fn=20);
    }

    //holes for ZMotors
    translate([Z_rods_distance/2 - z_rod_z_bar_distance, 0])
    NEMA17_holes(r=27/2); //This should be large enough to let the coupling pass through the hole

    //tslot cuts for side panels
    translate([Z_rods_distance/2 - Z_rod_sidepanel_distance + thickness, -BottomPanel_width/2 -BottomPanel_width/4])
    rotate([0,0,90])
    t_slot_shape(3,16);

    translate([Z_rods_distance/2 - Z_rod_sidepanel_distance + thickness, BottomPanel_width/2 + BottomPanel_width/4])
    rotate([0,0,90])
    t_slot_shape(3,16);

    translate([-Z_rods_distance/2 + Z_rod_sidepanel_distance + thickness,0]){
      translate([16,0])
      zip_tie_holes();

      translate([60,0])
      zip_tie_holes();
    }

    zip_tie_holes();
}

module heatedbed_bottompanel_hole(){
    zip_tie_holes();
    translate([6,0])
    hull(){
     zip_tie_holes(r=2);
    }
}

module zip_tie_holes(d=12, r=m3_diameter/2){
  for (i=[-1,1]){
    translate([0,d/2*i])
    circle(r=r, $fn=30);
  }
}

module Y_belt(){
  if (preview_rubber){
  	color(rubber_color){
      translate([2.5, 0, 66])
      rotate([0,0,-90])
      rotate([90,0,0]){
        belt(bearings = [
              [/*x:*/ RightPanel_basewidth/2 - bar_cut_length,
               /*y:*/ 0,
               /*r:*/ IdlerRadius],

              [/*x:*/ -RightPanel_basewidth/2 + bar_cut_length,
               /*y:*/ 0,
               /*r:*/ IdlerRadius],

              [/*x:*/ -RightPanel_basewidth/2 + bar_cut_length + 30,
               /*y:*/ -base_bars_Zdistance,
               /*r:*/ IdlerRadius]
             ],
             belt_width = belt_width);
      }
    }
  }
}

module YEndstopHolder_face(){
  width = 25;
  height = 20;
  r = 5;
  translate([-width/2,0])
  difference(){
    union(){
      rounded_square([width,height], corners=[0,0,r,r]);

      translate([width,-thickness/2])
      rotate(90)
      TSlot_joints(width);
    }

    translate([width/2,-thickness])
    t_slot_shape(3,16);
  }
}

module YEndstopHolder_sheet(){
  if( preview_lasercut ){
    color(sheet_color){
      linear_extrude(height=thickness)
      YEndstopHolder_face();
    }
  }
}

//!MachineBottomPanel_face();
module MachineBottomPanel_face(){
  render(){
    difference(){
      union(){
        rounded_square([machine_x_dim, BottomPanel_width], corners=[BottomPanel_width/2,BottomPanel_width/2,BottomPanel_width/2,BottomPanel_width/2], center=true);
        square([Z_rods_distance - 2*Z_rod_sidepanel_distance, 2*BottomPanel_width], center=true);
      }

      //cut off some unnecessary material
      translate([0,BottomPanel_width/2 + 30])
      rounded_square([Z_rods_distance - 2*Z_rod_sidepanel_distance - 60, BottomPanel_width], corners=[30,30,30,30], center=true);
      translate([0,-BottomPanel_width/2 - 30])
      rounded_square([Z_rods_distance - 2*Z_rod_sidepanel_distance - 60, BottomPanel_width], corners=[30,30,30,30], center=true);

      BottomPanel_holes();
      mirror([1,0,0]) BottomPanel_holes();

      translate([-Z_rods_distance/2 + Z_rod_sidepanel_distance + thickness + 16, 24])
      heatedbed_bottompanel_hole();

      //holes for YMIN endstop
      translate([30, 0]){
      for (i=[-1,1])
        translate([-10,24])
          hull()
            for (j=[-1,1])
              translate([-5,-5+j*5])
              circle(r=m3_diameter, $fn=20);
        for (i=[-1,1])
          translate([i*microswitch_holes_distance/2,10])
            M25_hole();
      }

      //holes for YMAX endstop
      translate([-30, 0]){
        translate([-10,-24])
          hull()
            for (j=[-1,1])
              translate([-5,5+j*5])
              circle(r=m3_diameter, $fn=20);
        for (i=[-1,1])
          translate([i*microswitch_holes_distance/2,-10])
            M25_hole();
      }

    }
  }
}

//!XPlatform_bottom_face();
module XPlatform_bottom_face(){
  render(){
    difference(){
	    union(){
	    	translate([-machine_x_dim/2 + thickness, -XPlatform_width/2])
	      square([machine_x_dim - 2 * thickness, XEnd_width]);

	    	translate([-machine_x_dim/2 + thickness, -XPlatform_width/2])
	    	square([XEnd_box_size+thickness, XEnd_width]);

	    	translate([+machine_x_dim/2 - 2*thickness - XEnd_box_size, -XPlatform_width/2])
	    	square([XEnd_box_size+thickness, XEnd_width]);
	    }

      //hole for extruder nozzle:
      square([nozzle_hole_length, nozzle_hole_width], center=true);
      translate([nozzle_hole_length/2,0]) circle(r=nozzle_hole_width/2);
      translate([-nozzle_hole_length/2,0]) circle(r=nozzle_hole_width/2);

      rotate([0,0,180])
      translate([-machine_x_dim/2, 0])
	    XEndIdler_bottom_holes();

      translate([-machine_x_dim/2, 0])
	    XEndMotor_bottom_holes();
    }
  }
}

module XEndMotor_bottom_holes(){
  r=2;

  //hole for lm8uu holder
  translate([0, -20])
  rounded_square([sandwich_hexspacer_length + 3*thickness + r, 40], corners=[0,r,0,r]);

  //hole for M8 nut&rod
  translate([thickness + XEnd_box_size - ZLink_rod_height, 0])
  rotate([0,0,360/12]) circle(r=8.5, $fn=6);

  //tslot holes
	translate([thickness, XPlatform_width/2 + XEnd_extra_width - thickness])
	rotate([0,0,-90])
	TSlot_holes(width=XEnd_box_size);

	translate([thickness, -XPlatform_width/2 + thickness])
	rotate([0,0,-90])
	TSlot_holes(width=XEnd_box_size);

}

module XEndIdler_bottom_holes(){
  r=2;

  //hole for lm8uu holder
  translate([0, -20])
  rounded_square([sandwich_hexspacer_length + 3*thickness + r, 40], corners=[0,r,0,r]);

  //hole for M8 nut&rod
  translate([thickness + XEnd_box_size - ZLink_rod_height, 0])
  rotate([0,0,360/12]) circle(r=8.5, $fn=6);

  //tslot holes
	translate([thickness, -XPlatform_width/2 - XEnd_extra_width + thickness])
	rotate([0,0,-90])
	TSlot_holes(width=XEnd_box_size);

	translate([thickness, XPlatform_width/2 - thickness])
	rotate([0,0,-90])
	TSlot_holes(width=XEnd_box_size);

}

module motor_face_head(round=18){
  translate([0,XPlatform_height-thickness])
  difference(){
    union(){
      translate([-thickness+round,0]) circle(r=round);

      translate([round-thickness, 0])
      square([XEnd_box_size+2*thickness-2*round, round]);

      translate([XEnd_box_size+thickness-round,0]) circle(r=round);
    }

    translate([-round,-round])
    square([XEnd_box_size + 2*round, round]);
  }
}

module XEnd_plain_face(){
  render(){
    difference(){
      union(){
        square([XEnd_box_size, XPlatform_height - thickness]);

        //bottom
        rotate([0, 0, -90])
        translate([thickness/2, 0])
        TSlot_joints(XEnd_box_size);

        translate([XEnd_box_size + thickness/2, 0])
        TSlot_joints(XPlatform_height - thickness);

        translate([-thickness/2, 0])
        TSlot_joints(XPlatform_height - thickness);
      }

    //bottom tslot
      translate([XEnd_box_size/2, -thickness])
      t_slot_shape(3,16);

    //left
      translate([XEnd_box_size + thickness, (XPlatform_height-thickness)/2])
      rotate([0,0,90])
      t_slot_shape(3, 16);

    //right
      translate([-thickness, (XPlatform_height-thickness)/2])
      rotate([0, 0, -90])
      t_slot_shape(3, 16);
    }
  }
}

module XEndMotor_plain_face(){
  XEnd_plain_face();
}

module XEndIdler_plain_face(){
  XEnd_plain_face();
}

module XEndIdler_belt_face(){
  difference(){
    XEnd_plain_face();
    translate([XEnd_box_size/2, XIdler_height - thickness])
    circle(r=m8_diameter/2);
  }
}

module XEndMotor_belt_face(){
  render(){
    difference(){
      union(){
        XEnd_plain_face();
        motor_face_head();
      }
      translate([XEnd_box_size/2, XMotor_height - thickness])
      NEMA17_holes();
    }
  }
}

module mm_logo(){
  translate([-10,-6])
  import("MM_logo_small.dxf");
}

//!XEndIdler_back_face();
module XEndIdler_back_face(){
  mirror([1,0])
  difference(){
    XEnd_back_face();
    translate([0,(40+thickness)/2])
    scale(2) mirror([1,0]) mm_logo();
  }
}

module XEndMotor_back_face(){
  difference(){
    XEnd_back_face();
    translate([0,(40+thickness)/2])
    scale(2) mm_logo();
  }
}

module XEnd_back_face(){
  render(){
    difference(){
      union(){
       translate([-XPlatform_width/2 - XEnd_extra_width, 0])
       rounded_square([XEnd_width, XPlatform_height], corners = [0, 0, thickness/2, thickness/2], $fn=80);

       //extra area for linear bearings
       circle(r=20);
       translate([0, XPlatform_height])
       circle(r=20);
      }

      //holes for bearing sandwich hexspacers
      translate([14, XPlatform_height])
      circle(r=m3_diameter/2, $fn=20);
      translate([-14, XPlatform_height])
      circle(r=m3_diameter/2, $fn=20);
      translate([14, 0])
      circle(r=m3_diameter/2, $fn=20);
      translate([-14, 0])
      circle(r=m3_diameter/2, $fn=20);

      translate([XPlatform_width/2 - thickness, thickness]){
        TSlot_holes(width=XPlatform_height - thickness);
      }

      translate([-XPlatform_width/2 - XEnd_extra_width + thickness, thickness]){
        TSlot_holes(width=XPlatform_height - thickness);
      }
    }
  }
}

module xend_bearing_sandwich_face(){
  translate([0,XPlatform_height/2])
  generic_bearing_sandwich_face(H=XPlatform_height);
}

module generic_bearing_sandwich_plainface(H, r){
  difference(){
    hull(){
      for (j=[-1,1])
        translate([0, j*H/2])
        circle(r=r, $fn=120);
    }

    for (i=[-1,1]){
      for (j=[-1,1]){
        translate([i*14, j*H/2])
        circle(r=m3_diameter/2, $fn=20);
      }
    }
  }
}

module LM8UU(){
  translate([0,12])
  rotate([90,0])
  cylinder(r=lm8uu_diameter/2,h=lm8uu_length);
}


module generic_bearing_sandwich_face(H, r=20, sandwich_tightening=1){
  projection(cut=true){
    difference(){
      linear_extrude(height=thickness)
      generic_bearing_sandwich_plainface(H, r);

      //linear bearings
      translate([0,0,lm8uu_diameter/2 - (sandwich_hexspacer_length + sandwich_tightening)]){
        for (j=[-1,1])
        translate([0,j*H/2])
        LM8UU();
      }
    }
  }
}

module XEnd_front_face(){
  difference(){
  	translate([-XPlatform_width/2 - XEnd_extra_width, thickness])
	  rounded_square([XEnd_width, XPlatform_height - thickness], corners=[0,0,thickness/2,thickness/2], $fn=80);
	  
    //holes for x-axis rods
    translate([X_rods_distance/2, X_rod_height + thickness])
    circle(r=(X_rods_diameter + rods_diameter_clearance)/2);

    translate([-X_rods_distance/2, X_rod_height + thickness])
    circle(r=(X_rods_diameter + rods_diameter_clearance)/2);

    //screw holes for z-axis threaded bar
    for (i=[-1,1])
      translate([i*dx_z_threaded, thickness+Zlink_hole_height])
      circle(r=m3_diameter/2, $fn=20);

    //hole for belt
  	translate([-XPlatform_width/2 - XEnd_extra_width + belt_offset - 5, XIdler_height])
    square([belt_width+6, 2*(IdlerRadius+4)], center=true);

    translate([XPlatform_width/2 - thickness, thickness]){
      TSlot_holes(width=XPlatform_height - thickness);
    }

    translate([-XPlatform_width/2 - XEnd_extra_width + thickness, thickness]){
      TSlot_holes(width=XPlatform_height - thickness);
    }
  }
}

module beltclamp_holes(){
  translate([0,9])  
  circle(r=m3_diameter/2, $fn=20);
  translate([0,-9])  
  circle(r=m3_diameter/2, $fn=20);
}

module wade_holes(){
  for (i=[-1,1])
  translate([0,i*extruder_mount_holes_distance/2])  
  circle(r=m4_diameter/2, $fn=20);
}

module XCarriage_sandwich_sheet(){
  if( preview_lasercut ){
    color(sheet_color){
      linear_extrude(height=thickness)
      XCarriage_sandwich_face();
    }
  }
}

module XCarriage_sandwich_face(){
  projection(cut=true){
    difference(){
      linear_extrude(height=thickness)
      XCarriage_plainface(true);

      //linear bearings
      translate([0, 0, lm8uu_diameter/2 - sandwich_hexspacer_length]){
        for (i=[-1,1]){
          for (j=[-1,1]){
            translate([i*XCarriage_lm8uu_distance/2, j*X_rods_distance/2])
            rotate([0,0,90])
            LM8UU();
          }
        }
      }
    }
  }
}

module M3_hole(){
  circle(r=m3_diameter/2, $fn=20);
}

m25_diameter = 2.5;
module M25_hole(){
  circle(r=m25_diameter/2, $fn=20);
}

module XEndstopHolder(){
  difference(){
    hull(){
      for (j=[-1,1]){
        translate([52,10*j])
        circle(r=5);

        translate([40,15*j])
        circle(r=5);
      }
    }

    for (j=[-1,1])
      translate([52,j*microswitch_holes_distance/2])
      M25_hole();
  }
}

module XCarriage_plainface(sandwich=false){
  difference(){
    if (sandwich){
      translate([-XCarriage_length/2, -XPlatform_width/2])
      rounded_square([XCarriage_length, XPlatform_width], corners=[10,10,10,10]);
    } else {
      translate([-XCarriage_length/2, -XPlatform_width/2])
      rounded_square([XCarriage_length, XPlatform_width], corners=[10,10,0,0]);

      //belt_clamp_area
      translate([29,43])
      belt_clamp_holder();

      //belt_clamp_area
      translate([-29,43])
      mirror([1,0])
      belt_clamp_holder();

      XEndstopHolder();
      mirror([1,0]) XEndstopHolder();
    }

    //central hole for extruder nozzle
    hull(){
      translate([-(num_extruders-1)*extra_extruder_length/2,0])
      circle(r=XCarriage_nozzle_hole_radius);

      translate([(num_extruders-1)*extra_extruder_length/2,0])
      circle(r=XCarriage_nozzle_hole_radius);
    }

    //hole for extruder wiring
    if (!sandwich){
      translate([-25,-10])
      rounded_square([25,20], corners=[5,5,5,5]);
    }

    //holes for attaching the wade extruder
    wade_holes();
    
    //holes for hexspacers
    for (i=[-1,1]){
      for (j=[-1,1]){
        translate([i*(XCarriage_lm8uu_distance/2), j*(XPlatform_width/2 - XCarriage_padding)])
        circle(r=m3_diameter/2, $fn=20);
      }
      translate([i*(XCarriage_length/2-XCarriage_padding), 0])
      circle(r=m3_diameter/2, $fn=20);
    }
  }
}

//!XCarriage_bottom_face();
module XCarriage_bottom_face(){
  difference(){
    XCarriage_plainface();

    //holes for beltclamps
    translate ([0, XPlatform_width/2 + XEnd_extra_width - belt_offset + belt_width]){
      for (i=[-1.3,1.3])
        translate([i*(XCarriage_lm8uu_distance/2+10), 0])
        beltclamp_holes();
    }
  }
}

// 3d preview of lasercut plates:

module XEnd_bearing_sandwich_sheet(){
  translate([thickness,0])
  for (x=[-14,14]){
    for (y=[0,45]){
      rotate([0,90,0])
      rotate([0,0,90])
      translate([x,y])
      hexspacer(h=sandwich_hexspacer_length);
    }
  }

  if( preview_lasercut ){
    color(sheet_color){
      translate([thickness + sandwich_hexspacer_length,0])
      rotate([0,90,0])
      rotate([0,0,90]){
        linear_extrude(height=thickness)
        xend_bearing_sandwich_face(H=XPlatform_height);
      }
    }
  }
}

module YMotorHolder(){
  if( preview_lasercut ){
    color(sheet_color){
      linear_extrude(height=thickness)
      YMotorHolder_face();
    }
  }
}

module RodEnd_ZTopLeft_sheet(){
  translate([-Z_rods_distance/2, -XZStage_offset, machine_height+thickness])
  RodEndTop_sheet();
}

module SecondaryRodEnd_ZTopLeft_sheet(){
  translate([-Z_rods_distance/2, -XZStage_offset, machine_height-thickness])
  SecondaryRodEndTop_sheet();
}

module RodEnd_ZTopRight_sheet(){
  translate([Z_rods_distance/2, -XZStage_offset, machine_height+thickness])
  rotate([0,0,180])
  RodEndTop_sheet();
}

module SecondaryRodEnd_ZTopRight_sheet(){
  translate([Z_rods_distance/2, -XZStage_offset, machine_height-thickness])
  rotate([0,0,180])
  SecondaryRodEndTop_sheet();
}

module RodEnd_ZBottomLeft_sheet(){
  translate([-Z_rods_distance/2, -XZStage_offset, BottomPanel_zoffset - thickness])
  RodEndBottom_sheet();
}

module RodEnd_ZBottomRight_sheet(){
  translate([Z_rods_distance/2, -XZStage_offset, BottomPanel_zoffset - thickness])
  rotate([0,0,180])
  RodEndBottom_sheet();
}

module RodEndTop_sheet(){
  if( preview_lasercut ){
    color(sheet_color){
      linear_extrude(height=thickness)
      RodEndTop_face();
    }
  }
}

module SecondaryRodEndTop_sheet(){
  if( preview_lasercut ){
    color(sheet_color){
      linear_extrude(height=thickness)
      SecondaryRodEndTop_face();
    }
  }
}

module RodEndBottom_sheet(){
  if( preview_lasercut ){
    color(sheet_color){
      linear_extrude(height=thickness)
      RodEndBottom_face();
    }
  }
}

module MachineRightPanel_sheet(){
  if( preview_lasercut ){
    color(sheet_color){
      translate([SidePanels_distance/2, RightPanel_basewidth/2, 0])
      rotate([0,0,-90])
      rotate([90,0,0])
      linear_extrude(height=thickness)
      MachineRightPanel_face();
    }
  }
}

module MachineLeftPanel_sheet(){
  if( preview_lasercut ){
    translate([-SidePanels_distance/2 + thickness, RightPanel_basewidth/2])
    rotate([0,0,-90])
    rotate([90,0,0]){
      color(sheet_color){
        linear_extrude(height=thickness)
        MachineLeftPanel_face();
      }

      translate([RAMBo_x, RAMBo_y, thickness])
      RAMBo();

      translate([z_max_endstop_x, z_max_endstop_y, thickness])      
      z_max_endstop();
    }
  }
}

module MachineTopPanel_sheet(){
  if( preview_lasercut ){
    color(sheet_color){
      translate([0,-XZStage_offset,machine_height])
      linear_extrude(height=thickness)
      MachineTopPanel_face();
    }
  }
}

module MachineBottomPanel_sheet(){
  if( preview_lasercut ){
    color(sheet_color){
      translate([0,-XZStage_offset,BottomPanel_zoffset])
      linear_extrude(height=thickness)
      MachineBottomPanel_face();
    }
  }
}

module MachineArcPanel_sheet(){
  if( preview_lasercut ){
    color(sheet_color){
      translate([0,ArcPanel_rear_advance-XZStage_offset, machine_height - ArcPanel_height])
      rotate([90,0,0])
      linear_extrude(height=thickness)
      MachineArcPanel_face();
    }
  }
}

module XCarriage_bottom_sheet(){
  if( preview_lasercut ){
    color(sheet_color){
      linear_extrude(height=thickness)
      XCarriage_bottom_face();
    }
  }
}

module XPlatform_bottom_sheet(){
  if( preview_lasercut ){
    color(sheet_color){
	    linear_extrude(height=thickness)
	    XPlatform_bottom_face();
    }
  }
}

module XEndMotor_back_face_sheet(){
  if( preview_lasercut ){
    color(sheet_color){
	    translate([thickness, 0, 0])
	    rotate([0,-90,0])
	    rotate([0,0,-90])
	    linear_extrude(height=thickness)
	    XEndMotor_back_face();
    }
  }
}

module XEndMotor_front_face_sheet(){
  if( preview_lasercut ){
    color(sheet_color){
	    translate([XEnd_box_size + 2*thickness, 0, 0])
	    rotate([0,-90,0])
	    rotate([0,0,-90])
	    linear_extrude(height=thickness)
	    XEnd_front_face();
    }
  }
}

module XEndIdler_back_face_sheet(){
  if( preview_lasercut ){
    color(sheet_color){
	    rotate([0,-90,0])
	    rotate([0,0,-90])
	    linear_extrude(height=thickness)
	    mirror([1,0]) XEndIdler_back_face();
    }
  }
}

module XEndIdler_front_face_sheet(){
  if( preview_lasercut ){
    color(sheet_color){
	    translate([- XEnd_box_size - thickness, 0, 0])
	    rotate([0,-90,0])
	    rotate([0,0,-90])
	    linear_extrude(height=thickness)
	    XEnd_front_face();
    }
  }
}

module XEndMotor_plain_face_sheet(){
  if( preview_lasercut ){
    color(sheet_color){
      translate([thickness, -XPlatform_width/2 + 1.5*thickness, thickness])
      rotate([90,0,0])
      linear_extrude(height=thickness)
      XEndMotor_plain_face();
    }
  }
}

module XEndMotor_belt_face_assembly(){
  if( preview_lasercut ){
    color(sheet_color){
      translate([0, thickness])
      linear_extrude(height=thickness)
      XEndMotor_belt_face();
    }
  }

  translate([0,0,thickness])
    XEndMotor_pulley();

  XMotor();
}

module XEndIdler_plain_face_sheet(){
  if( preview_lasercut ){
    color(sheet_color){
      translate([- thickness - XEnd_box_size, -XPlatform_width/2 + 1.5*thickness, thickness])
      rotate([90,0,0])
      linear_extrude(height=thickness)
      XEndIdler_plain_face();
    }
  }
}
  
module XEndIdler_belt_face_assembly(){
  if( preview_lasercut ){
    color(sheet_color){
      translate([- thickness - XEnd_box_size, XPlatform_width/2 + XEnd_extra_width - 0.5*thickness, thickness])
      rotate([90,0,0])
      linear_extrude(height=thickness)
      XEndIdler_belt_face();
    }
  }


  //TODO: positioning of this bearing

  if (true || preview_metal){
    color(metal_color){
      translate([-XEnd_box_size/2 - thickness, XPlatform_width/2 + XEnd_extra_width -2.5* thickness, XIdler_height])
      rotate([90,0,0]){
        cylinder(r=4, h=80, center=true, $fn=40);
        608zz_bearing(true);
      }
    }
  }

}

module Z_couplings(){
  if (preview_ABS){
    color(ABS_color){
      translate([-machine_x_dim/2 + thickness + lm8uu_diameter/2 + z_rod_z_bar_distance, -XZStage_offset, BottomPanel_zoffset + motor_shaft_length])
      coupling_pair();

      translate([machine_x_dim/2 - thickness - lm8uu_diameter/2 - z_rod_z_bar_distance, -XZStage_offset, BottomPanel_zoffset + motor_shaft_length])
      coupling_pair();
    }
  }
}

module coupling_pair(){
  rotate([0,0,coupling_demo(time)]){
    rotate([0,0,180])
    rotate([0,90,0])
    translate([0, 0, -4.5]) 
    coupling(c=0);

    rotate([0,90,0])
    translate([0, 0, -4.5]) 
    coupling(c=1);
  }
}

module belt(bearings, belt_width=5){
  linear_extrude(height=belt_width){
    difference(){
      hull(){
        for (b=bearings){
          assign(x=b[0], y=b[1], r=b[2]){
    		    translate([x,y])
            circle(r=r+2);
          }
        }
      }
      hull(){
        for (b=bearings){
          assign(x=b[0], y=b[1], r=b[2]){
		        translate([x,y])
            circle(r=r);
          }
        }
      }
    }
  }
}

module Xbelt(){
  if (preview_rubber){
  	color(rubber_color){
      translate([0, XPlatform_width/2 + XEnd_extra_width - belt_offset + thickness]){
        rotate([90,0,0]){
          belt(bearings = [
                [/*x:*/ -machine_x_dim/2 + thickness + XEnd_box_size/2,
                 /*y:*/ XMotor_height,
                 /*r:*/ 6],

                [/*x:*/ machine_x_dim/2 - thickness - XEnd_box_size/2,
                 /*y:*/ XIdler_height,
                 /*r:*/ IdlerRadius]
               ],
               belt_width = belt_width);
        }
      }
    }
  }
}

//!Xbelt();

module belt_clamps(){
  if (preview_lasercut){
    color(sheet_color){
      for (i=[-1.3,1.3])
      translate([XCarPosition + i*(XCarriage_lm8uu_distance/2+10),
                 XPlatform_width/2 + XEnd_extra_width - belt_offset + belt_width,
                 belt_clamp_height + 2*thickness + X_rod_height + lm8uu_diameter/2])
      rotate([0,0,90])
      rotate([180,0,0])
      beltclamp();
    }
  }
}

module XEndMotor_linear_bearings(){
  if (preview_metal){
    color(metal_color){
	    translate([thickness + lm8uu_diameter/2, 0, -12]){
        cylinder(r=lm8uu_diameter/2, h=lm8uu_length);
        translate([0, 0, XPlatform_height])
        cylinder(r=lm8uu_diameter/2, h=lm8uu_length);
      }
    }
  }
}

module XEndIdler_linear_bearings(){
  mirror([1,0])
  XEndMotor_linear_bearings();
}

module XCarriage_linear_bearings(){
  if (preview_metal){
    color(metal_color){
      translate([XCarPosition, 0, thickness + X_rod_height])
      for (i=[-1,1]){
        for (j=[-1,1]){
          translate([i*XCarriage_lm8uu_distance/2, j*X_rods_distance/2])
          rotate([0,0,90])
          LM8UU();
        }
      }
    }
  }
}

module XEndMotor_ZLink(){
  translate([thickness + lm8uu_diameter/2 + z_rod_z_bar_distance + ZLink_rod_height, 0, thickness + Zlink_hole_height])
  rotate([0,0,90])
  rotate([-90,0,0])
  ZLink();
}

module XEndIdler_ZLink(){
  translate([-thickness - lm8uu_diameter/2 - z_rod_z_bar_distance - ZLink_rod_height, 0, thickness + Zlink_hole_height])
  rotate([0,0,-90])
  rotate([-90,0,0])
  ZLink();
}

module XRods(){
  if (preview_metal){
    color(metal_color){
      translate([0, -X_rods_distance/2, thickness + X_rod_height])
      rotate([0,90,0])
      cylinder(r=8/2, h=X_rod_length, center=true);

      translate([0, X_rods_distance/2, thickness + X_rod_height])
      rotate([0,90,0])
      cylinder(r=8/2, h=X_rod_length, center=true);
    }
  }
}

module YRods(){
  if (preview_metal){
    color(metal_color){
      translate([Y_rods_distance/2, -Y_rod_length/2, Y_rod_height])
      rotate([-90,0,0])
      cylinder(r=8/2, h=Y_rod_length);

      translate([-Y_rods_distance/2, -Y_rod_length/2, Y_rod_height])
      rotate([-90,0,0])
      cylinder(r=8/2, h=Y_rod_length);
    }
  }
}

module ZRods(){
  if (preview_metal){
    color(metal_color){
      translate([-machine_x_dim/2 + thickness + lm8uu_diameter/2, -XZStage_offset, BottomPanel_zoffset])
      cylinder(r=8/2, h=Z_rod_length);

      translate([machine_x_dim/2 - thickness - lm8uu_diameter/2, -XZStage_offset,  BottomPanel_zoffset])
      cylinder(r=8/2, h=Z_rod_length);
    }
  }
}

module ZBars(){
  if (preview_threaded_metal){
    color(threaded_metal_color){
      translate([-machine_x_dim/2 + thickness + lm8uu_diameter/2 + z_rod_z_bar_distance, -XZStage_offset, BottomPanel_zoffset + motor_shaft_length])
      cylinder(r=m8_diameter/2, h=Z_bar_length);

      translate([machine_x_dim/2 - thickness - lm8uu_diameter/2 - z_rod_z_bar_distance, -XZStage_offset, BottomPanel_zoffset + motor_shaft_length])
      cylinder(r=m8_diameter/2, h=Z_bar_length);
    }
  }
}

XCarriage_height = thickness + X_rod_height + lm8uu_diameter/2;

module XCarriage(){
  //lasercut parts:
  translate([XCarPosition, 0, XCarriage_height]){
    XCarriage_bottom_sheet();
    translate([0,0,-sandwich_hexspacer_length]){

      for (i=[-1,1]){
        for (j=[-1,1]){
          translate([i*(XCarriage_lm8uu_distance/2), j*(XPlatform_width/2-XCarriage_padding)])
          hexspacer(h=sandwich_hexspacer_length);
        }

        translate([i*(XCarriage_length/2-XCarriage_padding), 0])
        hexspacer(h=sandwich_hexspacer_length);
      }

      translate([0,0,-thickness])
      XCarriage_sandwich_sheet();
    }

    translate([0,0,thickness])
    lasercut_extruder();
  }

  //plastic parts:
  belt_clamps();

  //metal parts:
  XCarriage_linear_bearings();

  //nozzle:
  translate([XCarPosition, 0, XCarriage_height + thickness])
  J_head_assembly();
}

module XPlatform(){
  //submodules:
  XEndMotor();
  XEndIdler();
  XCarriage();
  Xbelt();

  //lasercut parts:
  XPlatform_bottom_sheet();

  //metal parts:
  XRods();
}

module XEndMotor_pulley(){
  if (preview_ABS){
    color(ABS_color){
      translate([XEnd_box_size/2, XMotor_height])
      import("pulley.stl");
    }
  }
}

module XEndMotor(){
  translate([-machine_x_dim/2,0]){
  //lasercut parts:
    XEndMotor_back_face_sheet();
    XEnd_bearing_sandwich_sheet();

    XEndMotor_front_face_sheet();
    XEndMotor_plain_face_sheet();

    translate([thickness, XPlatform_width/2 + XEnd_extra_width - 0.5*thickness])
      rotate([90,0,0])
      XEndMotor_belt_face_assembly();

  //plastic parts:
    XEndMotor_ZLink();

  //metal parts:
    XEndMotor_linear_bearings();
  }
}

module XEndIdler(){

  translate([machine_x_dim/2, 0, 0]){
  //lasercut parts:
    XEndIdler_back_face_sheet();

    rotate([0,0,180])
    XEnd_bearing_sandwich_sheet();

    XEndIdler_front_face_sheet();
    XEndIdler_plain_face_sheet();
    XEndIdler_belt_face_assembly();

  //plastic parts:
    XEndIdler_ZLink();

  //metal parts:
    XEndIdler_linear_bearings();
  }
}

module BuildPlatform_pcb(){
  if(preview_pcb)
  color(pcb_color)
  translate([0,0,pcb_height])
  linear_extrude(height=2)
  BuildPlatform_pcb_curves();
}

module BuildPlatform_pcb_curves(){
  translate([0,pcbextra/2])
  difference(){
    square([HeatedBed_X, HeatedBed_Y], center=true);
    for (i=[-1,1]){
      for (j=[-1,1]){
        translate([i*(HeatedBed_X/2 - (1.6 + m3_diameter/2)), j*(HeatedBed_Y/2 - (1.5 + m3_diameter/2))])
        circle(r=m3_diameter/2, $fn=20);
      }
    }
  }
}


module YPlatform_left_sandwich_sheet(){
  if (preview_lasercut){
    color(sheet_color){  
      linear_extrude(height=thickness)
      YPlatform_left_sandwich_face();
    }
  }
}

module YPlatform_right_sandwich_sheet(){
  if (preview_lasercut){
    color(sheet_color){
      linear_extrude(height=thickness)
      YPlatform_right_sandwich_face();
    }
  }
}

YBearings_distance = 100;
module YPlatform_right_sandwich_face(){
  generic_bearing_sandwich_face(H=YBearings_distance);
}

module YPlatform_left_sandwich_outline(){
  width=40;
  height=50;
  r=5;
  R=25;
  translate([-width/2,-height/2])
  rounded_square([width, height], corners=[r,R,r,R]);
}

module YPlatform_left_sandwich_holes(){
    translate([14,0])
    circle(r=m3_diameter/2, $fn=20);

    for (j=[-1,1])
      translate([-14,j*(50/2 - 5)])
      circle(r=m3_diameter/2, $fn=20);
}

module YPlatform_left_sandwich_face(sandwich_tightening=1){
  difference(){
    projection(cut=true){
      difference(){
        linear_extrude(height=thickness)
        YPlatform_left_sandwich_outline();

        //linear bearing
        translate([0,0,lm8uu_diameter/2 - (sandwich_hexspacer_length + sandwich_tightening)])
        LM8UU();
      }
    }

    YPlatform_left_sandwich_holes();
  }
}

module YPlatform_sheet(){
    if (preview_lasercut){
      color(sheet_color){
        linear_extrude(height=thickness)
        YPlatform_face();
      }
    }
}

module YPlatform_subassembly(){
  translate([0,0,100-15]){ /*TODO*/
    YPlatform_sheet();

    translate([0,0, -sandwich_hexspacer_length]){
      YPlatform_hexspacers();

      translate([-Y_rods_distance/2, 0, -thickness])
      YPlatform_left_sandwich_sheet();

      translate([Y_rods_distance/2, 0, -thickness])
      YPlatform_right_sandwich_sheet();
    }

    translate([0,0, -lm8uu_diameter/2])
    YPlatform_linear_bearings();

    translate([30,80])
    rotate([-90,0])
    YEndstopHolder_sheet();

    translate([-30,-80])
    rotate([-90,0])
    YEndstopHolder_sheet();

  }
}

module YPlatform_face_generic(){
  difference(){
    rounded_square([HeatedBed_X, HeatedBed_Y + 35], corners=[10,10,10,10], center=true);
    for (i=[-1,1]){
      for (j=[-1,1]){
        translate([i*(HeatedBed_X/2 - 4), j*(HeatedBed_Y/2 - 4)])
        circle(r=m3_diameter/2, $fn=20);
      }
    }
  }
}

module belt_clamp_holes(){
  for (i=[-1,1]){
    translate([i*9,0])
      circle(r=m3_diameter/2, $fn=20);
  }  
}

module YPlatform_right_sandwich_holes(){
  for (i=[-1,1]){
    for (j=[-1,1]){
      translate([i*14,j*YBearings_distance/2])
      circle(r=m3_diameter/2, $fn=20);
    }
  }
}

module YPlatform_hexspacers(){
  translate([-Y_rods_distance/2 + 14, 0])
  hexspacer(h=sandwich_hexspacer_length);

  for (j=[-1,1]){
    translate([-Y_rods_distance/2 - 14, j*(50/2-5)])
    hexspacer(h=sandwich_hexspacer_length);
  }

  for (i=[-1,1]){
    for (j=[-1,1]){
      translate([Y_rods_distance/2 + i*14,j*50])
      hexspacer(h=sandwich_hexspacer_length);
    }
  }
}

module YPlatform_linear_bearings(){
  if (preview_metal){
    color(metal_color){
      translate([-Y_rods_distance/2, 0])
      LM8UU();

      for (j=[-1,1]){
        translate([Y_rods_distance/2, j*50])
        LM8UU();
      }
    }
  }
}

//!YPlatform_face();
module YPlatform_face(){
  difference(){
    translate([-(HeatedBed_X)/2,pcbextra-(HeatedBed_Y+pcbextra)/2])
    rounded_square([HeatedBed_X, HeatedBed_Y], corners=[3,3,3,3], $fn=50);

    //corner holes
    for (i=[-1,1]){
      for (j=[-1,1]){
        translate([i*(HeatedBed_X/2 - (1.6 + m3_diameter/2)), j*(-pcbextra/2+HeatedBed_Y/2 - (1.5 + m3_diameter/2))])
        circle(r=m3_diameter/2, $fn=20);
      }
    }

    //holes for the heated bed wiring
    for (i=[-1,1]){
      for (j=[-1,1]){
        translate([i*5, pcbextra+95+j*5])
        circle(r=m3_diameter/2, $fn=20);
      }
    }

    translate([-Y_rods_distance/2, 0])
    YPlatform_left_sandwich_holes();

    translate([Y_rods_distance/2, 0])
    YPlatform_right_sandwich_holes();

    for (i=[-1,1]){
      translate([0,i*20])
        belt_clamp_holes();
    }

    
    translate([30 + 25/2, 80 + thickness/2])
    rotate(90)
    TSlot_holes(width=25);

    translate([-30 + 25/2, -80 + thickness/2])
    rotate(90)
    TSlot_holes(width=25);

  }
}

module BuildVolumePreview(){
  if (render_build_volume){
    translate([-BuildVolume_X/2, -BuildVolume_Y/2, BuildPlatform_height])
    %cube([BuildVolume_X, BuildVolume_Y, BuildVolume_Z]);
  }
}

module YPlatform(){
  translate([0, YCarPosition, 0]){
    //#BuildVolumePreview();
    BuildPlatform_pcb();
    YPlatform_subassembly();
  }
  YRods();
  Y_belt();
}

module bearing_assembly(rear){
  //TODO: inherit these parameters from the washer library
  bearing_thickness = 7;
  washer_thickness = 1.5;
  mudguard_washer_thickness = 2;

  if (preview_metal){
    color(metal_color){

      //translate([belt_x,0])
      rotate([0,90,0]){
        for (i=[0,1]){
          rotate([0,i*180]){
            translate([0,0,bearing_thickness/2]){
              M8_washer();

              translate([0,0, washer_thickness]){
                M8_mudguard_washer();

                if (rear){
                  translate([0,0, mudguard_washer_thickness + i*(thickness + washer_thickness)])
                  M8_nut();  

                  translate([0,0, mudguard_washer_thickness + i*thickness])
                  M8_washer();
                }else{
                  translate([0,0, mudguard_washer_thickness])
                  M8_nut();
                }
              }
            }
          }
        }

        //bearing
        translate([0,0,-bearing_thickness/2])
        608zz_bearing(true);//TODO: add the bearing to the model in order to fix the X-belt related bugs
      }
    }
  }
}

//!bar_clamp_assembly();
module bar_clamp_assembly(){
  //TODO: inherit these parameters from the washer & barclap libraries
  washer_thickness = 1.5;
  barclamp_thickness = 13.5; //TODO

  rotate([0,90,0]){
    if (preview_metal){
      color(metal_color){
        for (angle=[0,180]){
          rotate([0,angle]){
            translate([0,0, barclamp_thickness/2]){
              M8_washer();

              translate([0,0, washer_thickness])
              M8_nut();
            }
          }
        }
      }
    }

    if (preview_PLA){
      color(PLA_color)
      //barclamp
      translate([-17, 6.7, -barclamp_thickness/2])
      rotate([90,0,0])
      barclamp();
    }
  }
}

//!nut_cap_assembly();
module nut_cap_assembly(){
  //TODO: inherit these parameters from the washer & barclap libraries
  washer_thickness = 1.5;

  rotate([0,90,0]){
  translate([0,0,-thickness/2])
    if (preview_metal){
      color(metal_color){
        for (angle=[0,180]){
          rotate([0,angle]){
            translate([0,0, thickness/2]){
              M8_washer();

              translate([0,0, washer_thickness])
              if (angle==180){
                M8_nut();
              }else{
                M8_domed_cap_nut();
              }
            }
          }
        }
      }
    }
  }
}

module FrontBars(){
  translate([0, -RightPanel_basewidth/2 + bar_cut_length, base_bars_Zdistance + base_bars_height]){

    if (preview_metal){
      color(metal_color){
          //front top bar
          rotate([0,90,0])
          cylinder(r=m8_diameter/2, h=horiz_bars_length, center=true);
      }
    }

    translate([SidePanels_distance/2,0,0])
    nut_cap_assembly();

    translate([-SidePanels_distance/2,0,0])
    mirror([1,0,0])
    nut_cap_assembly();

    translate([-Y_rods_distance/2,0,0])
    bar_clamp_assembly();

    translate([Y_rods_distance/2,0,0])
    bar_clamp_assembly();

    bearing_assembly();
  }

  translate([0, -RightPanel_basewidth/2 + bar_cut_length + 30,base_bars_height]){

    if (preview_metal){
      color(metal_color){
        //front bottom bar
        rotate([0,90,0])
        cylinder(r=m8_diameter/2, h=horiz_bars_length, center=true);
      }
    }

    translate([SidePanels_distance/2,0,0])
    nut_cap_assembly();

    translate([-SidePanels_distance/2,0,0])
    mirror([1,0,0])
    nut_cap_assembly();
  }

}

module RearBars(){
  translate([0, RightPanel_basewidth/2 - bar_cut_length, base_bars_Zdistance + base_bars_height]){

    //rear top bar
    if (preview_metal){
      color(metal_color){
        rotate([0,90,0])
        cylinder(r=m8_diameter/2, h=horiz_bars_length, center=true);
      }
    }

    translate([SidePanels_distance/2,0,0])
    nut_cap_assembly();

    translate([-SidePanels_distance/2,0,0])
    mirror([1,0,0])
    nut_cap_assembly();

    translate([-Y_rods_distance/2,0,0])
    bar_clamp_assembly();

    translate([Y_rods_distance/2,0,0])
    bar_clamp_assembly();

    bearing_assembly(rear=true);

  }

  translate([0, RightPanel_basewidth/2 - bar_cut_length - 30, base_bars_height]){

    //rear bottom bar
    if (preview_metal){
      color(metal_color){
        rotate([0,90,0])
        cylinder(r=m8_diameter/2, h=horiz_bars_length, center=true);
      }
    }

    translate([SidePanels_distance/2,0,0])
    nut_cap_assembly();

    translate([-SidePanels_distance/2,0,0])
    mirror([1,0,0])
    nut_cap_assembly();

    bearing_assembly(rear=true);

  }
}

module M8Nut(){
  linear_extrude(height = m8_nut_height){
    difference(){
      circle(r=14.5/2, $fn=6);
      circle(r=m8_diameter/2, $fn=20);
    }
  }
}

module M8Washer(){
  linear_extrude(height = m8_washer_height){
    difference(){
      circle(r=m8_diameter/2 + 3.6, $fn=20);
      circle(r=m8_diameter/2, $fn=20);
    }
  }
}

module FrontNutsAndWashers(){
  TopFrontNutsAndWashers();
  BottomFrontNutsAndWashers();
}

module RearNutsAndWashers(){
  TopRearNutsAndWashers();
  BottomRearNutsAndWashers();
}

module TopFrontNutsAndWashers(){
  translate([SidePanels_distance/2, -RightPanel_basewidth/2 + bar_cut_length, base_bars_Zdistance + base_bars_height]){
    rotate([0,90,0])
    M8Washer();

    translate([m8_washer_height,0,0])
    rotate([0,90,0])
    M8Nut();
  }

  translate([-SidePanels_distance/2, -RightPanel_basewidth/2 + bar_cut_length, base_bars_Zdistance + base_bars_height]){

    rotate([0,-90,0])
    M8Washer();

    translate([-m8_washer_height,0,0])
    rotate([0,-90,0])
    M8Nut();
  }
}

module BottomFrontNutsAndWashers(){
  translate([SidePanels_distance/2, -RightPanel_basewidth/2 + 30 + bar_cut_length, base_bars_height]){
    rotate([0,90,0])
    M8Washer();

    translate([m8_washer_height,0,0])
    rotate([0,90,0])
    M8Nut();
  }

  translate([-SidePanels_distance/2, -RightPanel_basewidth/2 + 30 + bar_cut_length, base_bars_height]){

    rotate([0,-90,0])
    M8Washer();

    translate([-m8_washer_height,0,0])
    rotate([0,-90,0])
    M8Nut();
  }
}

module TopRearNutsAndWashers(){
  translate([SidePanels_distance/2, RightPanel_basewidth/2 - bar_cut_length, base_bars_Zdistance + base_bars_height]){
    rotate([0,90,0])
    M8Washer();

    translate([m8_washer_height,0,0])
    rotate([0,90,0])
    M8Nut();
  }

  translate([-SidePanels_distance/2, RightPanel_basewidth/2 - bar_cut_length, base_bars_Zdistance + base_bars_height]){

    rotate([0,-90,0])
    M8Washer();

    translate([-m8_washer_height,0,0])
    rotate([0,-90,0])
    M8Nut();
  }
}

module BottomRearNutsAndWashers(){
  translate([SidePanels_distance/2, RightPanel_basewidth/2 - 30 - bar_cut_length, base_bars_height]){
    rotate([0,90,0])
    M8Washer();

    translate([m8_washer_height,0,0])
    rotate([0,90,0])
    M8Nut();
  }

  translate([-SidePanels_distance/2, RightPanel_basewidth/2 - 30 - bar_cut_length, base_bars_height]){

    rotate([0,-90,0])
    M8Washer();

    translate([-m8_washer_height,0,0])
    rotate([0,-90,0])
    M8Nut();
  }
}


module FrontAssembly(){
  FrontBars();

//  FrontTopBar();
  //FrontBottomBars();
}

module YMotorAssembly(){
  YMotorHolder();
  rotate([180,0])
  translate([40,-60,-7])
  YMotor();
}

module RearAssembly(){
  RearBars();
//  RearTopBar();
//  RearBottomBar();

  translate([-7, RightPanel_basewidth/2 - bar_cut_length, 60 + feetheight +12])
  rotate([0,-90,0])
  rotate([0,0,180])
  YMotorAssembly();
}

module LaserCutPanels(){
  MachineTopPanel_sheet();
  MachineLeftPanel_sheet();
  MachineRightPanel_sheet();
  MachineArcPanel_sheet();
  MachineBottomPanel_sheet();

  RodEnd_ZTopLeft_sheet();
  SecondaryRodEnd_ZTopLeft_sheet();
  RodEnd_ZTopRight_sheet();
  SecondaryRodEnd_ZTopRight_sheet();
  RodEnd_ZBottomLeft_sheet();
  RodEnd_ZBottomRight_sheet();
}

module XMotor(){
  translate([XEnd_box_size/2, XMotor_height]){
    rotate([-180,0,0])
    NEMA17();
  }
}

module YMotor(){
  rotate([0,0,45])
  rotate([180,0,0])
  NEMA17();
}

module ZMotors(){
  translate([Z_rods_distance/2 - z_rod_z_bar_distance, -XZStage_offset, BottomPanel_zoffset])
  rotate([180,0,0]) NEMA17();
  translate([-Z_rods_distance/2 + z_rod_z_bar_distance, -XZStage_offset, BottomPanel_zoffset])
  rotate([180,0,0]) NEMA17();
}

module ZAxis(){
  ZMotors();
  ZRods();
  ZBars();
  Z_couplings();
}

module ZRodCap_face(l=15.5, hole=true){
  difference(){
    rounded_square([40,40], corners=[5,5,5,5], center=true);
    if (hole)
      circle(r=(m8_diameter+epsilon)/2, $fn=20);

    for (i=[-l,l]){
      for (j=[-l,l]){
        translate([i,j])
          circle(r=m3_diameter/2, $fn=20);
      }
    }
  }
}

module M3_spacer(){
  difference(){
    circle(r=m3_diameter*1.5, $fn=30);
    circle(r=m3_diameter/2, $fn=30);
  }
}

module set_of_M3_spacers(w=4, h=4){
  for (x=[1:w]){
    for (y=[1:h]){
      translate([x*3.2*m3_diameter, y*3.2*m3_diameter])
      M3_spacer();
    }
  }
}

module M4_spacer(){
  difference(){
    circle(r=m4_diameter*1.5, $fn=30);
    circle(r=m4_diameter/2, $fn=30);
  }
}

module set_of_M4_spacers(w=4, h=4){
  for (x=[1:w]){
    for (y=[1:h]){
      translate([x*3.2*m4_diameter, y*3.2*m4_diameter])
      M4_spacer();
    }
  }
}


module plate_border(w=500, h=500, border=2){
  difference(){
    square([w, h]);

    translate([border, border])
    square([w-2*border, h-2*border]);
  }
}

//!LaserCutPanels();
module Metamaquina2(){
  LaserCutPanels();
  FrontAssembly();
  RearAssembly();

  if (render_xplatform){
    translate([0,-XZStage_offset, BuildPlatform_height + ZCarPosition + nozzle_tip_distance])
      XPlatform();
  }

  YPlatform();
  ZAxis();

  if (HIQUA_POWERSUPPLY){
    translate([SidePanels_distance/2, RightPanel_basewidth/2 + XZStage_offset - (rear_backtop_advance+RightPanel_backwidth), powersupply_Yposition])
    HiquaPowerSupply();
  }
}

//rotate([0,0,cos(360*time)*60])
Metamaquina2();

supplier_error = 2; // means bars&rods are cut with a typical error of +/- 2mm
function closest(x) = floor(x+0.5);
function corrected_length(x) = closest(x) - supplier_error;
function corrected_Ylength(x) = closest(x) + supplier_error;

echo(str("XCarriage dimensions: ", XCarriage_width, " mm x ", XCarriage_length, " mm"));

echo(str("barras roscadas M8:"));
echo(str("  horizontal_bars_length (x4): ", corrected_length(horiz_bars_length), " mm"));
echo(str("  Z_bar_length (x2): ", corrected_length(Z_bar_length), " mm"));

echo("barras lisas M8:");
echo(str("  X_rod_length (x2): ", corrected_length(X_rod_length), " mm"));
echo(str("  Y_rod_length (x2): ", corrected_Ylength(Y_rod_length), " mm"));
echo(str("  Z_rod_length (x2): ", corrected_length(Z_rod_length), " mm"));

barclamp_calibration = (SidePanels_distance - 2*thickness - Y_rods_distance - m8_diameter)/2;

echo(str("calibration distance between the internal face of a sidepanel and the closest tangent of a Y-axis rod: ", barclamp_calibration, " mm"));

if (render_calibration_guide){
  translate([-SidePanels_distance/2 + thickness, -RightPanel_basewidth/2 + bar_cut_length - 10, base_bars_Zdistance + base_bars_height])
  color([0,1,0,0.7]) cube([barclamp_calibration, 20, 10]);
}

bearing_thickness = 7;
washer_thickness = 1.5;
mudguard_washer_thickness = 2;
Ybearing_calibration = (SidePanels_distance - 2*thickness)/2 - bearing_thickness/2 - washer_thickness - mudguard_washer_thickness;

echo(str("calibration distance between the internal face of a sidepanel and the closest face of a mudguard washer: ", Ybearing_calibration, " mm"));

if (render_calibration_guide){
  translate([-SidePanels_distance/2 + thickness, -RightPanel_basewidth/2 + bar_cut_length - 10, base_bars_Zdistance + base_bars_height])
  color([0,0,1,0.7]) cube([Ybearing_calibration, 20, 15]);
}

echo(str("side panels distance (internal faces): ", SidePanels_distance - 2*thickness, " mm"));

