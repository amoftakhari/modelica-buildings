within Buildings.Fluid.Boilers.Data.Lochinvar.FTXL;
record FTX400 "Specifications for Lochinvar FTXL FTX400 boiler"
  extends Buildings.Fluid.Boilers.Data.Generic(
    effCur=
      [0,   294.264548954895, 299.823542354235, 305.382535753575, 310.941529152915, 316.500522552255, 322.059515951595, 327.580693069307, 333.177502750275, 338.698679867987, 344.257673267327;
       0.1,0.993531468531468,0.986538461538461,0.977797202797202,0.963286713286713,0.944755244755244,0.920629370629370,0.897902097902098,0.882167832167832,0.876223776223776,0.874825174825174;
       0.5,0.986888111888112,0.979895104895105,0.971153846153846,0.957517482517482,0.938986013986014,0.914335664335664,0.894755244755244,0.880419580419580,0.875000000000000,0.873776223776223;
         1,0.981993006993007,0.975000000000000,0.966258741258741,0.951748251748251,0.931643356643356,0.908916083916083,0.892132867132867,0.879370629370629,0.873776223776223,0.872552447552447],
    final fue = Buildings.Fluid.Data.Fuels.NaturalGasHigherHeatingValue(),
    Q_flow_nominal=114883.8594,
    VWat=0.049210353,
    mDry=216.8171529,
    m_flow_nominal=2.460518,
    dp_nominal=10461.43);
  annotation (Documentation(info="<html>
<p>
Performance data for boiler model.
See the documentation of
<a href=\"modelica://Buildings.Fluid.Boilers.Data.Lochinvar\">
Buildings.Fluid.Boilers.Data.Lochinvar</a>.
</p>
</html>"));
end FTX400;
