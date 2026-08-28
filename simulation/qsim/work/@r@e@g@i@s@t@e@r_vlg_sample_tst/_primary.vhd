library verilog;
use verilog.vl_types.all;
entity REGISTER_vlg_sample_tst is
    port(
        CLOCK           : in     vl_logic;
        \IN\            : in     vl_logic_vector(7 downto 0);
        IN_LOAD         : in     vl_logic_vector(7 downto 0);
        Load            : in     vl_logic;
        sampler_tx      : out    vl_logic
    );
end REGISTER_vlg_sample_tst;
