from __future__ import print_function, absolute_import
import os
import os.path as osp
import numpy as np

from ..utils.data import Dataset
from ..utils.osutils import mkdir_if_missing
from ..utils.serialization import read_json
from ..utils.serialization import write_json

class valSet(Dataset):

  def __init__(self, root, split_id=0, num_val=100, download=False):
    super(valSet, self).__init__(root, split_id=split_id)

    #if not self._check_integrity():
      #raise RuntimeError("Dataset not found or corrupted. ")
    self.load()

  ########################  
  # Added
  def load(self, verbose=True):

    ##########
    # Added
    images_dir = osp.join(self.root)
    self.meta = read_json(osp.join(self.root, 'meta.json'))
    query_fnames = self.meta['query_fnames']
    gallery_fnames = self.meta['gallery_fnames']
    self.query = []
    i = 0
    for fname in query_fnames:
      name, pid = fname.split('_')
      name += ".png"
      self.query.append((name, int(pid), i))
      i += 1
    self.gallery = []
    j = i + 1
    for fname in gallery_fnames:
      name, pid = fname.split('_')
      name += ".png"
      self.gallery.append((name, int(pid), j))
      j += 1
    ##########

    if verbose:
      print(self.__class__.__name__, "66666!!! validation dataset loaded")
  ########################
