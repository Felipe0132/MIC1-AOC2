library verilog;
use verilog.vl_types.all;
entity REGISTER32_vlg_sample_tst is
    port(
        A               : in     vl_logic_vector(31 downto 0);
        B               : in     vl_logic_vector(31 downto 0);
        CLOCK           : in     vl_logic;
        IN_LOAD         : in     vl_logic_vector(31 downto 0);
        INPUT_SELECT    : in     vl_logic;
        Load            : in     vl_logic;
        OUTPUT_ENABLE_A : in     vl_logic;
        OUTPUT_ENABLE_B : in     vl_logic;
        sampler_tx      : out    vl_logic
    );
end REGISTER32_vlg_sample_tst;
