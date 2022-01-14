trigger NaveenDemoTrigger on Opportunity (after insert) {
	NaveenDemoDelete.NaveenDemoDeletemethod(Trigger.new);
}