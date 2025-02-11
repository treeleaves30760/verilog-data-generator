
Next, the module name and ports must exactly match what's specified. So, if they give me specific names for inputs and outputs, I need to adhere strictly to those without any deviations.

Including clear comments is another key point. My code should have comments that explain each section or component, making it understandable for anyone reading it later.

I also need to use synthesizable constructs only. That means avoiding non-synthesizable features like `$display` or `$stop` unless they're part of a testbench, which seems acceptable in this context as the example provided uses them.

Looking at their example, I see that the testbench module includes clock generation, reset handling, signal assignments, and monitoring. It also has assertions for error checking. So, if I were to create another module, say a DUT (Digital Under Test), I should follow similar patterns but ensure it's correctly structured as per Verilog standards.

I need to avoid adding explanations or asking questions in the code. The user wants only the code within the