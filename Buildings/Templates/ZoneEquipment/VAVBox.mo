within Buildings.Templates.ZoneEquipment;
model VAVBox "VAV terminal unit"
  extends Buildings.Templates.ZoneEquipment.Interfaces.PartialAirTerminal(
    final typ=Types.Configuration.SingleDuct);

  inner replaceable package MediumHea=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Heating medium (such as HHW)"
    annotation(Dialog(enable=have_souCoiReh));

  parameter Modelica.SIunits.PressureDifference dpDamVAV_nominal=
    dat.getReal(varName=id + ".Mechanical.VAV damper pressure drop.value")
    "Damper pressure drop"
    annotation (Dialog(group="Nominal condition"));

  final parameter Boolean have_souCoiReh=coiReh.have_sou
    "Set to true for fluid ports on the source side"
    annotation (Evaluate=true, Dialog(group="Reheat coil"));

  Modelica.Fluid.Interfaces.FluidPort_a port_coiRehSup(
    redeclare final package Medium =MediumHea) if have_souCoiReh
    "Reheat coil supply port"
    annotation (Placement(transformation(extent={{10,-290},{30,-270}}),
      iconTransformation(extent={{-30,-208},{-10,-188}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_coiRehRet(
    redeclare final package Medium =MediumHea) if have_souCoiReh
    "Reheat coil return port"
    annotation (Placement(transformation(extent={{-30,-290},{-10,-270}}),
      iconTransformation(extent={{10,-208},{30,-188}})));

  inner replaceable Buildings.Templates.Components.Coils.None coiReh
    constrainedby Buildings.Templates.Components.Coils.Interfaces.PartialCoil(
      final fun=Buildings.Templates.Components.Types.CoilFunction.Reheat)
    "Reheat coil"
    annotation (
    choices(
      choice(redeclare Buildings.Templates.Components.Coils.None coiReh "No coil"),
      choice(redeclare Buildings.Templates.Components.Coils.WaterBasedHeating coiReh
          "Water-based")),
    Dialog(group="Reheat coil"),
    Placement(transformation(extent={{-10,-210},{10,-190}})));

  inner replaceable Buildings.Templates.Components.Dampers.PressureIndependent damVAV
    constrainedby
    Buildings.Templates.Components.Dampers.Interfaces.PartialDamper(
      redeclare final package Medium = MediumAir,
      final m_flow_nominal=m_flow_nominal,
      final dpDamper_nominal=dpDamVAV_nominal)
    "VAV damper"
    annotation (Dialog(group="VAV damper"),
      Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-120,-200})));

  inner replaceable Buildings.Templates.ZoneEquipment.Components.Controls.OpenLoop con
    constrainedby
    Buildings.Templates.ZoneEquipment.Components.Controls.Interfaces.PartialController
    "Terminal unit controller"
    annotation (
    choicesAllMatching=true,
    Dialog(group="Controller"),
    Placement(transformation(extent={{-10,90},{10,110}})));

  Buildings.Templates.Components.Sensors.Temperature TDis(
    redeclare final package Medium = MediumAir,
    final have_sen=con.typ==Buildings.Templates.ZoneEquipment.Types.Controller.Guideline36,
    final m_flow_nominal=m_flow_nominal,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.Standard)
    "Discharge air temperature sensor"
    annotation (Placement(transformation(extent={{90,-210},{110,-190}})));
  Buildings.Templates.Components.Sensors.VolumeFlowRate VDis_flow(
    redeclare final package Medium = MediumAir,
    final have_sen=con.typ==Buildings.Templates.ZoneEquipment.Types.Controller.Guideline36,
    final m_flow_nominal=m_flow_nominal,
    final typ=Buildings.Templates.Components.Types.SensorVolumeFlowRate.FlowCross)
    annotation (Placement(transformation(extent={{-200,-210},{-180,-190}})));
equation
  /* Control point connection - start */
  connect(damVAV.bus, bus.damVAV);
  connect(coiReh.bus, bus.coiReh);
  connect(TDis.y, bus.TDis);
  connect(VDis_flow.y, bus.VDis_flow);
  /* Control point connection - end */
  connect(port_coiRehSup, coiReh.port_aSou) annotation (Line(points={{20,-280},{
          20,-260},{4,-260},{4,-210}},     color={0,127,255}));
  connect(coiReh.port_bSou, port_coiRehRet) annotation (Line(points={{-4,-210},{
          -4,-260},{-20,-260},{-20,-280}},
                                        color={0,127,255}));
  connect(damVAV.port_b, coiReh.port_a)
    annotation (Line(points={{-110,-200},{-10,-200}}, color={0,127,255}));
  connect(bus, con.bus) annotation (Line(
      points={{-300,0},{-20,0},{-20,100},{-10,100}},
      color={255,204,51},
      thickness=0.5));
  connect(coiReh.port_b, TDis.port_a)
    annotation (Line(points={{10,-200},{90,-200}}, color={0,127,255}));
  connect(TDis.port_b, port_Dis)
    annotation (Line(points={{110,-200},{300,-200}}, color={0,127,255}));

  connect(port_Sup, VDis_flow.port_a)
    annotation (Line(points={{-300,-200},{-200,-200}}, color={0,127,255}));
  connect(VDis_flow.port_b, damVAV.port_a)
    annotation (Line(points={{-180,-200},{-130,-200}}, color={0,127,255}));
  annotation (Diagram(graphics={
        Line(points={{300,-190},{-300,-190}},
                                            color={0,0,0}),
        Line(points={{300,-210},{-300,-210}},
                                            color={0,0,0})}));
end VAVBox;
