# photoNix

## Usage (Docker)

### Shell (via docker-launcher.sh)
To run contaainer directly under shell, invoke:
```shell
./docker/docker-launcher.sh
```
Script will use path from which it was invoked as mounting point for workspace.

### VS Code (devcontainers)
It can be also run under VS Code using devcontainers extension.
To do this:
1. Open photoNix folder under VS Code.
2. Open Command Pallete (Ctrl + Shift + P)
3. Select 'Dev Containers: Reopen in Container'

## System and tools
| Component            | Version      | Note              | URL                                           |
| :------------------- | :----------- | :---------------- | :-------------------------------------------- |
| **OS**               | Ubuntu 24.04 | Base system       |                                               |
| **KLayout**          | 0.28.16      | GDS viewer/editor | https://www.klayout.de/                       |
| **klive**            | 0.4.3        | KLayout plugin    | https://github.com/gdsfactory/klive           |
| **XSection**         | 1.10         | KLayout plugin    | https://codeberg.org/klayoutmatthias/xsection |
| **SiEPIC Tools**     | 0.5.31       | KLayout plugin    | https://github.com/SiEPIC/SiEPIC-Tools        |
| **SiEPIC EBeam PDK** | 0.4.53       | KLayout plugin    | https://github.com/SiEPIC/SiEPIC_EBeam_PDK    |
| **Ansys Lumerical**  | 2026 R1      | Simulation suite  | https://ansys.synopsys.com/products/optics/   |

## Lumerical
> [!IMPORTANT]
> Currently, only Lumerical 2026 R1 has been tested and hence is considered as the only one supported.

In order to install Lumerical, place `lumerical.deb` in `secrets/` directory before starting the container.

```shell
user@host:~/photoNix/ > ls secrets
lumerical.deb
```

### Licensing
#### Using Ansys ID token

> [!IMPORTANT]
> Currently, only this form of licensing has been tested and hence is considered as the only one supported.

