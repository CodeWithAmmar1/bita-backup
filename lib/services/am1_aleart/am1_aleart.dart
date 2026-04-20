

class _AlertState {
  bool suctionAlerted = false;
  bool dischargeAlerted = false;
  bool returnAlerted = false;
  bool suctionPressureAlerted = false;
  bool dischargePressureAlerted = false;
  bool suctionPressureSwitchAlerted = false;
  bool dischargePressureSwitchAlerted = false;
  bool oilPressureSwitchAlerted = false;
}
final alertState = _AlertState();  // Also outside any function
