within Buildings.Templates.AHUs.Validation.UserProject.AHUs;
model WrapperEconomizerDampers
  extends Buildings.Templates.AHUs.VAVSingleDuctWrapper(
    typRel=Buildings.Templates.Types.ReliefReturn.ReliefDamper,
    typOut=Buildings.Templates.Types.OutdoorAir.SingleCommon,
    nZon=1,
    nGro=1,
    id="VAV_1");
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end WrapperEconomizerDampers;
