within Buildings.RoomsBeta.BaseClasses.Examples;
model HeatGain "Test model for the HeatGain model"
  import Buildings;
  package MediumA = Buildings.Media.GasesPTDecoupled.MoistAir "Medium model";

  Buildings.RoomsBeta.BaseClasses.HeatGain heatGain(redeclare package Medium =
        MediumA, AFlo=AFlo)
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Modelica.Blocks.Sources.Constant qConGai_flow(k=0) "Convective heat gain"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Modelica.Blocks.Sources.Constant qRadGai_flow1(k=0) "Radiative heat gain"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Modelica.Blocks.Routing.Multiplex3 multiplex3_1
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Modelica.Blocks.Sources.Constant qLatGai_flow(k=10) "Latent heat gain"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Buildings.Fluid.Sensors.SensibleEnthalpyFlowRate QSen_flow(redeclare package
      Medium = MediumA)
    annotation (Placement(transformation(extent={{30,-16},{50,4}})));
  Buildings.Fluid.Sensors.LatentEnthalpyFlowRate QLat_flow(redeclare package
      Medium = MediumA)
    annotation (Placement(transformation(extent={{60,-16},{80,4}})));
  Buildings.Fluid.Sources.Boundary_pT boundary(          redeclare package
      Medium = MediumA, nPorts=1)
    annotation (Placement(transformation(extent={{30,-80},{50,-60}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=273.15)
    annotation (Placement(transformation(extent={{-20,-90},{0,-70}})));
  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Buildings.Utilities.Diagnostics.AssertEquality assertEquality
    annotation (Placement(transformation(extent={{60,64},{80,84}})));
  parameter Modelica.SIunits.Area AFlo=50 "Floor area";
  Modelica.Blocks.Math.Gain gainCon(k=AFlo)
    annotation (Placement(transformation(extent={{0,70},{20,90}})));
  Modelica.Blocks.Math.Gain gainLat(k=AFlo)
    annotation (Placement(transformation(extent={{0,36},{20,56}})));
  Buildings.Utilities.Diagnostics.AssertEquality assertEquality1
    annotation (Placement(transformation(extent={{66,30},{86,50}})));
  Buildings.Fluid.MixingVolumes.MixingVolume vol(
    nPorts=2,
    redeclare package Medium = MediumA,
    V=AFlo*2.5)
    annotation (Placement(transformation(extent={{60,-70},{80,-50}})));
equation
  connect(qRadGai_flow1.y,multiplex3_1. u1[1]) annotation (Line(
      points={{-59,30},{-52,30},{-52,7},{-42,7}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(qConGai_flow.y,multiplex3_1. u2[1]) annotation (Line(
      points={{-59,6.10623e-16},{-54,6.10623e-16},{-54,0},{-50,0},{-50,
          6.66134e-16},{-42,6.66134e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(qLatGai_flow.y, multiplex3_1.u3[1])  annotation (Line(
      points={{-59,-30},{-52,-30},{-52,-7},{-42,-7}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(multiplex3_1.y, heatGain.qGai_flow) annotation (Line(
      points={{-19,6.10623e-16},{-14,6.10623e-16},{-14,0},{-10,0},{-10,
          6.66134e-16},{-2,6.66134e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heatGain.QLat_flow, QSen_flow.port_a) annotation (Line(
      points={{20,-6},{25,-6},{25,-6},{30,-6}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(QSen_flow.port_b, QLat_flow.port_a) annotation (Line(
      points={{50,-6},{52.5,-6},{52.5,-6},{55,-6},{55,-6},{60,-6}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(fixedTemperature.port, heatGain.QCon_flow) annotation (Line(
      points={{5.55112e-16,-80},{26,-80},{26,6.10623e-16},{20,6.10623e-16}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(assertEquality.u2, QSen_flow.H_flow) annotation (Line(
      points={{58,68},{40,68},{40,5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gainCon.y, assertEquality.u1) annotation (Line(
      points={{21,80},{58,80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gainCon.u, qConGai_flow.y) annotation (Line(
      points={{-2,80},{-54,80},{-54,6.10623e-16},{-59,6.10623e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(assertEquality1.u2, QLat_flow.H_flow) annotation (Line(
      points={{64,34},{54,34},{54,20},{70,20},{70,5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gainLat.y, assertEquality1.u1) annotation (Line(
      points={{21,46},{64,46}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(qLatGai_flow.y, gainLat.u) annotation (Line(
      points={{-59,-30},{-10,-30},{-10,46},{-2,46}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(boundary.ports[1], vol.ports[1]) annotation (Line(
      points={{50,-70},{68,-70}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(vol.ports[2], QLat_flow.port_b) annotation (Line(
      points={{72,-70},{90,-70},{90,-6},{80,-6}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (Diagram(graphics),Commands(file=
            "HeatGain.mos" "run"));
end HeatGain;
