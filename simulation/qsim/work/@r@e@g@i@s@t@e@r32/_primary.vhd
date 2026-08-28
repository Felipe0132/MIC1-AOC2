library verilog;
use verilog.vl_types.all;
entity REGISTER32 is
    port(
        OUTPUTA         : out    vl_logic_vector(31 downto 0);
        Load            : in     vl_logic;
        CLOCK           : in     vl_logic;
        B               : in     vl_logic_vector(31 downto 0);
        INPUT_SELECT    : in     vl_logic;
        A               : in     vl_logic_vector(31 downto 0);
        IN_LOAD         : in     vl_logic_vector(31 downto 0);
        OUTPUT_ENABLE_A : in     vl_logic;
        OUTPUTB         : out    vl_logic_vector(31 downto 0);
        OUTPUT_ENABLE_B : in     vl_logic
    );
end REGISTER32;
