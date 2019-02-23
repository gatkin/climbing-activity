using Toybox.Time;
using Toybox.Timer;
using Toybox.WatchUi;
using ClimbingCore as Core;
using ClimbingView;

class ClimbingSessionController extends WatchUi.BehaviorDelegate
{
    private const UPDATE_RATE_MS = 1000;
    
    private var climbingSession;
    private var view;
    private var timer;
    private var climbController;
    
    function initialize() {
        BehaviorDelegate.initialize();
        climbingSession = new Core.ClimbingSession(Time.now());
        
        view = new ClimbingSessionView(getViewModel());
        
        timer = new Timer.Timer();
        startTimer();
    }
    
    function getView() {
        return self.view;
    }

    function onChildBack() {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        self.view.update(self.getViewModel());
        self.startTimer();
    }

    function onNextPage() {
        startClimb();
        return true;
    }

    function onSelect() {
        startClimb();
        return true;
    }

    function onTimer() {
        self.view.update(self.getViewModel());
    }
    
    private function getViewModel() {
        return ClimbingView.sessionToViewModel(self.climbingSession, Time.now());
    }

    private function startClimb() {
        self.timer.stop();
        self.climbingSession.startNewClimb(Time.now());
        climbController = new ClimbController(self, self.climbingSession.getActiveClimb());

        WatchUi.pushView(climbController.getView(), climbController, WatchUi.SLIDE_UP);
    }

    private function startTimer() {
        timer.start(method(:onTimer), UPDATE_RATE_MS, true);
    }
}


class ClimbingSessionView extends WatchUi.View 
{
    private var sessionViewModel;

    function initialize(viewModel) {
        View.initialize();
        sessionViewModel = viewModel;
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
        var totalDuration = ClimbingView.formatDuration(sessionViewModel.getDuration());
        View.findDrawableById("total_time_text").setText(totalDuration);
        
        var climbsAttempted = sessionViewModel.getTotalClimbs().toString();
        View.findDrawableById("climbs_attempted_text").setText(climbsAttempted);
        
        var climbsSuccessful = sessionViewModel.getSuccessfulClimbs().toString();
        View.findDrawableById("climbs_successful_text").setText(climbsSuccessful);
        
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

    function update(newModel) {
        self.sessionViewModel = newModel;
        WatchUi.requestUpdate();
    }
}
