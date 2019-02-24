using Toybox.Test;


module ClimbingCore
{
    (:test)
    function boulderRating_UsesVScale(logger) {
        var test_cases = [
            {:value => :V0, :display => "V0"},
            {:value => :V1, :display => "V1"},
            {:value => :V2, :display => "V2"},
            {:value => :V3, :display => "V3"},
            {:value => :V4, :display => "V4"},
            {:value => :V5, :display => "V5"},
            {:value => :V6, :display => "V6"},
            {:value => :V7, :display => "V7"},
            {:value => :V8, :display => "V8"},
            {:value => :V9, :display => "V9"},
            {:value => :V10, :display => "V10"},
        ];

        for(var i = 0; i < test_cases.size(); i++) {
            var test_case = test_cases[i];

            logger.debug("boulder rating of value: " + test_case[:value]);
            var rating = new BoulderRating(test_case[:value]);

            logger.debug("climb type is bouldering");
            Test.assertEqual(CLIMB_TYPE_BOULDERING, rating.getClimbType());

            var expectedText = test_case[:display];
            var actualText = rating.getText();
            logger.debug("assert " + expectedText + " == " + actualText);
            Test.assertEqual(expectedText, actualText);
        }

        return true;
    }

    (:test)
    function ropedClimbRating_UsesYosemiteDecimalScale(logger) {
        // The "Y" prefix on the symbols is necessary because symbols cannot start with numbers.
        // The "Y" stands for "Yosemity decimal scale".
        var test_cases = [
            {:value => :Y56, :display => "5.6"},
            {:value => :Y57, :display => "5.7"},
            {:value => :Y58, :display => "5.8"},
            {:value => :Y59, :display => "5.9"},
            {:value => :Y510A, :display => "5.10A"},
            {:value => :Y510B, :display => "5.10B"},
            {:value => :Y510C, :display => "5.10C"},
            {:value => :Y510D, :display => "5.10D"},
            {:value => :Y511A, :display => "5.11A"},
            {:value => :Y511B, :display => "5.11B"},
            {:value => :Y511C, :display => "5.11C"},
            {:value => :Y511D, :display => "5.11D"},
            {:value => :Y512A, :display => "5.12A"},
        ];

        for(var i = 0; i < test_cases.size(); i++) {
            var test_case = test_cases[i];

            logger.debug("roped climb rating of value: " + test_case[:value]);
            var rating = new RopedClimbRating(test_case[:value]);

            logger.debug("climb type is roped climb");
            Test.assertEqual(CLIMB_TYPE_ROPE_CLIMB, rating.getClimbType());

            var expectedText = test_case[:display];
            var actualText = rating.getText();
            logger.debug("assert " + expectedText + " == " + actualText);
            Test.assertEqual(expectedText, actualText);
        }

        return true;
    }
}