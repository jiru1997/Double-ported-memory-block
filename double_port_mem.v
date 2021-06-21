
module double_port_mem(clk, addr_a, en_a, w_a, in_a, out_a, addr_b, en_b, w_b, in_b, out_b);

	parameter DW = 8,AW = 10,DP = 1 << AW;

	input clk;
	input [AW-1:0] addr_a;
	input en_a;
	input w_a;
	input [DW-1:0] in_a;
	output [DW-1:0] out_a;
	
	input [AW-1:0] addr_b;
	input en_b;
	input w_b;
	input [DW-1:0] in_b;
	output [DW-1:0] out_b;
	    
	reg [DW-1:0]mem[DP - 1 : 0];
	reg [DW-1:0]reg_out_a;
	reg [DW-1:0]reg_out_b;


	integer i;
	initial begin
	    for(i=0; i < DP; i = i + 1) begin
	        mem[i] = 8'h00;
	    end
	    reg_out_a = 8'h00;
        reg_out_b = 8'h00;
	end


	always@(posedge clk)
	begin
	    if(!w_a && en_a)
	        begin
	            reg_out_a <= mem[addr_a];
	        end
	    else if(w_a && en_a)
		    begin
		    	reg_out_a <= in_a;
		    end
	    else
	        begin
	            reg_out_a <= reg_out_a;
	        end
	end


	always@(posedge clk)
	begin
	    if(!w_b && en_b)
	        begin
	            reg_out_b <= mem[addr_b];
	        end
	    else if(w_b && en_b)
		    begin
		    	reg_out_b <= in_b;
		    end
	    else
	        begin
	            reg_out_b <= reg_out_b;
	        end
	end
	 

	always@(posedge clk)
	begin
	    if(w_a)
	        begin
	            mem[addr_a] <= in_a;
	        end
	    else if(w_b)
	        begin
	            mem[addr_b] <= in_b;
	        end
	    else
	        begin
	            mem[addr_a] <= mem[addr_a];
	            mem[addr_b] <= mem[addr_b];
	        end   
	end
	 
	assign out_a = (en_a) ? reg_out_a : {(DW-1){1'bz}};
	assign out_b = (en_b) ? reg_out_b : {(DW-1){1'bz}};

endmodule
