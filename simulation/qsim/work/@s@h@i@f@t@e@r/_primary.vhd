library verilog;
use verilog.vl_types.all;
entity SHIFTER is
    port(
        N               : out    vl_logic;
        OUTPUT          : out    vl_logic_vector(31 downto 0);
        INPUT           : in     vl_logic_vector(31 downto 0);
        MIR             : in     vl_logic_vector(23 downto 22);
        Z               : out    vl_logic
    );
end SHIFTER;
