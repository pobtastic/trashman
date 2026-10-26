#!/usr/bin/env python3
# Copyright 2026 Paul Maddern (paul@arcadegeek.co.uk)
import sys
import os
import argparse
from collections import OrderedDict
from disassemble import Disassemble

try:
    from skoolkit.snapshot import get_snapshot
    from skoolkit import tap2sna, sna2skool
except ImportError:
    SKOOLKIT_HOME = os.environ.get('SKOOLKIT_HOME')
    if not SKOOLKIT_HOME:
        sys.stderr.write('SKOOLKIT_HOME is not set; aborting\n')
        sys.exit(1)
    if not os.path.isdir(SKOOLKIT_HOME):
        sys.stderr.write('SKOOLKIT_HOME={}; directory not found\n'.format(SKOOLKIT_HOME))
        sys.exit(1)
    sys.path.insert(0, SKOOLKIT_HOME)
    from skoolkit.snapshot import get_snapshot
    from skoolkit import tap2sna, sna2skool

TRASHMAN_HOME = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
BUILD_DIR = '{}/sources'.format(TRASHMAN_HOME)
TRASHMAN_Z80 = '{}/TRASHMAN.z80'.format(TRASHMAN_HOME)


class Trashman:
    def __init__(self, snapshot):
        self.snapshot = snapshot

    def address(self, addr):
        return self.snapshot[addr] + self.snapshot[addr + 0x01] * 0x100

    def get_items(self):
        pc = 0xC023
        end = 0xC13D
        lines = Disassemble(get_snapshot(TRASHMAN_Z80), pc, end)
        return lines.run()

    def get_bonus(self):
        lines = []

        addr = 0xCD3E
        while addr <= 0xD810:
            start = addr
            count = 0x00
            message = []
            while self.snapshot[addr] != 0x80:
                message.append(self.snapshot[addr])
                count += 0x01
                addr += 0x01
            string = ''.join(chr(byte) for byte in message[:32])
            lines.append('t ${:X} Messaging: {}'.format(start, string))
            lines.append(f"  ${start:04X},${count+0x01:02X}"+",$20" * (count // 0x20) + (f",${count % 0x20:02X}" if count % 0x20 > 0 else "") + f":$01 #FONT$E417,attr=$30,chars=0({string})()")
            lines.append('')
            addr += 0x01

        return '\n'.join(lines)


def run(subcommand):
    if not os.path.isdir(BUILD_DIR):
        os.mkdir(BUILD_DIR)
    if not os.path.isfile(TRASHMAN_Z80):
        tap2sna.main(('-d', BUILD_DIR, '@{}/trashman.t2s'.format(TRASHMAN_HOME)))
    trashman = Trashman(get_snapshot(TRASHMAN_Z80))
    ctlfile = '{}/{}.ctl'.format(BUILD_DIR, subcommand)
    with open(ctlfile, 'wt') as f:
        f.write(getattr(trashman, methods[subcommand][0])())
    #sna2skool.main(('-c', ctlfile, TRASHMAN_Z80))
    #lines = Disassemble(get_snapshot(TRASHMAN_Z80), 0xC023, 0xC13D)
    #print(lines.run())


###############################################################################
# Begin
###############################################################################
methods = OrderedDict((
    ('bonus', ('get_bonus', 'Bonus Messaging (52542-55312)')),
    ('items', ('get_items', 'Items (58500-59175)')),
    ('rooms', ('get_rooms', 'Rooms (49152-64767)'))
))
subcommands = '\n'.join('  {} - {}'.format(k, v[1]) for k, v in methods.items())
parser = argparse.ArgumentParser(
    usage='%(prog)s SUBCOMMAND',
    description="Produce a skool file snippet for \"Trashman\". SUBCOMMAND must be one of:\n\n{}".format(
        subcommands),
    formatter_class=argparse.RawTextHelpFormatter,
    add_help=False
)
parser.add_argument('subcommand', help=argparse.SUPPRESS, nargs='?')
namespace, unknown_args = parser.parse_known_args()
if unknown_args or namespace.subcommand not in methods:
    parser.exit(2, parser.format_help())
run(namespace.subcommand)
