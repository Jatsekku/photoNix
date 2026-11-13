import numpy as np
import matplotlib.pyplot as plt

C = 299792458

def get_field_intensity(
    Fx,
    Fy,
    Fz
):
    Fx, Fy, Fz = (np.squeeze(Fa) for Fa in (Fx, Fy, Fz))
    return np.abs(Fx)**2 + np.abs(Fy)**2 + np.abs(Fz)**2

def get_field_intensisty_slice(
    Fx,
    Fy,
    Fz,
    x=None,
    y=None,
    z=None,
    scale="lin"
):
    active_axis = 0
    a = None

    if x is not None:
        active_axis += 1
        a=x
    if y is not None:
        active_axis += 1
        a=y
    if z is not None:
        active_axis += 1
        a=z
    a = np.asarray(a)
    a_len = len(a)

    if active_axis != 1 or a is None:
        raise ValueError("You must provide exactly one spatial axis (x, y, or z).")

    F_intensity = get_field_intensity(Fx, Fy, Fz)
    F_intensity = F_intensity/np.max(F_intensity)

    match scale:
        case "log":
            F_intensity = np.log10(F_intensity + 1e-50)
        case "db":
            F_intensity = 10*np.log10(F_intensity + 1e-50)
        case _:
            pass

    F_intensity = np.asarray(F_intensity)

    # Take slice of profile in the center along active axis
    shape = F_intensity.shape
    if shape[0] == a_len:
        mid_idx = shape[1] // 2
        F_intensity = F_intensity[:, mid_idx]
    elif shape[1] == a_len:
        mid_idx = shape[0] // 2
        F_intensity = F_intensity[mid_idx, :]
    else:
        raise ValueError("To handle")

    return np.asarray(F_intensity)

def get_decay_slope(
    Fx,
    Fy,
    Fz,
    x=None,
    y=None,
    z=None,
    amin=None,
    amax=None,
):
    active_axis = 0
    a = None

    if x is not None:
        active_axis += 1
        a=x
    if y is not None:
        active_axis += 1
        a=y
    if z is not None:
        active_axis += 1
        a=z
    a = np.asarray(a)
    a_len = len(a)

    if active_axis != 1 or a is None:
        raise ValueError("You must provide exactly one spatial axis (x, y, or z).")

    Amin, Amax = min(a), max(a)
    if amin < Amin or amax > Amax:
        raise ValueError(f"Specified bounds [{amin}, {amax}] exceed axis range [{Amin}, {Amax}].")

    F_intensity = get_field_intensity(Fx, Fy, Fz)
    F_intensity = F_intensity/np.max(F_intensity)
    F_intensity = np.log10(F_intensity + 1e-50)
    F_intensity = np.asarray(F_intensity)

    # Take slice of profile in the center along active axis
    shape = F_intensity.shape
    if shape[0] == a_len:
        mid_idx = shape[1] // 2
        F_intensity = F_intensity[:, mid_idx]
    elif shape[1] == a_len:
        mid_idx = shape[0] // 2
        F_intensity = F_intensity[mid_idx, :]
    else:
        raise ValueError("To handle")

    mask = (a >= amin) & (a <= amax)
    if not np.any(mask):
        raise ValueError(f"No points found within the specified bounds [{amin}, {amax}].")

    a = a[mask]
    F_intensity = F_intensity[mask]
    
    slope, intercept = np.polyfit(a, F_intensity, 1)
    return float(slope), float(intercept)

def plot_field(
    Fx,
    Fy, 
    Fz, 
    x=None,
    y=None,
    z=None,
    ax=None,
    cmap="jet",
    vmin=None,
    vmax=None,
):
    # Spatial components
    spatial_cords = {}
    if x is not None: spatial_cords["x"] = x
    if y is not None: spatial_cords["y"] = y
    if z is not None: spatial_cords["z"] = z

    spatial_cords_cnt = len(spatial_cords)
    if spatial_cords_cnt != 2:
        spatials_provided = list(spatial_cords.keys())
        err_msg = f"""Expected exactly 2 spatial coordinates to plot a 2D plane.
        {spatial_cords_cnt} has been provided: {spatials_provided}"""
        raise ValueError(err_msg)

    # XY, XZ, YZ planes
    (a1_name, a1_vals), (a2_name, a2_vals) = sorted(spatial_cords.items())

    # TOOD: For now just calc intensity |F|^2, extend later
    F_intensity = get_field_intensity(Fx, Fy, Fz)
    # Normalize
    F_intensity = F_intensity/np.max(F_intensity)
    # Log scale
    F_intensity = np.log10(F_intensity + 1e-50)

    # Plotting
    if ax is None:
        fig, ax = plt.subplots(figsize=(12, 8), tight_layout=True)
    else:
        fig = ax.get_figure()

    A1, A2 = np.meshgrid(a1_vals, a2_vals, indexing='ij')
    
    im = ax.pcolormesh(
        A1, A2,
        F_intensity,
        shading='gouraud',
        cmap=cmap,
        vmin=vmin,
        vmax=vmax,
    )
    ax.set_aspect('equal')
    ax.set_xlabel(rf'{a1_name} ($\mu$m)')
    ax.set_ylabel(rf'{a2_name} ($\mu$m)')

    fig.colorbar(
        im,
        ax=ax,
        label=r'$\log_{10}(|E|^2)$',
    )

    return im