1. Login to your [Ansys ID account](https://id.ansys.com/).
2. Click your profile icon in top, right corner and select `Personal access tokens`
3. Click `Create Token` button. Set name to `ansys_token` and confirm with `Create` button.
4. If token has been created, you should see the pop up message.
5. Click `Download the token`. In few seconds you should get `ansys_token.json` file.
6. Move or copy this file under `secrets/` directory.
7. Once your token and installer are in place you can run the container. 

```shell
user@host:~/photoNix/ > ls secrets
ansys_token.json  lumerical.deb
```

## Jupyter

To start Jupyter Lab in container, invoke
```shell
user@host:/workspace# just jupyter-start
```

To stop Jupyter Lab:
```shell
user@host:/workspace# just jupyter-stop
```

## Examples
<table>
  <thead>
    <tr>
      <th>Example</th>
      <th>Tools</th>
      <th>Note</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><strong><a href="workspace/examples/lumerical/jupyter/stripWaveguide_widthSweep.ipynb"> Width sweep of strip waveguide </a></strong></td>
      <td> Jupyter, Lumerical MODE (lumapi) </td>
      <td> Effective refractive index (n<sub>eff</sub>) analysis across varying waveguide core widths. </td>
    </tr>
    <tr>
      <td><strong><a href="workspace/examples/lumerical/jupyter/stripWaveguide_90Bend.ipynb"> Optimization of 90° bend </a></strong></td>
      <td> Jupyter, Lumerical FDTD (lumapi), GDSfactory </td>
      <td> Waveguide 90° bend insertion loss minimization using Bézier curves and CMA-ES </td>
    </tr>
    <tr>
      <td><strong><a href="workspace/examples/lumerical/jupyter/stripWaveguide_sBend.ipynb"> Optimization of S-bend </a></strong></td>
      <td> Jupyter, Lumerical FDTD (lumapi), GDSfactory </td>
      <td> Waveguide S-bend insertion loss minimization using Bézier curves and CMA-ES </td>
    </tr>
    <tr>
      <td><strong><a href="workspace/examples/lumerical/jupyter/stripWaveguide_directionalCoupler_fdtd.ipynb"> Gap width sweep of directional coupler </a></strong></td>
      <td> Jupyter, Lumerical MODE (lumapi) </td>
      <td> Analyzing symmetric and antisymmetric supermodes effective indices (n<sub>eff</sub>) and gap width influence on crossover length</td>
    </tr>
    <tr>
      <td><strong><a href="workspace/examples/lumerical/jupyter/stripWaveguide_directionalCoupler_fdtd.ipynb"> Light propagation through directional coupler </a></strong></td>
      <td> Jupyter, Lumerical FDTD (lumapi) </td>
      <td> FDTD analysis of directional coupler, S-parameters extraction. </td>
    </tr>
    <tr>
      <td><strong><a href="workspace/examples/misc/logicGate_gradientDescent.ipynb"> Optimization of MZI-based circuit to perform logic operations </a></strong></td>
      <td> Jupyter </td>
      <td> Gradient-descent optimization of a triangular 3-MZI mesh for optical logic operations via the transfer-matrix method. </td>
    </tr>
    <tr>
      <td><strong><a href="workspace/examples/lumerical/jupyter/logicGate_interconnect.ipynb"> Simulation of MZI-based circuit to perform logic operations </a></strong></td>
      <td> Jupyter, Lumerical INTERCONNECT (lumapi) </td>
      <td> Simulation of triangular 3-MZI mesh for optical logic operations in Lumerical INTERCONNECT. </td>
    </tr>
    <tr>
      <td><strong><a href="workspace/examples/lumerical/gui/stripWaveguide_directionalCoupler_fdtd/"> Light propagation through directional coupler </a></strong></td>
      <td> Lumerical FDTD (GUI) </td>
      <td> FDTD analysis of directional coupler </td>
    </tr>
    <tr>
      <td><strong><a href="workspace/examples/lumerical/gui/logicGate_interconnect/"> Simulation of MZI-based circuit to perform logic operations </a></strong></td>
      <td> Lumerical INTERCONNECT (GUI) </td>
      <td> Simulation of triangular 3-MZI mesh for optical logic operations in Lumerical INTERCONNECT. </td>
    </tr>
  </tbody>
</table>

## Publications
<table>
  <thead>
    <tr>
      <th> Category </th>
      <th> Platform </th>
      <th> Title </th>
      <th> DOI </th>
      <th> Date </th>
      <th> Open access </th>
      <th> Scihub </th>
      <th> Local </th>
    </tr>
  </thead>
  <tbody>
    <tr id="10.1109/JPROC.2018.2861576">
      <td> Overview </td>
      <td> SiN </td>
      <td><strong> Silicon Nitride in Silicon Photonics </strong></td>
      <td> 10.1109/JPROC.2018.2861576 </td>
      <td> 26.09.2018 </td>
      <td><a href="https://ocaqpi.ece.ucsb.edu/sites/default/files/2021-02/Blumenthal_et_al_Silicon%20Nitride%20in%20Silicon%20Photonics.pdf"> ✅ </a></td>
      <td> ✅ </td>
      <td><a href="/secrets/papers/SiliconNitrideInSiliconPhotonics.pdf"> ✅ </a></td>
    </tr>
    <tr id="10.3390/ma15041398">
      <td> - </td>
      <td> SiN</td>
      <td><strong> Passive Photonic Integrated Circuits Elements Fabricated on a Silicon Nitride Platform </strong></td>
      <td> 10.3390/ma15041398 </td>
      <td> 13.02.2022 </td>
      <td><a href="https://www.mdpi.com/1996-1944/15/4/1398/pdf"> ✅ </a></td>
      <td> ❌ </td>
      <td><a href="/secrets/papers/PassivePhotonicIntegratedCircuitsElementsFabricatedOnSiliconNitridePlatform.pdf"> ✅ </a></td>
    </tr>
    <tr id="10.1109/IPC65510.2025.11282252" >
      <td> Bends </td>
      <td> SiN </td>
      <td><strong> Low-loss Euler Waveguide Bends in Silicon Nitride Photonic Integrated Circuits </strong></td>
      <td> 10.1109/IPC65510.2025.11282252 </td>
      <td> 09.10.2025 </td>
      <td><a href="https://ieeexplore.ieee.org/document/11282252"> ❌ </a></td>
      <td> ✅ </td>
      <td><a href="/secrets/papers/LowLossEulerWaveguideBendsInSiliconNitridePhotonicIntegratedCircuits.pdf"> ✅ </a></td>
    </tr>
    <tr id="10.1364/OE.475398">
      <td> Bends </td>
      <td> SOI </td>
      <td><strong> Low-loss, ultracompact n-adjustable waveguide bends for photonic integrated circuits </strong></td>
      <td> 10.1364/OE.475398 </td>
      <td> 11.01.2023 </td>
      <td><a href="https://opg.optica.org/oe/viewmedia.cfm?uri=oe-31-2-2792&seq=0"> ✅ </a></td>
      <td> ❌ </td>
      <td><a href="/secrets/papers/LowLossUltracompactNAdjustableWaveguideBendsForPhotonicIntegratedCircuits.pdf"> ✅ </a></td>
    </tr>
    <tr id="10.1364/OE.25.009150">
      <td> Bends </td>
      <td> SOI </td>
      <td><strong> Low-loss, compact, and fabrication-tolerant Si-wire 90° waveguide bend using clothoid and normal curves for large scale photonic integrated circuits </strong></td>
      <td> 10.1364/OE.25.009150 </td>
      <td> 17.04.2017 </td>
      <td><a href="https://opg.optica.org/oe/viewmedia.cfm?uri=oe-25-8-9150&seq=0"> ✅ </a></td>
      <td> ✅ </td>
      <td><a href="/secrets/papers/LowLossCompactAndFabricationTolerantSiWire90WaveguideBendUsingClothoidAndNormalCurvesForLargeScalePhotonicIntegratedCircuits.pdf"> ✅ </a></td>
    </tr>
    <tr id="10.1109/LPT.2016.2585760">
      <td> Bends </td>
      <td> SiN </td>
      <td><strong> Adiabatically Bent Waveguides on Silicon Nitride Photonics for Compact and Dense Footprints </strong></td>
      <td> 10.1109/LPT.2016.2585760 </td>
      <td> 28.06.2016 </td>
      <td><a href="https://ieeexplore.ieee.org/document/7501623"> ❌ </a></td>
      <td> ✅ </td>
      <td><a href="/secrets/papers/AdiabaticallyBentWaveguidesOnSiliconNitridePhotonicsForCompactAndDenseFootprints.pdf"> ✅ </a></td>
    </tr>
    <tr id="10.1364/OE.452580">
      <td> Bends </td>
      <td> Si & SiN </td>
      <td><strong> Low loss modified Bezier bend waveguide </strong></td>
      <td> 10.1364/OE.452580 </td>
      <td> 14.03.2022 </td>
      <td><a href="https://opg.optica.org/oe/viewmedia.cfm?uri=oe-30-7-10293&seq=0"> ✅ </a></td>
      <td> ❌ </td>
      <td><a href="/secrets/papers/LowLossModifiedBezierBendWaveguide.pdf"> ✅ </a></td>
    </tr>
    <tr id="10.1109/JPHOT.2024.3509312">
      <td> Bends </td>
      <td> SiN </td>
      <td><strong> Advanced Bends and Micro Ring Resonators in Silicon Nitride Photonic Waveguides for C-Band </strong></td>
      <td> 10.1109/JPHOT.2024.3509312 </td>
      <td> 29.11.2024 </td>
      <td><a href="https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=10771684"> ✅ </a></td>
      <td> ✅ </td>
      <td><a href="/secrets/papers/AdvancedBendsAndMicroRingResonatorsInSiliconNitridePhotonicWaveguidesForCBand.pdf"> ✅ </a></td>
    </tr>
    <tr id="10.1364/OE.504866" >
      <td> S-bends </td>
      <td> SOI </td>
      <td><strong> Design of compact and low-loss S-bends by CMA-ES </strong></td>
      <td> 10.1364/OE.504866 </td>
      <td> 18.12.2023 </td>
      <td><a href="https://opg.optica.org/oe/viewmedia.cfm?uri=oe-31-26-43850&seq=0"> ✅ </a></td>
      <td> ❌ </td>
      <td><a href="/secrets/papers/DesignOfCompactAndLowLossSBendsByCMAES.pdf"> ✅ </a></td>
    </tr>
    <tr id="10.1364/AO.51.008693">
      <td> AO-LGs </td>
      <td> SOI </td>
      <td><strong> Single Mach–Zehnder interferometer based optical Boolean logic gates </strong></td>
      <td> 10.1364/AO.51.008693 </td>
      <td> 20.12.2012 </td>
      <td><a href="https://opg.optica.org/ao/abstract.cfm?uri=ao-51-36-8693"> ❌ </a></td>
      <td> ✅ </td>
      <td><a href="/secrets/papers/SingleMachZehnderInterferometerBasedOpticalBooleanLogicGates.pdf"> ✅ </a></td>
    </tr>
    <tr id="10.1016/j.optlastec.2023.109703">
      <td> AO-LGs </td>
      <td> SOI </td>
      <td><strong> Optical logic operations using a meshed Mach-Zehnder interference array </strong></td>
      <td> 10.1016/j.optlastec.2023.109703 </td>
      <td> xx.12.2023 </td>
      <td><a href="https://doi.org/10.1016/j.optlastec.2023.109703"> ❌ </a></td>
      <td> ❌ </td>
      <td><a href="/secrets/papers/OpticalLogicOperationsUsingMeshedMachZehnderInterferenceArray.pdf"> ✅ </a></td>
    </tr>
    <tr id="10.3390/nano15191532">
      <td> - </td>
      <td> SiN </td>
      <td><strong> Experimental Characterization of a Silicon Nitride Asymmetric Loop-Terminated Mach-Zehnder Interferometer with a Refractive Index-Engineered Sensing Arm </strong></td>
      <td> 10.3390/nano15191532 </td>
      <td> 08.10.2025 </td>
      <td><a href="https://www.mdpi.com/2079-4991/15/19/1532/pdf"> ✅ </a></td>
      <td> ❌ </td>
      <td><a href="/secrets/papers/ExperimentalCharacterizationOfSiliconNitrideAsymmetricLoopTerminatedMachZehnderInterferometerWithARefractiveIndexEngineeredSensingArm.pdf"> ✅ </a></td>
    </tr>
    <tr id="10.1364/OE.24.006843">
      <td> - </td>
      <td> SiN </td>
      <td><strong> Design and characterization of integrated components for SiN photonic quantum circuits </strong></td>
      <td> 10.1364/OE.24.006843 </td>
      <td> 21.03.2016 </td>
      <td><a href="https://opg.optica.org/oe/viewmedia.cfm?uri=oe-24-7-6843&seq=0"> ✅ </a></td>
      <td> ✅ </td>
      <td><a href="/secrets/papers/DesignAndCharacterizationOfIntegratedComponentsForSiNPhotonicQuantumCircuits.pdf"> ✅ </a></td>
    </tr>
    <tr id="10.1109/JLT.2024.3458459">
      <td> Optical computing </td>
      <td> - </td>
      <td><strong> An All-Optical General-Purpose CPU and Optical Computer Architecture </strong></td>
      <td> 10.1109/JLT.2024.3458459 </td>
      <td> 15.10.2024 </td>
      <td><a href="https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=10675424"> ✅ </a></td>
      <td> ✅ </td>
      <td><a href="/secrets/papers/AnAllOpticalGeneralPurposeCPUAndOpticalComputerArchitecture.pdf"> ✅ </a></td>
    </tr>
  </tbody>
</table>
