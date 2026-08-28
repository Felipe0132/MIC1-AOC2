library verilog;
use verilog.vl_types.all;
entity REGISTER_vlg_check_tst is
    port(
        \OUT\           : in     vl_logic_vector(7 downto 0);
        sampler_rx      : in     vl_logic
    );
end REGISTER_vlg_check_tst;
