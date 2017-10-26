import gmshType
import time
import matplotlib.tri as tri

class mesh() :
  class element():
    def __init__(self, etype, vertices, partition, tag):
      self.etype = etype
      self.vertices = vertices
      self.partition = partition
      self.tag = tag

    def genFaces(self) :
      v = self.vertices
      order = self.etype.order
      if self.etype.baseType == gmshType.TYPE_TRI :
        return [mesh.element(gmshType.TYPE_LIN.mshType[order], [v[i], v[(i + 1) % 3]] + v[3 + i * (order-1):3 + (i+1) * (order-1)], self.partition, -1) for i in range(3)]
      elif self.etype.baseType == gmshType.TYPE_QUA :
        return [mesh.element(gmshType.TYPE_LIN.mshType[order], [v[i], v[(i + 1) % 4]] + v[4 + i * (order-1):4 + (i+1) * (order-1)], self.partition, -1) for i in range(4)]
      elif self.etype.baseType == gmshType.TYPE_LIN :
        return [mesh.element(gmshType.MSH_PNT, [v[i]], self.partition, -1) for i in range(2)]

  class entity():
    def __init__(self, tag, dim, physicals) :
      self.tag = tag
      self.dimension = dim
      self.physicals = physicals
      self.elements = []

  def __init__(self, filename = None) :
    self.vertices = []
    self.data = []
    self.physicals = [{}, {}, {}, {}]
    self.entities = []
    self.maxeid = 0
    self.useFormat3 = False
    if filename :
      self.read_mesh(filename)

  def write(self, filename, format3=None) :
    output = open(filename, "w")
    if format3 == None :
      format3 = self.useFormat3
    if format3 :
      output.write("$MeshFormat\n3 0 8\n$EndMeshFormat\n")
      output.write("$PhysicalNames\n%i\n" % (len(self.physicals[0]) + len(self.physicals[1]) + len(self.physicals[2]) + len(self.physicals[3])))
      for dim, plist in enumerate(self.physicals) :
        for name, tag in plist.items() :
          output.write("%i %i \"%s\"\n" % (dim, tag, name))
      output.write("$EndPhysicalNames\n")
      output.write("$Entities\n%i\n" % (len(self.entities)))
      for e in self.entities :
        output.write("%i %i %i %s\n" % (e.tag, e.dimension, len(e.physicals), " ".join(repr(ip) for ip in e.physicals)))
      output.write("$EndEntities\n")
      output.write("$Nodes\n%d\n" % len(self.vertices))
      for (x, y, z, j) in self.vertices :
        output.write("%i %.16g %.16g %.16g 0\n" % (j, x, y, z))
      output.write("$EndNodes\n")
      output.write("$Elements\n%d\n" % sum ([len(e.elements) for e in self.entities]))
      for entity in self.entities :
        for e in entity.elements :
          ntag = len(e.vertices) + ((1 + len(e.partition)) if e.partition else 0)
          spart = " ".join(repr(i) for i in [len(e.partition)] + e.partition) if e.partition else ""
          output.write("%i %i %i %i %s %s\n" % (e.tag, e.etype.tag, entity.tag, ntag, " ".join(repr(v[3]) for v in e.vertices), spart))
      output.write("$EndElements\n")
    else :
      output.write("$MeshFormat\n2.2 0 8\n$EndMeshFormat\n")
      output.write("$PhysicalNames\n%i\n" % (len(self.physicals[0]) + len(self.physicals[1]) + len(self.physicals[2]) + len(self.physicals[3])))
      for dim, plist in enumerate(self.physicals) :
        for name, tag in plist.items() :
          output.write("%i %i \"%s\"\n" % (dim, tag, name))
      output.write("$EndPhysicalNames\n")
      output.write("$Nodes\n%d\n" % len(self.vertices))
      for (x, y, z, j) in self.vertices :
        output.write("%i %.16g %.16g %.16g\n" % (j, x, y, z))
      output.write("$EndNodes\n")
      output.write("$Elements\n%d\n" % sum ([len(e.elements) for e in self.entities]))
      for entity in self.entities :
        for e in entity.elements :
          ntag = 2 + ((1 + len(e.partition)) if e.partition else 0)
          spart = " ".join(repr(i) for i in [len(e.partition)] + e.partition) if e.partition else ""
          ptag = entity.physicals[0] if entity.physicals else 0
          output.write("%i %i %i %i %i %s %s\n" % (e.tag, e.etype.tag, ntag, ptag, entity.tag, spart, " ".join(repr(v[3]) for v in e.vertices)))
      output.write("$EndElements\n")

  def read_mesh(self, filename):
    fin = open(filename, "r");
    l = fin.readline()
    vmap = {}
    entitymap = {}
    while l != "" :
      w = l.split()
      if w[0] == "$MeshFormat":
        l = fin.readline().split()
        if float(l[0]) == 3.:
          self.useFormat3 = True
        elif int(float(l[0])) == 2 :
          self.useFormat3 = False
        else :
          print("error : cannot read mesh format " + l[0])
        l = fin.readline()
      elif w[0] == "$PhysicalNames" :
        n = int(fin.readline())
        for i in range(n) :
          dim, tag, name = fin.readline().split()
          self.physicals[int(dim)][name[1:-1]] = int(tag)
        fin.readline()
      elif w[0] == "$Entities" and self.useFormat3:
        n = int(fin.readline())
        for i in range(n) :
          l = fin.readline().split()
          j, dim, nphys = int(l[0]), int(l[1]), int(l[2])
          self.entities.append(mesh.entity(j, dim, [int(ip) for ip in l[3:3+nphys]]))
          entitymap[(dim, j)] = self.entities[-1]
        fin.readline()
      elif w[0] == "$Nodes" :
        n = int(fin.readline())
        for i in range(n) :
          if self.useFormat3 :
            (j, x, y, z, t) = fin.readline().split()
          else :
            (j, x, y, z) = fin.readline().split()
          self.vertices.append([float(x), float(y), float(z), int(j)])
          vmap[int(j)] = self.vertices[-1]
      elif w[0] == "$Elements" :
        n = int(fin.readline())
        for i in range(n) :
          l = fin.readline().split()
          if self.useFormat3 :
            j, t, e, nf = int(l[0]), int(l[1]), int(l[2]), int(l[3])
            nv = gmshType.Type[t].numVertices
            vertices = [vmap[int(i)] for i in l[4:4+nv]]
            partition = [int(i) for i in l[5 + nv : 5 + nv + int(l[4 + nv])]] if nf > nv else []
          else :
            j, t, nf, p, e = int(l[0]), int(l[1]), int(l[2]), int(l[3]), int(l[4])
            vertices = [vmap[int(i)] for i in l[3 + nf:]]
            partition = [int(i) for i in l[6 : 6 + int(l[5])]] if nf > 2 else []
          edim = gmshType.Type[t].baseType.dimension
          entity = entitymap.get((edim, e), None)
          if not self.useFormat3 and not entity:
            entity = mesh.entity(e, edim, [p])
            self.entities.append(entity)
            entitymap[(edim, e)] = entity
          entity.elements.append(mesh.element(gmshType.Type[t], vertices, partition, j))
          self.maxeid = max(self.maxeid, j)
      l = fin.readline()

  def read_data(self, filename):
    fin = open(filename, "r");
    l = fin.readline()
    vmap = {}
    entitymap = {}
    while l != "" :
      w = l.split()
      if w[0] == "$MeshFormat":
        l = fin.readline().split()
        if float(l[0]) == 3.:
          self.useFormat3 = True
        elif int(float(l[0])) == 2 :
          self.useFormat3 = False
        else :
          print("error : cannot read mesh format " + l[0])
        l = fin.readline()
      elif w[0] == "$PhysicalNames" :
        n = int(fin.readline())
        for i in range(n) :
          dim, tag, name = fin.readline().split()
          self.physicals[int(dim)][name[1:-1]] = int(tag)
        fin.readline()
      elif w[0] == "$Entities" and self.useFormat3:
        n = int(fin.readline())
        for i in range(n) :
          l = fin.readline().split()
          j, dim, nphys = int(l[0]), int(l[1]), int(l[2])
          self.entities.append(mesh.entity(j, dim, [int(ip) for ip in l[3:3+nphys]]))
          entitymap[(dim, j)] = self.entities[-1]
        fin.readline()
      elif w[0] == "$Nodes" :
        n = int(fin.readline())
        for i in range(n) :
          if self.useFormat3 :
            (j, x, y, z, t) = fin.readline().split()
          else :
            (j, x, y, z) = fin.readline().split()
          self.vertices.append([float(x), float(y), float(z), int(j)])
          vmap[int(j)] = self.vertices[-1]
      elif w[0] == "$Elements" :
        n = int(fin.readline())
        for i in range(n) :
          l = fin.readline().split()
          if self.useFormat3 :
            j, t, e, nf = int(l[0]), int(l[1]), int(l[2]), int(l[3])
            nv = gmshType.Type[t].numVertices
            vertices = [vmap[int(i)] for i in l[4:4+nv]]
            partition = [int(i) for i in l[5 + nv : 5 + nv + int(l[4 + nv])]] if nf > nv else []
          else :
            j, t, nf, p, e = int(l[0]), int(l[1]), int(l[2]), int(l[3]), int(l[4])
            vertices = [vmap[int(i)] for i in l[3 + nf:]]
            partition = [int(i) for i in l[6 : 6 + int(l[5])]] if nf > 2 else []
          edim = gmshType.Type[t].baseType.dimension
          entity = entitymap.get((edim, e), None)
          if not self.useFormat3 and not entity:
            entity = mesh.entity(e, edim, [p])
            self.entities.append(entity)
            entitymap[(edim, e)] = entity
          entity.elements.append(mesh.element(gmshType.Type[t], vertices, partition, j))
          self.maxeid = max(self.maxeid, j)
      elif w[0] == "$NodeData" :
        print("Reading the data (works only in 1D)")
        string_tags = []
        real_tags = []
        integer_tags = []
        for i in range (int(fin.readline())):
            string_tags.append(fin.readline())
        for i in range (int(fin.readline())):
            real_tags.append(float(fin.readline()))
        for i in range (int(fin.readline())):
            integer_tags.append(int(fin.readline()))
        for i in range(len(self.vertices)):
            l = fin.readline().split()
            self.data.append(float(l[1]))
      l = fin.readline()

      pass
  
  def getPhysicalNumber(self, dim, name) :
    t = self.physicals[dim].get(name, None)
    if not t :
      self.physicals[dim][name] = len(self.physicals[dim]) + 1
      t = len(self.physicals[dim])
    return t

  def getPhysicalName(self, dim, number) :
    for name, num in self.physicals[dim].items() :
      if num == number :
        return name
    return ""

  def newVertex(self, x, y, z) :
    self.vertices.append((x, y, z, len(self.vertices) + 1))
    return self.vertices[-1]

  def newElement(self, t, partition, entity, vertices) :
    self.maxeid += 1
    entity.elements.append(mesh.element(t, vertices, partition, self.maxeid))
    return entity.elements[-1]

  def newEntity(self, entityDim, physicalTag) :
    self.entities.append(mesh.entity(len(self.entities) + 1, entityDim, [self.getPhysicalNumber(entityDim, physicalTag)]))
    return self.entities[-1]

  def genFaces(self, dim, physicalTag) :
    allf = {}
    for entity in self.entities :
      if entity.dimension == dim - 1 :
        for e in entity.elements :
          allf[tuple(sorted([v[3] for v in e.vertices]))] = e
    for entity in self.entities :
      if entity.dimension == dim  :
        vbentity = self.newEntity(dim - 1, physicalTag)
        for e in entity.elements :
          e.faces = e.genFaces()
          for i, f in enumerate(e.faces) :
            fs = tuple(sorted([v[3] for v in f.vertices]))
            if not fs in allf :
              f.tag = self.maxeid + 1
              allf[fs] = f
              self.maxeid += 1
              vbentity.elements.append(f)
            else :
              e.faces[i] = allf[fs]

  def export_matplotlib_triangulation(self):
    x = [v[0] for v in self.vertices]
    y = [v[1] for v in self.vertices]
    triangles = []
    for entity in self.entities:
      if entity.dimension == 2:
        for e in entity.elements:
          triangles.append([v[3] - 1 for v in e.vertices]) 
          # -1 because gmsh starts indexing at 1
    triangulation = tri.Triangulation(x, y, triangles)
    return triangulation

  def get_matplotlib_triangulation_edges(self):
    edges = []
    for entity in self.entities:
      if entity.dimension == 1:
        # -1 because gmsh numbering starts at 1
        v_first = entity.elements[0].vertices[0]
        vertices_of_entity = [[v_first[0], v_first[1]]]
        for e in entity.elements:
          vertices_of_entity.append([e.vertices[1][0], e.vertices[1][1]])
        edges.append(vertices_of_entity)
    return edges

def read_data(filename):
  fin = open(filename, "r");
  while fin.readline().split()[0] != "$NodeData" :
    pass
  string_tags = []
  real_tags = []
  integer_tags = []
  data = []
  for i in range (int(fin.readline())):
    string_tags.append(fin.readline())
  for i in range (int(fin.readline())):
    real_tags.append(float(fin.readline()))
  for i in range (int(fin.readline())):
    integer_tags.append(int(fin.readline()))
  for i in range(integer_tags[-1]):
    l = fin.readline().split()
    if len(l) == 2:
      data.append(float(l[1]))
    else:
      l.pop(0)
      data.append([float(d) for d in l])
  return data

# vim:ts=2:sts=2:sw=2

