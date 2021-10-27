within Buildings.Templates.AirHandlersFans.Validation.UserProject;
block DummyControlPointsTerminalUnit
  extends Modelica.Blocks.Icons.Block;

  ZoneEquipment.Interfaces.Bus busTer
    "Terminal unit control bus" annotation (Placement(transformation(
        extent={{-20,20},{20,-20}},
        rotation=90,
        origin={200,0}), iconTransformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={100,0})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant tNexOcc(final k=3600)
    "Time next occupancy"
    annotation (Placement(transformation(extent={{-140,130},{-120,150}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant uOccSch(final k=true)
    "Scheduled occupancy"
    annotation (Placement(transformation(extent={{-140,90},{-120,110}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TZon(final k=303.15)
    "Zone temperature"
    annotation (Placement(transformation(extent={{-140,-30},{-120,-10}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant VDis_flow(final k=1)
    annotation (Placement(transformation(extent={{-140,-70},{-120,-50}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant yReqZonTemRes(final k=1)
    "Request"
    annotation (Placement(transformation(extent={{-100,-110},{-80,-90}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant yReqZonPreRes(final k=1)
    "Request"
    annotation (Placement(transformation(extent={{-60,-110},{-40,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant uOveZon(final k=true)
    "Zone occupancy override"
    annotation (Placement(transformation(extent={{-100,90},{-80,110}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TDis(final k=303.15)
    "Discharge temperature"
    annotation (Placement(transformation(extent={{-140,10},{-120,30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant uOcc(final k=true)
    "Zone occupancy sensor"
    annotation (Placement(transformation(extent={{-60,90},{-40,110}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant uWin(final k=true)
    "Zone window sensor"
    annotation (Placement(transformation(extent={{-20,90},{0,110}})));
equation
  connect(tNexOcc.y, busTer.tNexOcc);
  connect(uOccSch.y, busTer.uOccSch);
  connect(uOveZon.y, busTer.uOveZon);
  connect(uOcc.y, busTer.uOcc);
  connect(uWin.y, busTer.uWin);
  connect(TZon.y, busTer.TZon);
  connect(TDis.y, busTer.TDis);
  connect(VDis_flow.y, busTer.VDis_flow);
  connect(yReqZonTemRes.y, busTer.yReqZonTemRes);
  connect(yReqZonPreRes.y, busTer.yReqZonPreRes);

  annotation (
    defaultComponentName="conPoiDum",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}})),       Diagram(coordinateSystem(preserveAspectRatio=
            false, extent={{-200,-180},{200,180}})));
end DummyControlPointsTerminalUnit;
