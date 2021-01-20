within Buildings.Experimental.Templates.AHUs.Coils.Actuators;
model TwoWayValve
  extends Interfaces.Actuator(
    final typ=Types.Actuator.TwoWayValve);

  outer parameter Buildings.Experimental.Templates.AHUs.Coils.Data.WaterBased
    datCoi annotation (Placement(transformation(extent={{-10,-98},{10,-78}})));

  replaceable Fluid.Actuators.Valves.TwoWayEqualPercentage val
    constrainedby Fluid.Actuators.BaseClasses.PartialTwoWayValve(
      redeclare final package Medium=Medium,
      final m_flow_nominal=datCoi.mWat_flow_nominal,
      final dpValve_nominal=datCoi.datAct.dpValve_nominal,
      final dpFixed_nominal=datCoi.datAct.dpFixed_nominal)
    annotation (
      choicesAllMatching=true,
      Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={40,0})));
equation
  connect(port_aSup, port_bSup)
    annotation (Line(points={{-40,-100},{-40,100}}, color={0,127,255}));
  connect(port_aRet, val.port_a)
    annotation (Line(points={{40,100},{40,10}}, color={0,127,255}));
  connect(val.port_b, port_bRet)
    annotation (Line(points={{40,-10},{40,-100}}, color={0,127,255}));
  connect(y, val.y)
    annotation (Line(points={{-120,0},{-46,0},{-46,2.22045e-15},{28,2.22045e-15}},
                                               color={0,0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end TwoWayValve;
