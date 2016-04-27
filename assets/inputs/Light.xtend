package light

import org.eclipse.xtend.lib.annotations.Accessors

annotation StateMachine {}
annotation State {}
annotation Transition {
	String target
}

interface IStateMachine {}

interface IState {
	def void handle(IStateMachine stateMachine)
}

@StateMachine
class Light implements IStateMachine {
	@Accessors var IState state
	@Accessors var int count

	new() {
		count = 0
		state = new Off
	}

	def pushTheButton() {
		state.handle(this)
		count++
	}

	@State
	static class On implements IState {
		override void handle(IStateMachine stateMachine) {
			switchOff(stateMachine as Light)
		}

		@Transition(target="Off")
		def switchOff(Light light) {
			light.state = new Off
		}
	}

	@State
	static class Off implements IState {
		override void handle(IStateMachine stateMachine) {
			val light = stateMachine as Light
			if (light.count < 10) {
				switchOn(light)
			} else {
				getGone(light)
			} 
		}

		@Transition(target="On")
		def switchOn(Light light) {
			light.state = new On
		}

		@Transition(target="Gone")
		def getGone(Light light) {
			light.state = new Gone
		}
	}

	@State
	static class Gone implements IState {
		override void handle(IStateMachine stateMachine) {}
	}
}
