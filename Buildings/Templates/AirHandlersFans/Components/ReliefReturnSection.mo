﻿within Buildings.Templates.AirHandlersFans.Components;
package ReliefReturnSection
  extends Modelica.Icons.Package;

  model NoEconomizer "No economizer"
    extends Buildings.Templates.AirHandlersFans.Components.ReliefReturnSection.Interfaces.PartialReliefReturnSection(
      final typ=Types.ReliefReturnSection.NoEconomizer,
      final typDam=damRel.typ,
      final typFan=fanRet.typ,
      final have_porPre=fanRet.typCtr == Types.ReturnFanControlSensor.Pressure);

    replaceable .Buildings.Templates.Components.Fans.None fanRet constrainedby
      Buildings.Templates.Components.Fans.Interfaces.PartialFan(
                                                    redeclare final package
        Medium = MediumAir, final loc=Buildings.Templates.Components.Types.Location.Return)
      "Return/relief fan" annotation (
      choices(
        choice(redeclare Templates.BaseClasses.Fans.None fanRet "No fan"),
        choice(redeclare Templates.BaseClasses.Fans.SingleVariable fanRet
            "Single fan - Variable speed"),
        choice(redeclare Templates.BaseClasses.Fans.MultipleVariable fanRet
            "Multiple fans (identical) - Variable speed")),
      Dialog(group="Exhaust/relief/return section"),
      Placement(transformation(extent={{110,-10},{90,10}})));
    Buildings.Templates.Components.Sensors.DifferentialPressure pRet_rel(
      redeclare final package Medium = MediumAir,
      final have_sen=fanRet.typCtr == Types.ReturnFanControlSensor.Pressure,
      final loc=Buildings.Templates.Components.Types.Location.Return)
      "Return static pressure sensor"
      annotation (Placement(transformation(extent={{30,-10},{10,10}})));

    Buildings.Templates.Components.Sensors.VolumeFlowRate VRet_flow(
      redeclare final package Medium = MediumAir,
      final have_sen=fanRet.typCtr == Types.ReturnFanControlSensor.Airflow,
      final loc=Buildings.Templates.Components.Types.Location.Return)
      "Return air volume flow rate sensor"
      annotation (Placement(transformation(extent={{70,-10},{50,10}})));

    Buildings.Templates.Components.Dampers.TwoPosition damRel(redeclare final
        package Medium = MediumAir, final loc=Buildings.Templates.Components.Types.Location.Relief)
      "Relief damper" annotation (Placement(transformation(
          extent={{10,-10},{-10,10}},
          rotation=0,
          origin={-150,0})));
  equation
    /* Hardware point connection - start */
    connect(fanRet.bus, bus.fanRet);
    connect(damRel.bus, bus.damRel);
    /* Hardware point connection - end */
    connect(port_a, fanRet.port_a)
      annotation (Line(points={{180,0},{110,0}}, color={0,127,255}));
    connect(fanRet.port_b, VRet_flow.port_a)
      annotation (Line(points={{90,0},{70,0}}, color={0,127,255}));
    connect(VRet_flow.port_b, pRet_rel.port_a)
      annotation (Line(points={{50,0},{30,0}}, color={0,127,255}));
    connect(pRet_rel.port_b, port_aIns)
      annotation (Line(points={{10,0},{-80,0}}, color={0,127,255}));
    connect(pRet_rel.port_bRef, port_bPre) annotation (Line(points={{20,-10},{20,
            -120},{80,-120},{80,-140}}, color={0,127,255}));
    connect(port_b, damRel.port_b)
      annotation (Line(points={{-180,0},{-160,0}}, color={0,127,255}));
    connect(damRel.port_a, pas.port_a)
      annotation (Line(points={{-140,0},{-110,0}}, color={0,127,255}));
    connect(pRet_rel.y, bus.pRet_rel) annotation (Line(points={{20,12},{20,
            20},{0.1,20},{0.1,140.1}}, color={0,0,127}));
    connect(VRet_flow.y, bus.VRet_flow) annotation (Line(points={{60,12},{
            60,20},{0.1,20},{0.1,140.1}}, color={0,0,127}));
  end NoEconomizer;

  model NoRelief "No relief branch"
    extends Buildings.Templates.AirHandlersFans.Components.ReliefReturnSection.Interfaces.PartialReliefReturnSection(
      final typ=Types.ReliefReturnSection.NoRelief,
      final typDam=Buildings.Templates.Components.Types.Damper.None,
      final typFan=fanRet.typ,
      have_recHea=false,
      final have_porPre=fanRet.typCtr == Types.ReturnFanControlSensor.Pressure);

    replaceable .Buildings.Templates.Components.Fans.None fanRet constrainedby
      Buildings.Templates.Components.Fans.Interfaces.PartialFan(
                                                    redeclare final package
        Medium = MediumAir, final loc=Buildings.Templates.Components.Types.Location.Return)
      "Return/relief fan" annotation (
      choices(
        choice(redeclare Templates.BaseClasses.Fans.None fanRet "No fan"),
        choice(redeclare Templates.BaseClasses.Fans.SingleVariable fanRet
            "Single fan - Variable speed"),
        choice(redeclare Templates.BaseClasses.Fans.MultipleVariable fanRet
            "Multiple fans (identical) - Variable speed")),
      Dialog(group="Exhaust/relief/return section"),
      Placement(transformation(extent={{110,-10},{90,10}})));
    Buildings.Templates.Components.Sensors.DifferentialPressure pRet_rel(
      redeclare final package Medium = MediumAir,
      final have_sen=fanRet.typCtr == Types.ReturnFanControlSensor.Pressure,
      final loc=Buildings.Templates.Components.Types.Location.Return)
      "Return static pressure sensor"
      annotation (Placement(transformation(extent={{30,-10},{10,10}})));

    Buildings.Templates.Components.Sensors.VolumeFlowRate VRet_flow(
      redeclare final package Medium = MediumAir,
      final have_sen,
      final loc=Buildings.Templates.Components.Types.Location.Return)
      "Return air volume flow rate sensor"
      annotation (Placement(transformation(extent={{70,-10},{50,10}})));
  equation
    /* Hardware point connection - start */
    connect(fanRet.bus, bus.fanRet);
    /* Hardware point connection - end */
    connect(port_a, fanRet.port_a)
      annotation (Line(points={{180,0},{110,0}}, color={0,127,255}));
    connect(fanRet.port_b, VRet_flow.port_a)
      annotation (Line(points={{90,0},{70,0}}, color={0,127,255}));
    connect(VRet_flow.port_b, pRet_rel.port_a)
      annotation (Line(points={{50,0},{30,0}}, color={0,127,255}));
    connect(pRet_rel.port_bRef, port_bPre) annotation (Line(points={{20,-10},{20,
            -120},{80,-120},{80,-140}}, color={0,127,255}));
    connect(pRet_rel.port_b, port_bRet)
      annotation (Line(points={{10,0},{0,0},{0,-140}}, color={0,127,255}));
    connect(pRet_rel.y, bus.pRet_rel) annotation (Line(points={{20,12},{20,
            20},{0.1,20},{0.1,140.1}}, color={0,0,127}));
    connect(VRet_flow.y, bus.VRet_flow) annotation (Line(points={{60,12},{
            60,20},{0,20},{0,80},{0.1,80},{0.1,140.1}}, color={0,0,127}));
  end NoRelief;

  model ReliefDamper "No relief fan - Modulated relief damper"
    extends Buildings.Templates.AirHandlersFans.Components.ReliefReturnSection.Interfaces.PartialReliefReturnSection(
      final typ=Types.ReliefReturnSection.ReliefDamper,
      final typDam=damRel.typ,
      final typFan=Buildings.Templates.Components.Types.Fan.None,
      final have_porPre=false);

    Buildings.Templates.Components.Dampers.Modulated damRel(redeclare final
        package Medium = MediumAir, final loc=Buildings.Templates.Components.Types.Location.Relief)
      "Relief damper" annotation (Placement(transformation(
          extent={{10,-10},{-10,10}},
          rotation=0,
          origin={-60,0})));
  equation
    /* Hardware point connection - start */
    connect(damRel.bus, bus.damRel);
    /* Hardware point connection - end */
    connect(damRel.port_b, port_aIns)
      annotation (Line(points={{-70,0},{-80,0}}, color={0,127,255}));
    connect(pas.port_a, port_b)
      annotation (Line(points={{-110,0},{-180,0}}, color={0,127,255}));
    connect(damRel.port_a, port_a)
      annotation (Line(points={{-50,0},{180,0}}, color={0,127,255}));
    connect(port_bRet, damRel.port_a)
      annotation (Line(points={{0,-140},{0,0},{-50,0}}, color={0,127,255}));
    annotation (Documentation(info="<html>
<p>
5.16.8 Control of Actuated Relief Dampers without Fans
5.16.8.1 Relief dampers shall be enabled when the associated
supply fan is proven ON, and disabled otherwise.
5.16.8.2 When enabled, use a P-only control loop to
modulate relief dampers to maintain 12 Pa (0.05 in. of water)
building static pressure. Close damper when disabled.
</p>
</html>"));
  end ReliefDamper;

  model ReliefFan "Relief fan - Two-position relief damper"
    extends Buildings.Templates.AirHandlersFans.Components.ReliefReturnSection.Interfaces.PartialReliefReturnSection(
      final typ=Types.ReliefReturnSection.ReliefFan,
      final typDam=damRel.typ,
      final typFan=fanRet.typ,
      final have_porPre=fanRet.typCtr == Types.ReturnFanControlSensor.Pressure);

    Buildings.Templates.Components.Dampers.TwoPosition damRel(redeclare final
        package Medium = MediumAir, final loc=Buildings.Templates.Components.Types.Location.Relief)
      "Relief damper" annotation (Placement(transformation(
          extent={{10,-10},{-10,10}},
          rotation=0,
          origin={-60,0})));
    replaceable .Buildings.Templates.Components.Fans.SingleVariable fanRet
      constrainedby Buildings.Templates.Components.Fans.Interfaces.PartialFan(
      redeclare final package Medium = MediumAir,
      final typCtr=Types.ReturnFanControlSensor.None,
      final loc=Buildings.Templates.Components.Types.Location.Relief)
      "Return/relief fan" annotation (choices(choice(redeclare
            Templates.BaseClasses.Fans.SingleVariable fanRet
            "Single fan - Variable speed"), choice(redeclare
            Templates.BaseClasses.Fans.MultipleVariable fanRet
            "Multiple fans (identical) - Variable speed")), Placement(
          transformation(extent={{-10,-10},{-30,10}})));
  equation
    /* Hardware point connection - start */
    connect(fanRet.bus, bus.fanRet);
    connect(damRel.bus, bus.damRel);
    /* Hardware point connection - end */
    connect(damRel.port_b, port_aIns)
      annotation (Line(points={{-70,0},{-80,0}}, color={0,127,255}));
    connect(pas.port_a, port_b)
      annotation (Line(points={{-110,0},{-180,0}}, color={0,127,255}));
    connect(damRel.port_a,fanRet. port_b)
      annotation (Line(points={{-50,0},{-30,0}}, color={0,127,255}));
    connect(fanRet.port_a, port_a)
      annotation (Line(points={{-10,0},{180,0}}, color={0,127,255}));
    connect(fanRet.port_a, port_bRet)
      annotation (Line(points={{-10,0},{0,0},{0,-140}}, color={0,127,255}));
    annotation (Documentation(info="<html>
<p>
5.16.8 Control of Actuated Relief Dampers without Fans
5.16.8.1 Relief dampers shall be enabled when the associated
supply fan is proven ON, and disabled otherwise.
5.16.8.2 When enabled, use a P-only control loop to
modulate relief dampers to maintain 12 Pa (0.05 in. of water)
building static pressure. Close damper when disabled.
</p>
</html>"));
  end ReliefFan;

  model ReturnFan "Return fan - Modulated relief damper"
    extends Buildings.Templates.AirHandlersFans.Components.ReliefReturnSection.Interfaces.PartialReliefReturnSection(
      final typ=Types.ReliefReturnSection.ReturnFan,
      final typDam=damRel.typ,
      final typFan=fanRet.typ,
      final have_porPre=fanRet.typCtr == Types.ReturnFanControlSensor.Pressure);

    Buildings.Templates.Components.Dampers.TwoPosition damRel(redeclare final
        package Medium = MediumAir, final loc=Buildings.Templates.Components.Types.Location.Relief)
      "Relief damper" annotation (Placement(transformation(
          extent={{10,-10},{-10,10}},
          rotation=0,
          origin={-60,0})));
    replaceable .Buildings.Templates.Components.Fans.SingleVariable fanRet
      constrainedby Buildings.Templates.Components.Fans.Interfaces.PartialFan(
                                                                  redeclare
        final package Medium = MediumAir, final loc=Buildings.Templates.Components.Types.Location.Return)
      "Return/relief fan" annotation (choices(choice(redeclare
            Templates.BaseClasses.Fans.SingleVariable fanRet
            "Single fan - Variable speed"), choice(redeclare
            Templates.BaseClasses.Fans.MultipleVariable fanRet
            "Multiple fans (identical) - Variable speed")), Placement(
          transformation(extent={{130,-10},{110,10}})));
    Buildings.Templates.Components.Sensors.DifferentialPressure pRet_rel(
      redeclare final package Medium = MediumAir,
      final have_sen=fanRet.typCtr == Types.ReturnFanControlSensor.Pressure,
      final loc=Buildings.Templates.Components.Types.Location.Return)
      "Return static pressure sensor"
      annotation (Placement(transformation(extent={{50,-10},{30,10}})));

    Buildings.Templates.Components.Sensors.VolumeFlowRate VRet_flow(
      redeclare final package Medium = MediumAir,
      final have_sen=fanRet.typCtr == Types.ReturnFanControlSensor.Airflow,
      final loc=Buildings.Templates.Components.Types.Location.Return)
      "Return air volume flow rate sensor"
      annotation (Placement(transformation(extent={{90,-10},{70,10}})));

  equation
    /* Hardware point connection - start */
    connect(fanRet.bus, bus.fanRet);
    connect(damRel.bus, bus.damRel);
    /* Hardware point connection - end */
    connect(damRel.port_b, port_aIns)
      annotation (Line(points={{-70,0},{-80,0}}, color={0,127,255}));
    connect(pas.port_a, port_b)
      annotation (Line(points={{-110,0},{-180,0}}, color={0,127,255}));
    connect(fanRet.port_a, port_a)
      annotation (Line(points={{130,0},{180,0}},color={0,127,255}));
    connect(port_bRet, damRel.port_a)
      annotation (Line(points={{0,-140},{0,0},{-50,0}}, color={0,127,255}));
    connect(damRel.port_a, pRet_rel.port_b)
      annotation (Line(points={{-50,0},{30,0}}, color={0,127,255}));
    connect(pRet_rel.port_a, VRet_flow.port_b)
      annotation (Line(points={{50,0},{70,0}}, color={0,127,255}));
    connect(VRet_flow.port_a, fanRet.port_b)
      annotation (Line(points={{90,0},{110,0}}, color={0,127,255}));
    connect(pRet_rel.port_bRef, port_bPre) annotation (Line(points={{40,-10},{40,-120},
            {80,-120},{80,-140}}, color={0,127,255}));
    connect(pRet_rel.y, bus.pRet_rel) annotation (Line(points={{40,12},{40,
            20},{0,20},{0,80},{0.1,80},{0.1,140.1}}, color={0,0,127}));
    connect(VRet_flow.y, bus.VRet_flow) annotation (Line(points={{80,12},{
            80,20},{0.1,20},{0.1,140.1}}, color={0,0,127}));
    annotation (Documentation(info="<html>
<p>
5.16.10 Return-Fan Control—Direct Building Pressure
5.16.10.1 Return fan operates whenever the associated
supply fan is proven ON and shall be off otherwise.
5.16.10.2 Return fans shall be controlled to maintain returnfan
discharge static pressure at set point (Section 5.16.10.5).
5.16.10.3 Exhaust dampers shall only be enabled when
the associated supply and return fans are proven ON and the
minimum outdoor air damper is open. The exhaust dampers
shall be closed when disabled.
5.16.10.5 When exhaust dampers are enabled, a control
loop shall modulate exhaust dampers in sequence with the
return-fan static pressure set point, as shown in Figure
5.16.10.5, to maintain the building pressure at a set point of
12 Pa (0.05 in. of water).
a. From 0% to 50%, the building pressure control loop shall
modulate the exhaust dampers from 0% to 100% open.
b. From 51% to 100%, the building pressure control loop
shall reset the return-fan discharge static pressure set point
from RFDSPmin at 50% loop output to RFDSPmax at
100% of loop output. See Section 3.2.1.4 for RFDSPmin
and RFDSPmax.
</p>
<p>
5.16.11 Return-Fan Control— Airflow Tracking
5.16.11.1 Return fan operates whenever associated supply
fan is proven ON.
5.16.11.2 Return-fan speed shall be controlled to maintain
return airflow equal to supply airflow less differential SR-
DIFF, as determined per Section 3.2.1.5.
5.16.11.3 Relief/exhaust dampers shall be enabled when
the associated supply and return fans are proven ON and
closed otherwise. Exhaust dampers shall modulate as the
inverse of the return air damper per Section 5.16.2.3.4.
</p>
</html>"));
  end ReturnFan;

  package Interfaces "Classes defining the component interfaces"
    extends Modelica.Icons.InterfacesPackage;

    partial model PartialReliefReturnSection "Relief/return air section"

      replaceable package MediumAir=Buildings.Media.Air
        constrainedby Modelica.Media.Interfaces.PartialMedium
        "Air medium";

      parameter AirHandlersFans.Types.ReliefReturnSection typ
        "Relief/return air section type"
        annotation (Evaluate=true, Dialog(group="Configuration"));
      parameter Buildings.Templates.Components.Types.Damper typDam
        "Relief damper type"
        annotation (Evaluate=true, Dialog(group="Configuration"));
      parameter Buildings.Templates.Components.Types.Fan typFan
        "Relief/return fan type"
        annotation (Evaluate=true, Dialog(group="Configuration"));
      parameter Boolean have_porPre
        "Set to true in case of fluid port for differential pressure sensor"
        annotation (Evaluate=true, Dialog(group="Configuration"));
      parameter Boolean have_recHea
        "Set to true in case of heat recovery"
        annotation (Evaluate=true,
          Dialog(
            group="Configuration",
            enable=typ <> AirHandlersFans.Types.ReliefReturnSection.NoRelief));

      outer parameter String id
        "System identifier";
      outer parameter ExternData.JSONFile dat
        "External parameter file";

      parameter Boolean allowFlowReversal = true
        "= false to simplify equations, assuming, but not enforcing, no flow reversal"
        annotation(Dialog(tab="Assumptions"), Evaluate=true);

      Modelica.Fluid.Interfaces.FluidPort_a port_a(
        redeclare final package Medium = MediumAir,
        m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
        h_outflow(start=MediumAir.h_default, nominal=MediumAir.h_default))
        "Fluid connector a (positive design flow direction is from port_a to port_b)"
        annotation (Placement(transformation(extent={{170,-10},{190,10}})));
      Modelica.Fluid.Interfaces.FluidPort_b port_b(
        redeclare final package Medium = MediumAir,
        m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
        h_outflow(start=MediumAir.h_default, nominal=MediumAir.h_default))
        if typ <> AirHandlersFans.Types.ReliefReturnSection.NoRelief
        "Fluid connector b (positive design flow direction is from port_a to port_b)"
        annotation (Placement(transformation(extent={{-170,-10},{-190,10}})));
      Modelica.Fluid.Interfaces.FluidPort_a port_aHeaRec(
        redeclare final package Medium = MediumAir,
        m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
        h_outflow(start=MediumAir.h_default, nominal=MediumAir.h_default)) if have_recHea
        "Optional fluid connector for heat recovery"
        annotation (Placement(transformation(extent={{-130,-150},{-110,-130}})));
      Modelica.Fluid.Interfaces.FluidPort_b port_bHeaRec(
        redeclare final package Medium = MediumAir,
        m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
        h_outflow(start=MediumAir.h_default, nominal=MediumAir.h_default)) if have_recHea
        "Optional fluid connector for heat recovery"
        annotation (Placement(transformation(extent={{-70,-150},{-90,-130}})));
      Modelica.Fluid.Interfaces.FluidPort_b port_bRet(
        redeclare final package Medium = MediumAir,
        m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
        h_outflow(start=MediumAir.h_default, nominal=MediumAir.h_default))
        if typ <> AirHandlersFans.Types.ReliefReturnSection.NoEconomizer
        "Optional fluid connector for return branch"
        annotation (Placement(transformation(extent={{10,-150},{-10,-130}})));
      Modelica.Fluid.Interfaces.FluidPort_b port_bPre(
        redeclare final package Medium = MediumAir)
     if have_porPre
        "Optional fluid connector for differential pressure sensor"
        annotation (Placement(transformation(extent={{90,-150},{70,-130}})));

      Buildings.Templates.AirHandlersFans.Interfaces.Bus bus "Control bus"
        annotation (Placement(transformation(
            extent={{-20,-20},{20,20}},
            rotation=0,
            origin={0,140}), iconTransformation(
            extent={{-10,-10},{10,10}},
            rotation=0,
            origin={0,140})));

      Buildings.Templates.BaseClasses.PassThroughFluid pas(redeclare final
          package Medium =
                   MediumAir) if not have_recHea and typ <> AirHandlersFans.Types.ReliefReturnSection.NoRelief
        "Direct pass through (conditional)"
        annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
    protected
      Modelica.Fluid.Interfaces.FluidPort_a port_aIns(
        redeclare final package Medium = MediumAir,
        m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
        h_outflow(start=MediumAir.h_default, nominal=MediumAir.h_default))
        if typ <> AirHandlersFans.Types.ReliefReturnSection.NoRelief
        "Inside fluid connector a (positive design flow direction is from port_a to port_b)"
        annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));
    equation
      connect(port_aHeaRec, pas.port_a) annotation (Line(points={{-120,-140},{-120,0},
              {-110,0}}, color={0,127,255}));
      connect(port_aIns, pas.port_b)
        annotation (Line(points={{-80,0},{-90,0}}, color={0,127,255}));
      connect(port_aIns, port_bHeaRec) annotation (Line(points={{-80,0},{-80,-140},{
              -80,-140}}, color={0,127,255}));
      annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-180,-140},
                {180,140}}), graphics={
            Text(
              extent={{-149,-150},{151,-190}},
              lineColor={0,0,255},
              textString="%name")}),                                 Diagram(
            coordinateSystem(preserveAspectRatio=false, extent={{-180,-140},{180,140}})));
    end PartialReliefReturnSection;
  end Interfaces;
end ReliefReturnSection;
