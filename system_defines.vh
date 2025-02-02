/*!
 * @file system_defines.vh
 * @date 2015-02-28  
 * @author Andrey Filippov     
 *
 * @brief Preprocessor macros definitions to be included in the project
 * These defines specify overall configuration of the system, set type
 * of the sensor interface and more.
 *
 * @copyright Copyright (c) 2015 Elphel, Inc.
 *
 * <b>License:</b>
 *
 * system_defines.vh is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * system_defines.vh is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/> .
 *
 * Additional permission under GNU GPL version 3 section 7:
 * If you modify this Program, or any covered work, by linking or combining it
 * with independent modules provided by the FPGA vendor only (this permission
 * does not extend to any 3-rd party modules, "soft cores" or macros) under
 * different license terms solely for the purpose of generating binary "bitstream"
 * files and/or simulating the code, the copyright holders of this Program give
 * you the right to distribute the covered work without those independent modules
 * as long as the source code for them is available from the FPGA vendor free of
 * charge, and there is no dependence on any encrypted modules for simulating of
 * the combined code. This permission applies to you if the distributed code
 * contains all the components and scripts required to completely simulate it
 * with at least one of the Free Software programs.
 */
  // This file may be used to define same pre-processor macros to be included into each parsed file
`ifndef SYSTEM_DEFINES
  `define SYSTEM_DEFINES
  `define DEBUG_HISTOGRAMS
  // TODO: Later compare instantiate/infer
  `define INSTANTIATE_DSP48E1 // not yet tesetd/debugged otherwise
// https://forums.xilinx.com/t5/Embedded-Processor-System-Design/AXI4-Bursts-4KB-Address-Boundary-Limitation/td-p/216413
// Interconnect does not have 4K limit, and compressed data can only go to interconnect (memory), so it is OK to violate AXI specs here
  `define AXI_4K_LIMIT_DISABLE // Current x393 code (only simulation modules) does not have it implemented, defining it causes mismatch synth/sim    
  `define DEBUG_COMPRESSOR_SCRAMBLE // ======== WTF? ======== is undefined in synthesis mode
  `define DEBUG_DCT1D // undefine after debugging is over
//  `define USE_OLD_DCT
  
// Parameters from x393_sata project
  `define USE_DRP
  `define ALIGN_CLOCKS
//  `define STRAIGHT_XCLK
  `define USE_DATASCOPE
//  `define DATASCOPE_INCOMING_RAW
  `define PRELOAD_BRAMS
//  `define AHCI_SATA 1
//  `define DEBUG_ELASTIC  
// End of parameters from x393_sata project
  
  `define PRELOAD_BRAMS
  `define DISPLAY_COMPRESSED_DATA  
  // if HISPI is not defined, parallel sensor interface is used for all channels
//  `define HISPI /*************** CHANGE here and x393_hispi/x393_parallel in bitstream tool settings ****************/
  `define MON_HISPI // Measure HISPI timing  
//    `define USE_OLD_XDCT393  
//  `define USE_PCLK2X
//  `define USE_XCLK2X
  `define REVERSE_LANES 1
  `define DEBUG_RING 1
  `define USE_HARD_CURPARAMS // Adjustment of actual hardware may break simulation
//  `define DEBUG_SENS_MEM_PAGES 1   
//  `define MCLK_VCO_MULT 16
// DDR3 memory speed grade and density
    `define sg25 1
//  `define sg15E  1
//  `define sg187E  1
  `define den4096Mb 1  
  
  `define MCLK_VCO_MULT 16
//  `define MCLK_VCO_MULT 18
//  `define MCLK_VCO_MULT 20
    
  `define MEMBRIDGE_DEBUG_WRITE 1
// Enviroment-dependent options
  `ifdef IVERILOG
    `define SIMULATION
    `define OPEN_SOURCE_ONLY
  `endif
  
  `ifdef COCOTB
    `define SIMULATION
    `define OPEN_SOURCE_ONLY
  `endif
  
  `ifdef CVC
    `define SIMULATION
    `define OPEN_SOURCE_ONLY
  `endif // CVC
  
  `ifndef SIMULATION
    `undef DEBUG_COMPRESSOR_SCRAMBLE
    `undef DEBUG_DCT1D // undefine after debugging is over
  `endif
  
  
// will not use simultaneous reset in shift registers, just and input data with ~rst  
 `define SHREG_SEQUENTIAL_RESET 1
