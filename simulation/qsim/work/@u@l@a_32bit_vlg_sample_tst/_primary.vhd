library verilog;
use verilog.vl_types.all;
entity ULA_32bit_vlg_sample_tst is
    port(
        A               : in     vl_logic_vector(31 downto 0);
        B               : in     vl_logic_vector(31 downto 0);
        MIR             : in     vl_logic_vector(35 downto 0);
        sampler_tx      : out    vl_logic
    );
end ULA_32bit_vlg_sample_tst;
