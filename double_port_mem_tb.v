module double_port_mem_tb;

	reg clk;
	reg [9:0]addr_a;
	reg en_a;
	reg w_a;
	reg [7:0]in_a;
	wire [7:0]out_a;

	reg [9:0]addr_b;
	reg en_b;
	reg w_b;
    reg [7:0]in_b;
	wire [7:0]out_b;
	integer i, fw;


    double_port_mem dpm (
	  .clk(clk),
	  .addr_a(addr_a),      
	  .out_a(out_a),      
	  .w_a(w_a), 
	  .in_a(in_a), 
	  .en_a(en_a),  

	  .addr_b(addr_b),    
	  .out_b(out_b),     
	  .w_b(w_b),    
	  .in_b(in_b), 
	  .en_b(en_b)
	);

	always # 20 clk = ~ clk;

	initial
	begin
	    clk = 0;
	    addr_a = 10'b0000000000;
	    w_a = 1'b0;
	    en_a = 1'b0;
	    in_a = 1'b0;
	    addr_b = 10'b0000000000;
	    w_b = 1'b0;
	    en_b = 1'b0;
	    in_b = 1'b0;

	    fw = $fopen(" dual_port_mem.dump"); 
        $fmonitor(fw, "%t\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t", $time, w_a, w_b, in_a, in_b, addr_a, addr_b, en_a, en_b, out_a, out_b);
   
        @(negedge clk)
	        w_a = 1;
	        en_a = 0;
	        w_b = 0;
	        en_b = 0;

	        for(i = 0; i <= 511; i = i + 1) begin
	            @(negedge clk) begin
	    		addr_a = i;
	    		in_a = i % 256;
	    		end
	    		
	        end  
       
        @(negedge clk) 
	        w_b = 1;
	        en_b = 0;
	        w_a = 0;
	        en_a = 0;

	        for(i = 512; i <= 1023; i = i + 1) begin
	            @(negedge clk) begin
	    		addr_b = i;
	    		in_b = i % 256;
	    		end
	        end  
        

        @(negedge clk)
	        en_a = 0;
	        w_a = 0;
		    w_b = 0;
		    en_b = 0;

	        for(i = 1023; i >= 512; i = i - 1) begin
	        	@(posedge clk) begin
	        	en_a = 1;
	        	addr_a = i;
	        	end
	        end

        @(negedge clk)
	        en_a = 0;
	        w_a = 0;
		    w_b = 0;
		    en_b = 0;

	        for(i = 511; i >= 0; i = i - 1) begin
	        	@(posedge clk) begin
	        	en_b = 1;
	        	addr_b = i;
	        	end
	        end


        $stop();

	end


endmodule
