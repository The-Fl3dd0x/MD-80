# McDonnell Douglas MD-80 DU Controller
# Copyright (c) 2022 Josh Davidson (Octal450)
# This file manages the DU Canvas hide/showing in an efficient and synchronized way

var DUController = {
	errorActive: 0,
	flightDirector: "SINGLE CUE",
	pwrSource: {
		acR: 0,
		emerAc: 0,
	},
	showNd1: props.globals.initNode("/instrumentation/nd/show-nd1", 0, "BOOL"),
	showNd2: props.globals.initNode("/instrumentation/nd/show-nd2", 0, "BOOL"),
	updatePfd1: 0,
	updatePfd2: 0,
	updateNd1: 0,
	updateNd2: 0,
	showError: func() {
		me.errorActive = 1;
		
		# Hide the pages
		me.updatePfd1 = 0;
		me.updatePfd2 = 0;
		me.updateNd1 = 0;
		me.updateNd2 = 0;
		canvas_pfd.pfd1.page.hide();
		canvas_pfd.pfd2.page.hide();
		me.showNd1.setBoolValue(0); # Temporary
		me.showNd2.setBoolValue(0); # Temporary
		
		# Now show the error
		canvas_pfd.pfd1Error.page.show();
		canvas_pfd.pfd2Error.page.show();
		canvas_pfd.pfd1Error.update();
		canvas_pfd.pfd2Error.update();
	},
	loop: func() {
		me.flightDirector = pts.Systems.Acconfig.Options.flightDirector.getValue();
		
		if (pts.Options.panel.getValue() == "EFIS") {
			if (!me.errorActive) {
				me.pwrSource.acR = systems.ELEC.Bus.acR.getValue();
				me.pwrSource.emerAc = systems.ELEC.Bus.emerAc.getValue();
				
				if (me.pwrSource.emerAc >= 112 and pts.Instrumentation.Du.pfdDimmer[0].getValue() > 0.01) {
					if (!me.updatePfd1) {
						me.updatePfd1 = 1;
						canvas_pfd.pfd1.update();
						canvas_pfd.pfd1.page.show();
					}
				} else {
					if (me.updatePfd1) {
						me.updatePfd1 = 0;
						canvas_pfd.pfd1.page.hide();
					}
				}
				
				if (me.pwrSource.emerAc >= 112 and pts.Instrumentation.Du.ndDimmer[0].getValue() > 0.01) {
					if (!me.updateNd1) {
						me.updateNd1 = 1;
						me.showNd1.setBoolValue(1); # Temporary
					}
				} else {
					if (me.updateNd1) {
						me.updateNd1 = 0;
						me.showNd1.setBoolValue(0); # Temporary
					}
				}
				
				if (me.pwrSource.acR >= 112 and pts.Instrumentation.Du.pfdDimmer[1].getValue() > 0.01) {
					if (!me.updatePfd2) {
						me.updatePfd2 = 1;
						canvas_pfd.pfd2.update();
						canvas_pfd.pfd2.page.show();
					}
				} else {
					if (me.updatePfd2) {
						me.updatePfd2 = 0;
						canvas_pfd.pfd2.page.hide();
					}
				}
				
				if (me.pwrSource.acR >= 112 and pts.Instrumentation.Du.ndDimmer[1].getValue() > 0.01) {
					if (!me.updateNd2) {
						me.updateNd2 = 1;
						me.showNd2.setBoolValue(1); # Temporary
					}
				} else {
					if (me.updateNd2) {
						me.updateNd2 = 0;
						me.showNd2.setBoolValue(0); # Temporary
					}
				}
			}
		} else {
			me.updatePfd1 = 0;
			me.updatePfd2 = 0;
			me.updateNd1 = 0;
			me.updateNd2 = 0;
		}
	},
};
