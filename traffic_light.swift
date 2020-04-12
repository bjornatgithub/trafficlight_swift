import UIKit

protocol LightState
{
    func switchNext(_ light: Light)
    func switchOff(_ light: Light)
    func switchOn(_ light: Light)
    func switchAlert(_ light: Light)
    
    func changeState(_ light: Light, state: LightState)
}

extension LightState {
    func changeState(_ light: Light, state: LightState) {light.changeState(state)}
}


class LightRedState : LightState
{
    func switchNext(_ light: Light)
    {
        light.value_ = Light.Color.green
        changeState(light, state: LightGreenState())
    }
    func switchOff(_ light: Light)
    {
        light.value_ = Light.Color.off
        changeState(light, state: LightOffState())
    }
    func switchOn(_ light: Light) {}
    func switchAlert(_ light: Light) {}
}

class LightYellowState : LightState
{
    func switchNext(_ light: Light)
    {
        light.value_ = Light.Color.red
        changeState(light, state: LightRedState())
    }
    func switchOff(_ light: Light) {}
    func switchOn(_ light: Light) {}
    func switchAlert(_ light: Light) {}
}

class LightGreenState : LightState
{
    func switchNext(_ light: Light)
    {
        light.value_ = Light.Color.yellow
        changeState(light, state: LightYellowState())
    }
    func switchOff(_ light: Light) {}
    func switchOn(_ light: Light) {}
    func switchAlert(_ light: Light) {}
}

class LightOffState : LightState
{
    func switchNext(_ light: Light)
    {
        light.value_ = Light.Color.off
    }
    func switchOff(_ light: Light) {}
    func switchOn(_ light: Light)
    {
        light.value_ = Light.Color.red
        changeState(light, state: LightRedState())
    }
    func switchAlert(_ light: Light)
    {
        light.value_ = Light.Color.yellow
        changeState(light, state: LightAlertState())
    }
}

class LightAlertState : LightState
{
    func switchNext(_ light: Light)
    {
        if light.status() == Light.Color.yellow {
            light.value_ = Light.Color.off
        } else {
            light.value_ = Light.Color.yellow
        }
    }
    func switchOff(_ light: Light)
    {
        light.value_ = Light.Color.off
        changeState(light, state: LightOffState())
    }
    func switchOn(_ light: Light)
    {
        light.value_ = Light.Color.red
        changeState(light, state: LightRedState())
    }
    func switchAlert(_ light: Light) {}
}

class Light {
    enum Color {case off, red, green, yellow}
    
    var value_: Color = Color.off
    var state_: LightState = LightOffState()
    
    init() {print("initialize traffic light status:\(value_)")}
    deinit {print("deinitialize traffic light status:\(value_)")}
    
    func switchNext() {state_.switchNext(self)}
    func switchOff() {state_.switchOff(self)}
    func switchOn() {state_.switchOn(self)}
    func switchAlert() {state_.switchAlert(self)}

    func status() -> Color {return value_}
    func changeState(_ state: LightState) {state_ = state}
}

// __main__
var light = Light()

// switch on Light
print("Switch on light")
print(light.status())
light.switchOn()
print(light.status())

let maxCycle = 3
var countCycle = 0
print("Switch \(maxCycle) normal cycles...")
normalCycle: repeat {
    light.switchNext()
    print(light.status())
    if light.status() == Light.Color.red {
        countCycle += 1
    }
} while countCycle < maxCycle

print("Switch to Alert mode")
print(light.status())
light.switchOff()
print(light.status())
light.switchAlert()
print(light.status())

countCycle = 0
print("Switch \(maxCycle) alert cycles...")
alertCycle: repeat {
    light.switchNext()
    print(light.status())
    if light.status() == Light.Color.yellow {
        countCycle += 1
    }
} while countCycle < maxCycle
