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
        var test_cases = [
            {:value => 0, :display => "5.6"},
            {:value => 1, :display => "5.7"},
            {:value => 2, :display => "5.8"},
            {:value => 3, :display => "5.9"},
            {:value => 4, :display => "5.10A"},
            {:value => 5, :display => "5.10B"},
            {:value => 6, :display => "5.10C"},
            {:value => 7, :display => "5.10D"},
            {:value => 8, :display => "5.11A"},
            {:value => 9, :display => "5.11B"},
            {:value => 10, :display => "5.11C"},
            {:value => 11, :display => "5.11D"},
            {:value => 12, :display => "5.12A"},
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