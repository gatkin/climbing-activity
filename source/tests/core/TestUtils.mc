using Toybox.Test;


module ClimbingCore
{
    function assertDurationsAreEqual(expected, actual) {
		// It only works to compare durations by string
		var expectedDuration = expected.value().toString();
		var actualDuration = actual.value().toString();
		Test.assertEqual(expectedDuration, actualDuration);
	}
}
