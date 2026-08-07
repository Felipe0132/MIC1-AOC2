library verilog;
use verilog.vl_types.all;
entity SLL_vlg_sample_tst is
    port(
        INPUT           : in     vl_logic_vector(31 downto 0);
        sampler_tx      : out    vl_logic
    );
end SLL_vlg_sample_tst;
