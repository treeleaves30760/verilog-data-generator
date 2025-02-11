   initial begin
       clock = 0;
       forever #5ns clock = ~clock;
   end