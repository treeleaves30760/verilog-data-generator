
Let me outline the steps:

1. Set up the clock with a 10ns period.
2. Define the initial inputs (a and b) and output (y).
3. Use an initial block to iterate through all input combinations.
4. For each combination:
   - Assign values to a and b.
   - Wait for one clock cycle to let the DUT process the inputs.
   - Calculate the expected XOR result.
   - Compare the actual output with the expected value.
   - Print pass or fail message for each test case.
5. After all tests, print a final success message if all passed.

I should also ensure that the code is clean and follows good Verilog practices, such as using non-blocking assignments where necessary, but in this case, since it's a testbench, blocking assignments are fine for simplicity.

Double-checking each step to make sure I haven't missed any input combinations or failed to include any necessary parts like the clock. Also, ensuring that the messages clearly indicate each test result so that anyone running the simulation can easily see what happened.
</think>