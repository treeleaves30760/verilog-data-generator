import autogen
import subprocess
import os
from typing import List, Dict, Optional
import json
from datetime import datetime
import logging
from pathlib import Path


class ConversationLogger:
    def __init__(self, log_dir: str = "conversation_logs"):
        self.log_dir = log_dir
        # Create main log directory
        Path(log_dir).mkdir(parents=True, exist_ok=True)
        # Create raw outputs directory
        Path(os.path.join(log_dir, "raw_outputs")).mkdir(
            parents=True, exist_ok=True)
        self.current_conversation = []

    def log_raw_output(self, sender: str, content: str, topic: str, phase: str):
        """Log raw model output before any processing"""
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        filename = f"{topic}_{phase}_{sender}_{timestamp}_raw.txt"
        filepath = os.path.join(self.log_dir, "raw_outputs", filename)

        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(
                f"Timestamp: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n")
            f.write(f"Sender: {sender}\n")
            f.write(f"Topic: {topic}\n")
            f.write(f"Phase: {phase}\n")
            f.write("-" * 80 + "\n")
            f.write(content)

        return filepath

    def log_message(self, sender: str, receiver: str, message: str, timestamp: str):
        """Log a single message in the conversation"""
        self.current_conversation.append({
            "timestamp": timestamp,
            "sender": sender,
            "receiver": receiver,
            "message": message
        })

    def save_conversation(self, topic: str, conversation_type: str):
        """Save the current conversation to a JSON file"""
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        filename = f"{topic}_{conversation_type}_{timestamp}.json"
        filepath = os.path.join(self.log_dir, filename)

        with open(filepath, 'w') as f:
            json.dump(self.current_conversation, f, indent=2)

        self.current_conversation = []  # Reset for next conversation
        return filepath


class LoggedAssistantAgent(autogen.AssistantAgent):
    def __init__(self, name: str, logger: ConversationLogger, **kwargs):
        super().__init__(name=name, **kwargs)
        self.logger = logger

    async def a_receive(self, message: Dict, sender, **kwargs):
        """Override receive to log messages"""
        timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        self.logger.log_message(
            sender=sender.name,
            receiver=self.name,
            message=message["content"],
            timestamp=timestamp
        )
        return await super().a_receive(message, sender, **kwargs)


class LoggedUserProxyAgent(autogen.UserProxyAgent):
    def __init__(self, name: str, logger: ConversationLogger, **kwargs):
        super().__init__(name=name, **kwargs)
        self.logger = logger

    async def a_receive(self, message: Dict, sender, **kwargs):
        """Override receive to log messages"""
        timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        self.logger.log_message(
            sender=sender.name,
            receiver=self.name,
            message=message["content"],
            timestamp=timestamp
        )
        return await super().a_receive(message, sender, **kwargs)


