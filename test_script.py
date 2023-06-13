"""
test_script.py

A file containing an (unfinished) cocotb testbench. cocotb is a new, 
open-source testbenching framework that allows for testbenching in 
python. This allows for several benifits, including but not limited 
to, easier prototyping, a large number of Python libraries, and of 
course, a vastly increased pool of developers over SystemVerilog. I 
urge y'all to check this file out and take a look at cocotb on your 
own time. Check https://www.cocotb.org/ for more details!
"""

import cocotb
from cocotb.triggers import Timer


@cocotb.test()
async def basic_counting(dut):
    """Tests basic counter functionality."""

    dut.enable_i.value = 1
    dut.wrap_i.value = 1
    dut.max_i.value = (2 ** 8) - 1

    await reset_dut(dut.nrst, dut.clk, 10)

    for cycle in range(300):
        await clock_dut(dut.clk)
        assert dut.count_o.value.integer == (cycle + 1) % (2 ** 8)

    dut._log.info("count_o is %s", dut.count_o.value.integer).cocotb


@cocotb.test()
async def enable_test(dut):
    """Tests the enable feature."""

    dut.enable_i.value = 0
    dut.wrap_i.value = 1
    dut.max_i.value = (2 ** 8) - 1

    await reset_dut(dut.nrst, dut.clk, 10)

    for cycle in range(300):
        await clock_dut(dut.clk)
        assert dut.count_o.value.integer == 0

    dut._log.info("count_o is %s", dut.count_o.value.integer)


@cocotb.test()
async def max_test(dut):
    """Tests wrapping of the counter at a max value."""

    dut.enable_i.value = 1
    dut.wrap_i.value = 1
    dut.max_i.value = 40

    await reset_dut(dut.nrst, dut.clk, 10)

    for cycle in range(300):
        await clock_dut(dut.clk)
        assert dut.count_o.value.integer == (cycle + 1) % (40 + 1)

    dut._log.info("count_o is %s", dut.count_o.value.integer)


@cocotb.test()
async def no_wrap_test(dut):
    """Tests the counter at in no-wrap mode."""

    dut.enable_i.value = 1
    dut.wrap_i.value = 0
    dut.max_i.value = 100

    await reset_dut(dut.nrst, dut.clk, 10)

    for cycle in range(300):
        await clock_dut(dut.clk)
        assert dut.count_o.value.integer == min(cycle + 1, 100)

    dut._log.info("count_o is %s", dut.count_o.value.integer)


@cocotb.test()
async def at_max_test(dut):
    """Tests the counter's at-max signal."""

    dut.enable_i.value = 1
    dut.wrap_i.value = 1
    dut.max_i.value = 20

    await reset_dut(dut.nrst, dut.clk, 10)

    for cycle in range(300):
        await clock_dut(dut.clk)
        assert dut.count_o.value.integer == (cycle + 1) % (20 + 1)
        if dut.count_o.value.integer != 20:
            assert dut.atmax_o.value == 0
        else:
            assert dut.atmax_o.value == 1

    dut._log.info("count_o is %s", dut.count_o.value.integer)


async def reset_dut(reset, clock, duration, active_high=False):
    """Function for resting dut, by default active-low reset"""
    reset.value = 0 ^ active_high
    for _ in range(duration):
        await clock_dut(clock)
    reset.value = 1 ^ active_high


async def clock_dut(clock):
    """Clocks the dut for one clock cycle"""
    clock.value = 0
    await Timer(1, units="ns")
    clock.value = 1
    await Timer(1, units="ns")
