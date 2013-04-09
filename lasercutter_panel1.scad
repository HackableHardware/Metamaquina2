// Lasercutter Panel #1 for manufacturing the Metamaquina 2 desktop 3d printer
//
// (c) 2013 Felipe C. da S. Sanches <fsanches@metamaquina.com.br>
// Licensed under the terms of the GNU General Public License
// version 3 (or later).

use <Metamaquina2.scad>;

module lasercutter_panel1(){
  %plate_border(w=520);

  translate([10,10])
  render() MachineLeftPanel_face();

  translate([510,470])
  rotate([0,0,180])
  MachineRightPanel_face();

  translate([280,335])
  set_of_M3_spacers(h=3, w=7);

  translate([450,5])
  set_of_M3_spacers(h=10, w=2);

  translate([24,0]){
    translate([145,165])
    set_of_M3_spacers(h=2, w=6);

    translate([240,200])
    XEndIdler_back_face();

    translate([280,200+70])
    XEndMotor_back_face();

    translate([155,110])
    XEndMotor_belt_face();

    translate([195,270])
    rotate([0,0,90])
    XEndMotor_plain_face();

    translate([187,205])
    rotate([0,0,90])
    XEndIdler_belt_face();

    translate([270,157])
    XEndIdler_plain_face();
  }
}

lasercutter_panel1();

