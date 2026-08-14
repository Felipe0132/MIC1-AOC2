library verilog;
use verilog.vl_types.all;
entity SHIFTER_vlg_check_tst is
    port(
        N               : in     vl_logic;
        OUTPUT          : in     vl_logic_vector(31 downto 0);
        Z               : in     vl_logic;
        sampler_rx      : in     vl_logic
    );
end SHIFTER_vlg_check_tst;
