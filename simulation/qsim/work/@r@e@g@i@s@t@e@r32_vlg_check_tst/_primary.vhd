library verilog;
use verilog.vl_types.all;
entity REGISTER32_vlg_check_tst is
    port(
        OUTPUTA         : in     vl_logic_vector(31 downto 0);
        OUTPUTB         : in     vl_logic_vector(31 downto 0);
        sampler_rx      : in     vl_logic
    );
end REGISTER32_vlg_check_tst;
