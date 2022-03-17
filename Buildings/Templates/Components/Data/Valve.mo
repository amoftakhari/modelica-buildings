within Buildings.Templates.Components.Data;
record Valve "Record for valve model"
  extends Modelica.Icons.Record;

  parameter Buildings.Templates.Components.Types.Valve typ
    "Equipment type"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal(
    final min=0,
    start=if typ==Buildings.Templates.Components.Types.Valve.None then 0
    else 1)
    "Nominal mass flow rate of fully open valve"
    annotation(Dialog(group="Nominal condition",
      enable=typ<>Buildings.Templates.Components.Types.Valve.None));
  parameter Modelica.Units.SI.PressureDifference dpValve_nominal(
    final min=0,
    displayUnit="Pa",
    start=0)
    "Nominal pressure drop of fully open valve"
    annotation(Dialog(group="Nominal condition",
      enable=typ<>Buildings.Templates.Components.Types.Valve.None));
  parameter Modelica.Units.SI.PressureDifference dpFixed_nominal(
    final min=0,
    displayUnit="Pa")=0
    "Nominal pressure drop of pipes and other equipment in flow leg"
    annotation(Dialog(group="Nominal condition",
      enable=typ<>Buildings.Templates.Components.Types.Valve.None));
  parameter Modelica.Units.SI.PressureDifference dpFixedByp_nominal(
    final min=0,
    displayUnit="Pa")=dpFixed_nominal
    "Nominal pressure drop in the bypass line"
    annotation(Dialog(group="Nominal condition",
      enable=typ==Buildings.Templates.Components.Types.Valve.ThreeWayTwoPosition or
        typ==Buildings.Templates.Components.Types.Valve.ThreeWayModulating));

end Valve;
