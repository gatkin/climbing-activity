class ClimbingSession
{
	private var id;
	private var startTime;	

	function initialize(start) {
		startTime = start;
		id = start.value();
	}
	
	function getId() {
		return self.id;
	}
	
	function getNumberOfClimbs() {
		return 0;
	}
	
	function getStartTime() {
		return self.startTime;
	}
}