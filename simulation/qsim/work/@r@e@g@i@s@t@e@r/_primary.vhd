library verilog;
use verilog.vl_types.all;
entity \REGISTER\ is
    port(
        \OUT\           : out    vl_logic_vector(7 downto 0);
        Load            : in     vl_logic;
        IN_LOAD         : in     vl_logic_vector(7 downto 0);
        CLOCK           : in     vl_logic;
        \IN\            : in     vl_logic_vector(7 downto 0)
    );
end \REGISTER\;
