import json
import os

def append_to_json(file_path: str, new_entry: str):
    # Check if the file exists
    if os.path.exists(file_path):
        # Load existing data
        with open(file_path, 'r') as file:
            try:
                data = json.load(file)
            except json.JSONDecodeError:
                data = {}  # If the file is empty or invalid, reset to an empty dict
    else:
        data = {}  # Initialize empty data if file doesn't exist
    
    print(data)
    
    if data:
        # check new_entry is new
        max_id = 0 
        for key, value in data.items():
            print('key: '+key, 'value: '+str(value))
            if key=='id':
                if value>max_id:
                    max_id=value
            elif key=='first':
                if new_entry==value:
                    print('No New entry')
                    return
            else:
                continue
        old_max_id = max_id
        new_max_id = old_max_id + 1
        data['id'] = new_max_id
        data['first'] = new_entry

        # data['first'].append(new_entry)
        # last_id = data['id'][-1]
        # new_id = last_id + 1
        # data['id'].append(new_id)
        
    elif not data:
        # If the file was empty, initialize a structure
        data['id'] = 1
        data['first'] = new_entry
        print('Created New File')

    # Write back to the file
    with open(file_path, 'w+') as file:
        json.dump(data, file, indent=4)

    print(f"Added {new_entry}")
# Example usage
append_to_json("data.json", 'entry1')
append_to_json("data.json", 'entry2')
append_to_json("data.json", 'entry3')
append_to_json("data.json", 'entry3')