class VerilogGenerator:
    def __init__(self, ollama_base_url: str = "http://localhost:11434/v1",
                 model: str = "deepseek-r1:7b",
                 log_dir: str = "conversation_logs"):
        self.logger = ConversationLogger(log_dir)
        self.datetime = datetime.now().strftime("%Y_%m_%d_%H_%M_%S")
        self.result_folder = os.path.join("verilog_workspace", self.datetime)

        # Define the agent configurations
        self.config_list = [
            {
                "model": model,
                "base_url": ollama_base_url,
                "api_key": "NULL"
            }
        ]

        # Initialize the agents with logging capability
        self.spec_writer = LoggedAssistantAgent(
            name="spec_writer",
            logger=self.logger,
            system_message="""You are a Verilog specification writer. Create clear, structured specifications for digital circuit designs.
Format your specification as follows:
1. Module Name: [name]
2. Description: [brief description]
3. Inputs:
   - [input_name]: [width] [description]
4. Outputs:
   - [output_name]: [width] [description]
5. Functionality:
   [clear description of operations]
6. Timing Requirements:
   [clock, reset, and timing details]

Provide ONLY the specification without any additional text or explanations.
Do NOT use markdown formatting or code blocks.""",
            llm_config={
                "config_list": self.config_list,
                "timeout": 60,
                "temperature": 0.3
            }
        )

        self.module_writer = LoggedAssistantAgent(
            name="module_writer",
            logger=self.logger,
            system_message="""You are a Verilog module writer. Create efficient and correct Verilog modules.
ALWAYS:
1. Wrap your code in ```verilog blocks
2. Provide ONLY the Verilog code
3. Follow module name and ports from the specification exactly
4. Include clear comments
5. Use synthesizable constructs only

NEVER add explanations or ask questions.""",
            llm_config={
                "config_list": self.config_list,
                "timeout": 60,
                "temperature": 0.3
            }
        )

        self.testbench_writer = LoggedAssistantAgent(
            name="testbench_writer",
            logger=self.logger,
            system_message="""You are a Verilog testbench writer. Create comprehensive testbenches.
ALWAYS:
1. Wrap your code in ```verilog blocks
2. Provide ONLY the Verilog code
3. Include clock generation
4. Test all input combinations
5. Include clear success/failure messages

NEVER add explanations or ask questions.""",
            llm_config={
                "config_list": self.config_list,
                "timeout": 60,
                "temperature": 0.3
            }
        )

        # Initialize the user proxy
        self.user_proxy = LoggedUserProxyAgent(
            name="user_proxy",
            logger=self.logger,
            human_input_mode="NEVER",
            code_execution_config=False  # Disable code execution
        )

    def reset_user_proxy(self):
        """Reset the user proxy to clear previous conversation context."""
        self.user_proxy = LoggedUserProxyAgent(
            name="user_proxy",
            logger=self.logger,
            human_input_mode="NEVER",
            code_execution_config=False
        )

    def initialize_workspace(self):
        """Create workspace directory if it doesn't exist"""
        if not os.path.exists(self.result_folder):
            os.makedirs(self.result_folder)

    def verify_iverilog_installation(self) -> bool:
        """Verify if iverilog is installed"""
        try:
            subprocess.run(["iverilog", "-v"], capture_output=True)
            return True
        except FileNotFoundError:
            print("Error: iverilog is not installed. Please install it first.")
            return False

    def compile_and_run(self, module_name: str) -> tuple[bool, str]:
        """Compile and run Verilog files using iverilog"""
        try:
            # Compile
            compile_result = subprocess.run(
                ["iverilog", "-o", f"{self.result_folder}/{module_name}/{module_name}",
                 f"{self.result_folder}/{module_name}/{module_name}.v",
                 f"{self.result_folder}e/{module_name}/{module_name}_tb.v"],
                capture_output=True,
                text=True
            )

            if compile_result.returncode != 0:
                return False, compile_result.stderr

            # Run simulation
            sim_result = subprocess.run(
                ["vvp", f"{self.result_folder}/{module_name}/{module_name}"],
                capture_output=True,
                text=True
            )

            return True, sim_result.stdout
        except Exception as e:
            return False, str(e)

    def extract_code(self, content: str) -> str:
        """Extract code from message content, handling markdown code blocks"""
        # Check for markdown code blocks
        if "```" in content:
            # Extract content between ``` marks
            parts = content.split("```")
            for i in range(1, len(parts), 2):
                # Skip the language identifier if present
                code = parts[i].strip()
                if "\n" in code:
                    code = code.split("\n", 1)[1]
                return code
        return content  # Return as-is if no code blocks found

    def generate_spec(self, topic: str) -> str:
        """Generate specification for a given topic"""
        # Reset user proxy for a fresh conversation.
        self.reset_user_proxy()

        prompt = f"""Create a detailed Verilog specification for: {topic}

Please provide the specification in a clear format. Put the spec in the ``` code block.
Include all necessary details for implementation."""

        self.user_proxy.initiate_chat(
            self.spec_writer,
            message=prompt,
            max_turns=1
        )

        # Log raw output before processing
        raw_content = self.user_proxy.last_message()["content"]
        raw_log_file = self.logger.log_raw_output(
            sender="spec_writer",
            content=raw_content,
            topic=topic,
            phase="specification"
        )
        print(f"Raw specification output logged to: {raw_log_file}")

        spec = self.extract_code(raw_content)

        print(f"\n\n{'='*20}\nSpecification: {spec}\n\n{'='*20}")

        # Save specification to file
        with open(f"{self.result_folder}/{topic}/{topic}_spec.txt", "w", encoding='utf-8') as f:
            f.write(spec)

        # Save the conversation log
        log_file = self.logger.save_conversation(topic, "specification")
        print(f"Specification conversation logged to: {log_file}")

        return spec

    def generate_testbench(self, topic: str, spec: str) -> str:
        """Generate testbench based on specification"""
        # Reset user proxy for a fresh conversation.
        self.reset_user_proxy()

        prompt = f"""Create a Verilog testbench for the following specification:
{spec}

Provide ONLY the Verilog code without any markdown formatting or explanations.
The code should be directly usable in a Verilog simulator."""

        self.user_proxy.initiate_chat(
            self.testbench_writer,
            message=prompt,
            max_turns=3
        )

        # Log raw output before processing
        raw_content = self.user_proxy.last_message()["content"]
        raw_log_file = self.logger.log_raw_output(
            sender="testbench_writer",
            content=raw_content,
            topic=topic,
            phase="testbench"
        )
        print(f"Raw testbench output logged to: {raw_log_file}")

        testbench = self.extract_code(raw_content)

        # Save testbench to file
        with open(f"{self.result_folder}/{topic}/{topic}_tb.v", "w") as f:
            f.write(testbench)

        # Save the conversation log
        log_file = self.logger.save_conversation(topic, "testbench")
        print(f"Testbench conversation logged to: {log_file}")

        return testbench

    def generate_module(self, topic: str, spec: str, testbench: str) -> str:
        """Generate Verilog module based on specification and testbench"""
        # Reset user proxy for a fresh conversation.
        self.reset_user_proxy()

        prompt = f"""Create a Verilog module that implements this specification:
{spec}

And matches this testbench:
{testbench}

Provide ONLY the Verilog code without any markdown formatting or explanations.
The code should be directly usable in a Verilog simulator."""

        self.user_proxy.initiate_chat(
            self.module_writer,
            message=prompt,
            max_turns=3
        )

        # Log raw output before processing
        raw_content = self.user_proxy.last_message()["content"]
        raw_log_file = self.logger.log_raw_output(
            sender="module_writer",
            content=raw_content,
            topic=topic,
            phase="module"
        )
        print(f"Raw module output logged to: {raw_log_file}")

        module = self.extract_code(raw_content)

        # Save module to file
        with open(f"{self.result_folder}/{topic}/{topic}.v", "w") as f:
            f.write(module)

        # Save the conversation log
        log_file = self.logger.save_conversation(topic, "module")
        print(f"Module conversation logged to: {log_file}")

        return module

    def iterate_design(self, topic: str, error_message: str):
        """Iterate on design based on compilation/simulation errors"""
        # Reset user proxy for a fresh conversation.
        self.reset_user_proxy()

        prompt = f"""The following error occurred while verifying the design:
{error_message}

Please fix the issues in both the module and testbench."""

        # Create a group chat for collaborative fixing
        groupchat = autogen.GroupChat(
            agents=[self.user_proxy, self.module_writer, self.testbench_writer],
            messages=[],
            max_round=10
        )
        manager = autogen.GroupChatManager(groupchat=groupchat)

        self.user_proxy.initiate_chat(
            manager,
            message=prompt
        )

        # Log all messages from the group chat
        iteration_count = len([f for f in os.listdir(os.path.join(self.logger.log_dir, "raw_outputs"))
                               if f"_{topic}_iteration" in f]) + 1

        for msg in groupchat.messages:
            if msg["role"] == "assistant":
                raw_log_file = self.logger.log_raw_output(
                    sender=msg["name"],
                    content=msg["content"],
                    topic=topic,
                    phase=f"iteration_{iteration_count}"
                )
                print(f"Raw iteration output logged to: {raw_log_file}")

        # Extract updated versions
        updated_module = None
        updated_testbench = None
        for message in groupchat.messages:
            if message["role"] == "assistant" and message["name"] == "module_writer":
                updated_module = self.extract_code(message["content"])
            elif message["role"] == "assistant" and message["name"] == "testbench_writer":
                updated_testbench = self.extract_code(message["content"])

        # Save updated versions if available
        if updated_module:
            with open(f"{self.result_folder}/{topic}/{topic}.v", "w") as f:
                f.write(updated_module)
        if updated_testbench:
            with open(f"{self.result_folder}/{topic}/{topic}_tb.v", "w") as f:
                f.write(updated_testbench)

        # Save the conversation log
        log_file = self.logger.save_conversation(topic, "iteration")
        print(f"Iteration conversation logged to: {log_file}")

        return updated_module, updated_testbench

    def process_topic(self, topic: str) -> bool:
        """Process a single topic through the entire workflow"""
        print(f"\nProcessing topic: {topic}")

        # Generate specification
        spec = self.generate_spec(topic)
        print("Specification generated.")

        # Generate testbench first
        testbench = self.generate_testbench(topic, spec)
        print("Testbench generated.")

        # Generate module
        module = self.generate_module(topic, spec, testbench)
        print("Module generated.")

        # Verify design
        success = False
        max_iterations = 10
        iteration = 0

        while not success and iteration < max_iterations:
            success, message = self.compile_and_run(topic)
            if not success:
                print(
                    f"Verification failed. Iteration {iteration + 1}/{max_iterations}")
                print(f"Error message: {message}")
                self.iterate_design(topic, message)
            iteration += 1

        return success


