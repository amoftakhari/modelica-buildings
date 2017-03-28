within Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Validation;
model Max "Validation model for the Max block"
extends Modelica.Icons.Example;

  Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Max max1
    "Block that pass through the largest signal"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Ramp ramp1(
    duration=1,
    offset=-2,
    height=4)  "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-60,12},{-40,32}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Ramp ramp2(
    duration=1,
    offset=-1,
    height=2) "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
equation
  connect(ramp1.y, max1.u1) annotation (Line(points={{-39,22},{-26,22},{-26,6},{
          -12,6}}, color={0,0,127}));
  connect(ramp2.y, max1.u2) annotation (Line(points={{-39,-20},{-26,-20},{-26,-6},
          {-12,-6}}, color={0,0,127}));
  annotation (
experiment(StopTime=1.0),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/CDL/Continuous/Validation/Max.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Max\">
Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Max</a>.
</p>
<p>
The input <code>u1</code> varies from <i>-2</i> to <i>+2</i>, input <code>u2</code> varies from <i>-1</i> to <i>+1</i>.
</p>
</html>", revisions="<html>
<ul>
<li>
March 22, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>

</html>"));
end Max;
