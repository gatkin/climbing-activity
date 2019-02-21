using Toybox.Time;
using Toybox.WatchUi;
using ClimbingCore as Core;

class ClimbingActivityView extends WatchUi.View {

    private var climbingSession;

    function initialize() {
        View.initialize();
        climbingSession = new Core.ClimbingSession(Time);
    }

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.SessionLayout(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

}
