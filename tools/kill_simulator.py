"""Kills the ConnectIQ simulator."""
from collections import namedtuple
import glob
import subprocess


Process = namedtuple('Process', [
    'pid',
    'name',
])


def is_simulator_process(process: Process) -> bool:
    """Is the process a ConnectIQ simulator process."""
    return 'ConnectIQ.app' in process.name and 'simulator' in process.name


def parse_process_line(process_line: str) -> Process:
    """Parse a single process line."""
    process_line = process_line.strip()
    fields = process_line.split()
    return Process(
        pid=fields[0],
        name=fields[3],
    )


output = subprocess.run(['ps', '-A'], capture_output=True)
processe_lines = output.stdout.decode('utf-8').splitlines()

processes = (parse_process_line(line) for line in processe_lines)
simulator_processes = (process for process in processes
                       if is_simulator_process(process))

for simulator in simulator_processes:
    print(f'Killing {simulator}')
    subprocess.check_call(['kill', f'{simulator.pid}'])
