//`include "cpu_if.sv"
`include "mem_class.sv"
`include "SV_RAND_CHECK.sv"
import instr_package::*;
import mem_package::*;
//module memory(cpu_if cpuif);
program automatic memory(
   input bit clk,
   input logic reset,
   input logic Rden,
   input logic Wren,
   input logic [15:0]Address,
   input logic Din[15:0],
   output logic Dout[15:0] 
);

   /*mem_type data[mem_type],idx=1;
   mem_type a;
   Driver_cbs cbs[$];
   Driver_cbs_cover cb_cover;*/
   mem_type m;
   Driver_cbs cbs[$];
   Driver_cbs_cover cb_cover;
   logic Wren_s,Rden_s;
   logic [15:0]Address_s;
   logic Din_s[15:0];

initial begin
   forever @ (posedge clk or posedge reset) begin
      if (reset) begin
         Wren_s <= 0;
         Rden_s <= 0;
         Address_s <= 0;
      end
      else begin
         Wren_s <= Wren;
         Rden_s <= Rden;
         Address_s <= Address;
         Din_s <= Din;
      end
   end
end


   initial begin
       while(1) begin
 	      @(posedge clk)
      //    Wren_s <= Wren;
      //    Rden_s <= Rden;
      //    Address_s <= Address;
      //    Din_s <= Din;
	     //a <= Address_s;
          assert (!$isunknown(Address))
	        //a <= Address_s;
          else begin
             $warning("Memory Address is set to unknown");
	        $display("%x",Address);
	     end
          if (Rden_s) begin
            Dout <= {>>{m.data[Address][15:0]}};
	m.opstat(Address);
	
          end
          else begin
             Dout <= {>>{m.data[0][15:0]}};
          end

         if (Wren_s) begin
            m.data[Address] = {<<{Din_s}}; // why inverse Din?
          end
       end;
   end;
 // Load Program
   initial begin
      cb_cover = new();
      cbs.push_back(cb_cover); 
      m=new();
      @(posedge reset)
      @(negedge clk)
      for(int i=0;i<4096;i++) begin
         instr = new();
	    `SV_RAND_CHECK(instr.randomize());
	    instr.post_randomize();
	    instr.print_instruction;
          m.data[i]=instr.Compile(); // 16'h7000; //NOP
//$display("%x",m.data[i]);
	     foreach (cbs[i]) begin
	        cbs[i].post_tx(instr);
	     end
          // data[i]=16'b0111_0000_0000_0000; //NOP
      end
   end;

endprogram