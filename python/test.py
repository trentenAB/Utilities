import json
import pandas as pd
with open('data.json', 'r') as file:
    data = json.load(file)

print(pd.DataFrame(data))