from collections import OrderedDict

import matplotlib.pyplot as plt
import numpy as np
from femwell.maxwell.waveguide import compute_modes
from femwell.mesh import mesh_from_OrderedDict
from shapely.geometry import Polygon, box
from shapely.ops import clip_by_rect
from skfem import Basis, ElementTriP0
from skfem.io.meshio import from_meshio
from tqdm.auto import tqdm
