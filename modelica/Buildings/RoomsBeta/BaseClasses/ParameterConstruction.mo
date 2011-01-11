within Buildings.RoomsBeta.BaseClasses;
record ParameterConstruction
  "Record for exterior constructions that have no window"
  extends Buildings.RoomsBeta.BaseClasses.PartialParameterConstruction;
  parameter Modelica.SIunits.Area A "Heat transfer area";

  annotation (
Documentation(info="<html>
<p>
This data record is used to set the parameters of constructions that do not have a window.
</p>
<p>
The surface azimuth is defined in 
<a href=\"modelica://Buildings.RoomsBeta.Types.Azimuth\">
Buildings.RoomsBeta.Types.Azimuth</a>
and the surface tilt is defined in <a href=\"modelica://Buildings.RoomsBeta.Types.Tilt\">
Buildings.RoomsBeta.Types.Tilt</a>
</p>
</html>", revisions="<html>
<ul>
<li>
December 14, 2010, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));

end ParameterConstruction;
