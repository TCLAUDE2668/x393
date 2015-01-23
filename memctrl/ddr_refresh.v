/*******************************************************************************
 * Module: ddr_refresh
 * Date:2014-06-02  
 * Author: Andrey Filippov
 * Description: DDR3 memory refresh request module
 *
 * Copyright (c) 2014 Elphel, Inc.
 * ddr_refresh.v is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 *  ddr_refresh.v is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/> .
 *******************************************************************************/
`timescale 1ns/1ps

module  ddr_refresh(
    input       rst,
    input       clk,
    input       en,
    input [7:0] refresh_period, // in 16*clk, 0 - disable refresh, turn off requests
    input       set, // and reset counters
    output reg  want, // turns off next cycle after grant (or stays on if more are needed)
    output reg  need,
    input       grant // 1 cycle
);
    reg   [3:0] pre_div;
    reg   [4:0] pending_rq; // can accumulate  up to 31 requests, datasheet allows up to 16
    reg   [7:0] period_cntr;
    reg         cry;
    wire        over=(period_cntr == 0) && cry;
    reg         refresh_due;
    reg         en_refresh;
    reg         en_r;
    
    always @ (posedge rst or posedge clk) begin
        if (rst)       en_r <= 0;
        else           en_r <= en;

        if (rst)       en_refresh <= 0;
        else if (set)  en_refresh <= (refresh_period != 0);
        
        if (rst)                      pre_div <= 0;
        else if (set || !en_refresh)  pre_div <= 0;
        else                          pre_div <= pre_div +1;
        
        if (rst)       cry <= 0;
        else if (set)  cry <= 0;
        else           cry <= (pre_div == 4'hf);
        
        if (rst)       period_cntr <= 0;
        else if (set)  period_cntr <= 0;
        else if (over) period_cntr <= refresh_period;
        else if (cry)  period_cntr <= period_cntr -1;
        
        if (rst)       refresh_due <= 0;
        else           refresh_due <= over;
        
        if (rst)       pending_rq <= 0;
        else if (set)  pending_rq <= 0;
        else if ( refresh_due && !grant) pending_rq <= pending_rq+1;
        else if (!refresh_due &&  grant) pending_rq <= pending_rq-1;
        
        if (rst) want <= 0;
        else     want<= en_refresh && en_r && (pending_rq != 0);

        if (rst) need <= 0;
        else     need <= en_refresh && en_r && (pending_rq[4:3] != 0);
    end
endmodule

