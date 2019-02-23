"""Runs ConnectIQ tests and reports on the output."""
from collections import namedtuple
import subprocess
import sys


FAIL = 'FAIL'
ERROR = 'ERROR'
PASS = 'PASS'

TEST_OUTCOME_STRINGS = {
    FAIL,
    ERROR,
    PASS,
}


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

    cleaned_lines = (line.strip().upper() for line in lines)
    test_outcome_lines = (line for line in cleaned_lines if line in TEST_OUTCOME_STRINGS)
    
    for test_outcome in test_outcome_lines:
        total_tests += 1
        if test_outcome == PASS:
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
