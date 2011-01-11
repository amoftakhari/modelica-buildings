within Buildings.RoomsBeta;
model MixedAir "Model of a room in which the air is completely mixed"
  extends Buildings.RoomsBeta.BaseClasses.ParameterFluid;
  parameter Integer nPorts=0 "Number of ports"
    annotation(Evaluate=true, Dialog(__Dymola_connectorSizing=true, tab="General",group="Ports"));

  parameter Buildings.RoomsBeta.BaseClasses.ParameterConstruction datConExt[NConExt](
    each A=0,
    redeclare Buildings.HeatTransfer.Data.OpaqueConstructions.Brick120 layers,
    each til=0,
    each azi=0) "Data for exterior construction"
    annotation (Placement(transformation(extent={{100,-100},{120,-80}})));
  parameter Buildings.RoomsBeta.BaseClasses.ParameterConstructionWithWindow
    datConExtWin[NConExtWin](
    each A=0,
    redeclare Buildings.HeatTransfer.Data.OpaqueConstructions.Brick120 layers,
    each til=0,
    each azi=0,
    each AWin=0,
    redeclare Buildings.HeatTransfer.Data.GlazingSystems.SingleClear3 glaSys)
    "Data for exterior construction with window"
    annotation (Placement(transformation(extent={{100,-140},{120,-120}})));
  parameter Buildings.RoomsBeta.BaseClasses.ParameterConstruction datConPar[
              NConPar](
    each A=0,
    redeclare Buildings.HeatTransfer.Data.OpaqueConstructions.Brick120 layers,
    each til=0,
    each azi=0) "Data for partition construction"
    annotation (Placement(transformation(extent={{100,-180},{120,-160}})));
  parameter Buildings.RoomsBeta.BaseClasses.ParameterConstruction datConBou[NConBou](
    each A=0,
    redeclare Buildings.HeatTransfer.Data.OpaqueConstructions.Brick120 layers,
    each til=0,
    each azi=0) "Data for construction boundary"
    annotation (Placement(transformation(extent={{140,-100},{160,-80}})));
  HeatTransfer.Data.OpaqueSurfaces.Generic surBou[NSurBou](each A=0, each til=0)
    "Record for data of surfaces whose heat conduction is modeled outside of this room"
    annotation (Placement(transformation(extent={{160,-140},{140,-120}})));

  Buildings.RoomsBeta.BaseClasses.MixedAir air(
    redeclare final package Medium=Medium,
    final V=V,
    nPorts=nPorts,
    final energyDynamics=energyDynamics,
    final massDynamics=massDynamics,
    final substanceDynamics=energyDynamics,
    final traceDynamics=energyDynamics,
    final p_start=p_start,
    final use_T_start=use_T_start,
    final T_start=T_start,
    final h_start=h_start,
    final X_start=X_start,
    final C_start=C_start,
    final AConExt=datConExt.A,
    final AConExtWinOpa=datConExtWin.AOpa,
    final AConExtWinGla=(1 .- datConExtWin.fFra) .* datConExtWin.AWin,
    final AConExtWinFra=datConExtWin.fFra .* datConExtWin.AWin,
    final AConPar=datConPar.A,
    final AConBou=datConBou.A,
    final ASurBou=surBou.A,
    final nConExt=nConExt,
    final nConExtWin=nConExtWin,
    final nConPar=nConPar,
    final nConBou=nConBou,
    final nSurBou=nSurBou,
    final fFra=datConExtWin.fFra,
    final epsConExt=datConExt.layers.epsLW_b,
    final epsConExtWinUns={(datConExtWin[i].glaSys.glass[datConExtWin[i].glaSys.nLay].epsLW_b) for i in 1:NConExtWin},
    final epsConExtWinSha=datConExtWin.glaSys.shade.epsLW_a,
    final tauLWSha_air=datConExtWin.glaSys.shade.tauLW_a,
    final tauLWSha_glass=datConExtWin.glaSys.shade.tauLW_b,
    final epsConExtWinFra=datConExtWin.glaSys.epsLWFra,
    final epsConPar_a=datConPar.layers.epsLW_a,
    final epsConPar_b=datConPar.layers.epsLW_b,
    final epsConBou=datConBou.layers.epsLW_b,
    final epsSurBou=surBou.epsLW,
    final AFlo=AFlo,
    final hRoo=hRoo,
    final linearize=linearize,
    final epsConExtWinOpa=datConExtWin.layers.epsLW_b,
    final haveExteriorShade={datConExtWin[i].glaSys.haveExteriorShade for i in 1:NConExtWin},
    final haveInteriorShade={datConExtWin[i].glaSys.haveInteriorShade for i in 1:NConExtWin},
    final isFloorConExt=datConExt.isFloor,
    final isFloorConExtWin=datConExtWin.isFloor,
    final isFloorConPar_a=datConPar.isFloor,
    final isFloorConPar_b=datConPar.isCeiling,
    final isFloorConBou=datConBou.isFloor,
    final isFloorSurBou=surBou.isFloor,
    tauGlaSW={0.6 for i in 1:NConExtWin}) "Air volume"
    annotation (Placement(transformation(extent={{-140,40},{-120,60}})));

  Modelica.Fluid.Vessels.BaseClasses.VesselFluidPorts_b ports[nPorts](
      redeclare each package Medium = Medium) "Fluid inlets and outlets"
    annotation (Placement(transformation(extent={{-40,-10},{40,10}},
      origin={-200,-60},
        rotation=90)));
  parameter Modelica.SIunits.Angle lat "Latitude";
  final parameter Modelica.SIunits.Volume V=AFlo*hRoo "Volume";
  parameter Modelica.SIunits.Area AFlo "Floor area";
  parameter Modelica.SIunits.Length hRoo "Average room height";

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heaPorAir
    "Heat port to air volume"
    annotation (Placement(transformation(extent={{-212,30},{-192,50}}),
        iconTransformation(extent={{-212,32},{-192,52}})));

  ////////////////////////////////////////////////////////////////////////
  // Number of constructions and surface areas
  parameter Integer nConExt(min=0) "Number of exterior constructions"
    annotation (Dialog(group="Exterior constructions"));
  parameter Integer nConExtWin(min=0) "Number of window constructions"
    annotation (Dialog(group="Exterior constructions"));

  parameter Integer nConPar(min=0) "Number of partition constructions"
  annotation (Dialog(group="Partition constructions"));

  parameter Integer nConBou(min=0)
    "Number of constructions that have their outside surface exposed to the boundary of this room"
  annotation (Dialog(group="Boundary constructions"));

  parameter Integer nSurBou(min=0)
    "Number of surface heat transfer models that connect to constructions that are modeled outside of this room"
  annotation (Dialog(group="Boundary constructions"));
  ////////////////////////////////////////////////////////////////////////
  // Constructions
  Constructions.Construction conExt[NConExt](
    A=datConExt.A,
    til=datConExt.til,
    final layers={datConExt[i].layers for i in 1:NConExt},
    steadyStateInitial=datConExt.steadyStateInitial,
    T_a_start=datConExt.T_a_start,
    T_b_start=datConExt.T_b_start) if
       haveConExt
    "Heat conduction through exterior construction that have no window"
    annotation (Placement(transformation(extent={{54,114},{24,144}})));

  Constructions.ConstructionWithWindow conExtWin[NConExtWin](
    A=datConExtWin.A,
    til=datConExtWin.til,
    final layers={datConExtWin[i].layers for i in 1:NConExtWin},
    steadyStateInitial=datConExtWin.steadyStateInitial,
    T_a_start=datConExtWin.T_a_start,
    T_b_start=datConExtWin.T_b_start,
    AWin=datConExtWin.AWin,
    fFra=datConExtWin.fFra,
    linearize=datConExtWin.linearize,
    glaSys=datConExtWin.glaSys) if
       haveConExtWin
    "Heat conduction through exterior construction that have a window"
    annotation (Placement(transformation(extent={{56,46},{26,76}})));

  Constructions.Construction conPar[NConPar](
    A=datConPar.A,
    til=datConPar.til,
    final layers={datConPar[i].layers for i in 1:NConPar},
    steadyStateInitial=datConPar.steadyStateInitial,
    T_a_start=datConPar.T_a_start,
    T_b_start=datConPar.T_b_start) if
       haveConPar
    "Heat conduction through partitions that have both sides inside the thermal zone"
    annotation (Placement(transformation(extent={{24,-86},{4,-66}})));

  Constructions.Construction conBou[NConBou](
    A=datConBou.A,
    til=datConBou.til,
    final layers={datConBou[i].layers for i in 1:NConBou},
    steadyStateInitial=datConBou.steadyStateInitial,
    T_a_start=datConBou.T_a_start,
    T_b_start=datConBou.T_b_start) if
       haveConBou
    "Heat conduction through opaque constructions that have the boundary conditions of the other side exposed"
    annotation (Placement(transformation(extent={{24,-136},{4,-116}})));

  parameter Boolean linearize=true "Set to true to linearize emissive power";

  ////////////////////////////////////////////////////////////////////////
  // Models for boundary conditions
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a surf_conBou[nConBou] if
       haveConBou "Heat port at surface b of construction conBou"
    annotation (Placement(transformation(extent={{50,-170},{70,-150}}),
        iconTransformation(extent={{50,-170},{70,-150}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b surf_surBou[nSurBou] if
       haveSurBou "Heat port of surface that is connected to the room air"
    annotation (Placement(transformation(extent={{-70,-150},{-50,-130}}),
        iconTransformation(extent={{-48,-150},{-28,-130}})));

  Modelica.Blocks.Interfaces.RealInput uSha[nConExtWin](each min=0, each max=1) if
       haveConExtWin
    "Control signal for the shading device (removed if no shade is present)"
    annotation (Placement(transformation(extent={{-240,160},{-200,200}}),
        iconTransformation(extent={{-240,140},{-200,180}})));

  Modelica.Blocks.Interfaces.RealInput qGai_flow[3]
    "Radiant, convective and latent heat input into room (positive if heat gain)"
    annotation (Placement(transformation(extent={{-240,80},{-200,120}})));
  BaseClasses.ExteriorBoundaryConditions bouConExt(
    final nCon=nConExt,
    final AOpa=datConExt.A,
    final lat=lat,
    final til=datConExt.til,
    final azi=datConExt.azi,
    linearize=linearize,
    final epsLW=datConExt.layers.epsLW_a,
    final epsSW=datConExt.layers.epsSW_a) if
       haveConExt
    "Exterior boundary conditions for constructions without a window"
    annotation (Placement(transformation(extent={{114,106},{154,146}})));

  BaseClasses.ExteriorBoundaryConditionsWithWindow bouConExtWin(
    final nCon=nConExtWin,
    final lat=lat,
    final til=datConExtWin.til,
    final azi=datConExtWin.azi,
    final AOpa=datConExtWin.AOpa,
    final AWin=datConExtWin.AWin,
    final fFra=datConExtWin.fFra,
    linearize=linearize,
    final epsLW=datConExtWin.layers.epsLW_a,
    final epsLWSha_air={datConExtWin[i].glaSys.shade.epsLW_a for i in 1:nConExtWin},
    final epsLWSha_glass={datConExtWin[i].glaSys.shade.epsLW_b for i in 1:nConExtWin},
    final tauLWSha_air={datConExtWin[i].glaSys.shade.tauLW_a for i in 1:nConExtWin},
    final tauLWSha_glass={datConExtWin[i].glaSys.shade.tauLW_b for i in 1:nConExtWin},
    final haveExteriorShade={datConExtWin[i].glaSys.haveExteriorShade for i in 1:nConExtWin},
    final haveInteriorShade={datConExtWin[i].glaSys.haveInteriorShade for i in 1:nConExtWin},
    final epsSW=datConExtWin.layers.epsSW_a,
    final epsSWFra=datConExtWin.glaSys.epsSWFra) if
       haveConExtWin
    "Exterior boundary conditions for constructions with a window"
    annotation (Placement(transformation(extent={{116,44},{156,84}})));

  HeatTransfer.WindowsBeta.BaseClasses.WindowRadiation conExtWinRad[NConExtWin](
     final AWin=(1 .- datConExtWin.fFra) .* datConExtWin.AWin,
     final N=datConExtWin.glaSys.nLay,
     final tauGlaSW=datConExtWin.glaSys.glass.tauSW,
     final rhoGlaSW_a=datConExtWin.glaSys.glass.rhoSW_a,
     final rhoGlaSW_b=datConExtWin.glaSys.glass.rhoSW_b,
     final tauShaSW_a=datConExtWin.glaSys.shade.tauSW_a,
     final tauShaSW_b=datConExtWin.glaSys.shade.tauSW_b,
     final rhoShaSW_a=datConExtWin.glaSys.shade.rhoSW_a,
     final rhoShaSW_b=datConExtWin.glaSys.shade.rhoSW_b,
     final haveExteriorShade=datConExtWin.glaSys.haveExteriorShade,
     final haveInteriorShade=datConExtWin.glaSys.haveInteriorShade) if
        haveConExtWin
    "Model for short wave radiation through shades and window"
    annotation (Placement(transformation(extent={{40,-20},{60,0}})));

  BoundaryConditions.WeatherData.Bus weaBus
    annotation (Placement(transformation(extent={{170,170},{190,190}}),
        iconTransformation(extent={{148,168},{174,194}})));

  // Dimensions of components and connectors
protected
  parameter Integer NConExt(min=1)=max(1, nConExt)
    "Number of elements for exterior constructions";

  parameter Integer NConExtWin(min=1)=max(1, nConExtWin)
    "Number of elements for exterior constructions with windows";

  parameter Integer NConPar(min=1)=max(1, nConPar)
    "Number of elements for partition constructions";

  parameter Integer NConBou(min=1)=max(1, nConBou)
    "Number of elements for constructions that have their outside surface exposed to the boundary of this room";

  parameter Integer NSurBou(min=1)=max(1, nSurBou)
    "Number of elements for surface heat transfer models that connect to constructions that are modeled outside of this room";

  // Flags to conditionally remove components
  final parameter Boolean haveConExt = nConExt > 0
    "Flag to conditionally remove components";
  final parameter Boolean haveConExtWin = nConExtWin > 0
    "Flag to conditionally remove components";
  final parameter Boolean haveConPar = nConPar > 0
    "Flag to conditionally remove components";
  final parameter Boolean haveConBou = nConBou > 0
    "Flag to conditionally remove components";
  final parameter Boolean haveSurBou = nSurBou > 0
    "Flag to conditionally remove components";
  Modelica.Blocks.Sources.Constant zer(final k=0) if
       not haveConExtWin
    "Outputs zero. This block is needed to send a signal to the shading connector if no window is used in the room model"
    annotation (Placement(transformation(extent={{-200,120},{-180,140}})));

equation
  connect(air.heatPort, heaPorAir) annotation (Line(
      points={{-140.083,50},{-180,50},{-180,40},{-202,40}},
      color={191,0,0},
      smooth=Smooth.None));

  for i in 1:nPorts loop
  end for;

  connect(air.conExtWin, conExtWin.opa_b)
                                    annotation (Line(
      points={{-120,57.5},{-56,57.5},{-56,71},{25.9,71}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(air.conPar_b, conPar.opa_b) annotation (Line(
      points={{-119.917,45.8333},{-48,45.8333},{-48,-69.3333},{3.93333,-69.3333}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(air.conPar_a, conPar.opa_a) annotation (Line(
      points={{-119.917,47.5},{-40,47.5},{-40,-54},{40,-54},{40,-69.3333},{24,
          -69.3333}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conBou.opa_a, surf_conBou) annotation (Line(
      points={{24,-119.333},{60,-119.333},{60,-160}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(air.conBou, conBou.opa_b) annotation (Line(
      points={{-119.917,43.3333},{-52,43.3333},{-52,-119.333},{3.93333,-119.333}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(surf_surBou, air.surBou) annotation (Line(
      points={{-60,-140},{-60,22},{-119.958,22},{-119.958,40.8333}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(uSha, air.uSha)
                    annotation (Line(
      points={{-220,180},{-168,180},{-168,57.5833},{-140.833,57.5833}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(qGai_flow, air.qGai_flow) annotation (Line(
      points={{-220,100},{-172,100},{-172,54.1667},{-140.833,54.1667}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(air.JOutUns, conExtWin.JInUns_b)
                                        annotation (Line(
      points={{-119.583,56.6667},{-5.7915,56.6667},{-5.7915,60},{25.5,60}},
      color={0,127,0},
      smooth=Smooth.None));

  connect(conExtWin.JOutUns_b, air.JInUns)
                                        annotation (Line(
      points={{25.5,62},{-8,62},{-8,56},{-119.667,56}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(air.JOutSha, conExtWin.JInSha_b)
                                        annotation (Line(
      points={{-119.583,52.5},{4,52.5},{4,51},{25.5,51}},
      color={0,127,0},
      smooth=Smooth.None));

  connect(conExtWin.JOutSha_b, air.JInSha)
                                        annotation (Line(
      points={{25.5,53},{0,53},{0,51.6667},{-119.583,51.6667}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(air.glaUns, conExtWin.glaUns_b)
                                       annotation (Line(
      points={{-120,55},{-120,40},{16,40},{16,57},{26,57}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conExtWin.glaSha_b, air.glaSha)
                                       annotation (Line(
      points={{26,55},{-4,55},{-4,53.3333},{-120,53.3333}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(air.conExtWinFra, conExtWin.fra_b)
                                       annotation (Line(
      points={{-119.917,50},{32,50},{32,48},{25.9,48}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(uSha, conExtWin.uSha)
                       annotation (Line(
      points={{-220,180},{86,180},{86,64},{57,64}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(uSha, bouConExtWin.uSha)
                             annotation (Line(
      points={{-220,180},{100,180},{100,70.6667},{114.667,70.6667}},
      color={0,0,127},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(bouConExtWin.opa_a, conExtWin.opa_a)
                                         annotation (Line(
      points={{116,77.3333},{80,77.3333},{80,71},{56,71}},
      color={191,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(conExtWin.JInUns_a, bouConExtWin.JOutUns)
                                              annotation (Line(
      points={{56.5,62},{94,62},{94,62.6667},{115.333,62.6667}},
      color={0,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(bouConExtWin.JInUns, conExtWin.JOutUns_a)
                                              annotation (Line(
      points={{115.333,65.3333},{78,65.3333},{78,60},{56.5,60}},
      color={0,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(conExtWin.glaUns_a, bouConExtWin.glaUns)
                                             annotation (Line(
      points={{56,57},{80,57},{80,58.6667},{116,58.6667}},
      color={191,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(bouConExtWin.glaSha, conExtWin.glaSha_a)
                                             annotation (Line(
      points={{116,56},{88,56},{88,55},{56,55}},
      color={191,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(conExtWin.JInSha_a, bouConExtWin.JOutSha)
                                              annotation (Line(
      points={{56.5,53},{86,53},{86,50.6667},{115.333,50.6667}},
      color={0,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(bouConExtWin.JInSha, conExtWin.JOutSha_a)
                                              annotation (Line(
      points={{115.333,53.3333},{84,53.3333},{84,51},{56.5,51}},
      color={0,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(conExtWin.fra_a, bouConExtWin.fra)
                                       annotation (Line(
      points={{56,48},{82,48},{82,46.6667},{116,46.6667}},
      color={191,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(conExt.opa_b, air.conExt) annotation (Line(
      points={{23.9,139},{-106,139},{-106,60},{-120,60},{-120,59.1667}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conExt.opa_a, bouConExt.opa_a)      annotation (Line(
      points={{54,139},{94,139},{94,139.333},{114,139.333}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(weaBus, bouConExtWin.weaBus)    annotation (Line(
      points={{180,180},{180,65.4},{150.867,65.4}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(weaBus, bouConExt.weaBus) annotation (Line(
      points={{180,180},{180,128},{148.867,128},{148.867,127.4}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(air.uSha[1], zer.y) annotation (Line(
      points={{-140.833,57.5833},{-168,57.5833},{-168,130},{-179,130}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ports, air.ports) annotation (Line(
      points={{-200,-60},{-130,-60},{-130,40.0833}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(bouConExtWin.QAbsSWSha_flow, conExtWinRad.QAbsExtSha_flow)
    annotation (Line(
      points={{114.667,68},{100,68},{100,-1},{61,-1}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(bouConExtWin.inc, conExtWinRad.incAng) annotation (Line(
      points={{156.667,76},{172,76},{172,-40},{20,-40},{20,-11},{38.5,-11}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(bouConExtWin.HDir, conExtWinRad.HDir) annotation (Line(
      points={{156.667,72},{170,72},{170,-28},{22,-28},{22,-6},{38.5,-6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(bouConExtWin.HDif, conExtWinRad.HDif) annotation (Line(
      points={{156.667,68},{168,68},{168,-26},{24,-26},{24,-2},{38.5,-2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(uSha, conExtWinRad.uSha) annotation (Line(
      points={{-220,180},{-168,180},{-168,-34},{49.8,-34},{49.8,-21.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(air.HOutConExtWin, conExtWinRad.HRoo) annotation (Line(
      points={{-138.333,39.5833},{-138.333,-17.6},{38.5,-17.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conExtWinRad.QTra_flow, air.JInConExtWin) annotation (Line(
      points={{61,-18},{72,-18},{72,-46},{-152,-46},{-152,45.8333},{-140.833,
          45.8333}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conExtWinRad.QAbsIntSha_flow, air.QAbsSWSha_flow) annotation (Line(
      points={{61,-13},{76,-13},{76,-48},{-154,-48},{-154,41.6667},{-140.833,
          41.6667}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conExtWin.QAbsSha_flow, conExtWinRad.QAbsGlaSha_flow) annotation (
      Line(
      points={{37,45},{37,14},{76,14},{76,-9},{61,-9}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conExtWinRad.QAbsGlaUns_flow, conExtWin.QAbsUns_flow) annotation (
      Line(
      points={{61,-5},{70,-5},{70,10},{45,10},{45,45}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(zer.y, air.JInConExtWin[1]) annotation (Line(
      points={{-179,130},{-168,130},{-168,46},{-140.833,46},{-140.833,45.8333}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(zer.y, air.QAbsSWSha_flow[1]) annotation (Line(
      points={{-179,130},{-168,130},{-168,41.6667},{-140.833,41.6667}},
      color={0,0,127},
      smooth=Smooth.None));
   annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-200,
            -200},{200,200}}),
                      graphics), Icon(coordinateSystem(preserveAspectRatio=true,
          extent={{-200,-200},{200,200}}), graphics={
        Text(
          extent={{-104,210},{84,242}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="%name"),
        Rectangle(
          extent={{-160,160},{160,-160}},
          lineColor={135,135,135},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-140,140},{140,-140}},
          lineColor={135,135,135},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-214,114},{-138,82}},
          lineColor={0,0,127},
          textString="q"),
        Text(
          extent={{-212,176},{-136,144}},
          lineColor={0,0,127},
          textString="u")}),
    preferedView="info",
    Documentation(info="<html>
<p>The package <b>Buildings.RoomsBeta</b> contains models for heat transfer 
through the building envelope.</p>
<p>The model <a href=\"modelica:Buildings.RoomsBeta.MixedAir\">Buildings.RoomsBeta.MixedAir</a> is 
a model of a room with completely mixed air.
The room can have any number of constructions and surfaces that participate in the 
heat exchange through convection, conduction, long-wave radiation and short-wave radiation.</p>
<h4>Physical description</h4>
<p>
The room models the following physical processes:
<ol>
<li>
Transient or steady-state heat conduction through opaque surfaces, using
the model
<a href=\"modelica://Buildings.HeatTransfer.ConductorMultiLayer\">
Buildings.HeatTransfer.ConductorMultiLayer</a>
</li>
<li>
Heat transfer through glazing system, taking into account
short-wave radiation, long-wave radiation, heat conduction and heat convection.
The short-wave radiation is modeled using
<a href=\"modelica://Buildings.HeatTransfer.WindowsBeta.BaseClasses.WindowRadiation\">
Buildings.HeatTransfer.WindowsBeta.BaseClasses.WindowRadiation</a>.
The overall heat transfer is modeled using the model
<a href=\"modelica://Buildings.HeatTransfer.WindowsBeta.Window\">
Buildings.HeatTransfer.WindowsBeta.Window</a>
for the glass assembly, the models
<a href=\"modelica://Buildings.HeatTransfer.WindowsBeta.ExteriorHeatTransfer\">
Buildings.HeatTransfer.WindowsBeta.ExteriorHeatTransfer</a>
and
<a href=\"modelica://Buildings.HeatTransfer.WindowsBeta.ExteriorHeatTransfer\">
Buildings.HeatTransfer.WindowsBeta.ExteriorHeatTransfer</a>
for the exterior and interior heat transfer.
</li>
<li>
Short-wave and long-wave heat transfer between the room enclosing surfaces,
and temperature, pressure and species changes inside the room volume.
These effects are modeled and described in 
<a href=\"modelica://Buildings.RoomsBeta.BaseClasses.MixedAir\">
Buildings.RoomsBeta.BaseClasses.MixedAir</a>
which consists of several sub-models.
</li>
</ol>
</p>
<h4>Model instantiation</h4>
<p>The next paragraphs describe how to instantiate a room model.
To instantiate a room model, 
<ol>
<li>
make an instance of the room model in your model,
</li>
<li>
make instances of constructions from the package 
<a href=\"modelica://Buildings.HeatTransfer.Data.OpaqueConstructions\">
Buildings.HeatTransfer.Data.OpaqueConstructions</a> to model opaque constructions such as walls, floors,
ceilings and roofs,
</li>
<li>
make an instance of constructions from the package 
<a href=\"modelica://Buildings.HeatTransfer.Data.GlazingSystems\">
Buildings.HeatTransfer.Data.GlazingSystems</a> to model glazing systems, and
</li>
<li>
enter the parameters of the room. 
</li>
</ol>
Entering parameters may be easiest in a textual editor. 

In the here presented example, we assume we made several instances
of data records for the construction material by dragging them from 
the package <a href=\"modelica://Buildings.HeatTransfer.Data\">
Buildings.HeatTransfer.Data</a> to create the following list of declarations:
<pre>
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><span style=\" font-family:'Courier New,courier';\">  </span><span style=\" font-family:'Courier New,courier'; color:#ff0000;\">Buildings.HeatTransfer.Data.OpaqueConstructions.Insulation100Concrete200</span></p>
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    matLayExt </span><span style=\" font-family:'Courier New,courier'; color:#006400;\">\"Construction material for exterior walls\"</span></p>
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    </span><span style=\" font-family:'Courier New,courier'; color:#0000ff;\">annotation </span><span style=\" font-family:'Courier New,courier';\">(Placement(transformation(extent={{-60,140},{-40,160}})));</span></p>
<p style=\"-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; font-family:'Courier New,courier';\"></p>
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">  </span><span style=\" font-family:'Courier New,courier'; color:#ff0000;\">Buildings.HeatTransfer.Data.OpaqueConstructions.Brick120</span><span style=\" font-family:'Courier New,courier';\"> matLayPar </span></p>
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier'; color:#006400;\">    \"Construction material for partition walls\"</span></p>
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    </span><span style=\" font-family:'Courier New,courier'; color:#0000ff;\">annotation </span><span style=\" font-family:'Courier New,courier';\">(Placement(transformation(extent={{-20,140},{0,160}})));</span></p>
<p style=\"-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; font-family:'Courier New,courier';\"></p>
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">  </span><span style=\" font-family:'Courier New,courier'; color:#ff0000;\">Buildings.HeatTransfer.Data.OpaqueConstructions.Generic</span><span style=\" font-family:'Courier New,courier';\"> matLayRoo(</span></p>
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">        material={</span></p>
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">          </span><span style=\" font-family:'Courier New,courier'; color:#ff0000;\">HeatTransfer.Data.Solids.InsulationBoard</span><span style=\" font-family:'Courier New,courier';\">(x=0.2),</span></p>
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">          </span><span style=\" font-family:'Courier New,courier'; color:#ff0000;\">HeatTransfer.Data.Solids.Concrete</span><span style=\" font-family:'Courier New,courier';\">(x=0.2)},</span></p>
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">        </span><span style=\" font-family:'Courier New,courier'; color:#0000ff;\">final </span><span style=\" font-family:'Courier New,courier';\">nLay=2) </span><span style=\" font-family:'Courier New,courier'; color:#006400;\">\"Construction material for roof\"</span></p>
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    </span><span style=\" font-family:'Courier New,courier'; color:#0000ff;\">annotation </span><span style=\" font-family:'Courier New,courier';\">(Placement(transformation(extent={{20,140},{40,160}})));</span></p>
<p style=\"-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; font-family:'Courier New,courier';\"></p>
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">  </span><span style=\" font-family:'Courier New,courier'; color:#ff0000;\">Buildings.HeatTransfer.Data.OpaqueConstructions.Generic</span><span style=\" font-family:'Courier New,courier';\"> matLayFlo(</span></p>
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">        material={</span></p>
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">          </span><span style=\" font-family:'Courier New,courier'; color:#ff0000;\">HeatTransfer.Data.Solids.Concrete</span><span style=\" font-family:'Courier New,courier';\">(x=0.2),</span></p>
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">          </span><span style=\" font-family:'Courier New,courier'; color:#ff0000;\">HeatTransfer.Data.Solids.InsulationBoard</span><span style=\" font-family:'Courier New,courier';\">(x=0.1),</span></p>
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    </span><span style=\" font-family:'Courier New,courier'; color:#000000;\">      </span><span style=\" font-family:'Courier New,courier';\">HeatTransfer.Data.Solids.Concrete(x=0.05)</span><span style=\" font-family:'Courier New,courier'; color:#000000;\">}</span><span style=\" font-family:'Courier New,courier';\">,</span></p>
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">        </span><span style=\" font-family:'Courier New,courier'; color:#0000ff;\">final </span><span style=\" font-family:'Courier New,courier';\">nLay=3) </span><span style=\" font-family:'Courier New,courier'; color:#006400;\">\"Construction material for floor\"</span></p>
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    </span><span style=\" font-family:'Courier New,courier'; color:#0000ff;\">annotation </span><span style=\" font-family:'Courier New,courier';\">(Placement(transformation(extent={{60,140},{80,160}})));</span></p>
<p style=\"-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; font-family:'Courier New,courier';\"></p>
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">  </span><span style=\" font-family:'Courier New,courier'; color:#ff0000;\">Buildings.HeatTransfer.Data.GlazingSystems.DoubleClearAir13Clear</span><span style=\" font-family:'Courier New,courier';\"> glaSys(</span></p>
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    UFra=2,</span></p>
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    shade=</span><span style=\" font-family:'Courier New,courier'; color:#ff0000;\">Buildings.HeatTransfer.Data.Shades.Gray</span><span style=\" font-family:'Courier New,courier';\">(),</span></p>
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    haveExteriorShade=false,</span></p>
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    haveInteriorShade=true) </span><span style=\" font-family:'Courier New,courier'; color:#006400;\">\"Data record for the glazing system\"</span></p>
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    </span><span style=\" font-family:'Courier New,courier'; color:#0000ff;\">annotation </span><span style=\" font-family:'Courier New,courier';\">(Placement(transformation(extent={{100,140},{120,160}})));</span></p>
<p style=\"-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; font-family:'Courier New,courier';\"></p>

</pre>
<p>
Note that construction layers are assembled from the outside to the room-side. Thus, the construction
<code>matLayRoo</code> has an exterior insulation. This constructions can then be used in the room model.
</p>
<p>
Before we explain how to declare and parametrize a room model, 
we explain the different models that can be used to compute heat transfer through the room enclosing surfaces
and constructions. The room model 
<a href=\"modelica://Buildings.RoomsBeta.MixedAir\">Buildings.RoomsBeta.MixedAir</a> contains the constructions shown
in the table below. 
The first row of the table lists the name of the data record that is used by the user
to assign the model parameters. 
The second row lists the name of the instance of the model that simulates the equations.
The third column provides a reference to the class definition that implements the equations.
The forth column describes the main applicability of the model.
</p>
<p>
<table border=\"1\">
<tr>
<th>Record name</th>
<th>Model instance name</th>
<th>Class name</th>
<th>Description of the model</th></tr>
<tr>
<td>
datConExt
</td>
<td>
modConExt
</td>
<td>
<a href=\"modelica://Buildings.RoomsBeta.Constructions.Construction\">Buildings.RoomsBeta.Constructions.Construction</a>
</td>
<td>
Exterior constructions that have no window.
</td>
</tr>
<tr>
<td>
datConExtWin
</td>
<td>
modConExtWin
</td>
<td>
<a href=\"modelica://Buildings.RoomsBeta.Constructions.ConstructionWithWindow\">Buildings.RoomsBeta.Constructions.ConstructionWithWindow</a>
</td>
<td>
Exterior constructions that have a window. Each construction of this type needs to have one window.
Within the same room, all windows can either have a shade or have no shade. 
Individual windows within the same room can have either an interior shade or an exterior shade, but not both.
Each window has its own control signal for the shade. This signal is exposed by the port <code>uSha</code>, which
has the same dimension as the number of windows. 
A value of <code>0</code> means that the shade is open, and <code>1</code> means that the shade is closed.
</td>
</tr>
<tr>
<td>
datConPar
</td>
<td>
modConPar
</td>
<td>
<a href=\"modelica://Buildings.RoomsBeta.Constructions.Construction\">Buildings.RoomsBeta.Constructions.Construction</a>
</td>
<td>
Interior constructions such as partitions within a room. Both surfaces of this construction are inside the room model
and participate in the long-wave and short-wave radiation balance. 
Since the view factor between these surfaces is zero, there is no long-wave radiation from one surface to the other
of the same construction.
</td>
</tr>
<tr>
<td>
datConBou
</td>
<td>
modConBou
</td>
<td>
<a href=\"modelica://Buildings.RoomsBeta.Constructions.Construction\">Buildings.RoomsBeta.Constructions.Construction</a>
</td>
<td>
Constructions that expose the other boundary conditions of the other surface to the outside of this room model.
The heat conduction through these constructions is modeled in this room model. 
The surface at the port <code>opa_b</code> is connected to the models for convection, long-wave and short-wave radiation exchange 
with this room model and with the other surfaces of this room model.
The surface at the port <code>opa_a</code> is connected to the port <code>surf_conBou</code> of this room model. This could be used, for example,
to model a floor inside this room and connect to other side of this floor model to a model that computes heat transfer in the soil.
</td>
</tr>
<tr>
<td>
N/A
</td>
<td>
surBou
</td>
<td>
<a href=\"modelica://Buildings.HeatTransfer.Data.OpaqueSurfaces.Generic\">Buildings.HeatTransfer.Data.OpaqueSurfaces.Generic</a>
</td>
<td>
Opaque surfaces of this room model whose heat transfer through the construction is modeled outside of this room model.
This object is modeled using a data record that contains the area, short-wave and long-wave emissivities and surface tilt.
The surface then participates in the convection and radiation heat balance of the room model. The heat flow rate and temperature
of this surface are exposed at the heat port <code>surf_surBou</code>.
An application of this object may be to connect the port <code>surf_surBou</code> of this room model with the port
<code>surf_conBou</code> of another room model in order to couple two room models.
Another application would be to model a radiant ceiling outside of this room model, and connect its surface to the port
<code>surf_conBou</code> in order for the radiant ceiling model to participate in the heat balance of this room.
</td>
</tr>
</table>
</p>
<p>
With these constructions, we may define a room as follows: </p>
<pre>
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><span style=\" font-family:'Courier New,courier';\">  </span><span style=\" font-family:'Courier New,courier'; color:#ff0000;\">Buildings.RoomsBeta.MixedAir</span><span style=\" font-family:'Courier New,courier';\"> roo(</span></p>
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    </span><span style=\" font-family:'Courier New,courier'; color:#0000ff;\">redeclare package</span><span style=\" font-family:'Courier New,courier';\"> Medium = </span><span style=\" font-family:'Courier New,courier'; color:#ff0000;\">MediumA</span><span style=\" font-family:'Courier New,courier';\">,</span></p>
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    AFlo=6*4,</span></p>
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    hRoo=2.7,</span></p>
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    nConExt=2,</span></p>
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    datConExt(layers={matLayRoo, matLayExt},</span></p>
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">           A={6*4, 6*3},</span></p>
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">           til={Types.Tilt.ceiling, Types.Tilt.wall},</span></p>
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">           azi={Types.Azimuth.S, Types.Azimuth.W}),</span></p>
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    nConExtWin=nConExtWin,</span></p>
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    datConExtWin(layers={matLayExt}, A={4*3},</span></p>
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">              glaSys={glaSys},</span></p>
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">              AWin={2*2},</span></p>
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">              fFra={0.1},</span></p>
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">              til={Types.Tilt.wall},</span></p>
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">              azi={Types.Azimuth.S}),</span></p>
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    nConPar=1,</span></p>
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    datConPar(layers={matLayPar}, </span><span style=\" font-family:'Courier New,courier'; color:#0000ff;\">each </span><span style=\" font-family:'Courier New,courier';\">A=10,</span></p>
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">           </span><span style=\" font-family:'Courier New,courier'; color:#0000ff;\">each </span><span style=\" font-family:'Courier New,courier';\">til=Types.Tilt.wall),</span></p>
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    nConBou=1,</span></p>
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    datConBou(layers={matLayFlo}, </span><span style=\" font-family:'Courier New,courier'; color:#0000ff;\">each </span><span style=\" font-family:'Courier New,courier';\">A=6*4,</span></p>
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">           </span><span style=\" font-family:'Courier New,courier'; color:#0000ff;\">each </span><span style=\" font-family:'Courier New,courier';\">til=Types.Tilt.floor),</span></p>
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    nSurBou=1,</span></p>
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    surBou(</span><span style=\" font-family:'Courier New,courier'; color:#0000ff;\">each </span><span style=\" font-family:'Courier New,courier';\">A=6*3, </span><span style=\" font-family:'Courier New,courier'; color:#0000ff;\">each </span><span style=\" font-family:'Courier New,courier';\">epsLW=0.9, </span><span style=\" font-family:'Courier New,courier'; color:#0000ff;\">each </span><span style=\" font-family:'Courier New,courier';\">epsSW=0.9, </span><span style=\" font-family:'Courier New,courier'; color:#0000ff;\">each </span><span style=\" font-family:'Courier New,courier';\">til=Types.Tilt.wall),</span></p>
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    linearize=true,</span></p>
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,</span></p>
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    lat=0.73268921998722) </span><span style=\" font-family:'Courier New,courier'; color:#006400;\">\"Room model\"</span></p>
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    </span><span style=\" font-family:'Courier New,courier'; color:#0000ff;\">annotation </span><span style=\" font-family:'Courier New,courier';\">(Placement(transformation(extent={{46,20},{86,60}})));</span></p>

</pre>
<p>
The following paragraphs explain the different declarations.
</p>
<p>
The statement
<pre>
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    </span><span style=\" font-family:'Courier New,courier'; color:#0000ff;\">redeclare package</span><span style=\" font-family:'Courier New,courier';\"> Medium = </span><span style=\" font-family:'Courier New,courier'; color:#ff0000;\">MediumA</span><span style=\" font-family:'Courier New,courier';\">,</span></p>
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    AFlo=20,</span></p>
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    V=20*2.5,</span></p>

</pre>
declares that the medium of the room air is set to <code>MediumA</code>, 
that the floor area is <i>20 m<sup>2</sup></i> and that 
the room air volume is <i>20*2.5 m<sup>3</sup></i>. 
The floor area is used to scale the internal heat
gains, which are declared with units of <i>W/m<sup>2</sup></i> 
using the input signal <code>qGai_flow</code>.
</p>
<p>
The next entries specify constructions and surfaces
that participate in the heat exchange.
</p>
<p>
The entry
<pre>
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    nConExt=2,</span></p>

</pre>
declares that there are two exterior constructions.
</p>
<p>
The lines 
<pre>
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    datConExt(layers={matLayRoo, matLayExt},</span></p>
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">           A={6*4, 6*3},</span></p>
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">           til={Types.Tilt.ceiling, Types.Tilt.wall},</span></p>
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">           azi={Types.Azimuth.S, Types.Azimuth.W}),</span></p>

</pre>
declare that the material layers in these constructions are
set the the records <code>matLayRoo</code> and <code>matLayExt</code>.
What follows are the declarations for the surface area,
the tilt of the surface and the azimuth of the surfaces. Thus, the 
surface with construction <code>matLayExt</code> is <i>6*3 m<sup>2</sup></i> large
and it is a west-facing wall.
</p>
<p>
Next, the declaration
<pre>
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    nConExtWin=nConExtWin,</span></p>
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    datConExtWin(layers={matLayExt}, A={4*3},</span></p>
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">              glaSys={glaSys},</span></p>
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">              AWin={2*2},</span></p>
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">              fFra={0.1},</span></p>
<p style" + "=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">              til={Types.Tilt.wall},</span></p>
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">              azi={Types.Azimuth.S}),</span></p>

</pre>
declares the construction that contains a window. This construction is built
using the materials defined in the record <code>matLayExt</code>. Its total area,
including the window, is <i>4*3 m<sup>2</sup></i>.
The glazing system is built using the construction defined in the record
<code>glaSys</code>. The glass area is <i>2*2 m<sup>2</sup></i> and the ratio of frame
to total glazing system area is <i>10%</i>. The construction is a wall that is 
south exposed.
</p>
<p>
What follows is the declaration of the partition constructions, as declared by
<pre>
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    nConPar=1,</span></p>
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    datConPar(layers={matLayPar}, </span><span style=\" font-family:'Courier New,courier'; color:#0000ff;\">each </span><span style=\" font-family:'Courier New,courier';\">A=10,</span></p>
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">           </span><span style=\" font-family:'Courier New,courier'; color:#0000ff;\">each </span><span style=\" font-family:'Courier New,courier';\">til=Types.Tilt.wall),</span></p>

</pre>
Thus, there is one partition construction. Its area is <i>10 m<sup>2</sup></i> for <emph>each</emph>
surface, to form a total surface area inside this thermal zone of <i>20 m<sup>2</sup></i>.
</p>
<p>
Next, the declaration
<pre>
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    nConBou=1,</span></p>
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    datConBou(layers={matLayFlo}, </span><span style=\" font-family:'Courier New,courier'; color:#0000ff;\">each </span><span style=\" font-family:'Courier New,courier';\">A=6*4,</span></p>
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">           </span><span style=\" font-family:'Courier New,courier'; color:#0000ff;\">each </span><span style=\" font-family:'Courier New,courier';\">til=Types.Tilt.floor),</span></p>

</pre>
declares one construction whose other surface boundary condition is exposed by this
room model (through the connector <code>surf_conBou</code>).
</p>
<p>
The declaration
<pre>
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    nSurBou=1,</span></p>
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    surBou(</span><span style=\" font-family:'Courier New,courier'; color:#0000ff;\">each </span><span style=\" font-family:'Courier New,courier';\">A=6*3, </span><span style=\" font-family:'Courier New,courier'; color:#0000ff;\">each </span><span style=\" font-family:'Courier New,courier';\">epsLW=0.9, </span><span style=\" font-family:'Courier New,courier'; color:#0000ff;\">each </span><span style=\" font-family:'Courier New,courier';\">epsSW=0.9, </span><span style=\" font-family:'Courier New,courier'; color:#0000ff;\">each </span><span style=\" font-family:'Courier New,courier';\">til=Types.Tilt.wall),</span></p>

</pre>
is used to instantiate a model for a surface that is in this room. 
The surface has an area of <i>6*3 m<sup>2</sup></i>, emissivity in the long-wave and the short-wave
spectrum of <i>0.9</i> and it is a wall.
The room model will compute long-wave radiative heat exchange, short-wave radiative heat gains
and long-wave radiative heat gains of this surface. The surface temperature and 
heat flow rate are exposed by this room model at the heat port 
<code>surf_surBou</code>. 
A model builder may use this construct
to couple this room model to another room model that may model the construction.
</p>
<p>
The declaration
<pre>
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    linearize=true,</span></p>

</pre>
causes the equations for radiative and convective heat transfer to be linearized. This can
reduce computing time at the expense of accuracy.
</p>
<p>
The declaration 
<pre>
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,</span></p>

</pre>
is used to initialize the air volume inside the thermal zone.
</p>
<p>
Finally, the declaration
<pre>
<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:8;\"><span style=\" font-family:'Courier New,courier';\">    lat=0.73268921998722) </span><span style=\" font-family:'Courier New,courier'; color:#006400;\">\"Room model\"</span></p>

</pre>
sets the latitude of the building which needs to correspond with the latitude of the weather data file.
</p>
</html>",
revisions="<html>
<ul>
<li>
December 14, 2010, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end MixedAir;
