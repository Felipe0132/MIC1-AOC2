library verilog;
use verilog.vl_types.all;
entity SHIFTER_vlg_sample_tst is
    port(
        INPUT           : in     vl_logic_vector(31 downto 0);
        MIR             : in     vl_logic_vector(23 downto 22);
        sampler_tx      : out    vl_logic
    );
end SHIFTER_vlg_sample_tst;