// synthesis does to recognize global clock as G input of the primitive latch 
 `undef INFER_LATCHES
 // define when using CDC - it does not support them
 `undef IGNORE_ATTR
//`define MEMBRIDGE_DEBUG_READ 1
  `define use200Mhz 1
  `define USE_CMD_ENCOD_TILED_32_RD 1  
  // chn 0 is read from memory and write to memory
 `define def_enable_mem_chn0
 `define def_read_mem_chn0
 `define def_write_mem_chn0
 `undef  def_scanline_chn0
 `undef  def_tiled_chn0
 
  // chn 1 is scanline r+w
 `define  def_enable_mem_chn1
 `define  def_read_mem_chn1
 `define  def_write_mem_chn1
 `define  def_scanline_chn1
 `undef   def_tiled_chn1

  // chn 2 is tiled r+w
 `define  def_enable_mem_chn2
 `define  def_read_mem_chn2
 `define  def_write_mem_chn2
 `undef   def_scanline_chn2
 `define  def_tiled_chn2

  // chn 3 is scanline r+w (reuse later)
 `define  def_enable_mem_chn3
 `define  def_read_mem_chn3
 `define  def_write_mem_chn3
 `define  def_scanline_chn3
 `undef   def_tiled_chn3

  // chn 4 is tiled r+w (reuse later)
 `define  def_enable_mem_chn4
 `define  def_read_mem_chn4
 `define  def_write_mem_chn4
 `undef   def_scanline_chn4
 `define  def_tiled_chn4

  // chn 5 is disabled
 `undef def_enable_mem_chn5

  // chn 6 is disabled
 `undef  def_enable_mem_chn6
 
  // chn 7 is disabled
 `undef  def_enable_mem_chn7
 
  // chn 8 is scanline w (sensor channel 0)
 `define  def_enable_mem_chn8
 `undef   def_read_mem_chn8
 `define  def_write_mem_chn8
 `define  def_scanline_chn8
 `undef   def_tiled_chn8

  // chn 9 is scanline w (sensor channel 1)
 `define  def_enable_mem_chn9
 `undef   def_read_mem_chn9
 `define  def_write_mem_chn9
 `define  def_scanline_chn9
 `undef   def_tiled_chn9

  // chn 10 is scanline w (sensor channel 2)
 `define  def_enable_mem_chn10
 `undef   def_read_mem_chn10
 `define  def_write_mem_chn10
 `define  def_scanline_chn10
 `undef   def_tiled_chn10

  // chn 11 is scanline w (sensor channel 3)
 `define  def_enable_mem_chn11
 `undef   def_read_mem_chn11
 `define  def_write_mem_chn11
 `define  def_scanline_chn11
 `undef   def_tiled_chn11

  // chn 12 is tiled read + scanline read (for Tiff) (compressor channel 0)
 `define  def_enable_mem_chn12
 `define  def_read_mem_chn12
 `undef   def_write_mem_chn12
 `define  def_scanline_chn12
 `define  def_tiled_chn12
 
  // chn 13 is tiled read + scanline read (for Tiff) (compressor channel 1)
 `define  def_enable_mem_chn13
 `define  def_read_mem_chn13
 `undef   def_write_mem_chn13
 `define  def_scanline_chn13
 `define  def_tiled_chn13
 
  // chn 14 is tiled read + scanline read (for Tiff) (compressor channel 2)
 `define  def_enable_mem_chn14
 `define  def_read_mem_chn14
 `undef   def_write_mem_chn14
 `define  def_scanline_chn14
 `define  def_tiled_chn14
 
  // chn 15 is tiled read + scanline read (for Tiff) (compressor channel 3)
 `define  def_enable_mem_chn15
 `define  def_read_mem_chn15
 `undef   def_write_mem_chn15
 `define  def_scanline_chn15
 `define  def_tiled_chn15
`endif
 