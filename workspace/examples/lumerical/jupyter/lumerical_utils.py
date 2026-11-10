import numpy as np
import matplotlib.pyplot as plt

# X/Z only for now
def plot_Efield(Efield):
    Ex = np.squeeze(Efield["E"][..., 0])
    Ey = np.squeeze(Efield["E"][..., 1])
    Ez = np.squeeze(Efield["E"][..., 2])

    E_intensity = np.abs(Ex)**2 + np.abs(Ey)**2 + np.abs(Ez)**2
    E_intensity_normalized = E_intensity / np.max(E_intensity)
    E_intensity_log = np.log10(E_intensity_normalized + 1e-15)
    E_intensity_log = np.clip(E_intensity_log, -10, 0)

    x, z = Efield["x"], Efield["z"]

    fig, ax = plt.subplots(figsize=(12, 8))

    im = ax.imshow(
        E_intensity_log.T,
        extent=[
            x.min() * 1e6, x.max() * 1e6,
            z.min() * 1e6, z.max() * 1e6
        ],
        origin='lower',
        aspect='auto',
        cmap='jet',
        vmin=-10,
        vmax=0,
        interpolation='bicubic'
    )

    fig.colorbar(
        im,
        ax=ax,
        label=r'$\log_{10}(|E|^2)$',
        ticks=np.arange(-10, 1, 1)
    )

    ax.set_xlabel(r'x ($\mu m$)')
    ax.set_ylabel(r'z ($\mu m$)')

    return fig, ax

# X/Z only for now
def get_Efield_intensity_decay(Efield, axis, margin=6):
    Ex = np.squeeze(Efield["E"][..., 0])
    Ey = np.squeeze(Efield["E"][..., 1])
    Ez = np.squeeze(Efield["E"][..., 2])

    E_intensity = np.abs(Ex)**2 + np.abs(Ey)**2 + np.abs(Ez)**2
    E_peak = np.max(E_intensity)

    coords = [ax for ax in ['x', 'y', 'z'] if ax in Efield]
    idx = coords.index(axis.lower())

    # Evaluate intensity within wider boundary strips
    if idx == 0:
        boundary_max = np.max([
            np.max(E_intensity[:margin, :]),
            np.max(E_intensity[-margin:, :])
        ])
    else:
        boundary_max = np.max([
            np.max(E_intensity[:, :margin]),
            np.max(E_intensity[:, -margin:])
        ])

    return boundary_max / E_peak

def optimize_simulation_axis(
    mode_obj, 
    axis='x', 
    target_decay=1e-8,
    span_min=0.5e-6, 
    span_max=20e-6,
    max_iterations=15, 
    decades_tolerance=0.2,
    Efield_source="FDE::data::mode1",
    boundry_layers=5,
    extend_side='both',
    strict=True,
):
    if extend_side not in ['both', 'negative', 'positive']:
        raise ValueError("extend_side must be 'both', 'left', or 'right'")

    print(f"--- Optimizing {axis.upper()} Span (Target Decay: {target_decay:.4e}) ---")

    # Axis center
    center_name = axis
    original_center = mode_obj.get(center_name)

    # Axis span    
    span_name = f"{axis.lower()} span"
    original_span = mode_obj.get(span_name)

    # Lower boundry
    a_min_name = f"{axis.lower()} min"
    original_a_min = mode_obj.get(a_min_name)

    # Higher boundry
    a_max_name = f"{axis.lower()} max"
    original_a_max = mode_obj.get(a_max_name)
    
    def set_solver_span(span):
        if extend_side == 'both':
            mode_obj.set(span_name, span)
        elif extend_side == 'negative':
            mode_obj.set(a_min_name, original_a_min - (span - original_span))
        else:
            mode_obj.set(a_min_name, original_a_max + (span - original_span))
    
    best_span = None
    span_low, span_high = span_min, span_max
    
    for i in range(max_iterations):
        if i == 0:
            span_current = span_min
        else:
            span_current = (span_low + span_high) / 2.0
        
        mode_obj.switchtolayout()
        set_solver_span(span_current)
        
        try:
            mode_obj.findmodes()
            Efield = mode_obj.getresult(Efield_source, "E")
            decay = get_Efield_intensity_decay(Efield, axis, boundry_layers)
            log_decay = np.log10(max(decay, 1e-50))
            log_target = np.log10(target_decay)

            print(f"{axis.upper()} Iter {i+1}: {span_name} = {span_current*1e6:.3f} µm | Decay = {decay:.4e} (Log: {log_decay:.2f})")

            if not strict and decay <= target_decay:
                best_span = span_current
                print(f"Target decay achieved: ({decay:.4e} <= {target_decay:.4e})")
                break

            log_error = log_decay - log_target
            if abs(log_error) <= decades_tolerance:
                best_span = span_current
                print(f"Target decay decade tolerance reached (Log Error: {log_error:.2f} decades)")
                break

            if log_error > 0:
                span_low = span_current
            else:
                best_span = span_current
                span_high = span_current

        except Exception as e:
            print(f"Solver error at {span_name} {span_current*1e6:.2f} µm: {e}")
            span_low = span_current

    if best_span is None:
        best_span = span_max
        print(f"⚠️ Warning: Ideal span meeting the condition was not found. Using span_max.")

    # Apply final optimized span for this axis
    mode_obj.switchtolayout()
    mode_obj.set(span_name, best_span)

    print(f"✅ Optimal {axis.upper()} span: {best_span*1e6:.3f} µm\n")
    return best_span

    