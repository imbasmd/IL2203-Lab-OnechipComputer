// The mem_type should be converted into a class so that you can collect statistics of the instructions

/*package mem_package;
import instr_package::*;
typedef bit [15:0] uint16;
typedef uint16 mem_type;
typedef bit [3:0] nybble;
class mem_statistics;
   int instr[nybble];
   function new();
      for(int i=0;i<15;i++) instr[i]=0;
   endfunction
   function void Incr(mem_type din);
      nybble op;
      op=din[15:12];
      instr[op]++;
   endfunction
   function void Print();
      $display("ADD %x iSUB %x iAND %x iOR %x iXOR %x iNOT %x MOV %x NOP %x LD %x ST %x LDI %x NU  %x BRZ  %x BRN %x BRO %x BRA",
               instr[ADD],
               instr[iSUB],
               instr[iAND],
               instr[iOR],
               instr[iXOR],
               instr[iNOT],
               instr[MOV],
               instr[NOP],
               instr[LD],
               instr[ST],
               instr[LDI],
               instr[NU],
               instr[BRZ],
               instr[BRN],
               instr[BRO],
               instr[BRA]);
   endfunction
endclass
endpackage
*/
package mem_package;
import instr_package::*;
typedef bit [3:0] nybble;
typedef bit [15:0] uint16;
class mem_statistics;
   int instr[nybble];
   function new();
      for(int i=0;i<15;i++) instr[i]=0;
   endfunction
   function void Incr(bit[15:0] din);
      nybble op;
      op=din[15:12];
      instr[op]++;
   endfunction
   function void Print();
      $display("ADD %x iSUB %x iAND %x iOR %x iXOR %x iNOT %x MOV %x NOP %x LD %x ST %x LDI %x NU  %x BRZ  %x BRN %x BRO %x BRA %x",
               instr[ADD],
               instr[iSUB],
               instr[iAND],
               instr[iOR],
               instr[iXOR],
               instr[iNOT],
               instr[MOV],
               instr[NOP],
               instr[LD],
               instr[ST],
               instr[LDI],
               instr[NU],
               instr[BRZ],
               instr[BRN],
               instr[BRO],
               instr[BRA]);
$display("SUM %d",instr.sum());
   endfunction
endclass

class mem_type;
  uint16 data[4096];
   //bit [15:0] a;
   mem_statistics stat;

   function new();
      this.stat = new();
   endfunction
   function void opstat(bit[15:0] Addr);
      if (Addr<4096) begin
         stat.Incr(data[Addr]);
	      stat.Print();
         if (data[Addr][15:12]==BRZ) begin
            $display("BRZ excuted");
         end
         if (data[Addr][15:12]==BRN) begin
            $display("BRN excuted");
         end
         if (data[Addr][15:12]==BRO) begin
            $display("BRO excuted");
         end
         if (data[Addr][15:12]==BRA) begin
            $display("BRA excuted");
         end
      end
   endfunction

endclass
endpackage