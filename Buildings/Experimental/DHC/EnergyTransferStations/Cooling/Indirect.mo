within Buildings.Experimental.DHC.EnergyTransferStations.Cooling;
model Indirect
  "Indirect cooling energy transfer station for district energy systems"
  extends
    Buildings.Experimental.DHC.EnergyTransferStations.BaseClasses.PartialETS(
    QChiWat_flow_nominal=-Q_flow_nominal,
    final typ=DHC.Types.DistrictSystemType.Cooling,
    final have_weaBus=false,
    final have_chiWat=true,
    final have_heaWat=false,
    final have_hotWat=false,
    final have_eleHea=false,
    final nFue=0,
    final have_eleCoo=false,
    final have_pum=false,
    final have_fan=false,
    nPorts_aChiWat=1,
    nPorts_bChiWat=1);
  // mass flow rates
  parameter Modelica.Units.SI.MassFlowRate mDis_flow_nominal(
    final min=0,
    final start=0.5)
    "Nominal mass flow rate of district cooling side"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.MassFlowRate mBui_flow_nominal(
    final min=0,
    final start=0.5)
    "Nominal mass flow rate of building cooling side"
    annotation(Dialog(group="Nominal condition"));
  // Primary supply control valve
  parameter Modelica.Units.SI.PressureDifference dpConVal_nominal(
    final min=0,
    displayUnit="Pa")=6000
    "Nominal pressure drop of fully open control valve"
    annotation(Dialog(group="Nominal condition"));
  // Heat exchanger
  parameter Modelica.Units.SI.PressureDifference dp1_nominal(
    final min=0,
    final start=500,
    displayUnit="Pa")
    "Nominal pressure difference on primary side"
    annotation (Dialog(group="Heat exchanger"));
  parameter Modelica.Units.SI.PressureDifference dp2_nominal(
    final min=0,
    final start=500,
    displayUnit="Pa")
    "Nominal pressure difference on secondary side"
    annotation (Dialog(group="Heat exchanger"));
  parameter Boolean use_Q_flow_nominal=true
    "Set to true to specify Q_flow_nominal and temeratures, or to false to specify effectiveness"
    annotation (Dialog(group="Heat exchanger"));
  parameter Modelica.Units.SI.HeatFlowRate Q_flow_nominal(
    final max=0,
    final start=-100000)
    "Nominal heat transfer"
    annotation (Dialog(group="Heat exchanger"));
  parameter Modelica.Units.SI.Temperature T_a1_nominal(
    final min=0+273.15,
    final max=100+273.15,
    final start=5+273.15,
    displayUnit="K")
    "Nominal temperature at port a1"
    annotation (Dialog(group="Heat exchanger"));
  parameter Modelica.Units.SI.Temperature T_a2_nominal(
    final min=0+273.15,
    final max=100+273.15,
    final start=7+273.15,
    displayUnit="K")
    "Nominal temperature at port a2"
    annotation (Dialog(group="Heat exchanger"));
  parameter Modelica.Units.SI.Efficiency eta(
    final min=0,
    final max=1)=0.8
    "Constant effectiveness"
    annotation (Dialog(group="Heat exchanger"));
   //Controller parameters
  parameter Modelica.Blocks.Types.Init initType=Modelica.Blocks.Types.Init.InitialState
    "Type of initialization (1: no init, 2: steady state, 3: initial state, 4: initial output)"
    annotation (Dialog(group="PID controller"));
  parameter Modelica.Blocks.Types.SimpleController controllerType=Modelica.Blocks.Types.SimpleController.PID
    "Type of controller"
    annotation (Dialog(group="PID controller"));
  parameter Real k(
    final min=0,
    final unit="1")=1
    "Gain of controller"
    annotation (Dialog(group="PID controller"));
  parameter Modelica.Units.SI.Time Ti(
    final min=Modelica.Constants.small)=120
    "Time constant of integrator block"
    annotation (Dialog(group="PID controller",enable=
          controllerType == Modelica.Blocks.Types.SimpleController.PI or
          controllerType == Modelica.Blocks.Types.SimpleController.PID));
  parameter Modelica.Units.SI.Time Td(
    final min=0)=0.1
    "Time constant of derivative block"
    annotation (Dialog(group="PID controller",enable=
          controllerType == Modelica.Blocks.Types.SimpleController.PD or
          controllerType == Modelica.Blocks.Types.SimpleController.PID));
  parameter Real yMax(
    final start=1)=1
    "Upper limit of output"
    annotation (Dialog(group="PID controller"));
  parameter Real yMin=0.01
    "Lower limit of output"
    annotation (Dialog(group="PID controller"));
  Modelica.Blocks.Interfaces.RealInput TSetBuiSup
    "Setpoint temperature for building supply"
    annotation (Placement(transformation(extent={{-340,-20},{-300,20}})));
  Modelica.Blocks.Interfaces.RealOutput Q_flow(
    final quantity="HeatFlowRate",
    final unit="W",
    displayUnit="kW")
    "Measured heating demand at the ETS"
    annotation (Placement(
        transformation(extent={{300,-140},{340,-100}}),iconTransformation(extent={{300,
            -140},{340,-100}})));
  Modelica.Blocks.Interfaces.RealOutput Q(
    final quantity="Energy",
    final unit="J",
    displayUnit="kWh")
    "Measured energy consumption at the ETS"
     annotation (Placement(transformation(extent={{300,-180},{340,-140}}),
     iconTransformation(extent={{300,-130},{340,-90}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTDisSup(
    redeclare final package Medium=MediumSer,
    final m_flow_nominal=mDis_flow_nominal)
    "District supply temperature sensor"
    annotation (Placement(transformation(extent={{-220,-290},{-200,-270}})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFlo(
    redeclare final package Medium=MediumSer)
    "District supply mass flow rate sensor"
    annotation (Placement(transformation(extent={{-160,-290},{-140,-270}})));
  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage conVal(
    redeclare final package Medium=MediumSer,
    final m_flow_nominal=mDis_flow_nominal,
    final dpValve_nominal=dpConVal_nominal,
    riseTime(displayUnit="s") = 10,
    y_start=0)
    "Control valve"
    annotation (Placement(transformation(extent={{-100,-290},{-80,-270}})));
  Buildings.Fluid.HeatExchangers.PlateHeatExchangerEffectivenessNTU hex(
    redeclare package Medium1 = MediumSer,
    redeclare package Medium2 = MediumBui,
    final m1_flow_nominal=mDis_flow_nominal,
    final m2_flow_nominal=mBui_flow_nominal,
    final dp1_nominal=dp1_nominal,
    final dp2_nominal=dp2_nominal,
    final configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow,
    final Q_flow_nominal=Q_flow_nominal,
    final T_a1_nominal=T_a1_nominal,
    final T_a2_nominal=T_a2_nominal)
    annotation (Placement(transformation(extent={{0,-200},{20,-220}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTDisRet(
    redeclare final package Medium=MediumSer,
    final m_flow_nominal=mDis_flow_nominal)
    "District return temperature sensor"
    annotation (Placement(transformation(extent={{180,-270},{200,-290}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTBuiRet(
    redeclare final package Medium=MediumBui,
    final m_flow_nominal=mBui_flow_nominal)
    "Building return temperature sensor"
    annotation (Placement(transformation(extent={{-218,210},{-198,190}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTBuiSup(
    redeclare final package Medium=MediumBui,
    final m_flow_nominal=mBui_flow_nominal)
    "Building supply temperature sensor"
    annotation (Placement(transformation(extent={{200,210},{220,190}})));
  Buildings.Controls.Continuous.LimPID con(
    final controllerType=controllerType,
    final k=k,
    final Ti=Ti,
    final Td=Td,
    final yMax=yMax,
    final yMin=yMin,
    final initType=Modelica.Blocks.Types.Init.InitialState)
    "Building supply temperature controller"
    annotation (Placement(transformation(extent={{-180,10},{-160,-10}})));

  Modelica.Blocks.Math.Add dTdis(
    final k1=-1)
  "Temperature difference on the district side"
    annotation (Placement(transformation(extent={{20,-120},{40,-100}})));
  Modelica.Blocks.Math.Product pro
  "product"
    annotation (Placement(transformation(extent={{120,-120},{140,-100}})));
  Modelica.Blocks.Math.Gain cp(
    final k=cp_default)
    "Specific heat multiplier to calculate heat flow rate"
    annotation (Placement(transformation(extent={{180,-120},{200,-100}})));
  Modelica.Blocks.Continuous.Integrator int(
    final k=1)
    "Integration"
    annotation (Placement(transformation(extent={{240,-170},{260,-150}})));
protected
  final parameter MediumSer.ThermodynamicState sta_default=MediumSer.setState_pTX(
    T=MediumSer.T_default,
    p=MediumSer.p_default,
    X=MediumSer.X_default)
    "Medium state at default properties";
  final parameter Modelica.Units.SI.SpecificHeatCapacity cp_default=MediumSer.specificHeatCapacityCp(
    sta_default)
    "Specific heat capacity of the fluid";
equation
  connect(ports_aChiWat[1], senTBuiRet.port_a)
    annotation (Line(points={{-300,200},{-218,200}}, color={0,127,255}));
  connect(port_aSerCoo, senTDisSup.port_a)
    annotation (Line(points={{-300,-280},{-220,-280}}, color={0,127,255}));
  connect(senTDisSup.port_b, senMasFlo.port_a)
    annotation (Line(points={{-200,-280},{-160,-280}}, color={0,127,255}));
  connect(senMasFlo.port_b, conVal.port_a)
    annotation (Line(points={{-140,-280},{-100,-280}}, color={0,127,255}));
  connect(conVal.port_b, hex.port_a1)
    annotation (Line(points={{-80,-280},{-40,-280},
          {-40,-216},{0,-216}}, color={0,127,255}));
  connect(hex.port_b1, senTDisRet.port_a)
    annotation (Line(points={{20,-216},{60,
          -216},{60,-280},{180,-280}}, color={0,127,255}));
  connect(senTDisRet.port_b, port_bSerCoo)
    annotation (Line(points={{200,-280},{300,-280}}, color={0,127,255}));
  connect(senTBuiRet.port_b, hex.port_a2)
    annotation (Line(points={{-198,200},{60,
          200},{60,-204},{20,-204}}, color={0,127,255}));
  connect(hex.port_b2, senTBuiSup.port_a)
    annotation (Line(points={{0,-204},{-40,
          -204},{-40,180},{180,180},{180,200},{200,200}}, color={0,127,255}));
  connect(senTBuiSup.port_b, ports_bChiWat[1])
    annotation (Line(points={{220,200},{300,200}}, color={0,127,255}));
  connect(senTBuiSup.T, con.u_m)
    annotation (Line(points={{210,189},{210,80},{-170,
          80},{-170,12}}, color={0,0,127}));
  connect(TSetBuiSup, con.u_s)
    annotation (Line(points={{-320,0},{-182,0}}, color={0,0,127}));
  connect(con.y, conVal.y)
    annotation (Line(points={{-159,0},{-90,0},{-90,-268}}, color={0,0,127}));
  connect(senTDisSup.T, dTdis.u2)
    annotation (Line(points={{-210,-269},{-210,-116},
          {18,-116}}, color={0,0,127}));
  connect(senTBuiRet.T, dTdis.u1)
    annotation (Line(points={{-208,189},{-210,189},
          {-210,-104},{18,-104}}, color={0,0,127}));
  connect(senMasFlo.m_flow, pro.u2)
    annotation (Line(points={{-150,-269},{-148,-269},{-148,-140},{100,-140},{
          100,-116},{118,-116}},                         color={0,0,127}));
  connect(dTdis.y, pro.u1)
    annotation (Line(points={{41,-110},{88,-110},{88,-104},{118,-104}},
                       color={0,0,127}));
  connect(pro.y, cp.u)
    annotation (Line(points={{141,-110},{178,-110}}, color={0,0,127}));
  connect(cp.y, Q_flow)
    annotation (Line(points={{201,-110},{228,-110},{228,-120},{320,-120}},
                                                     color={0,0,127}));
  connect(cp.y, int.u)
    annotation (Line(points={{201,-110},{228,-110},{228,-160},{238,-160}},
                       color={0,0,127}));
  connect(int.y, Q)
    annotation (Line(points={{261,-160},{320,-160}},
                       color={0,0,127}));
  annotation (
    defaultComponentName="etsCoo",
    Documentation(info="<html>
<p>Indirect cooling energy transfer station (ETS) model that controls the 
building chilled water supply temperature by modulating a primary control valve 
on the district supply side. The design is based on a typical district cooling 
ETS described in ASHRAE's <a href=\"https://www.ashrae.org/technical-resources/bookstore/district-heating-and-cooling-guides\">District Cooling Guide</a>. 
As shown in the figure below, the building pumping design (constant/variable) 
is specified on the building side and not within the ETS. 
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Experimental/DHC/EnergyTransferStations/Cooling/Indirect.png\" alt=\"DHC.ETS.Indirect\"/>
</p>
<h4>Reference</h4>
<p>American Society of Heating, Refrigeration and Air-Conditioning Engineers. (2019). 
Chapter 5: End User Interface. In <i>District Cooling Guide</i>, Second Edition and 
<i>Owner's Guide for Buildings Served by District Cooling</i>. 
</p>
</html>",
      revisions="<html>
<ul>
<li>March 21, 2022, by Chengnan Shi:<br/>Update with base class partial model.</li>
<li>Novermber 13, 2019, by Kathryn Hinkelman:<br/>First implementation. </li>
</ul>
</html>"));
end Indirect;