def main():
    # List of IC topics to process
    ic_topics = [
        "4-bit counter",
        "8-bit ALU",
        "UART receiver",
        "UART transmitter",
        "SPI master",
        "I2C slave",
        "PWM generator",
        "FIFO buffer",
        "Digital Calculator with FSM Control",
        "Traffic Light Controller",
        "RISC-V Processor Core",
        "DDR3 Memory Controller",
        "VGA Controller",
        "Audio DAC",
        "SD Card Interface",
        "Ethernet MAC",
        "USB Controller",
        "PCIe Endpoint",
        "HDMI Transmitter",
        "AES Encryption Engine",
        "SHA-256 Hashing Unit",
        "JPEG Decoder",
        "FFT Processor",
        "DCT Processor",
        "Convolutional Neural Network",
        "Matrix Multiplier",
        "Floating Point Adder",
        "Digital Filter",
        "PID Controller",
        "Pulse Width Modulator",
        "Direct Digital Synthesizer",
        "Phase Locked Loop",
        "Frequency Divider",
        "Frequency Multiplier",
        "Digital Down Converter",
        "Digital Up Converter",
        "Digital Mixer",
        "Digital Oscillator",
        "Digital Comparator",
        "Digital Divider",
        "Digital Integrator",
        "Digital Differentiator",
        "Digital Slicer",
        "Digital Demodulator",
        "Digital Modulator",
        "Digital Phase Shifter",
        "Digital Power Amplifier",
        "Digital Low Pass Filter",
        "Digital High Pass Filter",
        "Digital Band Pass Filter",
        "Digital Band Stop Filter",
        "Digital Equalizer",
        "Digital Delay Line",
        "Digital Frequency Counter",
        "Digital Frequency Meter",
        "Digital Signal Generator",
        "Digital Signal Analyzer",
        "Digital Signal Processor",
        "Digital Signal Modulator",
        "Digital Signal Demodulator",
        "Digital Signal Mixer",
        "Digital Signal Splitter",
        "Digital Signal Combiner",
        "Digital Signal Selector",
        "Digital Signal Switch",
        "Digital Signal Router",
        "Digital Signal Multiplexer",
        "Digital Signal Demultiplexer",
        "Digital Signal Encoder",
        "Digital Signal Decoder"
    ]

    # Initialize the generator with logging
    generator = VerilogGenerator(log_dir="conversation_logs")

    # Check iverilog installation
    if not generator.verify_iverilog_installation():
        return

    # Initialize workspace
    generator.initialize_workspace()

    # Process each topic
    results = {}
    for topic in ic_topics:
        success = generator.process_topic(topic)
        results[topic] = "Success" if success else "Failed"

    # Print summary
    print("\nProcessing Summary:")
    for topic, result in results.items():
        print(f"{topic}: {result}")


if __name__ == "__main__":
    main()
