class MshBaseElementType :
  def __init__(self, name, tag, dimension) :
    self.name = name
    self.tag = tag
    self.dimension = dimension
    self.mshType = [None] * 11
    self.mshTypeSerendip = [None] * 11

BaseType = [None]
Type = [None]

for t in [
  ('TYPE_PNT', 1, 0),
  ('TYPE_LIN', 2, 1),
  ('TYPE_TRI', 3, 2),
  ('TYPE_QUA', 4, 2),
  ('TYPE_TET', 5, 3),
  ('TYPE_PYR', 6, 3),
  ('TYPE_PRI', 7, 3),
  ('TYPE_HEX', 8, 3),
  ('TYPE_POLYG', 9, 2),
  ('TYPE_POLYH', 10, 3)
] :
  BaseType.append(MshBaseElementType(*t))
  globals()[t[0]] = BaseType[-1]

class MshElementType :
  def __init__(self, name, tag, numVertices, baseType, order, serendip) :
    self.name = name
    self.tag = tag
    self.numVertices = numVertices
    self.baseType = baseType
    self.order = order
    self.serendip = serendip

for i, t in enumerate([
  'MSH_LIN_2', 'MSH_TRI_3', 'MSH_QUA_4', 'MSH_TET_4', 'MSH_HEX_8',
  'MSH_PRI_6', 'MSH_PYR_5', 'MSH_LIN_3', 'MSH_TRI_6', 'MSH_QUA_9',
  'MSH_TET_10', 'MSH_HEX_27', 'MSH_PRI_18', 'MSH_PYR_14', 'MSH_PNT',
  'MSH_QUA_8', 'MSH_HEX_26', 'MSH_PRI_15', 'MSH_PYR_13', 'MSH_TRI_9',
  'MSH_TRI_10', 'MSH_TRI_12', 'MSH_TRI_15', 'MSH_TRI_15I', 'MSH_TRI_21',
  'MSH_LIN_4', 'MSH_LIN_5', 'MSH_LIN_6', 'MSH_TET_20', 'MSH_TET_35',
  'MSH_TET_56', 'MSH_TET_34', 'MSH_TET_52', 'MSH_POLYG_', 'MSH_POLYH_',
  'MSH_QUA_16', 'MSH_QUA_25', 'MSH_QUA_36', 'MSH_QUA_12', 'MSH_QUA_16I',
  'MSH_QUA_20', 'MSH_TRI_28', 'MSH_TRI_36', 'MSH_TRI_45', 'MSH_TRI_55',
  'MSH_TRI_66', 'MSH_QUA_49', 'MSH_QUA_64', 'MSH_QUA_81', 'MSH_QUA_100',
  'MSH_QUA_121', 'MSH_TRI_18', 'MSH_TRI_21I', 'MSH_TRI_24', 'MSH_TRI_27',
  'MSH_TRI_30', 'MSH_QUA_24', 'MSH_QUA_28', 'MSH_QUA_32', 'MSH_QUA_36I',
  'MSH_QUA_40', 'MSH_LIN_7', 'MSH_LIN_8', 'MSH_LIN_9', 'MSH_LIN_10',
  'MSH_LIN_11', 'MSH_LIN_B', 'MSH_TRI_B', 'MSH_POLYG_B', 'MSH_LIN_C',
  'MSH_TET_84', 'MSH_TET_120', 'MSH_TET_165', 'MSH_TET_220', 'MSH_TET_286',
  None, None, None, 'MSH_TET_74', 'MSH_TET_100',
  'MSH_TET_130', 'MSH_TET_164', 'MSH_TET_202', 'MSH_LIN_1', 'MSH_TRI_1',
  'MSH_QUA_1', 'MSH_TET_1', 'MSH_HEX_1', 'MSH_PRI_1', 'MSH_PRI_40',
  'MSH_PRI_75', 'MSH_HEX_64', 'MSH_HEX_125', 'MSH_HEX_216', 'MSH_HEX_343',
  'MSH_HEX_512', 'MSH_HEX_729', 'MSH_HEX_1000', 'MSH_HEX_56', 'MSH_HEX_98',
  'MSH_HEX_152', 'MSH_HEX_218', 'MSH_HEX_296', 'MSH_HEX_386', 'MSH_HEX_488',
  'MSH_PRI_126', 'MSH_PRI_196', 'MSH_PRI_288', 'MSH_PRI_405', 'MSH_PRI_550',
  'MSH_PRI_38', 'MSH_PRI_66', 'MSH_PRI_102', 'MSH_PRI_146', 'MSH_PRI_198',
  'MSH_PRI_258', 'MSH_PRI_326', 'MSH_PYR_30', 'MSH_PYR_55', 'MSH_PYR_91',
  'MSH_PYR_140', 'MSH_PYR_204', 'MSH_PYR_285', 'MSH_PYR_385', 'MSH_PYR_29',
  'MSH_PYR_50', 'MSH_PYR_77', 'MSH_PYR_110', 'MSH_PYR_149', 'MSH_PYR_194',
  'MSH_PYR_245', 'MSH_PYR_1', 'MSH_PNT_SUB', 'MSH_LIN_SUB', 'MSH_TRI_SUB',
  'MSH_TET_SUB'
]) :
  if not t :
    Type.append(None)
    continue
  w = t.split("_")
  baseType = globals()["TYPE_"+w[1]]
  nnodes2order = {
    TYPE_LIN:(dict((o+1,o) for o in range(11)), {}),
    TYPE_TRI:(dict(((o+1) * (o+2) / 2,o) for o in range(11)), dict((3 * o,o) for o in range(11))),
    TYPE_QUA:(dict(((o+1) * (o+1),o) for o in range(11)), dict((4 * o,o) for o in range(11))),
    TYPE_TET:(dict(((o+1) * (o+2) * (o+3) / 6,o) for o in range(11)), dict((4 * (o+1) * (o+2)/2 - 6 * (o + 1) + 4,o) for o in range(11))),
    TYPE_HEX:(dict(((o+1) * (o+1) * (o+1),o) for o in range(11)), dict(((o+1)**3 - (o-1)**3, o) for o in range(11))),
    TYPE_PRI:(dict(((o+1) * (o+2) * (o+1)/2,o) for o in range(11)), dict(((o+1) * (o+2) + 3 * o * (o-1), o) for o in range(11))),
    TYPE_PYR:(dict(((o+1) * (o+2) * (2*o +3)/6, o) for o in range(11)), dict(((o+1)*(o+1) + 2 * (o+1) * (o+2) - 8*(o + 1) + 5,o) for o in range(11)))
  }
  try :
    numnodes = int(w[2].strip("I"))
  except:
    numnodes = 1 if baseType == TYPE_PNT else -1
  try :
    serendip = (w[2][-1] == 'I')
  except :
    serendip = False
  if numnodes == -1 :
    order = -1
  elif baseType == TYPE_PNT :
    order = 0
    serendip = False
  elif t == "MSH_PRI_15" or t == "MSH_PYR_13":
    order = 2
    serendip = True
  else:
    if (not serendip) and numnodes in nnodes2order[baseType][0] :
      order = nnodes2order[baseType][0][numnodes]
    else :
      order = nnodes2order[baseType][1][numnodes]
      serendip = True
  Type.append(MshElementType(t, i + 1, numnodes, baseType, order, serendip))
  if serendip :
    baseType.mshTypeSerendip[order] = Type[-1]
  else :
    baseType.mshType[order] = Type[-1]
  globals()[t] = Type[-1]
