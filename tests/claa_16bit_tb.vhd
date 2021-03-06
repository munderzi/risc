library ieee;
use ieee.std_logic_1164.all;

entity claa_16bit_tb is
end entity;

architecture behaviour of claa_16bit_tb is
    component claa_16bit is
        port
        (
        i_opa, i_opb:    in std_logic_vector(15 downto 0);
        i_c:             in std_logic;
        o_e:             out std_logic_vector(15 downto 0);
        o_p,   o_g, o_c: out std_logic
        );
    end component;

    signal opa_tb, opb_tb, eo_tb:      std_logic_vector(15 downto 0);
    signal ci_tb, po_tb, go_tb, co_tb: std_logic;

begin
    dut : claa_16bit port map
    (
    i_opa => opa_tb,
    i_opb => opb_tb,
    i_c   => ci_tb,
    o_e   => eo_tb,
    o_p   => po_tb,
    o_g   => go_tb,
    o_c   => co_tb
    );

    stim_proc : process
    type pattern_type is record
        a, b:     std_logic_vector(15 downto 0);
        c:        std_logic;
        e:        std_logic_vector(15 downto 0);
        p, g, oc: std_logic;
    end record;

    type pattern_array is array(natural range <>) of pattern_type;
    constant patterns : pattern_array :=
    (("0000000000000000", "0000000000000000", '0', "0000000000000000", '0', '0', '0'),
     ("0000000000000001", "0000000000000001", '0', "0000000000000010", '0', '0', '0'),
     ("0000000000000001", "0000000000000001", '1', "0000000000000011", '0', '0', '0'),
     ("1111111111111100", "0000000000000011", '0', "1111111111111111", '1', '0', '0'),
     ("1010101010101010", "0101010101010101", '1', "0000000000000000", '1', '0', '1'),
     ("0001000010001011", "0100001000000100", '1', "0101001010010000", '0', '0', '0'),
     ("0001000010001011", "0100001000000100", '0', "0101001010001111", '0', '0', '0'),
     ("0000100110010000", "1100000000000011", '0', "1100100110010011", '0', '0', '0'),
     ("0000000000001111", "0000000000001111", '0', "0000000000011110", '0', '0', '0'),
     ("0000000011111111", "0000000011111111", '1', "0000000111111111", '0', '0', '0'));

    begin
        for i in patterns'range loop
            opa_tb <= patterns(i).a;
            opb_tb <= patterns(i).b;
            ci_tb  <= patterns(i).c;

            wait for 5 ns;
            assert eo_tb = patterns(i).e report "bad sum value" severity error;
            assert po_tb = patterns(i).p report "bad prop value" severity error;
            assert go_tb = patterns(i).g report "bad gen value" severity error;
            assert co_tb = patterns(i).oc report "bad carry value" severity error;
        end loop;
        
        assert false report "CLAA testbench finished" severity note;
        wait;
    end process;
end;
