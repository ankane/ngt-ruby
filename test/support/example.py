from ngt import base as ngt

objects = [
  [1, 1, 2, 1],
  [5, 4, 6, 5],
  [1, 2, 1, 2]
]

index = ngt.Index.create(b"/tmp/index", 4)
index.insert(objects)
index.save()

query = objects[0]
result = index.search(query, 3)

for res in result:
  print(str(res.id) + ", " + str(res.distance))
  print(index.get_object(res.id))
