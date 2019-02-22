"""Runs ConnectIQ tests and reports on the output."""
from collections import namedtuple
import subprocess
import sys


TestStats = namedtuple('TestStats', [
    'total',
    'passed',
    'failed',
])


def run_tests(simulator_path, device_id):
    """Run tests."""
    output = subprocess.run(
        ['monkeydo', simulator_path, device_id, '-t'],
        capture_output=True
    )

    if output.returncode != 0:
        raise Exception(output.stderr)
    
    return output.stdout.decode('utf-8')


def parse_output(test_output: str) -> TestStats:
    """Parse test output."""
    lines = test_output.splitlines()
    total_tests = 0
    passed_tests = 0

    for i, line in enumerate(lines[:-1]):
        next_line = lines[i+1]
        if not next_line or next_line.startswith('---------'):
            total_tests += 1

            if line.strip().upper() == 'PASS':
                passed_tests += 1

    return TestStats(
        total=total_tests,
        passed=passed_tests,
        failed=total_tests - passed_tests,
    )


if __name__ == '__main__':
    test_output = run_tests(sys.argv[1], sys.argv[2])
    stats = parse_output(test_output)
    print(test_output)

    print('***************************************************************')
    print(stats)
    print('***************************************************************\n')
    
    if stats.failed > 0:
        sys.exit(1)
