within Buildings.Templates.AHUs.Validation.UserProject.AHUs;
model FanSupplyDrawMultipleVariable
  extends VAVSingleDuctWithEconomizer(
    nZon=1,
    nGro=1,
    final id="VAV_1",
    redeclare replaceable Buildings.Templates.BaseClasses.Fans.MultipleVariable
      fanSupDra(nFan=2));

  annotation (
    defaultComponentName="ahu");
end FanSupplyDrawMultipleVariable;
