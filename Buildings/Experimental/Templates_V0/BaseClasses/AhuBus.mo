within Buildings.Experimental.Templates_V0.BaseClasses;
expandable connector AhuBus
  "Control bus that is adapted to the signals connected to it"
  extends Modelica.Icons.SignalBus;
  // The following declarations are optional:
  // any connect equation involving those variables will make them available in each instance of AhuBus.
//   Real yMea;
//   Real yAct;
  parameter Integer nTer=0
    "Number of terminal units";
    // annotation(Dialog(connectorSizing=true)) is not interpreted properly in Dymola.
  Real yTest
    "Test declared variable";
  Boolean staAhu
    "Test how a scalar variable can be passed on to an array of connected units";
  Buildings.Experimental.Templates_V0.BaseClasses.AhuSubBusO ahuO "AHU/O"
    annotation (HideResult=false);
  Buildings.Experimental.Templates_V0.BaseClasses.AhuSubBusI ahuI "AHU/I"
    annotation (HideResult=false);
  Buildings.Experimental.Templates_V0.BaseClasses.TerminalBus ahuTer[nTer] if
    nTer > 0 "Terminal unit sub-bus";
    // Binding with (each staAhu=staAhu) is invalid in Dymola and OCT.
  annotation (
  defaultComponentName="busAhu",
  Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}), graphics={Rectangle(
                  extent={{-20,2},{22,-2}},
                  lineColor={255,204,51},
                  lineThickness=0.5)}), Documentation(info="<html>
<p>
This connector defines the \"expandable connector\" ControlBus that
is used as bus in the
<a href=\"modelica://Modelica.Blocks.Examples.BusUsage\">BusUsage</a> example.
Note, this connector contains \"default\" signals that might be utilized
in a connection (the input/output causalities of the signals
are determined from the connections to this bus).
</p>
</html>"));
end AhuBus;
