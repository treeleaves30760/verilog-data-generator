     always begin
       clk = ~clk;
       #(`CLOCK_PERIOD / 2);
     end