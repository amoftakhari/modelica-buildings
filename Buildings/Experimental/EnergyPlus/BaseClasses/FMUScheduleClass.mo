within Buildings.Experimental.EnergyPlus.BaseClasses;
class FMUScheduleClass
  "Class used to couple the FMU to send values to schedules"
  extends Modelica.Icons.BasesPackage;
  extends ExternalObject;

  function constructor
    "Construct to connect to a schedule in EnergyPlus"
    extends Modelica.Icons.Function;

    input String modelicaNameBuilding
      "Name of this Modelica building instance that requests this output variable";
    input String modelicaNameSchedule
      "Name of the Modelica instance that requests this output variable";
    input String idfName "Name of the IDF";
    input String weaName "Name of the weather file";
    input String iddName "Name of the IDD file";
    input String scheduleName "EnergyPlus name of the schedule";
    input Boolean usePrecompiledFMU "Set to true to use precompiled FMU with name specified by input fmuName";
    input String fmuName
      "Specify if a pre-compiled FMU should be used instead of EnergyPlus (mainly for development)";
    input String buildingsLibraryRoot "Root directory of the Buildings library (used to find the spawn executable)";
    input Buildings.Experimental.EnergyPlus.Types.Verbosity verbosity
    "Verbosity of EnergyPlus output"
    annotation(Dialog(tab="Debug"));
    output FMUScheduleClass adapter;
    external "C" adapter = ScheduleAllocate(
      modelicaNameBuilding,
      modelicaNameSchedule,
      idfName,
      weaName,
      iddName,
      scheduleName,
      usePrecompiledFMU,
      fmuName,
      buildingsLibraryRoot,
      verbosity)
        annotation (
          IncludeDirectory="modelica://Buildings/Resources/C-Sources/EnergyPlus",
          Include="#include \"ScheduleAllocate.c\"",
          Library={"fmilib_shared", "dl"});
          // dl provides dlsym to load EnergyPlus dll, which is needed by OpenModelica compiler

    annotation (Documentation(info="<html>
<p>
The function <code>constructor</code> is a C function that is called by a Modelica simulator
exactly once during the initialization.
The function returns the object <code>adapter</code> that
will be used to store the data structure needed to communicate with EnergyPlus.
</p>
</html>", revisions="<html>
<ul>
<li>
November 8, 2019, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
  end constructor;

  function destructor "Release storage"
    extends Modelica.Icons.Function;

    input FMUScheduleClass adapter;
    external "C" ScheduleFree(adapter)
        annotation (
          IncludeDirectory="modelica://Buildings/Resources/C-Sources/EnergyPlus",
          Include="#include \"ScheduleFree.c\"");

  annotation(Documentation(info="<html>
<p>
Destructor that frees the memory of the object.
</p>
</html>", revisions="<html>
<ul>
<li>
November 8, 2019, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
  end destructor;
annotation(Documentation(info="<html>
<p>
Class derived from <code>ExternalObject</code> having two local external function definition,
named <code>destructor</code> and <code>constructor</code> respectively.
<p>
These functions create and release an external object that allows the storage
of the data structure needed to communicate with the EnergyPlus FMU.

</html>",
revisions="<html>
<ul>
<li>
November 8, 2019, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end FMUScheduleClass;
