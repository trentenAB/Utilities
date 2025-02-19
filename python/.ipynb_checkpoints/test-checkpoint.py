import json
import pandas as pd
with open('data.json', 'r') as file:
    data = json.load(file)
print(data)
data = pd.json_normalize(data)
print(data)
print(type(data))
# print(pd.DataFrame(data))