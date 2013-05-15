// Lasercutter Panel #4 for manufacturing the Metamaquina 2 desktop 3d printer
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

use <RAMBo.scad>;

//This is intended to be lasercut in acrylic
module lasercutter_panel4(){
  %plate_border();

  RAMBo_cover_curves();

  translate([110,0])
  RAMBo_cover_curves(3);
}

lasercutter_panel4();

