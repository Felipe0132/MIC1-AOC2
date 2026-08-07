library verilog;
use verilog.vl_types.all;
entity \SLL\ is
    port(
        OUTPUT          : out    vl_logic_vector(31 downto 0);
        INPUT           : in     vl_logic_vector(31 downto 0)
    );
end \SLL\;
