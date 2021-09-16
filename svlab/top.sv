//  `include "cpu_if.sv"
`include "instr_package.sv"
import instr_package::*;
module top;
   bit clk;
   always #5 clk = ~clk;

   logic Din[15:0];
   logic Dout[15:0];
   logic [15:0]Address;
   logic Rden;
   logic Wren;
   logic reset;
   bit signed [15:0] sum;
   bit [15:0] pc;

   bit [7:0] ST_Count=0;
   bit [7:0] LD_Count=0;

/*
   cpu_if cpuif(clk);
   memory mem (cpuif);

  memory mem (.clk(cpuif.clk),
	.reset(cpuif.reset),
	.Din(cpuif.cb.Din),
	.Dout(cpuif.cb.Dout),
	.Address(cpuif.cb.Address),
	.RW(cpuif.cb.RW));

   initial begin
      cpuif.reset = 1'b0;
      @(posedge clk);
      cpuif.reset=1'b1;
      @(posedge clk);
      cpuif.reset=1'b0;
   end;      
*/
   CPU dut (.clk(clk),
           .reset(reset),
           .Din(Din),
           .Dout(Dout),
           .Address(Address),
           .mem_Rden(Rden),
           .mem_Wren(Wren));

  //test test(cpu_bus);   

  memory mem (.clk(clk),
	.reset(reset),
	.Din(Dout),
	.Dout(Din),
	.Address(Address),
   .Rden(Rden),
   .Wren(Wren));

   initial begin
      reset = 1'b0;
      @(posedge clk);
      reset=1'b1;
      @(posedge clk);
      reset=1'b0;
   end;      

   // Instruction properties

   // assert property (
   //    @(posedge clk) ((dut.Instr[15:12]==ST) && (dut.uPC==1)) |-> ##2 !(RW)
   // );

always @(posedge clk)
begin
   // $display("%0T: Inst=%b",$time,dut.U1_fsm.Inst_s[15:12]);
   case (dut.U1_fsm.Inst_s[15:12])

      ADD: begin 
      if (dut.U1_fsm.A1A0_s==1) begin
         sum = dut.U2_datapath.U2.data[dut.U1_fsm.Inst_s[8:6]] + dut.U2_datapath.U2.data[dut.U1_fsm.Inst_s[5:3]];
      end
      if (dut.U1_fsm.A1A0_s==2) begin 
      assert ((sum==dut.U2_datapath.U2.data[dut.U1_fsm.Inst_s[11:9]])) 
         $display("%0T: ADD works ok",$time);
      else
         $display("%0t: ADD instruction has an error",$time);
      end
      end

      iSUB: begin 
      if (dut.U1_fsm.A1A0_s==1) begin
         sum = dut.U2_datapath.U2.data[dut.U1_fsm.Inst_s[8:6]] - dut.U2_datapath.U2.data[dut.U1_fsm.Inst_s[5:3]];
      end
      if (dut.U1_fsm.A1A0_s==2) begin 
      assert ((sum==dut.U2_datapath.U2.data[dut.U1_fsm.Inst_s[11:9]])) 
         $display("%0T: SUB works ok",$time);
      else
         $display("%0t: SUB instruction has an error",$time);
      end
      end

      iAND: begin 
      if (dut.U1_fsm.A1A0_s==1) begin
         sum = dut.U2_datapath.U2.data[dut.U1_fsm.Inst_s[8:6]] & dut.U2_datapath.U2.data[dut.U1_fsm.Inst_s[5:3]];
      end
      if (dut.U1_fsm.A1A0_s==2) begin 
      assert ((sum==dut.U2_datapath.U2.data[dut.U1_fsm.Inst_s[11:9]])) 
         $display("%0T: AND works ok",$time);
      else
         $display("%0t: AND instruction has an error",$time);
      end
      end

      iOR: begin 
      if (dut.U1_fsm.A1A0_s==1) begin
         sum = dut.U2_datapath.U2.data[dut.U1_fsm.Inst_s[8:6]] | dut.U2_datapath.U2.data[dut.U1_fsm.Inst_s[5:3]];
      end
      if (dut.U1_fsm.A1A0_s==2) begin 
      assert ((sum==dut.U2_datapath.U2.data[dut.U1_fsm.Inst_s[11:9]])) 
         $display("%0T: OR works ok",$time);
      else
         $display("%0t: OR instruction has an error",$time);
      end
      end

      iXOR: begin 
      if (dut.U1_fsm.A1A0_s==1) begin
         sum = dut.U2_datapath.U2.data[dut.U1_fsm.Inst_s[8:6]] ^ dut.U2_datapath.U2.data[dut.U1_fsm.Inst_s[5:3]];
      end
      if (dut.U1_fsm.A1A0_s==2) begin 
      assert ((sum==dut.U2_datapath.U2.data[dut.U1_fsm.Inst_s[11:9]])) 
         $display("%0T: XOR works ok",$time);
      else
         $display("%0t: XOR instruction has an error",$time);
      end
      end

      iNOT: begin 
      if (dut.U1_fsm.A1A0_s==1) begin
         sum = ~(dut.U2_datapath.U2.data[dut.U1_fsm.Inst_s[8:6]]);
      end
      if (dut.U1_fsm.A1A0_s==2) begin 
      assert ((sum==dut.U2_datapath.U2.data[dut.U1_fsm.Inst_s[11:9]])) 
         $display("%0T: NOT works ok",$time);
      else
         $display("%0t: NOT instruction has an error",$time);
      end
      end

      MOV: begin 
      if (dut.U1_fsm.A1A0_s==1) begin
         sum = (dut.U2_datapath.U2.data[dut.U1_fsm.Inst_s[8:6]]);
      end
      if (dut.U1_fsm.A1A0_s==2) begin 
      assert ((sum==dut.U2_datapath.U2.data[dut.U1_fsm.Inst_s[11:9]])) 
         $display("%0T: MOV works ok",$time);
      else
         $display("%0t: MOV instruction has an error",$time);
      end
      end


      LD: begin
         assert (dut.U2_datapath.U2.data[dut.U1_fsm.Inst_s[8:6]]<4096) 
         else   $display("%0t: LD instruction out of range,address=%x",$time,dut.U2_datapath.U2.data[dut.U1_fsm.Inst_s[8:6]]);

         if (dut.U1_fsm.A1A0_s==1)begin
            assert (Rden) begin
               $display("%0T: ST works ok",$time);
               LD_Count++;
            end
            else
            $display("%0t: ST instruction has an error",$time);
	 end
      end


      ST: begin
         assert (dut.U2_datapath.U2.data[dut.U1_fsm.Inst_s[5:3]]<4096) 
         else   $display("%0t: ST instruction out of range,address=%x",$time,dut.U2_datapath.U2.data[dut.U1_fsm.Inst_s[5:3]]);
         
         if (dut.U1_fsm.A1A0_s==3)
            assert (dut.U1_fsm.mem_Wren_s) begin
               $display("%0T: ST works ok",$time);
               ST_Count++;
            end
         else
            $display("%0t: ST instruction has an error",$time);
      end

      LDI: begin 
      if (dut.U1_fsm.A1A0_s==1) begin
         sum = $signed(dut.U1_fsm.Inst_s[8:0]);
      end
      if (dut.U1_fsm.A1A0_s==2) begin 
      assert ((sum==dut.U2_datapath.U2.data[dut.U1_fsm.Inst_s[11:9]])) 
         $display("%0T: LDI works ok",$time);
      else
         $display("%0t: LDI instruction has an error",$time);
      end
      end

      BRZ: begin 
      if (dut.U1_fsm.A2_s) begin
         if (dut.U1_fsm.A1A0_s==1) begin
         sum = $signed(dut.U1_fsm.Inst_s[11:0]);
         pc = (dut.U2_datapath.U2.data[7]);
      end
         if (dut.U1_fsm.A1A0_s==3) begin 
         assert (dut.U2_datapath.U2.data[7]==sum+$signed(pc))
            $display("%0T: BRZ works ok",$time);
         else
            $display("%0t: BRZ instruction(flag=1) has an error",$time);
      end
      end else begin
         if (dut.U1_fsm.A1A0_s==1) begin
         sum = $signed(dut.U1_fsm.Inst_s[11:0]);
         pc = (dut.U2_datapath.U2.data[7]);
      end
         if (dut.U1_fsm.A1A0_s==3) begin 
         assert (dut.U2_datapath.U2.data[7]==pc+1)
            $display("%0T: BRZ works ok",$time);
         else
            $display("%0t: BRZ instruction(flag=0) has an error",$time);
      end
      end
      end

      BRN: begin 
      if (dut.U1_fsm.A2_s) begin
         if (dut.U1_fsm.A1A0_s==1) begin
         sum = $signed(dut.U1_fsm.Inst_s[11:0]);
         pc = (dut.U2_datapath.U2.data[7]);
      end
         if (dut.U1_fsm.A1A0_s==3) begin 
         assert (dut.U2_datapath.U2.data[7]==sum+$signed(pc))
            $display("%0T: BRN works ok",$time);
         else
            $display("%0t: BRN instruction(flag=1) has an error",$time);
      end
      end else begin
         if (dut.U1_fsm.A1A0_s==1) begin
         sum = $signed(dut.U1_fsm.Inst_s[11:0]);
         pc = (dut.U2_datapath.U2.data[7]);
      end
         if (dut.U1_fsm.A1A0_s==3) begin 
         assert (dut.U2_datapath.U2.data[7]==pc+1)
            $display("%0T: BRN works ok",$time);
         else
            $display("%0t: BRN instruction(flag=0) has an error",$time);
      end
      end
      end


      BRO: begin 
      if (dut.U1_fsm.A2_s) begin
         if (dut.U1_fsm.A1A0_s==1) begin
         sum = $signed(dut.U1_fsm.Inst_s[11:0]);
         pc = (dut.U2_datapath.U2.data[7]);
      end
         if (dut.U1_fsm.A1A0_s==3) begin 
         assert (dut.U2_datapath.U2.data[7]==sum+$signed(pc))
            $display("%0T: BRO works ok",$time);
         else
            $display("%0t: BRO instruction(flag=1) has an error",$time);
      end
      end else begin
         if (dut.U1_fsm.A1A0_s==1) begin
         sum = $signed(dut.U1_fsm.Inst_s[11:0]);
         pc = (dut.U2_datapath.U2.data[7]);
      end
         if (dut.U1_fsm.A1A0_s==3) begin 
         assert (dut.U2_datapath.U2.data[7]==pc+1)
            $display("%0T: BRO works ok",$time);
         else
            $display("%0t: BRO instruction(flag=0) has an error",$time);
      end
      end
      end

      BRA: begin 
         if (dut.U1_fsm.A1A0_s==1) begin
         sum = $signed(dut.U1_fsm.Inst_s[11:0]);
         pc = (dut.U2_datapath.U2.data[7]);
      end
         if (dut.U1_fsm.A1A0_s==3) begin 
            $display("%x==%x+%x",dut.U2_datapath.U2.data[7],sum,$signed(pc));
         assert (dut.U2_datapath.U2.data[7]==sum+$signed(pc))
            $display("%0T: BRA works ok",$time);
         else begin
            $display("%0t: BRA instruction has an error",$time);
            $display("%x==%x+%x",dut.U2_datapath.U2.data[7],sum,$signed(pc));
            end
      end
      end
   
   
      default:begin
         if (dut.U1_fsm.A1A0_s==1) begin
         $display("%0t: Not Used instruction",$time);
      end
      end
   endcase
end 

endmodule
