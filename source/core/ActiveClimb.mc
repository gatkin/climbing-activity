class ActiveClimb
{
	private var id;
	private var startTime;
	
	function initialize(start) {
		startTime = start;
		id = start.value();
	}
	
	function completeAsSuccess(endTime) {
		return new CompletedClimb(
			id, startTime, endTime, true
		);
	}
	
	function getId() {
		return self.id;
	}
	
	function getStartTime() {
		return self.startTime;
	}
}