within Buildings.Templates.AirHandlersFans.Components.Controls;
block OpenLoop "Open loop controller (output signals only)"
  extends
    Buildings.Templates.AirHandlersFans.Components.Controls.PartialSingleDuct(
      final typ=Types.Controller.OpenLoop);

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yDamOut(k=1)
 if secOutRel.typDamOut == Buildings.Templates.Components.Types.Damper.Modulated
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-180,170})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant yDamOut1(k=true)
 if secOutRel.typDamOut == Buildings.Templates.Components.Types.Damper.TwoPosition
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-170,144})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yDamOutMin(k=1)
 if secOutRel.typDamOutMin == Buildings.Templates.Components.Types.Damper.Modulated
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-150,170})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant yDamOutMin1(k=true)
 if secOutRel.typDamOutMin == Buildings.Templates.Components.Types.Damper.TwoPosition
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-140,144})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yDamRet(k=1)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-120,170})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yDamRel(k=1)
 if secOutRel.typDamRel == Buildings.Templates.Components.Types.Damper.Modulated
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-90,170})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant yDamRel1(k=true)
 if secOutRel.typDamRel == Buildings.Templates.Components.Types.Damper.TwoPosition
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-60,170})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yCoiCoo(k=1) if coiCoo.typ
     == Buildings.Templates.Components.Types.Coil.WaterBased or coiCoo.typHex
     == Buildings.Templates.Components.Types.HeatExchanger.DXVariableSpeed
     annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-60,110})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant yCoiCooSta(k=1)
 if coiCoo.typHex == Buildings.Templates.Components.Types.HeatExchanger.DXMultiStage
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-20,110})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant ySpeFanSup(k=1)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={60,70})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant yFanSup(k=true)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={100,70})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yCoiHea(k=1) if coiHea.typ
     == Buildings.Templates.Components.Types.Coil.WaterBased or coiHea.typHex
     == Buildings.Templates.Components.Types.HeatExchanger.DXVariableSpeed
    annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={20,110})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant ySpeFanRet(k=1)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={140,70})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant yFanRet(k=true)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={180,70})));

equation
  /* Equipment signal connection - start */
  connect(yDamOutMin.y, bus.out.yDamOutMin);
  connect(yDamOutMin1.y, bus.out.yDamOutMin);
  connect(yDamRel.y, bus.out.yDamRel);
  connect(yDamRel1.y, bus.out.yDamRel);
  connect(yCoiCoo.y, bus.out.yCoiCoo);
  connect(yCoiHea.y, bus.out.yCoiHea);

  connect(yFanSup.y, bus.fanSup.out.y);
  connect(ySpeFanSup.y, bus.fanSup.out.ySpe);

  connect(yFanRet.y, bus.fanRet.out.y);
  connect(ySpeFanRet.y, bus.fanRet.out.ySpe);

  connect(yCoiCooSta.y, bus.out.yCoiCoo);

  connect(yDamOut.y, bus.out.yDamOut);
  connect(yDamOut1.y, bus.out.yDamOut);

  connect(yDamRet.y, bus.out.yDamRet);
  /* Equipment signal connection - stop */

  annotation (
  defaultComponentName="conAHU",
  Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end OpenLoop;