# TODO: Margin is based on index not physcial distance!
def get_field_decay(
    Fx,
    Fy,
    Fz,
    margin=6,
    per_side=False,
):
    # calc intensity |F|^2
    F_intensity = get_field_intensity(Fx, Fy, Fz)
    F_intensity_peak = np.max(F_intensity)
    if F_intensity_peak == 0:
        return 0.0

    F_am = np.max(F_intensity[:margin, :])
    F_ap = np.max(F_intensity[-margin:, :])
    F_bm = np.max(F_intensity[:, :margin])
    F_bp = np.max(F_intensity[:, -margin:])

    F_dam = float(np.log10((F_am/F_intensity_peak) + 1e-50))
    F_dap = float(np.log10((F_ap/F_intensity_peak) + 1e-50))
    F_dbm = float(np.log10((F_bm/F_intensity_peak) + 1e-50))
    F_dbp = float(np.log10((F_bp/F_intensity_peak) + 1e-50))
   
    if per_side:
        return (F_dam, F_dap, F_dbm, F_dbp)

    return np.max([F_dam, F_dap, F_dbm, F_dbp])

# Determine relative intensity in region (center) to rest of the window
def get_field_confinement(
    Fx,
    Fy,
    Fz,
    x=None,
    y=None,
    z=None,
    radius=1
):
    spatial_cords = {}
    if x is not None: spatial_cords["x"] = x
    if y is not None: spatial_cords["y"] = y
    if z is not None: spatial_cords["z"] = z

    spatial_cords_cnt = len(spatial_cords)
    if spatial_cords_cnt != 2:
        spatials_provided = list(spatial_cords.keys())
        err_msg = f"""Expected exactly 2 spatial coordinates to plot a 2D plane.
        {spatial_cords_cnt} has been provided: {spatials_provided}"""
        raise ValueError(err_msg)

    (_, a1), (_, a2) = sorted(spatial_cords.items())
    a1, a2 = np.asarray(a1), np.asarray(a2)

    A1, A2 = np.meshgrid(a1, a2, indexing='ij')
    da1, da2 = np.gradient(a1), np.gradient(a2)
    dA1, dA2 = np.meshgrid(da1, da2, indexing='ij')
    cell_area = dA1 * dA2

    F_intensity = np.asarray(get_field_intensity(Fx, Fy, Fz))
    total_intensity = np.sum(F_intensity * cell_area)
    if total_intensity == 0:
        return 0.0

    center_1 = (a1[0] + a1[-1]) / 2.0
    center_2 = (a2[0] + a2[-1]) / 2.0

    mask = (A1 - center_1)**2 + (A2 - center_2)**2 <= radius**2

    confined_intensity = np.sum(F_intensity[mask] * cell_area[mask])

    return float(confined_intensity / total_intensity)

def calc_grid_dl(
    wavelength_center,
    material_n,
    min_steps_per_wvl
):
    return (wavelength_center/(min_steps_per_wvl * material_n))

def plot_material_n(
    mat_permitivity_samples=None,
    mat_n_interpolated=None,
    mat_n_model=None,
    wavelength_min=None,
    wavelength_max=None,
    ax=None,
):
    if ax is None:
        fig, ax = plt.subplots(figsize=(12, 8), tight_layout=True)
    else:
        fig = ax.get_figure()

    all_n = []
    all_wavelenghts = []

    # Sampled data
    if mat_permitivity_samples is not None:
        permitivties = mat_permitivity_samples[:, 1]
        freqs = np.real(mat_permitivity_samples[:, 0])
        wavelengths = C / freqs
        wavelengths_um = wavelengths*1e6
        n = np.real(np.sqrt(permitivties))

        all_n.extend(n)
        all_wavelenghts.extend(wavelengths)

        ax.plot(
            wavelengths_um,
            n,
            linestyle="none",
            marker="s",
            color="red",
            label="Sampled data"
        )
    
    # Interpolated data
    if mat_n_interpolated is not None:
        freqs = np.real(mat_n_interpolated[:, 0])
        wavelengths = C / freqs
        wavelengths_um = wavelengths*1e6
        n = np.real(mat_n_interpolated[:, 1])

        all_n.extend(n)
        all_wavelenghts.extend(wavelengths)

        ax.plot(
            wavelengths_um,
            n,
            color="blue",
            label="Interpolated data"
        )

    # Model data
    if mat_n_model is not None:
        freqs = np.real(mat_n_model[:, 0])
        wavelengths = C / freqs
        wavelengths_um = wavelengths*1e6
        n = np.real(mat_n_model[:, 1])

        all_n.extend(n)
        all_wavelenghts.extend(wavelengths)

        ax.plot(
            wavelengths_um,
            n,
            color="green",
            label="Model data"
        )

    all_wavelengths = np.array(all_wavelenghts)
    mask = np.ones(all_wavelengths.shape, dtype=bool)

    if wavelength_min is not None:
        wavelength_min_um = wavelength_min*1e6
        mask &= (all_wavelengths >= wavelength_min)
        ax.set_xlim(left=wavelength_min_um)

    if wavelength_max is not None:
        wavelength_max_um = wavelength_max*1e6
        mask &= (all_wavelengths <= wavelength_max)
        ax.set_xlim(right=wavelength_max_um)

    if np.any(mask):
        all_n = np.array(all_n)
        visible_n = all_n[mask]
        ymin, ymax = np.min(visible_n), np.max(visible_n)
        margin = 0.05 * (ymax - ymin)
        ax.set_ylim(ymin - margin, ymax + margin)

    ax.set_xlabel("Wavelength (um)")
    ax.set_ylabel("Refractive index (n)")

    ax.legend()
    ax.grid(True, alpha=0.3)
    fig.tight_layout()

    return ax

