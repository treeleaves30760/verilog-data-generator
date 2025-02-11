library ieee;
use ieee.std_logic_1164.all;

entity testbench is
    -- Empty entity for testbench
end testbench;

architecture sim of testbench is
    signal A, B, C_in, S, C_out : std_logic_vector(3 downto 0);
    
begin
    -- Instantiating the full adder (replace with your actual component)
    full_adder: entity work.full_adder_4bit
        port map(
            A => A,
            B => B,
            C_in => C_in,
            S => S,
            C_out => C_out
        );

    -- Test process
    test_process : process
    begin
        -- Loop through all possible values of A (0 to 15)
        for a in 0 to 15 loop
            -- Convert integer to std_logic_vector
            A <= std_logic_vector(to_unsigned(a, 4));
            
            -- Loop through all possible values of B (0 to 15)
            for b in 0 to 15 loop
                B <= std_logic_vector(to_unsigned(b, 4));
                
                -- Loop through all possible values of C_in (0 and 1)
                for cin in 0 to 1 loop
                    C_in <= std_logic_vector(to_unsigned(cin, 1));
                    
                    -- Wait for one clock cycle
                    wait for 1 ns;
                    
                    -- Calculate expected sum and carry out
                    integer sum := a + b + cin;
                    integer expected_S_int := sum mod 16;
                    integer expected_C_out_int := (sum >= 16);
                    
                    -- Convert integers to std_logic_vector
                    type svector is array (natural range <>) of std_logic;
                    function to_slv(i : integer) return svector is
                        variable res : svector(3 downto 0);
                        begin
                            for j in 3 downto 0 loop
                                if i >= 2**j then
                                    res(j) <= '1';
                                    i := i - 2**j;
                                else
                                    res(j) <= '0';
                                end if;
                            end loop;
                            return res;
                        end function;
                    expected_S <= to_slv(expected_S_int);
                    
                    -- Convert C_out to std_logic_vector (only one bit)
                    expected_C_out <= std_logic_vector(to_unsigned(expected_C_out_int, 1));
                    
                    -- Assert the results
                    assert S = expected_S
                        report "S mismatch: A=" & integer'image(a) & ", B=" & integer'image(b) &
                               ", C_in=" & integer'image(cin) & ", Expected S=" & integer'image(expected_S_int)
                        severity failure;
                    
                    assert C_out = expected_C_out
                        report "C_out mismatch: A=" & integer'image(a) & ", B=" & integer'image(b) &
                               ", C_in=" & integer'image(cin) & ", Expected C_out=" & integer'image(expected_C_out_int)
                        severity failure;
                end loop;
            end loop;
        end loop;
        
        -- Test completed successfully
        report "All tests passed!" severity success;
    end process;
end sim;